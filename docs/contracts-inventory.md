# Contracts Inventory

Generated: 2026-03-31T16:18:00.336Z
Target Org Alias: cm-prod-demo

## Inventory Summary
- Scanned metadata types: 20
- Scanned components: 23120
- Selected contract-scope types: 20
- Selected contract-scope components: 3712
- Integration-related selected components (M365/DocuSign markers): 75

## Metadata Scan Coverage
| Metadata Type | Scanned | Components Found |
|---|---|---|
| ApexClass | Yes | 5200 |
| ApexTrigger | Yes | 365 |
| AuthProvider | Yes | 4 |
| ConnectedApp | Yes | 2 |
| CustomField | Yes | 9691 |
| CustomMetadata | Yes | 567 |
| CustomObject | Yes | 1791 |
| ExternalCredential | Yes | 5 |
| FlexiPage | Yes | 419 |
| Flow | Yes | 528 |
| FlowDefinition | Yes | 528 |
| Layout | Yes | 1347 |
| LightningComponentBundle | Yes | 1119 |
| NamedCredential | Yes | 13 |
| OmniDataTransform | Yes | 569 |
| OmniIntegrationProcedure | Yes | 156 |
| OmniScript | Yes | 204 |
| OmniUiCard | Yes | 84 |
| PermissionSet | Yes | 310 |
| RemoteSiteSetting | Yes | 218 |

## Selected Scope by Type
| Metadata Type | Selected Components |
|---|---|
| ApexClass | 1003 |
| ApexTrigger | 99 |
| AuthProvider | 4 |
| ConnectedApp | 2 |
| CustomField | 719 |
| CustomMetadata | 60 |
| CustomObject | 125 |
| ExternalCredential | 5 |
| FlexiPage | 11 |
| Flow | 402 |
| FlowDefinition | 402 |
| Layout | 92 |
| LightningComponentBundle | 253 |
| NamedCredential | 13 |
| OmniDataTransform | 74 |
| OmniIntegrationProcedure | 103 |
| OmniScript | 113 |
| OmniUiCard | 3 |
| PermissionSet | 12 |
| RemoteSiteSetting | 217 |

## Selected Components by Business Domain
### Automation
Count: 1094
- `Flow` - case_csat_nps_survey
- `Flow` - Create_Application_Decision
- `Flow` - Create_Benefits_and_Filters
- `Flow` - Create_BLA_Business_Site_Address
- `Flow` - Create_Child_Universal360_for_Case_DCDP
- `Flow` - Create_Child_Universal360_for_Messaging_Session_DCDP
- `Flow` - Create_Child_Universal360_for_Voice_Call_DCDP
- `Flow` - Create_Indicators_For_Tasks
- `Flow` - Create_Indicators_for_Visit_Tasks
- `Flow` - Create_Milestone_Progress_on_Opportunity_Close
- `Flow` - Create_Program_and_Rebate_Types
- `Flow` - Create_Site_Location_from_BLA
- `Flow` - Demo_Cleanup_Flow_Item_Test
- `Flow` - FSAA__Create_Service_Report_and_Document_Recipient
- `Flow` - FSSK__FSK_Actual_Times_Capturing
- `Flow` - FSSK__FSK_Cancelation_Canned_Notification
- `Flow` - FSSK__FSK_Canned_Notification_Dispatched
- `Flow` - FSSK__FSK_Exclude_Resource_On_Rejection
- `Flow` - FSSK__FSK_Populate_Custom_Work_Order_Lookup
- `Flow` - FSSK__FSK_Reflect_Actual_Times_on_Gantt
- `Flow` - FSSK__FSK_Resource_Deactivation
- `Flow` - FSSK__FSK_Service_Appointment
- `Flow` - FSSK__FSK_Set_Assign_Resource_On_Service_Appointment
- `Flow` - FSSK__FSK_Set_Assign_Service_Resource_On_Service_Appointment
- `Flow` - FSSK__FSK_Set_Gantt_Label_Concatenation
- `Flow` - FSSK__FSK_Update_Work_Order_Child_Records
- `Flow` - FSSK__FSK_Work_Order_Process
- `Flow` - gps_Application_Review_Scorecard
- `Flow` - GPS_BLA_Approval_Process_Flow
- `Flow` - gps_Calculate_Goal_Completion_Percent_for_Indicator_Result
- ...and 1064 more

