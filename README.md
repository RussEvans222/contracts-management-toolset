# Salesforce Contracts Management Toolset

Public-sector focused accelerator for Salesforce Contracts in the Kansas Commerce demo org (`storm-67f93fa3759a67`).

This repository now includes a complete Contracts management workspace: discovery tooling, operational command center, analytics access, document/template management, timeline intelligence, and demo data seeding.

## Positioning
Use this toolset to demo and operate a contract lifecycle end-to-end:
- Intake and attention queue for new requests.
- Contract execution monitoring (approval, signature, activation, expiration).
- Contract document visibility with preview/version context.
- Template governance and merge-field authoring for OmniStudio document generation.
- Timeline evidence (field history + approvals + activities) for audit-style storytelling.

## Feature Sets

### 1. Contracts Command Center
- **Component:** `c:contractsCommandCenter`
- **Page/Tab:** `SalesforceContracts_Command_Center`
- **What it provides:**
  - KPI header (total, draft, approval, activated, signed).
  - Stage distribution visualization.
  - Expiring contracts panel.
  - Attention Queue with quick-open actions.
  - One-click navigation actions (new contract, list views, refresh).
- **Theme:** aligned to a professional public-sector visual style (muted slate/navy palette).

### 2. Contract Viewer
- **Component:** `c:contractsDocumentViewer`
- **Page/Tab:** `SalesforceContracts_Viewer`
- **What it provides:**
  - Thumbnail-first grid for recent contract documents (expanded view capacity).
  - Signed-state badges and contract status context.
  - Version count visibility and quick contract open.
  - Refresh behavior for latest files/thumbnails.
  - Filtering and sorting toward latest contract activity.

### 3. Contract History Timeline
- **Component:** `c:contractHistoryTimeline`
- **Placement:** Contract record experience.
- **What it provides:**
  - Left-to-right timeline with zoom controls.
  - Contract history + approvals + Salesforce activities (tasks/calls/emails/events).
  - Legend-driven filtering and isolate behavior.
  - Detail panel synchronized with selected timeline bucket/event.
  - Improved event markers/icons and scale handling.

### 4. Contract Template Manager
- **Component:** `c:contractsTemplateManager`
- **Page/Tab:** `SalesforceContracts_Template_Manager`
- **What it provides:**
  - CLM template catalog with KPI strip.
  - Card/grid browsing with front-page preview thumbnails.
  - Usage drilldown by related contract/version/file metrics.
  - Quick actions: open template app context, download DOCX, open mapper/extract in OmniStudio builder.
  - Admin delete action for template records.

### 5. Merge Field Authoring (Template Manager)
- **Location:** right-side Template Details panel.
- **What it provides:**
  - Accordion-based “Add Merge Field” workflow (closed by default).
  - 3-step flow: Source Object -> Source Field -> Friendly Name.
  - Suggested merge name generation (example: `FundingAward:AwardeeName -> {{FundingAwardAwardeeName}}`).
  - Preview-before-apply validation.
  - Additive write path for DataRaptor Extract + Mapper item creation.
  - Mapper-focused merge field listing for document authors.

### 6. CRM Analytics (Analytics Studio) Enablement
- **Assets:** `SalesforceContracts_Analytics` app page/tab plus inventory script support.
- **What it provides:**
  - Contracts analytics surface in app navigation.
  - Dataset/dashboard/recipe discovery and baseline inventory support via script.

### 7. Demo Data and Operational Seeding
- **Scripts:** sample contracts, contract documents/versions, and contract activities.
- **What it provides:**
  - Realistic seeded lifecycle distribution for demos.
  - Expiring windows and trend/population support.
  - Activity history density for timeline and operational storytelling.

### 8. Discovery and Documentation Framework
- **What it provides:**
  - Metadata inventory and contract-scope retrieval/analyze scripts.
  - Integration mapping support for M365 + DocuSign touchpoints.
  - Structured docs for setup/configuration, explainer, data model, and release adoption.

## Core Pages and Tabs
- `SalesforceContracts_Command_Center` (FlexiPage + Tab)
- `SalesforceContracts_Viewer` (FlexiPage + Tab)
- `SalesforceContracts_Template_Manager` (FlexiPage + Tab)
- `SalesforceContracts_Analytics` (FlexiPage + Tab)

## Key Components and Controllers

### LWCs
- `contractsCommandCenter`
- `contractsDocumentViewer`
- `contractHistoryTimeline`
- `contractsTemplateManager`
- `contractsStageInsightsPanel`

