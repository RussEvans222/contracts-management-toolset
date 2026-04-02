# Salesforce Contracts Management Toolset

Custom Salesforce contracts accelerator with command center, viewer, timeline, template manager, and demo data seeding.

## Included Features

### Contracts Command Center (`c:contractsCommandCenter`)
- Top KPI strip for lifecycle and attention metrics.
- Stage Distribution donut chart.
- Expiring Contracts panel.
- Attention Queue with quick-open actions.
- Quick actions: New Contract, list views, refresh.

### Contract Viewer (`c:contractsDocumentViewer`)
- Contract document thumbnail grid (multi-record view).
- Signed/status indicators on cards.
- Contract open links and version visibility.
- Refresh support for newly generated files/thumbnails.

### Contract History Timeline (`c:contractHistoryTimeline`)
- Left-to-right contract event timeline.
- Zoomed time navigation for dense contract activity.
- Combined events: field history, approvals, tasks/calls/emails/events.
- Interactive filtering and synchronized details panel.

### Contract Template Manager (`c:contractsTemplateManager`)
- Template catalog grid with preview thumbnails.
- Template usage metrics and contract drilldown.
- Open Mapper/Extract in OmniStudio builder.
- Download template DOCX.
- Optional template delete action.

### Merge Field Authoring (inside Template Manager)
- Accordion-based Add Merge Field workflow.
- 3-step guided builder (Object -> Field -> Friendly Name).
- Suggested merge token generation.
- Preview-before-apply validation.
- Additive mapper/extract write behavior.

## App Pages / Tabs
- `SalesforceContracts_Command_Center`
- `SalesforceContracts_Viewer`
- `SalesforceContracts_Template_Manager`
- `SalesforceContracts_Analytics`

## Demo Data Seeding

### 1. Seed lifecycle contract records
```bash
./scripts/seed-contracts-sample-data.sh --alias cm-prod-demo --accounts 12 --contracts-per-account 5
```

### 2. Seed contract document files/versions
```bash
./scripts/seed-contract-documents.sh --alias cm-prod-demo --contracts 12
```

### 3. Seed contract activities for timeline demos
```bash
./scripts/seed-contract-activities.sh --alias cm-prod-demo --contracts 20 --per-contract 8
```

## Deploy Custom UI
```bash
./scripts/deploy-command-center.sh --alias cm-prod-demo
```

## Target Org Safety Check
```bash
./scripts/preflight-target.sh --alias cm-prod-demo
```

## Primary Custom Assets

### LWCs
- `contractsCommandCenter`
- `contractsDocumentViewer`
- `contractHistoryTimeline`
- `contractsTemplateManager`

### Apex Controllers
- `SDO_ContractsCommandCenterController`
- `SDO_ContractViewerController`
- `SDO_ContractHistoryTimelineController`
- `SDO_ContractTemplateManagerController`
