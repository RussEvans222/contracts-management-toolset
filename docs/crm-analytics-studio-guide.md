# CRM Analytics Studio Guide (Contracts)

## Org + App Context
- Target org alias: `cm-prod-demo`
- Target instance: `https://storm-67f93fa3759a67.my.salesforce.com`
- Analytics app/folder: `Salesforce Contracts Analytics` (`Salesforce_Contracts_Analytics`)

## What Exists Now (Verified March 31, 2026)
- Datasets:
  - `CLM_Contract`
  - `CLM_ContractHistory`
  - `CLM_Document_Clause`
  - `CLM_Document_Template`
  - `CLM_Sales_Contract_Line`
- Dashboards:
  - `Contract_Admin`
  - `Contract_Stage_Insights`
  - `Sales_Operation`
  - `Contract_Line_Items_Embedded`
  - `Contracts_Account_Embedded`
  - `Contracts_Quote_Embedded`
- Contracts recipe:
  - `Salesforce_Contracts_Analytics_Contract_Lifecycle_Management_Analytics`
  - Recipe ID: `05vHu000000Z4hpIAC`
  - Target dataflow ID: `02KHu000004d7zlMAA`

## Latest Refresh Snapshot
- Latest contracts recipe job: `0ePHu000003JJRSMA4`
- Status: `Success`
- Start/End: `2026-03-31T17:58:52Z` -> `2026-03-31T18:02:40Z`
- Output node row counts from this run:
  - `Output_Contract`: 67
  - `Output_Contract_History`: 34
  - `Output Document Templates`: 25
  - `Output DocumentClause`: 0
  - `Output_CLM_Sales_Contract_Line`: 0

## App Navigation Integration
- CRM Analytics is now promoted to a top-level app page and tab:
  - Tab: `Salesforce Contracts Analytics`
  - FlexiPage API name: `SalesforceContracts_Analytics`
  - Components embedded:
    - Custom all-time stage insights (`c:contractsStageInsightsPanel`)
    - Dashboard: `Contract_Admin`
- URLs:
  - `https://storm-67f93fa3759a67.lightning.force.com/lightning/n/SalesforceContracts_Analytics`
  - `https://storm-67f93fa3759a67.lightning.force.com/lightning/n/SalesforceContracts_Command_Center`

## Demo Data Baseline (for compelling visuals)
- Seeded contract count (sample accounts): `60`
- Seed status coverage:
  - Draft, In Approval Process, Negotiating, Awaiting Signature, Activated, Signed, Rejected, Canceled, Contract Expired, Contract Terminated
- Expiring soon cohort (next 60 days): `10`

## Repeatable Commands
```bash
./scripts/preflight-target.sh --alias cm-prod-demo
./scripts/inventory-crm-analytics.sh --alias cm-prod-demo
./scripts/seed-contracts-sample-data.sh --alias cm-prod-demo --accounts 12 --contracts-per-account 5
```

## Output Artifacts
- `analysis/crm-analytics/contracts-analytics-summary.json`
- `analysis/crm-analytics/contracts-datasets.tsv`
- `analysis/crm-analytics/contracts-dashboards.tsv`
- `analysis/crm-analytics/contracts-recipes.tsv`
- `analysis/crm-analytics/contracts-jobs.tsv`
- `analysis/crm-analytics/contracts-recipe-output-nodes.tsv`