### Apex (primary custom controllers)
- `SDO_ContractsCommandCenterController`
- `SDO_ContractViewerController`
- `SDO_ContractHistoryTimelineController`
- `SDO_ContractTemplateManagerController`

## Operational Scripts
- `./scripts/auth-org.sh` - interactive auth + alias setup.
- `./scripts/preflight-target.sh` - locked-org verification before mutating actions.
- `./scripts/deploy-command-center.sh` - deploy command-center bundle.
- `./scripts/seed-contracts-sample-data.sh` - lifecycle contract seed.
- `./scripts/seed-contract-documents.sh` - contract document/version seed.
- `./scripts/seed-contract-activities.sh` - timeline activity seed.
- `./scripts/inventory-metadata.sh` - metadata type/component inventory.
- `./scripts/retrieve-contract-scope.sh` - contract-scope retrieval.
- `./scripts/analyze-contract-scope.sh` - scope classification + summaries.
- `./scripts/inventory-crm-analytics.sh` - CRM Analytics asset inventory.
- `./scripts/export-omnistudio-fallback.sh` - Omni fallback export path.
- `./scripts/run-discovery.sh` - orchestrated discovery workflow.

## Documentation Set
- `/Users/russellevans/Downloads/Salesforce Builds/Contracts/docs/contracts-inventory.md`
- `/Users/russellevans/Downloads/Salesforce Builds/Contracts/docs/contracts-setup-guide.md`
- `/Users/russellevans/Downloads/Salesforce Builds/Contracts/docs/contracts-configuration-guide.md`
- `/Users/russellevans/Downloads/Salesforce Builds/Contracts/docs/contracts-explainer.md`
- `/Users/russellevans/Downloads/Salesforce Builds/Contracts/docs/m365-docusign-integration-map.md`
- `/Users/russellevans/Downloads/Salesforce Builds/Contracts/docs/spring26-adoption-backlog.md`
- `/Users/russellevans/Downloads/Salesforce Builds/Contracts/docs/contracts-versioning-data-model.md`
- `/Users/russellevans/Downloads/Salesforce Builds/Contracts/docs/crm-analytics-studio-guide.md`
- `/Users/russellevans/Downloads/Salesforce Builds/Contracts/docs/contracts-template-merge-field-authoring.md`

## Environment and Safety Defaults
- **Canonical org alias:** `cm-prod-demo`
- **Locked instance URL:** `https://storm-67f93fa3759a67.my.salesforce.com`
- Discovery scripts are read-focused.
- Mutating scripts should run only after `preflight-target.sh` succeeds.

## Quick Start
```bash
export SF_USE_GENERIC_UNIX_KEYCHAIN=true
export SF_HOME_DIR="/Users/russellevans/Downloads/Salesforce Builds/Contracts/.sfhome-generic"
./scripts/auth-org.sh --alias cm-prod-demo
./scripts/preflight-target.sh --alias cm-prod-demo
```

## Deploy + Seed Example
```bash
./scripts/deploy-command-center.sh --alias cm-prod-demo
./scripts/seed-contracts-sample-data.sh --alias cm-prod-demo --accounts 12 --contracts-per-account 5
./scripts/seed-contract-documents.sh --alias cm-prod-demo --contracts 12
./scripts/seed-contract-activities.sh --alias cm-prod-demo --contracts 20 --per-contract 8
```

## Developer Changelog

### 2026-04-02
- Re-themed `contractsTemplateManager` to a unified public-sector visual system.
- Re-themed `contractsCommandCenter` to match the same palette and UI tone.
- Added/updated README as a full Contracts Management Toolset summary.

### 2026-04-01
- Delivered merge-field authoring in Template Manager (preview -> apply).
- Added suggested merge-name generation and accordion UX behavior.
- Added mapper/extract deep links to OmniStudio builder contexts.
- Added template thumbnail preview surfaces and usage drilldown refinements.
- Added template delete action support in manager UI.

### 2026-03-31
- Built/iterated Contracts Command Center (KPIs, stage insights, attention queue).
- Added Contract Viewer with document thumbnails, signed indicators, version context.
- Implemented Contract History Timeline with scale/zoom and event integrations.
- Added CRM Analytics app page/tab surfaces.
- Added seed scripts for contracts, documents, and activities.
- Established discovery scripts and contract-focused documentation baseline.

## Notes
- This repo is optimized for demo + accelerator workflows in public sector contracts use cases.
- For production hardening, add regression test packs for Apex controllers and LWC Jest where appropriate.
