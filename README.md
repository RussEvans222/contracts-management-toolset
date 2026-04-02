# Salesforce Contracts Management Toolset

Custom Salesforce contracts accelerator with command center, viewer, timeline, and template manager.

## Easy Deploy
<a href="https://githubsfdeploy.herokuapp.com?owner=thedges&repo=PS2MapComponents&ref=main">
  <img alt="Deploy to Salesforce"
    src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

## Included Features

### Contracts Command Center (`c:contractsCommandCenter`)
- Top KPI strip for lifecycle and attention metrics.
- Stage Distribution donut chart.
- Expiring Contracts panel.
- Attention Queue with quick-open actions.
- Quick actions: New Contract, list views, refresh.
![Contracts Command Center](docs/images/readme/contracts-command-center.png)

### Contract Viewer (`c:contractsDocumentViewer`)
- Contract document thumbnail grid (multi-record view).
- Signed/status indicators on cards.
- Contract open links and version visibility.
- Refresh support for newly generated files/thumbnails.
![Contract Viewer](docs/images/readme/contract-viewer.png)

### Contract Documents Snapshot on Contract Page (`c:contractRecordDocumentsPanel`)
- Snapshot card on the Contract record to show the latest generated/signed contract document.
- Includes status pills, quick contract/document actions, and embedded thumbnail preview.
![Contract Documents Snapshot on Contract Page](docs/images/readme/contract-documents-snapshot.png)

### Contract History Timeline (`c:contractHistoryTimeline`)
- Left-to-right contract event timeline.
- Zoomed time navigation for dense contract activity.
- Combined events: field history, approvals, tasks/calls/emails/events.
- Interactive filtering and synchronized details panel.
![Contract History Timeline](docs/images/readme/contract-history-timeline.png)

### Contract Template Manager (`c:contractsTemplateManager`)
- Template catalog grid with preview thumbnails.
- Template usage metrics and contract drilldown.
- Open Mapper/Extract in OmniStudio builder.
- Download template DOCX.
- Optional template delete action.
![Contract Template Manager](docs/images/readme/contract-template-manager.png)

### Merge Field Authoring (inside Template Manager)
- Accordion-based Add Merge Field workflow.
- 3-step guided builder (Object -> Field -> Friendly Name).
- Suggested merge token generation.
- Preview-before-apply validation.
- Additive mapper/extract write behavior.
![Add Merge Field Workflow](docs/images/readme/merge-field-add-form.png)
![Data Mapper Merge Fields](docs/images/readme/merge-field-mapped-fields.png)

## App Pages / Tabs
- `SalesforceContracts_Command_Center`
- `SalesforceContracts_Viewer`
- `SalesforceContracts_Template_Manager`
- `SalesforceContracts_Analytics`

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
- `contractRecordDocumentsPanel`
- `contractHistoryTimeline`
- `contractsTemplateManager`

### Apex Controllers
- `SDO_ContractsCommandCenterController`
- `SDO_ContractViewerController`
- `SDO_ContractHistoryTimelineController`
- `SDO_ContractTemplateManagerController`
