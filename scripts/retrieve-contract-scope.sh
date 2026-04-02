#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

DEFAULT_ALIAS="cm-prod-demo"
DEFAULT_CONFIG="analysis/contracts-scope.config.json"
ALIAS="$DEFAULT_ALIAS"
CONFIG_PATH="$DEFAULT_CONFIG"
WAIT_MINUTES="60"
NO_RETRIEVE="false"

usage() {
  cat <<USAGE
Build contract-focused retrieval scope and pull metadata.

Usage:
  ./scripts/retrieve-contract-scope.sh [--alias <org-alias>] [--config <path>] [--wait <minutes>] [--no-retrieve]

Options:
  --alias        Salesforce org alias (default: ${DEFAULT_ALIAS})
  --config       Contract scope config JSON (default: ${DEFAULT_CONFIG})
  --wait         Wait time for retrieve command in minutes (default: ${WAIT_MINUTES})
  --no-retrieve  Build scope + package.xml but skip retrieve execution
  -h, --help     Show this help message

Environment:
  SF_HOME_DIR    Optional home directory for Salesforce CLI state.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --alias)
      ALIAS="$2"
      shift 2
      ;;
    --config)
      CONFIG_PATH="$2"
      shift 2
      ;;
    --wait)
      WAIT_MINUTES="$2"
      shift 2
      ;;
    --no-retrieve)
      NO_RETRIEVE="true"
      shift
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

sf_cmd() {
  if [[ -n "${SF_HOME_DIR:-}" ]]; then
    HOME="$SF_HOME_DIR" sf "$@"
  else
    sf "$@"
  fi
}

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Required command not found: $1" >&2
    exit 1
  fi
}

require_cmd sf
require_cmd node

if [[ ! -f "$CONFIG_PATH" ]]; then
  echo "Config file not found: $CONFIG_PATH" >&2
  exit 1
fi

if [[ ! -f analysis/component-inventory.json ]]; then
  echo "analysis/component-inventory.json not found. Running inventory script first..."
  ./scripts/inventory-metadata.sh --alias "$ALIAS" --config "$CONFIG_PATH"
fi

mkdir -p analysis/tmp manifest

CONFIG_PATH="$CONFIG_PATH" TARGET_ORG_ALIAS="$ALIAS" node <<'NODE'
const fs = require('fs');

function readJson(path, fallback = null) {
  try {
    return JSON.parse(fs.readFileSync(path, 'utf8'));
  } catch (_error) {
    return fallback;
  }
}

function xmlEscape(value) {
  return String(value)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&apos;');
}

function stripNamespace(name) {
  return name.replace(/^[A-Za-z0-9]+__/, '');
}

function rootToken(name) {
  const stripped = stripNamespace(name).toLowerCase();
  const token = stripped.split(/[^a-z0-9]+/).filter(Boolean)[0];
  return token || stripped;
}

function keywordMatch(name, keywords) {
  const lower = name.toLowerCase();
  return keywords.some((keyword) => lower.includes(keyword.toLowerCase()));
}

const cfg = readJson(process.env.CONFIG_PATH);
const inventory = readJson('analysis/component-inventory.json', {});
const metadataTypesPayload = readJson('analysis/metadata-types.json', {});

if (!cfg) {
  console.error('Could not parse config JSON.');
  process.exit(1);
}

const componentsByType = inventory.componentsByType || {};
const includeKeywords = (cfg.includeKeywords || []).map((value) => value.toLowerCase());
const excludeKeywords = (cfg.excludeKeywords || []).map((value) => value.toLowerCase());
const integrationMarkers = (cfg.integrationMarkers || []).map((value) => value.toLowerCase());
const integrationTypes = new Set(cfg.integrationMetadataTypes || []);
const omniTypes = new Set(cfg.omniMetadataTypes || []);
const dependencyTypes = new Set(cfg.dependencyTypes || []);

const metadataTypesText = JSON.stringify(metadataTypesPayload).toLowerCase();
const enabledOmniTypes = (cfg.omniMetadataTypes || []).filter((type) => metadataTypesText.includes(type.toLowerCase()));
const enabledOmniTypeSet = new Set(enabledOmniTypes);

const relevantManagedPrefixes = new Set(
  (inventory.managedPackagePrefixes || []).filter((prefix) => {
    const lower = prefix.toLowerCase();
    return includeKeywords.some((keyword) => lower.includes(keyword)) || integrationMarkers.some((marker) => lower.includes(marker));
  })
);

const selectedDetail = [];
const selectedMap = new Map();

function pushSelection(type, name, reason) {
  const key = `${type}::${name}`;
  if (selectedMap.has(key)) return;
  selectedMap.set(key, true);
  selectedDetail.push({ metadataType: type, fullName: name, reason });
}

