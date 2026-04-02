#!/usr/bin/env bash
set -euo pipefail
export SF_DISABLE_AUTOUPDATE=true
export SF_AUTOUPDATE_DISABLE=true

DEFAULT_ALIAS="cm-prod-demo"
EXPECTED_INSTANCE_URL="https://storm-67f93fa3759a67.my.salesforce.com"
ALIAS="$DEFAULT_ALIAS"
ACCOUNT_COUNT=12
CONTRACTS_PER_ACCOUNT=5
NAME_PREFIX="CM Sample"

usage() {
  cat <<USAGE
Seed sample Accounts and Contracts for compelling Contracts reports/dashboard views.

Usage:
  ./scripts/seed-contracts-sample-data.sh [--alias <org-alias>] [--accounts <count>] [--contracts-per-account <count>]

Options:
  --alias                  Target org alias (default: ${DEFAULT_ALIAS})
  --accounts               Number of sample accounts (default: ${ACCOUNT_COUNT})
  --contracts-per-account  Contracts per account (default: ${CONTRACTS_PER_ACCOUNT})
  -h, --help               Show this help message
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --alias)
      ALIAS="$2"
      shift 2
      ;;
    --accounts)
      ACCOUNT_COUNT="$2"
      shift 2
      ;;
    --contracts-per-account)
      CONTRACTS_PER_ACCOUNT="$2"
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

sf_cmd() { sf "$@"; }

./scripts/preflight-target.sh --alias "$ALIAS" --expected-instance-url "$EXPECTED_INSTANCE_URL"

echo "Seeding sample data in org alias '$ALIAS'..."

mkdir -p analysis/raw analysis/tmp

# 1) Ensure accounts exist.
for i in $(seq 1 "$ACCOUNT_COUNT"); do
  account_name="$NAME_PREFIX Account $i"
  existing=$(sf_cmd data query --target-org "$ALIAS" --query "SELECT Id FROM Account WHERE Name = '$account_name' LIMIT 1" --json | node -e 'const fs=require("fs");const d=JSON.parse(fs.readFileSync(0,"utf8"));const r=d.result&&d.result.records&&d.result.records[0];console.log(r?r.Id:"")')

  if [[ -n "$existing" ]]; then
    echo "Account exists: $account_name ($existing)"
  else
    sf_cmd data create record --target-org "$ALIAS" --sobject Account --values "Name='$account_name' Type='Customer - Direct' Industry='Technology'" --json >/dev/null
    echo "Created account: $account_name"
  fi
done

# 2) Load account ids for contract seeding.
sf_cmd data query --target-org "$ALIAS" --query "SELECT Id, Name FROM Account WHERE Name LIKE '$NAME_PREFIX Account %' ORDER BY Name" --json > analysis/tmp/sample-accounts.json

# 3) Build deterministic contract plan with varied stages/time windows.
ACCOUNT_COUNT="$ACCOUNT_COUNT" CONTRACTS_PER_ACCOUNT="$CONTRACTS_PER_ACCOUNT" node <<'NODE' > analysis/tmp/sample-contract-plan.tsv
const fs = require('fs');
const data = JSON.parse(fs.readFileSync('analysis/tmp/sample-accounts.json', 'utf8'));
const accountLimit = Number(process.env.ACCOUNT_COUNT || '12');
const accounts = ((data.result && data.result.records) || []).slice(0, accountLimit);
const contractsPerAccount = Number(process.env.CONTRACTS_PER_ACCOUNT || '5');
const today = new Date();

const patterns = [
  { status: 'Draft', monthsAgo: 1, term: 12 },
  { status: 'In Approval Process', monthsAgo: 2, term: 12 },
  { status: 'Negotiating', monthsAgo: 3, term: 18 },
  { status: 'Awaiting Signature', monthsAgo: 1, term: 24 },
  { status: 'Activated', monthsAgo: 11, term: 12 },
  { status: 'Signed', monthsAgo: 10, term: 12 },
  { status: 'Rejected', monthsAgo: 4, term: 12 },
  { status: 'Canceled', monthsAgo: 5, term: 12 },
  { status: 'Contract Expired', monthsAgo: 15, term: 12 },
  { status: 'Contract Terminated', monthsAgo: 8, term: 12 },
  { status: 'Activated', monthsAgo: 6, term: 24 }
];

