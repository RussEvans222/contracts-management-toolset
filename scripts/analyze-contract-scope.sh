#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

DEFAULT_CONFIG="analysis/contracts-scope.config.json"
CONFIG_PATH="$DEFAULT_CONFIG"

usage() {
  cat <<USAGE
Analyze contract retrieval outputs and generate inventory documentation.

Usage:
  ./scripts/analyze-contract-scope.sh [--config <config-path>]

Options:
  --config    Contract scope config JSON (default: ${DEFAULT_CONFIG})
  -h, --help  Show this help message
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --config)
      CONFIG_PATH="$2"
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

if [[ ! -f analysis/component-inventory.json ]]; then
  echo "analysis/component-inventory.json not found. Run ./scripts/inventory-metadata.sh first." >&2
  exit 1
fi

if [[ ! -f analysis/contracts-scope.json ]]; then
  echo "analysis/contracts-scope.json not found. Run ./scripts/retrieve-contract-scope.sh first." >&2
  exit 1
fi

CONFIG_PATH="$CONFIG_PATH" node <<'NODE'
const fs = require('fs');

function readJson(path, fallback = null) {
  try {
    return JSON.parse(fs.readFileSync(path, 'utf8'));
  } catch (_error) {
    return fallback;
  }
}

function domainFor(metadataType, fullNameLower) {
  if ([
    'Flow',
    'FlowDefinition',
    'OmniScript',
    'OmniIntegrationProcedure',
    'OmniDataTransform'
  ].includes(metadataType)) return 'Automation';

  if (['LightningComponentBundle', 'FlexiPage', 'Layout', 'OmniUiCard'].includes(metadataType)) return 'User Experience';

  if (['NamedCredential', 'ExternalCredential', 'RemoteSiteSetting', 'ConnectedApp', 'AuthProvider'].includes(metadataType)) {
    return 'Integrations & Security';
  }

  if (['ApexClass', 'ApexTrigger', 'CustomMetadata'].includes(metadataType)) {
    if (fullNameLower.includes('docusign') || fullNameLower.includes('microsoft') || fullNameLower.includes('m365')) {
      return 'Integrations & Security';
    }
    return 'Platform Logic';
  }

  if (['CustomObject', 'CustomField', 'PermissionSet'].includes(metadataType)) return 'Contracts Data Model';

  return 'Other';
}

const cfg = readJson(process.env.CONFIG_PATH, {});
const inventory = readJson('analysis/component-inventory.json', {});
const scope = readJson('analysis/contracts-scope.json', {});

const selectedByType = scope.selectedByType || {};
const stats = inventory.metadataTypeStats || [];

const selectedRows = [];
for (const [metadataType, members] of Object.entries(selectedByType)) {
  for (const member of members) {
    const lower = member.toLowerCase();
    selectedRows.push({
      metadataType,
      fullName: member,
      domain: domainFor(metadataType, lower),
      integrationRelated:
        lower.includes('docusign') ||
        lower.includes('m365') ||
        lower.includes('microsoft') ||
        lower.includes('outlook') ||
        lower.includes('word')
    });
  }
}

const byDomain = {};
for (const row of selectedRows) {
  if (!byDomain[row.domain]) byDomain[row.domain] = [];
  byDomain[row.domain].push(row);
}

const summary = {
  generatedAt: new Date().toISOString(),
  targetOrgAlias: scope.targetOrgAlias || inventory.targetOrgAlias || cfg.targetOrgAlias || 'cm-prod-demo',
  totals: {
    scannedTypes: stats.filter((row) => row.scanned).length,
    scannedComponents: inventory.totals?.componentsScanned || 0,
    selectedTypes: Object.keys(selectedByType).length,
    selectedComponents: selectedRows.length,
    integrationRelatedSelected: selectedRows.filter((row) => row.integrationRelated).length
  },
  byDomain: Object.fromEntries(
    Object.entries(byDomain).map(([domain, rows]) => [
      domain,
      {
        count: rows.length,
        components: rows
          .sort((a, b) => a.metadataType.localeCompare(b.metadataType) || a.fullName.localeCompare(b.fullName))
          .map((row) => ({ metadataType: row.metadataType, fullName: row.fullName, integrationRelated: row.integrationRelated }))
      }
    ])
  )
};

fs.writeFileSync('analysis/contracts-scope-summary.json', JSON.stringify(summary, null, 2) + '\n');

const typeTableRows = stats
  .slice()
  .sort((a, b) => a.metadataType.localeCompare(b.metadataType))
  .map((row) => `| ${row.metadataType} | ${row.scanned ? 'Yes' : 'No'} | ${row.count} |`)
  .join('\n');

const selectedTypeRows = Object.entries(selectedByType)
  .sort(([a], [b]) => a.localeCompare(b))
  .map(([type, names]) => `| ${type} | ${names.length} |`)
  .join('\n');

const domainSections = Object.entries(summary.byDomain)
  .sort(([a], [b]) => a.localeCompare(b))
  .map(([domain, payload]) => {
    const rows = payload.components
      .slice(0, 30)
      .map((component) => `- \`${component.metadataType}\` - ${component.fullName}${component.integrationRelated ? ' (integration-related)' : ''}`)
      .join('\n');
    const truncated = payload.components.length > 30
      ? `\n- ...and ${payload.components.length - 30} more`
      : '';

    return `### ${domain}\nCount: ${payload.count}\n${rows}${truncated}`;
  })
  .join('\n\n');

const markdown = `# Contracts Inventory\n\nGenerated: ${summary.generatedAt}\nTarget Org Alias: ${summary.targetOrgAlias}\n\n## Inventory Summary\n- Scanned metadata types: ${summary.totals.scannedTypes}\n- Scanned components: ${summary.totals.scannedComponents}\n- Selected contract-scope types: ${summary.totals.selectedTypes}\n- Selected contract-scope components: ${summary.totals.selectedComponents}\n- Integration-related selected components (M365/DocuSign markers): ${summary.totals.integrationRelatedSelected}\n\n## Metadata Scan Coverage\n| Metadata Type | Scanned | Components Found |\n|---|---|---|\n${typeTableRows || '| _none_ | No | 0 |'}\n\n## Selected Scope by Type\n| Metadata Type | Selected Components |\n|---|---|\n${selectedTypeRows || '| _none_ | 0 |'}\n\n## Selected Components by Business Domain\n${domainSections || 'No components selected yet.'}\n\n## Notes\n- Inventory is generated from CLI metadata listing + contract keyword classification.\n- For OmniStudio metadata types not enabled in the org, run \`./scripts/export-omnistudio-fallback.sh\`.\n`;

fs.writeFileSync('docs/contracts-inventory.md', markdown);
NODE

echo "Wrote analysis/contracts-scope-summary.json"
echo "Wrote docs/contracts-inventory.md"
