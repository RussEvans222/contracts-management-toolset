# Contracts Home Page + Sample Data Next Steps

## What Was Added
- New app page metadata: `force-app/main/default/flexipages/SalesforceContracts_Command_Center.flexipage-meta.xml`
- New app tab metadata: `force-app/main/default/tabs/SalesforceContracts_Command_Center.tab-meta.xml`
- Sample data script: `scripts/seed-contracts-sample-data.sh`

## App Update Required
The Salesforce Contracts app metadata should include the new tab so users can land on a curated command center view.

## Deploy Metadata
```bash
export SF_USE_GENERIC_UNIX_KEYCHAIN=true
export SF_HOME_DIR="/Users/russellevans/Downloads/Salesforce Builds/Contracts/.sfhome-generic"

sf project deploy start \
  --target-org cm-prod-demo \
  --metadata FlexiPage:SalesforceContracts_Command_Center \
  --metadata CustomTab:SalesforceContracts_Command_Center \
  --metadata CustomApplication:standard__SalesforceContracts \
  --ignore-conflicts
```

## Seed Sample Data
```bash
export SF_USE_GENERIC_UNIX_KEYCHAIN=true
export SF_HOME_DIR="/Users/russellevans/Downloads/Salesforce Builds/Contracts/.sfhome-generic"

./scripts/seed-contracts-sample-data.sh --alias cm-prod-demo --accounts 10 --contracts-per-account 3
```

## Validate
- Open app: **Salesforce Contracts**
- Open tab: **Contracts Command Center**
- Confirm list cards populate for:
  - All Contracts
  - All In Approval Contracts
  - All Activated Contracts
  - All Service Contracts
