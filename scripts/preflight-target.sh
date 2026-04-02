#!/usr/bin/env bash
set -euo pipefail

DEFAULT_ALIAS="cm-prod-demo"
EXPECTED_INSTANCE_URL="https://storm-67f93fa3759a67.my.salesforce.com"
ALIAS="$DEFAULT_ALIAS"

usage() {
  cat <<USAGE
Preflight target validation for mutating scripts.

Usage:
  ./scripts/preflight-target.sh [--alias <org-alias>] [--expected-instance-url <url>]

Options:
  --alias                  Target org alias (default: ${DEFAULT_ALIAS})
  --expected-instance-url  Required instance URL (default: ${EXPECTED_INSTANCE_URL})
  -h, --help               Show this help message
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --alias)
      ALIAS="$2"
      shift 2
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

org_json=$(sf org display --target-org "$ALIAS" --json 2>/dev/null || true)
if [[ -z "$org_json" ]]; then
  echo "Unable to resolve alias '$ALIAS'. Authenticate first with ./scripts/auth-org.sh --alias $ALIAS" >&2
  exit 1
fi

instance_url=$(echo "$org_json" | node -e 'const fs=require("fs");const d=JSON.parse(fs.readFileSync(0,"utf8"));console.log(d?.result?.instanceUrl||"")')
username=$(echo "$org_json" | node -e 'const fs=require("fs");const d=JSON.parse(fs.readFileSync(0,"utf8"));console.log(d?.result?.username||"")')

echo "Preflight target:"
echo "  alias: $ALIAS"
echo "  username: $username"
echo "  instanceUrl: $instance_url"
echo "  expectedInstanceUrl: $EXPECTED_INSTANCE_URL"

if [[ "$instance_url" != "$EXPECTED_INSTANCE_URL" ]]; then
  echo "Target validation failed: alias '$ALIAS' is not bound to '$EXPECTED_INSTANCE_URL'." >&2
  exit 2
fi

echo "Target validation passed."
