# 🧾 1. HERO SECTION

# Salesforce Contracts Management Accelerator

AI-powered contract lifecycle and document intelligence built on Salesforce.

- Accelerate review cycles with AI-driven version comparison and evidence-backed change summaries.
- Give executives and reviewers real-time lifecycle visibility across draft, approval, signature, and renewal states.
- Govern document templates and merge fields in a business-friendly workspace.
- Improve operational control with timeline traceability, obligation context, and guided next actions.

---

# 🚀 2. CORE CAPABILITIES

- **AI Version Compare** with structured change output and before/after evidence.
- **Contracts Command Center** for KPI-driven lifecycle monitoring and attention queues.
- **Contract Viewer** for thumbnail-based contract file and version exploration.
- **Contract Timeline** for left-to-right audit visibility across contract and activity events.
- **Template Manager** for document template governance, usage analytics, and merge field authoring.

---

# 🧠 3. WHY THIS EXISTS

Public sector and enterprise contract teams often operate across disconnected systems, manual review workflows, and fragmented document histories. That creates avoidable risk, slower approvals, and weak audit readiness.

This accelerator brings contracts, documents, AI insight, and operational context into one Salesforce-native experience so teams can move faster, reduce risk, and make review decisions with confidence.

---

# 🧱 4. PRODUCT PILLARS

## 🤖 Contract Intelligence
AI comparison and prompt-driven summaries convert complex version changes into clear, structured insights. Teams can focus on business impact instead of manually diffing documents.

## ⚙️ Contract Operations
Operational dashboards, status segmentation, and action queues surface what needs attention now. Reviewers and operators can triage quickly and keep lifecycle work moving.

## 📄 Document Governance
Template governance, usage visibility, and guided merge-field authoring help standardize document generation. Admins can maintain quality and consistency without deep technical handoffs.

## 🕒 Audit & Traceability
Unified timeline history across record changes, approvals, and activities provides end-to-end traceability. Teams gain defensible audit narratives for oversight and compliance reviews.

---

# 🔥 5. KEY FEATURES (REUSE EXISTING CONTENT)

### AI Version Compare
- Compare two contract document versions through an async comparison pipeline.
- Creates and tracks a `Document_Comparisson__c` record with run status, summary, confidence, and parsed change categories.
- Supports rerun behavior and comparison record reuse to avoid unnecessary repeated AI calls.
- Captures structured outputs including `materialChanges`, `riskFlags`, `recommendedActions`, and evidence fields (`beforeText`, `afterText`) when returned.
- Why teams use this: reviewers get faster, evidence-oriented change insight without manually reading every revision.

### Contracts Command Center
- Top KPI strip for lifecycle and attention metrics.
- Stage Distribution donut chart.
- Expiring Contracts panel.
- Attention Queue with quick-open actions.
- Quick actions: New Contract, list views, refresh.
- Why teams use this: gives executives and reviewers an immediate health check of contract operations without opening reports.

### Contract Viewer
- Contract document thumbnail grid (multi-record view).
- Signed/status indicators on cards.
- Contract open links and version visibility.
- Refresh support for newly generated files/thumbnails.
- Compare Versions modal with chronological left-to-right ordering (older on left, updated on right).
- Contract Documents Snapshot on Contract Page (`c:contractRecordDocumentsPanel`) with latest generated/signed document visibility.
- Snapshot includes status pills, quick contract/document actions, and embedded thumbnail preview.
- Why teams use this: legal and program staff can visually validate the right contract files quickly, at portfolio and record level.

### Contract Timeline
- Left-to-right contract event timeline.
- Zoomed time navigation for dense contract activity.
- Combined events: field history, approvals, tasks/calls/emails/events.
- Interactive filtering and synchronized details panel.
- Why teams use this: creates a clear audit narrative of who changed what and when across the full contract lifecycle.

### Template Manager
- Template catalog grid with preview thumbnails.
- Template usage metrics and contract drilldown.
- Open Mapper/Extract in OmniStudio builder.
- Download template DOCX.
- Optional template delete action.
- Merge Field Authoring inside Template Manager with an accordion-based Add Merge Field workflow.
- 3-step guided merge builder (Object -> Field -> Friendly Name) with suggested token generation.
- Preview-before-apply validation with additive mapper/extract write behavior.
- Why teams use this: centralizes template governance and enables faster, safer template evolution with less developer dependency.