### Contracts Data Model
Count: 856
- `CustomField` - Account.maps__AssignmentRule__c
- `CustomField` - Account.SBQQ__ContractCoTermination__c
- `CustomField` - Account.SBQQ__CoTermedContractsCombined__c
- `CustomField` - Account.SBQQ__IgnoreParentContractedPrices__c
- `CustomField` - Account.SDO_Contract_Signed__c
- `CustomField` - Account.SDO_MAPS_Adv_Maps_User_Assignment__c
- `CustomField` - Account.SDO_Partner_Geographic_Coverage__c
- `CustomField` - AgentWork__c.AssignedDateTime__c
- `CustomField` - aqi_ltng_mng__Article_Quality__c.aqi_ltng_mng__Action_Assigned_To__c
- `CustomField` - Asset.Service_Contract__c
- `CustomField` - AssignedResource.Customer_Name__c
- `CustomField` - AssignedResource.External_ID__c
- `CustomField` - AssignedResource.FSL__calculated_duration__c
- `CustomField` - AssignedResource.FSL__Estimated_Travel_Time_From_Source__c
- `CustomField` - AssignedResource.FSL__Estimated_Travel_Time_To_Source__c
- `CustomField` - AssignedResource.FSL__EstimatedTravelDistanceFrom__c
- `CustomField` - AssignedResource.FSL__EstimatedTravelDistanceTo__c
- `CustomField` - AssignedResource.FSL__EstimatedTravelTimeFrom__c
- `CustomField` - AssignedResource.FSL__Last_Updated_Epoch__c
- `CustomField` - AssignedResource.FSL__UpdatedByOptimization__c
- `CustomField` - blng__BillingTreatment__c.blng__BillingLegalEntity__c
- `CustomField` - blng__CreditNoteAllocation__c.blng__LegalEntity__c
- `CustomField` - blng__CreditNoteLine__c.blng__LegalEntity__c
- `CustomField` - blng__CreditNoteLine__c.blng__LegalEntityReference__c
- `CustomField` - blng__DebitNoteAllocation__c.blng__LegalEntity__c
- `CustomField` - blng__DebitNoteAllocationCreditNoteLine__c.blng__LegalEntity__c
- `CustomField` - blng__DebitNoteLine__c.blng__LegalEntity__c
- `CustomField` - blng__DebitNoteLine__c.blng__LegalEntityReference__c
- `CustomField` - blng__DebitNoteLine__c.blng__RevenueAgreementMatchingID__c
- `CustomField` - blng__FinancePeriod__c.blng__LegalEntity__c
- ...and 826 more

### Integrations & Security
Count: 248
- `ApexClass` - omnistudio__DefaultDocuSignOmniScriptIntegration (integration-related)
- `ApexClass` - omnistudio__DefaultDocuSignOmniScriptIntegrationTest (integration-related)
- `ApexClass` - omnistudio__DocuSignAccountSetting (integration-related)
- `ApexClass` - omnistudio__DocuSignBatch (integration-related)
- `ApexClass` - omnistudio__DocuSignCredentialController (integration-related)
- `ApexClass` - omnistudio__DocuSignCredentialControllerTest (integration-related)
- `ApexClass` - omnistudio__PlatformDocuSignIntegrationService (integration-related)
- `AuthProvider` - AutoAuthProvider
- `AuthProvider` - DocuSign (integration-related)
- `AuthProvider` - Microsoft_Application (integration-related)
- `AuthProvider` - Q_Branch_Demo
- `ConnectedApp` - CumulusCI
- `ConnectedApp` - Salesforce_CLI
- `ExternalCredential` - ExternalAWSTextractforContractAI
- `ExternalCredential` - Microsoft_Application_ExtCred (integration-related)
- `ExternalCredential` - Mixpanel_Salesforce_Engage
- `ExternalCredential` - Mixpanel_Salesforce_Import
- `ExternalCredential` - ngo_Heroku_OData
- `NamedCredential` - asj__VideoComponentNamedCredentialDemoOrg
- `NamedCredential` - asj__VideoComponentNamedCredentialProductionOrg
- `NamedCredential` - AWS_Extract_Contract_AI
- `NamedCredential` - DocuSign (integration-related)
- `NamedCredential` - EDocuSign (integration-related)
- `NamedCredential` - Microsoft_Application (integration-related)
- `NamedCredential` - Mixpanel_Engage_Ingestion_Api
- `NamedCredential` - Mixpanel_Import_Ingestion_Api
- `NamedCredential` - MktgExtAction__Zoom_Named_Cred
- `NamedCredential` - ngo_Heroku_OData
- `NamedCredential` - Q_Branch_Demo
- `NamedCredential` - Salesforce
- ...and 218 more