for (const [metadataType, components] of Object.entries(componentsByType)) {
  const isOmniType = omniTypes.has(metadataType);
  if (isOmniType && enabledOmniTypes.length > 0 && !enabledOmniTypeSet.has(metadataType)) {
    continue;
  }

  for (const component of components || []) {
    const name = component.fullName;
    if (!name) continue;

    const lower = name.toLowerCase();
    const namespaceMatch = /^([A-Za-z0-9]+)__/.exec(name);
    const namespace = namespaceMatch ? namespaceMatch[1] : null;

    const isExcluded = excludeKeywords.some((keyword) => lower.includes(keyword));
    if (isExcluded) continue;

    if (integrationTypes.has(metadataType)) {
      pushSelection(metadataType, name, 'integration-metadata-type');
      continue;
    }

    const includeByKeyword = includeKeywords.some((keyword) => lower.includes(keyword));
    const includeByIntegrationMarker = integrationMarkers.some((marker) => lower.includes(marker));
    const includeByNamespace = namespace ? relevantManagedPrefixes.has(namespace) : false;

    if (includeByKeyword || includeByIntegrationMarker || includeByNamespace) {
      const reason = includeByKeyword
        ? 'keyword'
        : includeByIntegrationMarker
          ? 'integration-marker'
          : 'managed-namespace';
      pushSelection(metadataType, name, reason);
    }
  }
}

const selectedRoots = new Set(selectedDetail.map((row) => rootToken(row.fullName)).filter(Boolean));
for (const [metadataType, components] of Object.entries(componentsByType)) {
  if (!dependencyTypes.has(metadataType)) continue;

  for (const component of components || []) {
    const name = component.fullName;
    if (!name) continue;

    const key = `${metadataType}::${name}`;
    if (selectedMap.has(key)) continue;

    const root = rootToken(name);
    if (selectedRoots.has(root)) {
      pushSelection(metadataType, name, `dependency-root:${root}`);
    }
  }
}

const selectedByType = {};
for (const row of selectedDetail) {
  if (!selectedByType[row.metadataType]) selectedByType[row.metadataType] = [];
  selectedByType[row.metadataType].push(row.fullName);
}

for (const metadataType of Object.keys(selectedByType)) {
  selectedByType[metadataType] = [...new Set(selectedByType[metadataType])].sort();
}

const totalSelected = Object.values(selectedByType).reduce((sum, arr) => sum + arr.length, 0);
if (totalSelected === 0) {
  console.error('No metadata components matched contract scope. Update includeKeywords or inspect component inventory.');
  process.exit(2);
}

const packageTypes = Object.keys(selectedByType)
  .sort()
  .map((metadataType) => {
    const members = selectedByType[metadataType]
      .map((name) => `    <members>${xmlEscape(name)}</members>`)
      .join('\n');
    return `  <types>\n${members}\n    <name>${xmlEscape(metadataType)}</name>\n  </types>`;
  })
  .join('\n');

const packageXml = `<?xml version="1.0" encoding="UTF-8"?>\n<Package xmlns="http://soap.sforce.com/2006/04/metadata">\n${packageTypes}\n  <version>${xmlEscape(cfg.apiVersion || '63.0')}</version>\n</Package>\n`;

const contractsScope = {
  generatedAt: new Date().toISOString(),
  targetOrgAlias: process.env.TARGET_ORG_ALIAS,
  configPath: process.env.CONFIG_PATH,
  omni: {
    requestedTypes: cfg.omniMetadataTypes || [],
    enabledTypes: enabledOmniTypes,
    fallbackRequired: enabledOmniTypes.length === 0
  },
  totals: {
    selectedTypes: Object.keys(selectedByType).length,
    selectedComponents: totalSelected
  },
  selectedByType,
  selectedDetail
};

fs.writeFileSync('analysis/contracts-scope.json', JSON.stringify(contractsScope, null, 2) + '\n');
fs.writeFileSync('manifest/contract-scope.package.xml', packageXml);
fs.writeFileSync('manifest/package.xml', packageXml);
NODE

echo "Wrote analysis/contracts-scope.json"
echo "Wrote manifest/contract-scope.package.xml"

if [[ "$NO_RETRIEVE" == "true" ]]; then
  echo "Skipping retrieve because --no-retrieve was provided."
  exit 0
fi

echo "Retrieving contract-scoped metadata into source format..."
sf_cmd project retrieve start \
  --target-org "$ALIAS" \
  --manifest manifest/contract-scope.package.xml \
  --ignore-conflicts \
  --wait "$WAIT_MINUTES" \
  --json > analysis/retrieve-result.json