**Also Included:**
- **Agentforce Contract Summary Action** (`Contract_Obligations_Summary_For_Agentforce`) to compile obligations context and generate AI-ready contract summaries.

---

# 🖼 6. VISUALS (PLACEHOLDERS ONLY)

![Contracts Command Center](docs/images/command-center.png)
![AI Compare](docs/images/ai-compare.png)
![Contract Viewer](docs/images/contract-viewer.png)
![Contract Documents Snapshot](docs/images/contract-documents-snapshot.png)
![Contract Timeline](docs/images/timeline.png)
![Template Manager](docs/images/template-manager.png)

---

# ⚙️ 7. QUICK START

1. Deploy the accelerator metadata to your Salesforce org.
2. Open the **Salesforce Contracts** app and navigate to **Contracts Command Center**.
3. Create or open a Contract and review generated files in **Contract Viewer**.
4. Generate or update a contract document from your configured template workflow.
5. Run **AI Compare** on two versions to produce summary, risks, and recommended actions.

Helpful commands:
- Deploy custom UI: `./scripts/deploy-command-center.sh --alias cm-prod-demo`
- Preflight target safety check: `./scripts/preflight-target.sh --alias cm-prod-demo`

---

# 🧩 8. ARCHITECTURE OVERVIEW

- **Apex services/controllers** power contract metrics, document retrieval, timeline aggregation, template governance, and AI comparison orchestration.
- **LWC experience layer** delivers Command Center, Viewer, Timeline, Template Manager, and record-level document/comparison previews.
- **Flow + Prompt Builder** support Agentforce actions and prompt-driven obligation/contract summarization.
- **Salesforce Files + version links** provide document storage, version relationships, preview rendering, and comparison context.

---

# 📦 9. PROJECT STRUCTURE (REUSE EXISTING LIST)

**LWCs**
- `contractsCommandCenter`
- `contractsDocumentViewer`
- `contractRecordDocumentsPanel`
- `contractHistoryTimeline`
- `contractsTemplateManager`
- `documentComparisonRecordPreview`
- `contractObligationsPanel`

**Apex Controllers / Services**
- `SDO_ContractsCommandCenterController`
- `SDO_ContractViewerController`
- `SDO_ContractHistoryTimelineController`
- `SDO_ContractTemplateManagerController`
- `SDO_DocumentComparisonPreviewController`
- `SDO_ContractComparisonController`
- `SDO_ContractComparisonQueueable`
- `SDO_ContractVersionCompareService`
- `SDO_ContractPromptTemplateInvocable`

**Flow + Prompt Assets**
- `Contract_Obligations_Summary_For_Agentforce` (Autolaunched Flow)
- `Contract_Version_Compare_For_Agentforce` (Autolaunched Flow)
- `Contracts_Summary` (Prompt Template)
- `Contracts_Version_Compare` / `Contracts_Comparison_Record` (Prompt Template pipeline usage)

**Scripts**
- Discovery/inventory: `auth-org.sh`, `inventory-metadata.sh`, `retrieve-contract-scope.sh`, `analyze-contract-scope.sh`, `run-discovery.sh`
- Deployment/safety: `deploy-command-center.sh`, `preflight-target.sh`
- Seed/support: `seed-contracts-sample-data.sh`, `seed-contract-activities.sh`, `seed-contract-documents.sh`, `seed-portal-contract-demo-data.sh`

**App Pages / Tabs**
- `SalesforceContracts_Command_Center`
- `SalesforceContracts_Viewer`
- `SalesforceContracts_Template_Manager`
- `SalesforceContracts_Analytics`
- `Document_Comparisson__c`

**Developer Change Log**
- `docs/developer-change-log.md`

---

# 🚀 10. ROADMAP

- Clause-level AI analysis with richer evidence extraction.
- Contract risk scoring by change type, obligation state, and lifecycle stage.
- External document extraction and cross-repository comparison support.
- Approval intelligence with bottleneck prediction and routing recommendations.