### Platform Logic
Count: 1155
- `ApexClass` - aqi_ltng_mng__aqi_ArticleQualityIndexCtrl
- `ApexClass` - aqi_ltng_mng__aqi_ArticleQualityIndexCtrl_Test
- `ApexClass` - aqi_ltng_mng__aqi_Ctrl
- `ApexClass` - aqi_ltng_mng__aqi_Ctrl_Test
- `ApexClass` - aqi_ltng_mng__aqi_DynamicPickList_AQI
- `ApexClass` - aqi_ltng_mng__aqi_KnowledgeSearchCtrl
- `ApexClass` - aqi_ltng_mng__aqi_KnowledgeSearchCtrl_Test
- `ApexClass` - aqi_ltng_mng__aqi_LightningResponse
- `ApexClass` - aqi_ltng_mng__aqi_LightningResponse_Test
- `ApexClass` - aqi_ltng_mng__aqi_SecurityHandler
- `ApexClass` - aqi_ltng_mng__aqi_SecurityHandler_Test
- `ApexClass` - aqi_ltng_mng__aqi_SettingsHandler
- `ApexClass` - aqi_ltng_mng__aqi_SettingsHandler_Test
- `ApexClass` - aqi_ltng_mng__aqi_SetupCtrl
- `ApexClass` - aqi_ltng_mng__aqi_SetupCtrl_Test
- `ApexClass` - assigntopics__ccp_assignTopicsUnscopedController
- `ApexClass` - assigntopics__ccp_assignTopicsUnscopedControllerT
- `ApexClass` - assigntopics__communitiesPicklist
- `ApexClass` - assigntopics__communitiesPicklistTest
- `ApexClass` - blng__BatchInvoiceAssignGroupQuantity
- `ApexClass` - blng__InvoiceNewOrderFunctionalTest (integration-related)
- `ApexClass` - blng__LegalEntityDAO
- `ApexClass` - blng__LegalEntityDAOTest
- `ApexClass` - blng__RevenueAgreementDAO
- `ApexClass` - blng__RevenueAgreementFunctionalTest
- `ApexClass` - blng__RevenueAgreementService
- `ApexClass` - blng__RevenueAgreementServiceTest
- `ApexClass` - blng__RevenueSchedule
- `ApexClass` - ChangePasswordController (integration-related)
- `ApexClass` - ChangePasswordControllerTest (integration-related)
- ...and 1125 more

### User Experience
Count: 359
- `FlexiPage` - Contract_Record_Page
- `FlexiPage` - Emergency_Response_Community_Check_Password (integration-related)
- `FlexiPage` - Emergency_Response_Community_Forgot_Password (integration-related)
- `FlexiPage` - Funding_Award_Contract_Record_Page
- `FlexiPage` - gps_Action_Plan_Template_Record_Page
- `FlexiPage` - gps_Care_Plan_Template_Record_Page
- `FlexiPage` - GPS_Signature_Task_Page
- `FlexiPage` - omnistudio__FlexCardDesigner
- `FlexiPage` - omnistudio__Vlocity_OmniScript_Designer
- `FlexiPage` - SalesforceContracts_UtilityBar
- `FlexiPage` - SDO_Experience_Template
- `Layout` - ActionPlanTemplate-Action Plan Template Layout
- `Layout` - ActionPlanTemplateAssignment-Action Plan Template Assignment Layout
- `Layout` - ActionPlanTemplateItem-Action Plan Template Item Layout
- `Layout` - ActionPlanTemplateItemValue-Action Plan Template Item Value Layout
- `Layout` - ActionPlanTemplateVersion-Action Plan Template Version Layout
- `Layout` - ActionPlnTmplItmDependency-Action Plan Template Item Dependency Layout
- `Layout` - ApprovalAlertContentDef-%5F%5FMISSING LABEL%5F%5F PropertyFile - val ApprovalAlertContentDef not found in section StandardLayouts
- `Layout` - AssessmentQuestionAssignment-Assessment Question Assignment Layout
- `Layout` - AssessmentQuestionSourceDoc-Assessment Question Source Document Layout
- `Layout` - AssessmentSignature-Assessment Signature Layout
- `Layout` - AssessmentTaskContentDocument-Assessment Task Content Document Layout
- `Layout` - AssignedResource-Assigned Resource Layout
- `Layout` - AssignedResource-SDO - SFS Assigned Resource
- `Layout` - BenefitAssignment-Benefit Assignment Layout
- `Layout` - BenefitAssignmentAdjustment-Benefit Assignment Adjustment Layout
- `Layout` - BenefitAssignmentAsset-%5F%5FMISSING LABEL%5F%5F PropertyFile - val BenefitAssignmentAsset not found in section StandardLayouts
- `Layout` - blng__LegalEntity__c-Legal Entity Layout
- `Layout` - blng__RevenueAgreement__c-RevenueAgreement Layout
- `Layout` - BnftAsgntBnftItemCode-Benefit Assignment Benefit Item Code Layout
- ...and 329 more

## Notes
- Inventory is generated from CLI metadata listing + contract keyword classification.
- For OmniStudio metadata types not enabled in the org, run `./scripts/export-omnistudio-fallback.sh`.
