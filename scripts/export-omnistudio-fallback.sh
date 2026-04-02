#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

DEFAULT_ALIAS="cm-prod-demo"
ALIAS="$DEFAULT_ALIAS"
JOB_FILE="analysis/vlocity-contracts-job.yaml"

usage() {
  cat <<USAGE
Fallback export for OmniStudio/Vlocity assets when Omni metadata types aren't retrievable via Metadata API.

Usage:
  ./scripts/export-omnistudio-fallback.sh [--alias <org-alias>] [--job-file <path>]

Options:
  --alias      Salesforce org alias (default: ${DEFAULT_ALIAS})
  --job-file   Vlocity build job file (default: ${JOB_FILE})
  -h, --help   Show this help message

Notes:
- Requires the Vlocity Build Tool CLI (vlocity) to be installed.
- Output is expected under analysis/raw/omnistudio/ and should be summarized into
  analysis/contracts-scope.json and docs/contracts-inventory.md manually or via custom parser.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --alias)
      ALIAS="$2"
      shift 2
      ;;
    --job-file)
      JOB_FILE="$2"
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

if ! command -v vlocity >/dev/null 2>&1; then
  echo "vlocity CLI not found. Install Vlocity Build Tool before running this fallback." >&2
  exit 1
fi

mkdir -p analysis/raw/omnistudio

if [[ ! -f "$JOB_FILE" ]]; then
  cat > "$JOB_FILE" <<'JOB'
projectPath: ./analysis/raw/omnistudio
queries:
  - DataRaptor/%Contract%
  - OmniScript/%Contract%
  - IntegrationProcedure/%Contract%
  - OmniUiCard/%Contract%
  - VlocityUITemplate/%Contract%
  - VlocityDataPackConfiguration/%DocuSign%
  - VlocityDataPackConfiguration/%Microsoft%
JOB
fi

echo "Running Vlocity export using alias '$ALIAS' and job '$JOB_FILE'..."
vlocity -sfdx.username "$ALIAS" -job "$JOB_FILE" packExport

echo "OmniStudio fallback export complete."
