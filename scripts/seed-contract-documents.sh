#!/usr/bin/env bash
set -euo pipefail

DEFAULT_ALIAS="cm-prod-demo"
EXPECTED_INSTANCE_URL="https://storm-67f93fa3759a67.my.salesforce.com"
ALIAS="$DEFAULT_ALIAS"
MAX_CONTRACTS=12
FORCE_CREATE=false

usage() {
  cat <<USAGE
Seed generated contract documents onto Contract records for the Contract Viewer page.

Usage:
  ./scripts/seed-contract-documents.sh [--alias <org-alias>] [--contracts <count>] [--force]

Options:
  --alias      Target org alias (default: ${DEFAULT_ALIAS})
  --contracts  Max contracts to seed documents for (default: ${MAX_CONTRACTS})
  --force      Create new generated docs even when generated docs already exist
  -h, --help   Show this help message
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --alias)
      ALIAS="$2"
      shift 2
      ;;
    --contracts)
      MAX_CONTRACTS="$2"
      shift 2
      ;;
    --force)
      FORCE_CREATE=true
      shift 1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

./scripts/preflight-target.sh --alias "$ALIAS" --expected-instance-url "$EXPECTED_INSTANCE_URL"
mkdir -p analysis/raw

cat > analysis/raw/seed-contract-documents.apex <<APEX
Integer maxContracts = ${MAX_CONTRACTS};
Boolean forceCreate = ${FORCE_CREATE};
List<Contract> contracts = [
    SELECT Id, ContractNumber, Status
    FROM Contract
    WHERE Account.Name LIKE 'CM Sample Account %'
    ORDER BY LastModifiedDate DESC
    LIMIT :maxContracts
];

if (contracts.isEmpty()) {
    System.debug('No sample contracts found.');
    return;
}

Set<Id> contractIds = new Set<Id>();
for (Contract c : contracts) {
    contractIds.add(c.Id);
}

Map<Id, Integer> existingGeneratedDocs = new Map<Id, Integer>();
for (ContentDocumentLink l : [
    SELECT LinkedEntityId, ContentDocument.Title
    FROM ContentDocumentLink
    WHERE LinkedEntityId IN :contractIds
    AND ContentDocument.Title LIKE 'CM Generated Contract %'
]) {
    Integer running = existingGeneratedDocs.containsKey(l.LinkedEntityId)
        ? existingGeneratedDocs.get(l.LinkedEntityId)
        : 0;
    existingGeneratedDocs.put(l.LinkedEntityId, running + 1);
}

List<ContentVersion> toInsert = new List<ContentVersion>();
for (Contract c : contracts) {
    if (!forceCreate && existingGeneratedDocs.containsKey(c.Id) && existingGeneratedDocs.get(c.Id) > 0) {
        continue;
    }

    String title = 'CM Generated Contract ' + c.ContractNumber;
    String badgeColor = c.Status == 'Signed' ? '#16a34a' : '#2563eb';
    String svg = ''
        + '<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="760">'
        + '<defs><linearGradient id="g" x1="0" y1="0" x2="1" y2="1">'
        + '<stop offset="0%" stop-color="#dbeafe"/><stop offset="100%" stop-color="#bfdbfe"/>'
        + '</linearGradient></defs>'
        + '<rect width="1200" height="760" fill="url(#g)"/>'
        + '<rect x="60" y="60" width="1080" height="640" rx="24" fill="#ffffff" stroke="#93c5fd" stroke-width="4"/>'
        + '<text x="100" y="170" font-size="54" font-family="Arial" fill="#1e3a8a">Contract ' + c.ContractNumber + '</text>'
        + '<text x="100" y="250" font-size="36" font-family="Arial" fill="#334155">Generated Document Preview</text>'
        + '<rect x="100" y="300" width="360" height="74" rx="14" fill="' + badgeColor + '"/>'
        + '<text x="126" y="348" font-size="34" font-family="Arial" fill="#ffffff">Status: ' + c.Status + '</text>'
        + '<text x="100" y="430" font-size="28" font-family="Arial" fill="#475569">Generated: ' + String.valueOf(Date.today()) + '</text>'
        + '</svg>';
    ContentVersion cv = new ContentVersion();
    cv.Title = title;
    cv.PathOnClient = title.replace(' ', '_') + '.svg';
    cv.VersionData = Blob.valueOf(svg);
    cv.FirstPublishLocationId = c.Id;
    toInsert.add(cv);
}

insert toInsert;

Map<Id, String> contractStatusById = new Map<Id, String>();
for (Contract c : contracts) {
    contractStatusById.put(c.Id, c.Status);
}

List<ContentVersion> createdVersions = [
    SELECT Id, ContentDocumentId, FirstPublishLocationId
    FROM ContentVersion
    WHERE Id IN :toInsert
];

List<ContentVersion> versionUpdates = new List<ContentVersion>();
for (ContentVersion created : createdVersions) {
    Id contractId = created.FirstPublishLocationId;
    if (contractId == null) continue;

    if (contractStatusById.get(contractId) == 'Signed') {
        String revisionSvg = ''
            + '<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="760">'
            + '<rect width="1200" height="760" fill="#dcfce7"/>'
            + '<rect x="60" y="60" width="1080" height="640" rx="24" fill="#ffffff" stroke="#86efac" stroke-width="4"/>'
            + '<text x="100" y="180" font-size="56" font-family="Arial" fill="#14532d">Signed Contract Revision</text>'
            + '<text x="100" y="280" font-size="34" font-family="Arial" fill="#166534">Version update generated for signed contract.</text>'
            + '<text x="100" y="360" font-size="30" font-family="Arial" fill="#15803d">Timestamp: ' + String.valueOf(System.now()) + '</text>'
            + '</svg>';
        ContentVersion v2 = new ContentVersion();
        v2.ContentDocumentId = created.ContentDocumentId;
        v2.Title = 'CM Generated Contract Revision';
        v2.PathOnClient = 'cm_generated_contract_revision.svg';
        v2.VersionData = Blob.valueOf(revisionSvg);
        versionUpdates.add(v2);
    }
}

if (!versionUpdates.isEmpty()) {
    insert versionUpdates;
}

System.debug('Generated contract documents created: ' + toInsert.size());
System.debug('Generated document version updates created: ' + versionUpdates.size());
APEX

sf apex run --target-org "$ALIAS" --file analysis/raw/seed-contract-documents.apex --json > analysis/raw/seed-contract-documents.json

echo "Seeded contract documents."
sf data query --target-org "$ALIAS" --query "SELECT COUNT(Id) total FROM ContentDocumentLink WHERE LinkedEntityId IN (SELECT Id FROM Contract WHERE Account.Name LIKE 'CM Sample Account %')" --json \
  | jq -r '"Contract-linked files for sample contracts: \(.result.records[0].total)"'
