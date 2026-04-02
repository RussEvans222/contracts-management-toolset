#!/usr/bin/env bash
set -euo pipefail

DEFAULT_ALIAS="cm-prod-demo"
EXPECTED_INSTANCE_URL="https://storm-67f93fa3759a67.my.salesforce.com"
ALIAS="$DEFAULT_ALIAS"
WAIT_MINUTES="120"

usage() {
  cat <<USAGE
Deploy Contracts Command Center metadata to the locked target org.

Usage:
  ./scripts/deploy-command-center.sh [--alias <org-alias>] [--wait <minutes>]

Options:
  --alias   Target org alias (default: ${DEFAULT_ALIAS})
  --wait    Deploy wait time in minutes (default: ${WAIT_MINUTES})
  -h, --help Show this help message
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --alias)
      ALIAS="$2"
      shift 2
      ;;
    --wait)
      WAIT_MINUTES="$2"
      shift 2
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

mkdir -p analysis/raw
./scripts/preflight-target.sh --alias "$ALIAS" --expected-instance-url "$EXPECTED_INSTANCE_URL"

echo "Deploying Contracts Command Center metadata to alias '$ALIAS'..."
sf project deploy start \
  --target-org "$ALIAS" \
  --source-dir force-app/main/default/classes/SDO_ContractsCommandCenterController.cls \
  --source-dir force-app/main/default/classes/SDO_ContractsCommandCenterControllerTest.cls \
  --source-dir force-app/main/default/classes/SDO_ContractViewerController.cls \
  --source-dir force-app/main/default/classes/SDO_ContractViewerControllerTest.cls \
  --source-dir force-app/main/default/lwc/contractsCommandCenter \
  --source-dir force-app/main/default/lwc/contractsStageInsightsPanel \
  --source-dir force-app/main/default/lwc/contractsDocumentViewer \
  --source-dir force-app/main/default/flexipages/SalesforceContracts_Command_Center.flexipage-meta.xml \
  --source-dir force-app/main/default/flexipages/SalesforceContracts_Analytics.flexipage-meta.xml \
  --source-dir force-app/main/default/flexipages/SalesforceContracts_Viewer.flexipage-meta.xml \
  --source-dir force-app/main/default/tabs/SalesforceContracts_Command_Center.tab-meta.xml \
  --source-dir force-app/main/default/tabs/SalesforceContracts_Analytics.tab-meta.xml \
  --source-dir force-app/main/default/tabs/SalesforceContracts_Viewer.tab-meta.xml \
  --source-dir force-app/main/default/applications/standard__SalesforceContracts.app-meta.xml \
  --source-dir force-app/main/default/permissionsets/Contracts_Command_Center_Visibility.permissionset-meta.xml \
  --test-level RunSpecifiedTests \
  --tests SDO_ContractsCommandCenterControllerTest \
  --tests SDO_ContractViewerControllerTest \
  --wait "$WAIT_MINUTES" \
  --json > analysis/raw/deploy-command-center.json

node <<'NODE'
const fs = require('fs');
const path = 'analysis/raw/deploy-command-center.json';
const payload = JSON.parse(fs.readFileSync(path, 'utf8'));
if (payload.status !== 0 || !payload.result?.success) {
  console.error('Deployment failed. Inspect analysis/raw/deploy-command-center.json for details.');
  process.exit(1);
}
console.log('Deployment succeeded.');
console.log(`Deploy ID: ${payload.result.id}`);
console.log(`Status: ${payload.result.status}`);
NODE
