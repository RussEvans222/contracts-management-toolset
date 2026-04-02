# Contract Template Manager: Merge Field Authoring

## Purpose
This document explains the merge-field authoring capability embedded in the Contract Template Manager and clarifies the two operating modes:
- Production-direct mode (implemented)
- Demo-safe simulation mode (documented fallback)

## Production-Direct Mode (Implemented)
The right-side **Template Details** pane includes an **Add Merge Field** workflow with:
1. Source object selection (template-scoped)
2. Source field selection
3. Friendly merge field name entry
4. Required **Preview Change** step before **Apply**

### What `Apply` Does
`Apply` inserts additive rows into OmniStudio DataRaptor items (`OmniDataTransformItem`):
- Extract candidate row: source path -> extract alias key
- Mapper candidate row: extract alias key -> friendly merge output key

No existing rows are overwritten.

### Safety/Guardrails
- Scope is inferred from the selected template's extract context.
- Source object/field choices are filtered by runtime describe + read access.
- Friendly merge name is normalized to CamelCase alphanumeric and must begin with a letter.
- Duplicate mapper output names are blocked with suggested alternatives.
- Idempotent behavior: if exact extract+mapper rows already exist, apply returns success/no-op.

## Demo-Safe Simulator Mode (Fallback, Not Shipped)
Use this option when direct mutation of Omni DataRaptors is disallowed.

### Suggested Design
- Persist requested mappings in a custom object (for example `Merge_Field_Config__c`).
- Generate a simulated transform-output JSON in Apex/LWC for review and copy use.
- Show merge token syntax (for example `{{VendorAddress}}`) and export/copy actions.

### Tradeoff
- Pro: no mutation of DataRaptor internals.
- Con: mappings are not immediately active in real document generation until manually applied to mapper/extract definitions.

## Operational Notes
- Keep this workflow additive-only.
- Use Preview -> Apply as a required sequence.
- Reopen DataRaptor Builder after apply to validate resulting mapping rows in context.
