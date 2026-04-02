#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

DEFAULT_ALIAS="cm-prod-demo"
DEFAULT_LOGIN_URL="https://storm-67f93fa3759a67.my.salesforce.com"
DEFAULT_EXPECTED_INSTANCE_URL="https://storm-67f93fa3759a67.my.salesforce.com"
ALIAS="$DEFAULT_ALIAS"
LOGIN_URL="$DEFAULT_LOGIN_URL"
EXPECTED_INSTANCE_URL="$DEFAULT_EXPECTED_INSTANCE_URL"
SET_DEFAULT="true"

usage() {
  cat <<USAGE
Authenticate to a Salesforce org for discovery-only Contracts Management work.

Usage:
  ./scripts/auth-org.sh [--alias <org-alias>] [--login-url <url>] [--expected-instance-url <url>] [--no-set-default]

Options:
  --alias          Salesforce org alias (default: ${DEFAULT_ALIAS})
  --login-url      Login URL (default: ${DEFAULT_LOGIN_URL})
  --expected-instance-url Required post-login instance URL (default: ${DEFAULT_EXPECTED_INSTANCE_URL})
  --no-set-default       Do not set this org as the default target org
  -h, --help       Show this help message

Environment:
  SF_HOME_DIR      Optional home directory for Salesforce CLI state.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --alias)
      ALIAS="$2"
      shift 2
      ;;
    --login-url)
      LOGIN_URL="$2"
      shift 2
      ;;
    --no-set-default)
      SET_DEFAULT="false"
      shift
      ;;
    --expected-instance-url)
      EXPECTED_INSTANCE_URL="$2"
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

mkdir -p analysis/raw
require_cmd sf

if [[ -n "${SF_HOME_DIR:-}" ]]; then
  mkdir -p "$SF_HOME_DIR"
fi

LOGIN_FLAGS=(org login web --alias "$ALIAS" --instance-url "$LOGIN_URL")
if [[ "$SET_DEFAULT" == "true" ]]; then
  LOGIN_FLAGS+=(--set-default)
fi

echo "Opening interactive Salesforce login for alias '$ALIAS'..."
sf_cmd "${LOGIN_FLAGS[@]}"

ORG_QUERY="SELECT Id, Name, InstanceName, OrganizationType, IsSandbox FROM Organization LIMIT 1"

sf_cmd data query --target-org "$ALIAS" --query "$ORG_QUERY" --json > analysis/raw/org-organization.json
sf_cmd org display --target-org "$ALIAS" --json > analysis/raw/org-display.json

ALIAS_NAME="$ALIAS" LOGIN_URL="$LOGIN_URL" EXPECTED_INSTANCE_URL="$EXPECTED_INSTANCE_URL" node <<'NODE'
const fs = require('fs');

function readJson(path) {
  return JSON.parse(fs.readFileSync(path, 'utf8'));
}

function firstRecord(queryResult) {
  const result = queryResult?.result;
  if (Array.isArray(result?.records) && result.records.length > 0) return result.records[0];
  if (Array.isArray(result) && result.length > 0) return result[0];
  return null;
}

const org = firstRecord(readJson('analysis/raw/org-organization.json'));
const display = readJson('analysis/raw/org-display.json');

if (!org) {
  console.error('Could not resolve organization identity from query output.');
  process.exit(1);
}

const identity = {
  generatedAt: new Date().toISOString(),
  targetOrgAlias: process.env.ALIAS_NAME,
  loginUrl: process.env.LOGIN_URL,
  org: {
    id: org.Id,
    name: org.Name,
    instanceName: org.InstanceName,
    organizationType: org.OrganizationType,
    isSandbox: org.IsSandbox
  },
  user: {
    username: display?.result?.username || null,
    userId: display?.result?.id || null
  },
  orgDisplay: {
    apiVersion: display?.result?.apiVersion || null,
    connectedStatus: display?.status === 0 ? 'connected' : 'unknown',
    instanceUrl: display?.result?.instanceUrl || null
  },
  discoveryMode: {
    writeOrDeployAllowedByScripts: false,
    note: 'This project only includes retrieval and analysis scripts. No deploy commands are used.'
  }
};

fs.writeFileSync('analysis/org-identity.json', JSON.stringify(identity, null, 2) + '\n');

if (identity.org.isSandbox) {
  console.error('Connected org is a sandbox (IsSandbox=true). This project is configured for production demo org discovery.');
  process.exit(2);
}

if (identity.orgDisplay.instanceUrl !== process.env.EXPECTED_INSTANCE_URL) {
  console.error(`Connected instance URL '${identity.orgDisplay.instanceUrl}' does not match required '${process.env.EXPECTED_INSTANCE_URL}'.`);
  process.exit(3);
}
NODE

echo "Org identity written to analysis/org-identity.json"
echo "Alias '$ALIAS' authenticated and validated as non-sandbox org at '$EXPECTED_INSTANCE_URL'."
