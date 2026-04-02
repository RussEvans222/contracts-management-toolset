#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

DEFAULT_ALIAS="cm-prod-demo"
DEFAULT_CONFIG="analysis/contracts-scope.config.json"
ALIAS="$DEFAULT_ALIAS"
CONFIG_PATH="$DEFAULT_CONFIG"

usage() {
  cat <<USAGE
Create metadata inventory for Contracts Management discovery.

Usage:
  ./scripts/inventory-metadata.sh [--alias <org-alias>] [--config <config-path>]

Options:
  --alias     Salesforce org alias (default: ${DEFAULT_ALIAS})
  --config    Contract scope config JSON (default: ${DEFAULT_CONFIG})
  -h, --help  Show this help message

Environment:
  SF_HOME_DIR Optional home directory for Salesforce CLI state.
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

if [[ -n "${SF_HOME_DIR:-}" ]]; then
  mkdir -p "$SF_HOME_DIR"
fi

mkdir -p analysis/raw/inventory analysis/tmp

echo "Listing enabled metadata types..."
sf_cmd org list metadata-types --target-org "$ALIAS" --json > analysis/metadata-types.json

TARGET_TYPES=()
while IFS= read -r metadata_type; do
  [[ -n "$metadata_type" ]] && TARGET_TYPES+=("$metadata_type")
done < <(node -e '
const fs = require("fs");
const cfg = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
const merged = [
  ...(cfg.targetMetadataTypes || []),
  ...(cfg.integrationMetadataTypes || []),
  ...(cfg.omniMetadataTypes || [])
];
const unique = [...new Set(merged)];
for (const type of unique) console.log(type);
' "$CONFIG_PATH")

STATUS_FILE="analysis/tmp/inventory-status.tsv"
: > "$STATUS_FILE"

for metadata_type in "${TARGET_TYPES[@]}"; do
  out_file="analysis/raw/inventory/${metadata_type}.json"
  err_file="analysis/raw/inventory/${metadata_type}.err"

  echo "Listing components for ${metadata_type}..."
  if sf_cmd org list metadata --target-org "$ALIAS" --metadata-type "$metadata_type" --json > "$out_file" 2>"$err_file"; then
    printf "%s\t0\t%s\t%s\n" "$metadata_type" "$out_file" "$err_file" >> "$STATUS_FILE"
  else
    exit_code=$?
    printf "%s\t%s\t%s\t%s\n" "$metadata_type" "$exit_code" "$out_file" "$err_file" >> "$STATUS_FILE"
  fi
done

TARGET_ORG_ALIAS="$ALIAS" CONFIG_PATH="$CONFIG_PATH" node <<'NODE'
const fs = require('fs');

const statusLines = fs
  .readFileSync('analysis/tmp/inventory-status.tsv', 'utf8')
  .split('\n')
  .map((line) => line.trim())
  .filter(Boolean);

function safeReadJson(path) {
  try {
    return JSON.parse(fs.readFileSync(path, 'utf8'));
  } catch (_error) {
    return null;
  }
}

function readError(path) {
  try {
    return fs.readFileSync(path, 'utf8').trim();
  } catch (_error) {
    return null;
  }
}

function normalizeComponents(payload) {
  const result = payload?.result;
  if (!result) return [];
  if (Array.isArray(result)) return result;
  if (Array.isArray(result?.metadataObjects)) return result.metadataObjects;
  if (Array.isArray(result?.result)) return result.result;
  if (Array.isArray(result?.records)) return result.records;
  return [];
}

function nameFor(component) {
  return (
    component.fullName ||
    component.fileName ||
    component.developerName ||
    component.id ||
    component.xmlName ||
    null
  );
}

const componentsByType = {};
const metadataTypeStats = [];
const managedPackagePrefixes = new Set();

for (const line of statusLines) {
  const [metadataType, exitCodeRaw, outFile, errFile] = line.split('\t');
  const exitCode = Number(exitCodeRaw);
  const payload = safeReadJson(outFile);
  const rawComponents = payload ? normalizeComponents(payload) : [];

  const normalized = rawComponents
    .map((component) => {
      const name = nameFor(component);
      if (!name) return null;
      const namespaceMatch = /^([A-Za-z0-9]+)__/.exec(name);
      if (namespaceMatch) managedPackagePrefixes.add(namespaceMatch[1]);
      return {
        fullName: name,
        fileName: component.fileName || null,
        namespacePrefix: namespaceMatch ? namespaceMatch[1] : null
      };
    })
    .filter(Boolean);

  componentsByType[metadataType] = normalized;

  metadataTypeStats.push({
    metadataType,
    scanned: exitCode === 0,
    exitCode,
    count: normalized.length,
    error: exitCode === 0 ? null : readError(errFile)
  });
}

const summary = {
  generatedAt: new Date().toISOString(),
  targetOrgAlias: process.env.TARGET_ORG_ALIAS,
  configPath: process.env.CONFIG_PATH,
  metadataTypeStats,
  totals: {
    typesRequested: metadataTypeStats.length,
    typesScanned: metadataTypeStats.filter((row) => row.scanned).length,
    componentsScanned: Object.values(componentsByType).reduce((sum, arr) => sum + arr.length, 0)
  },
  managedPackagePrefixes: [...managedPackagePrefixes].sort(),
  componentsByType
};

fs.writeFileSync('analysis/component-inventory.json', JSON.stringify(summary, null, 2) + '\n');
NODE

echo "Wrote analysis/metadata-types.json"
echo "Wrote analysis/component-inventory.json"
