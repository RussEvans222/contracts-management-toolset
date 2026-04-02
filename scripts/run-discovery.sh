#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

DEFAULT_ALIAS="cm-prod-demo"
ALIAS="$DEFAULT_ALIAS"
CONFIG_PATH="analysis/contracts-scope.config.json"
WAIT_MINUTES="60"

usage() {
  cat <<USAGE
Run end-to-end Contracts Management discovery workflow.

Usage:
  ./scripts/run-discovery.sh [--alias <org-alias>] [--config <path>] [--wait <minutes>]

Steps:
  1) Authenticate and validate org identity
  2) Inventory metadata
  3) Build contract scope + retrieve metadata
  4) Analyze and generate docs/contracts-inventory.md
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

./scripts/auth-org.sh --alias "$ALIAS"
./scripts/inventory-metadata.sh --alias "$ALIAS" --config "$CONFIG_PATH"
./scripts/retrieve-contract-scope.sh --alias "$ALIAS" --config "$CONFIG_PATH" --wait "$WAIT_MINUTES"
./scripts/analyze-contract-scope.sh --config "$CONFIG_PATH"

echo "Contracts discovery workflow complete."
