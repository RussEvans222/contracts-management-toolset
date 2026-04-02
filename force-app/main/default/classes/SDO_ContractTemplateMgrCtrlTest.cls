@IsTest(SeeAllData=true)
private class SDO_ContractTemplateMgrCtrlTest {
    private static Id getTemplateWithTransforms() {
        List<DocumentTemplate> templates = [
            SELECT Id
            FROM DocumentTemplate
            WHERE MapperOmniDataTransformName != null
              AND ExtractOmniDataTransformName != null
            ORDER BY LastModifiedDate DESC
            LIMIT 1
        ];
        System.assert(!templates.isEmpty(), 'Expected at least one DocumentTemplate with mapper and extract configured.');
        return templates[0].Id;
    }

    private static SDO_ContractTemplateManagerController.MergeFieldChangeRequest buildPreviewableRequest(Id templateId, String uniqueSeed) {
        SDO_ContractTemplateManagerController.MergeFieldBuilderContext context =
            SDO_ContractTemplateManagerController.getMergeFieldBuilderContext(templateId);
        System.assert(context != null, 'Builder context should be returned.');
        System.assert(context.fieldsByObject != null && !context.fieldsByObject.isEmpty(), 'Builder context must include scoped field groups.');

        Integer attempt = 0;
        for (SDO_ContractTemplateManagerController.MergeFieldObjectFieldGroup fieldGroup : context.fieldsByObject) {
            if (fieldGroup.fields == null || fieldGroup.fields.isEmpty()) {
                continue;
            }
            for (SDO_ContractTemplateManagerController.MergeFieldFieldOption fieldOption : fieldGroup.fields) {
                attempt += 1;
                if (attempt > 60) {
                    break;
                }

                SDO_ContractTemplateManagerController.MergeFieldChangeRequest request =
                    new SDO_ContractTemplateManagerController.MergeFieldChangeRequest();
                request.templateId = templateId;
                request.sourceObjectApiName = fieldGroup.objectApiName;
                request.sourceFieldApiName = fieldOption.fieldApiName;
                request.friendlyMergeFieldName = 'Auto' + uniqueSeed + String.valueOf(attempt);

                SDO_ContractTemplateManagerController.MergeFieldChangePreview preview =
                    SDO_ContractTemplateManagerController.previewMergeFieldChange(request);
                if (preview.canApply == true &&
                    !(preview.alreadyExistsExtract == true && preview.alreadyExistsMapper == true)) {
                    return request;
                }
            }
        }
        return null;
    }

    @IsTest
    static void getTemplateSummary_clmOnly_filtersAndReturnsKpis() {
        Test.startTest();
        SDO_ContractTemplateManagerController.TemplateSummaryResponse response =
            SDO_ContractTemplateManagerController.getTemplateSummary(true);
        Test.stopTest();

        System.assertNotEquals(null, response, 'Template summary response should be returned.');
        System.assertNotEquals(null, response.kpis, 'KPI summary should be present.');
        System.assertNotEquals(null, response.templates, 'Template list should be initialized.');
        System.assertEquals(response.templates.size(), response.kpis.totalTemplates, 'KPI total should match list size.');

        for (SDO_ContractTemplateManagerController.TemplateRow row : response.templates) {
            System.assertEquals(
                'Contract_Lifecycle_Management',
                row.usageType,
                'CLM-only request should only return CLM templates.'
            );
        }
    }