function toDateYMD(dateValue) {
  const y = dateValue.getUTCFullYear();
  const m = String(dateValue.getUTCMonth() + 1).padStart(2, '0');
  const d = String(dateValue.getUTCDate()).padStart(2, '0');
  return `${y}-${m}-${d}`;
}

function shiftedStart(monthsAgo, dayOffset) {
  const d = new Date(Date.UTC(today.getUTCFullYear(), today.getUTCMonth(), Math.min(28, today.getUTCDate())));
  d.setUTCMonth(d.getUTCMonth() - monthsAgo);
  d.setUTCDate(Math.min(28, d.getUTCDate() + dayOffset));
  return d;
}

accounts.forEach((account, accountIndex) => {
  for (let i = 0; i < contractsPerAccount; i++) {
    const pattern = patterns[(accountIndex + i) % patterns.length];
    const dayOffset = (accountIndex * 2 + i) % 5;
    const startDate = shiftedStart(pattern.monthsAgo, dayOffset);
    const marker = `CM-SEED|${account.Name}|${String(i + 1).padStart(2, '0')}`;

    process.stdout.write([
      account.Id,
      account.Name,
      pattern.status,
      toDateYMD(startDate),
      String(pattern.term),
      marker
    ].join('\t') + '\n');
  }
});
NODE

created=0
skipped=0
status_updates=0
status_update_failures=0

while IFS=$'\t' read -r account_id account_name contract_status start_date contract_term marker; do
  [[ -z "$account_id" ]] && continue

  existing_contract=$(sf_cmd data query --target-org "$ALIAS" --query "SELECT Id FROM Contract WHERE AccountId = '$account_id' AND StartDate = $start_date AND Status = '$contract_status' LIMIT 1" --json | node -e 'const fs=require("fs");const d=JSON.parse(fs.readFileSync(0,"utf8"));const r=d.result&&d.result.records&&d.result.records[0];console.log(r?r.Id:"")')

  if [[ -n "$existing_contract" ]]; then
    skipped=$((skipped + 1))
    continue
  fi

  create_values="AccountId='$account_id' StartDate=$start_date ContractTerm=$contract_term Status='Draft' Description='$marker'"

  create_result=$(sf_cmd data create record --target-org "$ALIAS" --sobject Contract --values "$create_values" --json)
  contract_id=$(echo "$create_result" | node -e 'const fs=require("fs");const d=JSON.parse(fs.readFileSync(0,"utf8"));console.log(d.result&&d.result.id?d.result.id:"")')
  created=$((created + 1))

  if [[ -n "$contract_id" ]] && [[ "$contract_status" != "Draft" ]]; then
    if sf_cmd data update record --target-org "$ALIAS" --sobject Contract --record-id "$contract_id" --values "Status='$contract_status'" --json >/dev/null 2>&1; then
      status_updates=$((status_updates + 1))
    else
      status_update_failures=$((status_update_failures + 1))
    fi
  fi
done < analysis/tmp/sample-contract-plan.tsv

echo "Sample data seed complete."
echo "Contracts created: $created"
echo "Contracts skipped (already existed): $skipped"
echo "Status updates applied: $status_updates"
echo "Status updates failed (left as Draft): $status_update_failures"

echo "Current status distribution for seeded accounts:"
status_json=$(sf_cmd data query --target-org "$ALIAS" --query "SELECT Status, COUNT(Id) c FROM Contract WHERE Account.Name LIKE '$NAME_PREFIX Account %' GROUP BY Status ORDER BY COUNT(Id) DESC" --json || true)
echo "$status_json" | node -e 'const fs=require("fs");const d=JSON.parse(fs.readFileSync(0,"utf8"));const rows=(d.result&&d.result.records)||[];if(!rows.length){console.log("  (no rows)");process.exit(0);}for(const r of rows){console.log(`  ${r.Status}: ${r.c}`);}'
