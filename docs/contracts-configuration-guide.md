# Contracts Management Configuration Guide

## Purpose
Map and explain configuration layers used by Contracts Management customizations.

## Configuration Layers
- **Data model**: `CustomObject`, `CustomField`, and contract-related standard object extensions.
- **Security**: `PermissionSet`, `AuthProvider`, `ConnectedApp`, `ExternalCredential`, `NamedCredential`, `RemoteSiteSetting`.
- **Automation**: `Flow`, `FlowDefinition`, OmniStudio (`OmniScript`, `OmniIntegrationProcedure`, `OmniDataTransform`).
- **UX**: `LightningComponentBundle`, `FlexiPage`, `Layout`, `OmniUiCard`.
- **Code layer**: `ApexClass`, `ApexTrigger`, `CustomMetadata`.

## How to Review Configuration in This Project
1. Use `analysis/component-inventory.json` to inspect all discovered components.
2. Use `analysis/contracts-scope.json` to inspect filtered in-scope assets and selection reasons.
3. Use `docs/contracts-inventory.md` for domain-oriented summary.

## Integration-Specific Configuration Checks
- **Microsoft 365**
  - Validate auth and endpoint configs in credential metadata.
  - Identify flows/classes that reference Word/Outlook/document generation paths.
- **DocuSign**
  - Identify managed package namespaces and extension classes/flows.
  - Track signing workflow entry points and callback/update logic.

## Change Impact Checklist
- Which business process is affected (authoring, review, approval, signature, renewal)?
- Which metadata layers are touched?
- Which integrations are touched?
- Are there release updates or API changes to account for?
