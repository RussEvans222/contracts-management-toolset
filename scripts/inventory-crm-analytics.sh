#!/usr/bin/env bash
set -euo pipefail

DEFAULT_ALIAS="cm-prod-demo"
DEFAULT_EXPECTED_INSTANCE_URL="https://storm-67f93fa3759a67.my.salesforce.com"
API_VERSION="v66.0"
CONTRACTS_FOLDER_NAME="Salesforce_Contracts_Analytics"
ALIAS="$DEFAULT_ALIAS"
EXPECTED_INSTANCE_URL="$DEFAULT_EXPECTED_INSTANCE_URL"

usage() {
  cat <<USAGE
Inventory CRM Analytics (Analytics Studio) assets for Contracts in the locked target org.

Usage:
  ./scripts/inventory-crm-analytics.sh [--alias <org-alias>] [--api-version <version>] [--expected-instance-url <url>]

Options:
  --alias                  Target org alias (default: ${DEFAULT_ALIAS})
  --api-version            Salesforce REST API version for Wave endpoints (default: ${API_VERSION})
  --expected-instance-url  Target lock URL (default: ${DEFAULT_EXPECTED_INSTANCE_URL})
  -h, --help               Show this help message
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --alias)
      ALIAS="$2"
      shift 2
      ;;
    --api-version)
      API_VERSION="$2"
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

mkdir -p analysis/crm-analytics
./scripts/preflight-target.sh --alias "$ALIAS" --expected-instance-url "$EXPECTED_INSTANCE_URL"

sf org display --target-org "$ALIAS" --verbose --json > analysis/crm-analytics/org-display.json
INSTANCE_URL="$(jq -r '.result.instanceUrl' analysis/crm-analytics/org-display.json)"
ACCESS_TOKEN="$(jq -r '.result.accessToken' analysis/crm-analytics/org-display.json)"

fetch_wave() {
  local endpoint="$1"
  local output_path="$2"
  curl -sS \
    -H "Authorization: Bearer ${ACCESS_TOKEN}" \
    "${INSTANCE_URL}/services/data/${API_VERSION}/wave/${endpoint}" > "$output_path"
}

fetch_wave "folders" "analysis/crm-analytics/folders.json"
fetch_wave "datasets" "analysis/crm-analytics/datasets.json"
fetch_wave "dashboards" "analysis/crm-analytics/dashboards.json"
fetch_wave "recipes" "analysis/crm-analytics/recipes.json"
fetch_wave "dataflows" "analysis/crm-analytics/dataflows.json"
fetch_wave "dataflowjobs" "analysis/crm-analytics/dataflowjobs.json"

jq -n \
  --arg generatedAt "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  --arg targetOrgAlias "$ALIAS" \
  --arg instanceUrl "$INSTANCE_URL" \
  --arg contractsFolderName "$CONTRACTS_FOLDER_NAME" \
  --slurpfile datasets analysis/crm-analytics/datasets.json \
  --slurpfile dashboards analysis/crm-analytics/dashboards.json \
  --slurpfile recipes analysis/crm-analytics/recipes.json \
  --slurpfile dataflows analysis/crm-analytics/dataflows.json \
  --slurpfile jobs analysis/crm-analytics/dataflowjobs.json \
  '{
    generatedAt: $generatedAt,
    targetOrgAlias: $targetOrgAlias,
    instanceUrl: $instanceUrl,
    contractsFolderName: $contractsFolderName,
    datasets: ($datasets[0].datasets // [] | map(select(.folder.name == $contractsFolderName) | {
      id,
      name,
      label,
      currentVersionId,
      dataRefreshDate,
      lastModifiedDate,
      lastQueriedDate
    })),
    dashboards: ($dashboards[0].dashboards // [] | map(select(.folder.name == $contractsFolderName) | {
      id,
      name,
      label,
      refreshDate,
      lastModifiedDate
    })),
    recipes: ($recipes[0].recipes // [] | map(select((.name | ascii_downcase | contains("contract")) or (.label | ascii_downcase | contains("contract"))) | {
      id,
      name,
      label,
      status,
      targetDataflowId
    })),
    dataflows: ($dataflows[0].dataflows // [] | map(select((.name | ascii_downcase | contains("contract")) or (.label | ascii_downcase | contains("contract"))) | {
      id,
      name,
      label,
      nextScheduledDate,
      lastModifiedDate
    })),
    latestJobs: ($jobs[0].dataflowJobs // [] | .[0:10] | map({
      id,
      jobType,
      status,
      startDate,
      endDate,
      source
    }))
  }' > analysis/crm-analytics/contracts-analytics-summary.json

{
  echo -e "name\tid\tcurrentVersionId\tdataRefreshDate\tlastModifiedDate\tlastQueriedDate"
  jq -r '.datasets[] | [.name,.id,.currentVersionId,.dataRefreshDate,.lastModifiedDate,.lastQueriedDate] | @tsv' analysis/crm-analytics/contracts-analytics-summary.json
} > analysis/crm-analytics/contracts-datasets.tsv

{
  echo -e "name\tid\trefreshDate\tlastModifiedDate"
  jq -r '.dashboards[] | [.name,.id,.refreshDate,.lastModifiedDate] | @tsv' analysis/crm-analytics/contracts-analytics-summary.json
} > analysis/crm-analytics/contracts-dashboards.tsv

{
  echo -e "name\tid\tstatus\ttargetDataflowId"
  jq -r '.recipes[] | [.name,.id,.status,.targetDataflowId] | @tsv' analysis/crm-analytics/contracts-analytics-summary.json
} > analysis/crm-analytics/contracts-recipes.tsv

{
  echo -e "id\tjobType\tstatus\tstartDate\tendDate\tsourceName"
  jq -r '.latestJobs[] | [.id,.jobType,.status,(.startDate // ""),(.endDate // ""),(.source.name // "")] | @tsv' analysis/crm-analytics/contracts-analytics-summary.json
} > analysis/crm-analytics/contracts-jobs.tsv

echo "CRM Analytics inventory complete."
echo "Summary: analysis/crm-analytics/contracts-analytics-summary.json"
echo "Datasets: analysis/crm-analytics/contracts-datasets.tsv"
echo "Dashboards: analysis/crm-analytics/contracts-dashboards.tsv"
echo "Recipes: analysis/crm-analytics/contracts-recipes.tsv"
echo "Jobs: analysis/crm-analytics/contracts-jobs.tsv"