    @IsTest
    static void getTemplateUsage_returnsContractUsageRows() {
        Id templateId;

        List<AggregateResult> templateWithUsage = [
            SELECT DocumentTemplateId templateId, COUNT(Id) usageCount
            FROM ContractDocumentVersion
            WHERE DocumentTemplateId != null
            GROUP BY DocumentTemplateId
            ORDER BY COUNT(Id) DESC
            LIMIT 1
        ];

        if (!templateWithUsage.isEmpty()) {
            templateId = (Id) templateWithUsage[0].get('templateId');
        }

        if (templateId == null) {
            List<DocumentTemplate> fallbackTemplates = [
                SELECT Id
                FROM DocumentTemplate
                LIMIT 1
            ];
            if (!fallbackTemplates.isEmpty()) {
                templateId = fallbackTemplates[0].Id;
            }
        }

        System.assertNotEquals(null, templateId, 'Expected at least one DocumentTemplate in org data.');

        Test.startTest();
        SDO_ContractTemplateManagerController.TemplateUsageResponse response =
            SDO_ContractTemplateManagerController.getTemplateUsage(templateId);
        Test.stopTest();

        System.assertNotEquals(null, response, 'Template usage response should be returned.');
        System.assertEquals(templateId, response.templateId, 'Response should map to requested template.');
        System.assertNotEquals(null, response.contracts, 'Contract usage list should be initialized.');
        System.assertEquals(response.contracts.size(), response.totalContracts, 'Contract count KPI should match row count.');

        Integer totalVersionsFromRows = 0;
        Integer totalFilesFromRows = 0;
        for (SDO_ContractTemplateManagerController.TemplateContractUsageRow row : response.contracts) {
            totalVersionsFromRows += row.totalVersions;
            totalFilesFromRows += row.generatedFiles;
            System.assertNotEquals(null, row.contractId, 'Usage row should include contract id.');
            System.assertNotEquals(null, row.latestVersionId, 'Usage row should include latest version id.');
        }

        System.assertEquals(totalVersionsFromRows, response.totalVersions, 'Version KPI should match usage rows.');
        System.assertEquals(totalFilesFromRows, response.totalGeneratedFiles, 'Generated file KPI should match usage rows.');
    }

    @IsTest
    static void getMergeFieldBuilderContext_returnsScopedObjectsAndFields() {
        Id templateId = getTemplateWithTransforms();

        Test.startTest();
        SDO_ContractTemplateManagerController.MergeFieldBuilderContext context =
            SDO_ContractTemplateManagerController.getMergeFieldBuilderContext(templateId);
        Test.stopTest();

        System.assertNotEquals(null, context, 'Builder context should be returned.');
        System.assertEquals(templateId, context.templateId, 'Context should map back to requested template.');
        System.assert(context.blockingIssues == null || context.blockingIssues.isEmpty(), 'Expected no blocking issues for configured template.');
        System.assert(context.sourceObjects != null && !context.sourceObjects.isEmpty(), 'Source objects should be inferred from extract scope.');
        System.assert(context.fieldsByObject != null && !context.fieldsByObject.isEmpty(), 'Field groups should be returned.');
        System.assert(context.mapperTransformId != null, 'Mapper transform id should be resolved.');
        System.assert(context.extractTransformId != null, 'Extract transform id should be resolved.');
    }

    @IsTest
    static void previewMergeFieldChange_blocksDuplicateFriendlyName() {
        Id templateId = getTemplateWithTransforms();
        SDO_ContractTemplateManagerController.MergeFieldBuilderContext context =
            SDO_ContractTemplateManagerController.getMergeFieldBuilderContext(templateId);

        System.assert(context.fieldsByObject != null && !context.fieldsByObject.isEmpty(), 'Expected scoped field options.');
        SDO_ContractTemplateManagerController.MergeFieldObjectFieldGroup fieldGroup = context.fieldsByObject[0];
        System.assert(fieldGroup.fields != null && !fieldGroup.fields.isEmpty(), 'Expected at least one selectable field.');

        List<OmniDataTransformItem> existingMapperRows = [
            SELECT OutputFieldName
            FROM OmniDataTransformItem
            WHERE OmniDataTransformationId = :context.mapperTransformId
              AND IsDisabled = false
              AND OutputFieldName != null
            LIMIT 1
        ];
        System.assert(!existingMapperRows.isEmpty(), 'Expected at least one mapper row for duplicate check.');

        SDO_ContractTemplateManagerController.MergeFieldChangeRequest request =
            new SDO_ContractTemplateManagerController.MergeFieldChangeRequest();
        request.templateId = templateId;
        request.sourceObjectApiName = fieldGroup.objectApiName;
        request.sourceFieldApiName = fieldGroup.fields[0].fieldApiName;
        request.friendlyMergeFieldName = existingMapperRows[0].OutputFieldName;

        Test.startTest();
        SDO_ContractTemplateManagerController.MergeFieldChangePreview preview =
            SDO_ContractTemplateManagerController.previewMergeFieldChange(request);
        Test.stopTest();

        System.assertNotEquals(null, preview, 'Preview response should be returned.');
        System.assertEquals(false, preview.canApply, 'Duplicate merge target name should be blocked.');
        System.assert(preview.blockingIssues != null && !preview.blockingIssues.isEmpty(), 'Preview should include blocking issues.');
    }