CONFIG_PATH="$CONFIG_PATH" TARGET_ORG_ALIAS="$ALIAS" node <<'NODE'
const fs = require('fs');
const path = require('path');

function readJson(filePath, fallback = null) {
  try {
    return JSON.parse(fs.readFileSync(filePath, 'utf8'));
  } catch (_error) {
    return fallback;
  }
}

function walk(dir, files = []) {
  if (!fs.existsSync(dir)) return files;
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      walk(fullPath, files);
    } else {
      files.push(fullPath);
    }
  }
  return files;
}

function stripNamespace(name) {
  return name.replace(/^[A-Za-z0-9]+__/, '');
}

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

function xmlEscape(value) {
  return String(value)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&apos;');
}

const cfg = readJson(process.env.CONFIG_PATH, {});
const inventory = readJson('analysis/component-inventory.json', {});
const scope = readJson('analysis/contracts-scope.json', {});

const dependencyTypes = new Set(cfg.dependencyTypes || []);
const selectedSet = new Set(
  Object.entries(scope.selectedByType || {}).flatMap(([type, names]) => names.map((name) => `${type}::${name}`))
);

const candidates = [];
for (const [metadataType, components] of Object.entries(inventory.componentsByType || {})) {
  if (!dependencyTypes.has(metadataType)) continue;
  for (const component of components || []) {
    const name = component.fullName;
    if (!name) continue;
    const key = `${metadataType}::${name}`;
    if (selectedSet.has(key)) continue;
    candidates.push({ metadataType, fullName: name });
  }
}

const sourceFiles = walk('force-app').filter((filePath) =>
  /\.(cls|trigger|js|html|xml|json|yaml|yml|ts)$/i.test(filePath)
);

const content = sourceFiles
  .map((filePath) => {
    try {
      return fs.readFileSync(filePath, 'utf8').toLowerCase();
    } catch (_error) {
      return '';
    }
  })
  .join('\n');

const inferredDependencies = [];
for (const candidate of candidates) {
  const stripped = stripNamespace(candidate.fullName).toLowerCase();
  if (stripped.length < 5) continue;

  const tokens = stripped.split(/[^a-z0-9]+/).filter((token) => token.length >= 5);
  if (tokens.length === 0) continue;

  const hasReference = tokens.some((token) => {
    const regex = new RegExp(`\\b${escapeRegExp(token)}\\b`, 'i');
    return regex.test(content);
  });

  if (hasReference) {
    inferredDependencies.push(candidate);
  }
}

if (inferredDependencies.length === 0) {
  scope.dependencyExpansion = {
    attempted: true,
    inferredFromRetrievedSource: 0,
    retrieveExecuted: false
  };
  fs.writeFileSync('analysis/contracts-scope.json', JSON.stringify(scope, null, 2) + '\n');
  process.exit(0);
}

const additionsByType = {};
for (const dep of inferredDependencies) {
  if (!additionsByType[dep.metadataType]) additionsByType[dep.metadataType] = new Set();
  additionsByType[dep.metadataType].add(dep.fullName);
}

const packageTypes = Object.entries(additionsByType)
  .sort(([a], [b]) => a.localeCompare(b))
  .map(([metadataType, set]) => {
    const members = [...set]
      .sort()
      .map((name) => `    <members>${xmlEscape(name)}</members>`)
      .join('\n');
    return `  <types>\n${members}\n    <name>${xmlEscape(metadataType)}</name>\n  </types>`;
  })
  .join('\n');

const packageXml = `<?xml version="1.0" encoding="UTF-8"?>\n<Package xmlns="http://soap.sforce.com/2006/04/metadata">\n${packageTypes}\n  <version>${xmlEscape(cfg.apiVersion || '63.0')}</version>\n</Package>\n`;

fs.writeFileSync('manifest/dependency-expansion.package.xml', packageXml);

scope.dependencyExpansion = {
  attempted: true,
  inferredFromRetrievedSource: inferredDependencies.length,
  retrieveExecuted: true,
  additionsByType: Object.fromEntries(
    Object.entries(additionsByType).map(([type, names]) => [type, [...names].sort()])
  )
};

fs.writeFileSync('analysis/contracts-scope.json', JSON.stringify(scope, null, 2) + '\n');
NODE

if [[ -f manifest/dependency-expansion.package.xml ]]; then
  echo "Retrieving inferred dependency components..."
  sf_cmd project retrieve start \
    --target-org "$ALIAS" \
    --manifest manifest/dependency-expansion.package.xml \
    --ignore-conflicts \
    --wait "$WAIT_MINUTES" \
    --json > analysis/retrieve-dependency-result.json
fi

echo "Retrieve complete."
