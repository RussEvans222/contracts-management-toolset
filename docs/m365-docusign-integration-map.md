# M365 and DocuSign Integration Map

## Objective
Document where Microsoft 365 and DocuSign touch your Contracts Management implementation.

## Inventory Inputs
- `analysis/component-inventory.json`
- `analysis/contracts-scope.json`
- `analysis/integration-discovery.md`
- `docs/contracts-inventory.md`

## Integration Touchpoint Categories
- Credential and auth configs:
  - `NamedCredential`, `ExternalCredential`, `AuthProvider`, `ConnectedApp`, `RemoteSiteSetting`
- Automation touchpoints:
  - `Flow`, `OmniScript`, `OmniIntegrationProcedure`, `ApexClass`
- UX touchpoints:
  - `LightningComponentBundle`, `FlexiPage`, `OmniUiCard`

## Microsoft 365 Mapping Checklist
- Document generation/assembly points tied to Word workflows.
- Outlook or mail/collaboration related process triggers.
- Endpoint/auth setup and rotation ownership.

## DocuSign Mapping Checklist
- Envelope creation triggers and metadata source.
- Signing status callback/update pathways.
- Error handling and retry points.

## Risks to Capture
- Hardcoded endpoints or non-rotating credentials.
- Flow/Apex dependencies without owner documentation.
- Missing monitoring around signature failures.

---

## Current Discovery Snapshot

Generated: 2026-03-31T16:18:38.443Z

- Integration-marked components in selected scope: 243

### By Metadata Type
- ApexClass: 33
- AuthProvider: 2
- CustomField: 30
- CustomObject: 7
- ExternalCredential: 1
- FlexiPage: 5
- Flow: 4
- FlowDefinition: 4
- Layout: 5
- LightningComponentBundle: 139
- NamedCredential: 3
- OmniDataTransform: 4
- OmniIntegrationProcedure: 3
- OmniScript: 2
- PermissionSet: 1

### Sample Components
- `ApexClass` - omnistudio__DocuSignCredentialControllerTest
- `ApexClass` - omnistudio__DocuSignAccountSetting
- `ApexClass` - pi__OutlookAuthController
- `ApexClass` - SBQQ__ElectronicSignaturePlugin2
- `ApexClass` - LightningForgotPasswordControllerTest
- `ApexClass` - SBQQ__ElectronicSignaturePlugin
- `ApexClass` - SBQQ__ElectronicSignaturePlugin3
- `ApexClass` - omnistudio__OmniScriptDesignerControllerTest
- `ApexClass` - omnistudio__DefaultDocuSignOmniScriptIntegrationTest
- `ApexClass` - omnistudio__DefaultDocuSignOmniScriptIntegration
- `ApexClass` - pi__OutlookComposeControllerTest
- `ApexClass` - SDO_Service_ResetUserPassword
- `ApexClass` - LightningForgotPasswordController
- `ApexClass` - pi__OutlookComposeController
- `ApexClass` - FSL__ut_RuleTimeSlot_Designated_Work
- `ApexClass` - omnistudio__DocuSignBatch
- `ApexClass` - pi__OutlookEmailTest
- `ApexClass` - DocumentESigner
- `ApexClass` - blng__InvoiceNewOrderFunctionalTest
- `ApexClass` - omnistudio__OmniScriptDesignerController
- `ApexClass` - omnistudio__PlatformDocuSignIntegrationService
- `ApexClass` - omnistudio__LWCDesignerControllerTest
- `ApexClass` - pi__OutlookEmail
- `ApexClass` - ChangePasswordControllerTest
- `ApexClass` - ChangePasswordController
- `ApexClass` - omnistudio__LWCDesignerController
- `ApexClass` - SDO_Platform_EventDesignPicklist
- `ApexClass` - ForgotPasswordControllerTest
- `ApexClass` - FSL__RuleTimeSlot_Designated_Work
- `ApexClass` - omnistudio__DocuSignCredentialController
- `ApexClass` - SDO_Service_BotsResetPassword
- `ApexClass` - ForgotPasswordController
- `ApexClass` - SBQQ__DefaultElectronicSignaturePlugin
- `LightningComponentBundle` - omnistudio__carddesignerCommon
- `LightningComponentBundle` - omnistudio__omniDesignerRootElementsVisualOverview
- `LightningComponentBundle` - omnistudio__omniDesignerDateTimePropertySet
- `LightningComponentBundle` - omnistudio__clmOsDocxGenerateWordDocument
- `LightningComponentBundle` - omnistudio__omniDesignerDebugActionsPanel
- `LightningComponentBundle` - omnistudio__omniDesignerEditableGridCell
- `LightningComponentBundle` - changeOfCircumstancesSignatureCaptureEnglish
- `LightningComponentBundle` - omnistudio__clmShowWordPptThumbnail
- `LightningComponentBundle` - omnistudio__clmOsMultiDocxGenerateWordDocument
- `LightningComponentBundle` - omnistudio__omniDesignerModalConvertToMultiLang
- `LightningComponentBundle` - omnistudio__omniDesignerMatrixActionPropertySet
- `LightningComponentBundle` - omnistudio__cardDesignerFieldsPalette
- `LightningComponentBundle` - omnistudio__omniDesignerMessagingPropertySet
- `LightningComponentBundle` - omnistudio__omniDesignerDebugDataJsonPanel
- `LightningComponentBundle` - omnistudio__carddesignerSidebarBaseMixin
- `LightningComponentBundle` - omnistudio__omniDesignerDataRaptorPostActionPropertySet
- `LightningComponentBundle` - omnistudio__cardDesignerHeader
- `LightningComponentBundle` - omnistudio__cardDesignerElementsPalette
- `LightningComponentBundle` - omnistudio__omniDesignerLineBreakPropertySet
- `LightningComponentBundle` - omnistudio__omniDesignerDataRaptorTurboActionPropertySet
- `LightningComponentBundle` - omnistudio__omniDesignerShowHideGroup
- `LightningComponentBundle` - omnistudio__omniDesignerRadioGroupPropertySet
- `LightningComponentBundle` - omnistudio__omniDesignerSetValuesPropertySet
- `LightningComponentBundle` - omnistudio__omniDesignerElementPalette
- `LightningComponentBundle` - omnistudio__omniDesignerNewOmniScriptForm
- `LightningComponentBundle` - omnistudio__omniDesignerTextBlockPropertySet
- `LightningComponentBundle` - omnistudio__omniDesignerNavigateActionPropertySet