    @IsTest
    static void applyMergeFieldChange_createsRowsAndSupportsIdempotency() {
        Id templateId = getTemplateWithTransforms();
        String seedSource = String.valueOf(Crypto.getRandomLong()).replace('-', '');
        String uniqueSeed = seedSource.length() > 6 ? seedSource.substring(0, 6) : seedSource;

        SDO_ContractTemplateManagerController.MergeFieldChangeRequest request =
            buildPreviewableRequest(templateId, uniqueSeed);
        System.assertNotEquals(null, request, 'Expected to find at least one previewable source object/field request.');

        SDO_ContractTemplateManagerController.MergeFieldChangePreview preview =
            SDO_ContractTemplateManagerController.previewMergeFieldChange(request);
        System.assertEquals(true, preview.canApply, 'Preview should be applicable before apply.');
        System.assertNotEquals(null, preview.extractCandidate, 'Extract candidate should be present.');
        System.assertNotEquals(null, preview.mapperCandidate, 'Mapper candidate should be present.');

        Integer extractBefore = [
            SELECT Count()
            FROM OmniDataTransformItem
            WHERE OmniDataTransformationId = :preview.extractCandidate.omniDataTransformationId
        ];
        Integer mapperBefore = [
            SELECT Count()
            FROM OmniDataTransformItem
            WHERE OmniDataTransformationId = :preview.mapperCandidate.omniDataTransformationId
        ];

        Test.startTest();
        SDO_ContractTemplateManagerController.MergeFieldApplyResult applyResult =
            SDO_ContractTemplateManagerController.applyMergeFieldChange(request);
        Test.stopTest();

        System.assertEquals(true, applyResult.success, 'Apply should succeed for valid preview payload.');

        Integer extractAfter = [
            SELECT Count()
            FROM OmniDataTransformItem
            WHERE OmniDataTransformationId = :preview.extractCandidate.omniDataTransformationId
        ];
        Integer mapperAfter = [
            SELECT Count()
            FROM OmniDataTransformItem
            WHERE OmniDataTransformationId = :preview.mapperCandidate.omniDataTransformationId
        ];

        Integer expectedExtractIncrement = preview.alreadyExistsExtract == true ? 0 : 1;
        Integer expectedMapperIncrement = preview.alreadyExistsMapper == true ? 0 : 1;

        System.assertEquals(extractBefore + expectedExtractIncrement, extractAfter, 'Extract transform item count should increment by expected amount.');
        System.assertEquals(mapperBefore + expectedMapperIncrement, mapperAfter, 'Mapper transform item count should increment by expected amount.');

        SDO_ContractTemplateManagerController.MergeFieldChangePreview secondPreview =
            SDO_ContractTemplateManagerController.previewMergeFieldChange(request);
        System.assertEquals(true, secondPreview.alreadyExistsExtract, 'Second preview should detect existing extract mapping.');
        System.assertEquals(true, secondPreview.alreadyExistsMapper, 'Second preview should detect existing mapper mapping.');

        SDO_ContractTemplateManagerController.MergeFieldApplyResult secondApplyResult =
            SDO_ContractTemplateManagerController.applyMergeFieldChange(request);
        System.assertEquals(true, secondApplyResult.success, 'Second apply should be treated as a safe no-op.');
    }
}
