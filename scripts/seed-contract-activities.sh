#!/usr/bin/env bash
set -euo pipefail

DEFAULT_ALIAS="cm-prod-demo"
DEFAULT_EXPECTED_INSTANCE_URL="https://storm-67f93fa3759a67.my.salesforce.com"
ALIAS="$DEFAULT_ALIAS"
EXPECTED_INSTANCE_URL="$DEFAULT_EXPECTED_INSTANCE_URL"
MAX_CONTRACTS=20
ACTIVITIES_PER_CONTRACT=8

usage() {
  cat <<USAGE
Seed Task/Event activity records onto Contracts for timeline demos.

Usage:
  ./scripts/seed-contract-activities.sh [--alias <org-alias>] [--contracts <count>] [--per-contract <count>] [--expected-instance-url <url>]

Options:
  --alias                  Target org alias (default: ${DEFAULT_ALIAS})
  --contracts              Number of contracts to seed (default: ${MAX_CONTRACTS})
  --per-contract           Activity rows per contract (default: ${ACTIVITIES_PER_CONTRACT})
  --expected-instance-url  Locked target instance URL (default: ${DEFAULT_EXPECTED_INSTANCE_URL})
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --alias)
      ALIAS="$2"
      shift 2
      ;;
    --contracts)
      MAX_CONTRACTS="$2"
      shift 2
      ;;
    --per-contract)
      ACTIVITIES_PER_CONTRACT="$2"
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

./scripts/preflight-target.sh --alias "$ALIAS" --expected-instance-url "$EXPECTED_INSTANCE_URL"

mkdir -p analysis/raw

cat > analysis/raw/seed-contract-activities.apex <<APEX
Integer maxContracts = ${MAX_CONTRACTS};
Integer perContract = ${ACTIVITIES_PER_CONTRACT};

List<Contract> contracts = [
    SELECT Id, ContractNumber, Status
    FROM Contract
    ORDER BY LastModifiedDate DESC
    LIMIT :maxContracts
];

if (contracts.isEmpty()) {
    System.debug('No contracts found for activity seed.');
    return;
}

List<Task> tasksToInsert = new List<Task>();
List<Event> eventsToInsert = new List<Event>();
Datetime anchor = System.now().addDays(-60);
Integer seed = 0;

for (Contract contractRecord : contracts) {
    for (Integer i = 0; i < perContract; i++) {
        Datetime stamp = anchor.addDays(Math.mod(seed, 45)).addHours(Math.mod(i * 3, 16)).addMinutes(Math.mod(i * 11, 59));
        String activityType = Math.mod(i, 3) == 0 ? 'Email' : (Math.mod(i, 3) == 1 ? 'Call' : 'Review');
        String taskStatus = Math.mod(i, 4) == 0 ? 'Completed' : (Math.mod(i, 4) == 1 ? 'In Progress' : 'Not Started');

        Task taskRecord = new Task(
            WhatId = contractRecord.Id,
            Subject = 'Contract ' + contractRecord.ContractNumber + ' - ' +
                (activityType == 'Email' ? 'Vendor email follow-up' : (activityType == 'Call' ? 'Stakeholder call' : 'Revision review')),
            Type = activityType,
            Status = taskStatus,
            Priority = Math.mod(i, 2) == 0 ? 'High' : 'Normal',
            ActivityDate = stamp.date(),
            Description = 'CM timeline demo seed activity for ' + contractRecord.ContractNumber
        );
        tasksToInsert.add(taskRecord);

        if (Math.mod(i, 2) == 0) {
            Event eventRecord = new Event(
                WhatId = contractRecord.Id,
                Subject = 'Contract ' + contractRecord.ContractNumber + ' - Working Session',
                StartDateTime = stamp,
                EndDateTime = stamp.addMinutes(45),
                DurationInMinutes = 45,
                Description = 'CM timeline demo event seed'
            );
            eventsToInsert.add(eventRecord);
        }

        seed++;
    }
}

if (!tasksToInsert.isEmpty()) {
    insert tasksToInsert;
}
if (!eventsToInsert.isEmpty()) {
    insert eventsToInsert;
}

System.debug('Seeded contracts: ' + contracts.size());
System.debug('Seeded tasks: ' + tasksToInsert.size());
System.debug('Seeded events: ' + eventsToInsert.size());
APEX

echo "Seeding contract activity in alias '$ALIAS'..."
sf apex run --target-org "$ALIAS" --file analysis/raw/seed-contract-activities.apex --json > analysis/raw/seed-contract-activities.json

echo "Seed complete. Summaries:"
sf data query --target-org "$ALIAS" --query "SELECT COUNT(Id) total FROM Task WHERE WhatId IN (SELECT Id FROM Contract)" --json | jq -r '"Tasks linked to contracts: \(.result.records[0].total)"'
sf data query --target-org "$ALIAS" --query "SELECT COUNT(Id) total FROM Event WHERE WhatId IN (SELECT Id FROM Contract)" --json | jq -r '"Events linked to contracts: \(.result.records[0].total)"'
