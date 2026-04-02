public with sharing class SDO_ContractTemplateManagerController {
    private static final String CLM_USAGE_TYPE = 'Contract_Lifecycle_Management';
    private static final String JSON_OUTPUT_OBJECT = 'json';
    private static final Integer MAX_CONTEXT_ITEMS = 5000;
    private static final Integer MAX_NAME_SUGGESTIONS = 3;

    public class KpiSummary {
        @AuraEnabled public Integer totalTemplates;
        @AuraEnabled public Integer activeTemplates;
        @AuraEnabled public Integer usedByContracts;
        @AuraEnabled public Integer generatedFiles;
    }

    public class TemplateRow {
        @AuraEnabled public Id templateId;
        @AuraEnabled public String name;
        @AuraEnabled public String status;
        @AuraEnabled public String type;
        @AuraEnabled public String usageType;
        @AuraEnabled public Integer versionNumber;
        @AuraEnabled public Boolean isActive;
        @AuraEnabled public String mapperName;
        @AuraEnabled public String extractName;
        @AuraEnabled public Id mapperTransformId;
        @AuraEnabled public Id extractTransformId;
        @AuraEnabled public Boolean mapperExists;
        @AuraEnabled public Boolean extractExists;
        @AuraEnabled public Id contentDocumentId;
        @AuraEnabled public Id latestContentVersionId;
        @AuraEnabled public String fileTitle;
        @AuraEnabled public String fileType;
        @AuraEnabled public String fileExtension;
        @AuraEnabled public Integer fileSize;
        @AuraEnabled public String downloadUrl;
        @AuraEnabled public Integer timesUsed;
        @AuraEnabled public Integer distinctContracts;
        @AuraEnabled public Integer generatedFiles;
        @AuraEnabled public Datetime lastUsedDate;
        @AuraEnabled public Datetime lastModifiedDate;
        @AuraEnabled public Boolean canDelete;
    }

    public class TemplateSummaryResponse {
        @AuraEnabled public KpiSummary kpis;
        @AuraEnabled public List<TemplateRow> templates;
    }

    public class TemplateContractUsageRow {
        @AuraEnabled public Id contractId;
        @AuraEnabled public String contractName;
        @AuraEnabled public String contractNumber;
        @AuraEnabled public String contractStatus;
        @AuraEnabled public Id latestVersionId;
        @AuraEnabled public Integer latestVersionNumber;
        @AuraEnabled public String latestVersionStatus;
        @AuraEnabled public Datetime latestVersionDate;
        @AuraEnabled public Integer totalVersions;
        @AuraEnabled public Integer generatedFiles;
    }

    public class TemplateUsageResponse {
        @AuraEnabled public Id templateId;
        @AuraEnabled public String templateName;
        @AuraEnabled public String mapperName;
        @AuraEnabled public String extractName;
        @AuraEnabled public Id mapperTransformId;
        @AuraEnabled public Id extractTransformId;
        @AuraEnabled public Boolean mapperExists;
        @AuraEnabled public Boolean extractExists;
        @AuraEnabled public Integer mapperFieldCount;
        @AuraEnabled public Integer extractFieldCount;
        @AuraEnabled public Integer totalContracts;
        @AuraEnabled public Integer totalVersions;
        @AuraEnabled public Integer totalGeneratedFiles;
        @AuraEnabled public Datetime lastUsedDate;
        @AuraEnabled public List<TemplateMappingFieldRow> mappedFields;
        @AuraEnabled public List<TemplateContractUsageRow> contracts;
    }

    public class MergeFieldBuilderContext {
        @AuraEnabled public Id templateId;
        @AuraEnabled public String templateName;
        @AuraEnabled public Id mapperTransformId;
        @AuraEnabled public Id extractTransformId;
        @AuraEnabled public List<MergeFieldObjectOption> sourceObjects;
        @AuraEnabled public List<MergeFieldObjectFieldGroup> fieldsByObject;
        @AuraEnabled public List<String> blockingIssues;
    }

    public class MergeFieldObjectOption {
        @AuraEnabled public String objectApiName;
        @AuraEnabled public String objectLabel;
    }

    public class MergeFieldObjectFieldGroup {
        @AuraEnabled public String objectApiName;
        @AuraEnabled public String objectLabel;
        @AuraEnabled public String inferredBasePath;
        @AuraEnabled public List<MergeFieldFieldOption> fields;
    }

    public class MergeFieldFieldOption {
        @AuraEnabled public String fieldApiName;
        @AuraEnabled public String fieldLabel;
        @AuraEnabled public String dataType;
    }

    public class MergeFieldChangeRequest {
        @AuraEnabled public Id templateId { get; set; }
        @AuraEnabled public String sourceObjectApiName { get; set; }
        @AuraEnabled public String sourceFieldApiName { get; set; }
        @AuraEnabled public String friendlyMergeFieldName { get; set; }
    }

    public class MergeFieldCandidate {
        @AuraEnabled public String name;
        @AuraEnabled public Id omniDataTransformationId;
        @AuraEnabled public String inputObjectName;
        @AuraEnabled public String inputFieldName;
        @AuraEnabled public String outputObjectName;
        @AuraEnabled public String outputFieldName;
        @AuraEnabled public String formulaResultPath;
        @AuraEnabled public Integer outputCreationSequence;
        @AuraEnabled public Boolean isDisabled;
    }

    public class MergeFieldChangePreview {
        @AuraEnabled public Boolean canApply;
        @AuraEnabled public String mergeToken;
        @AuraEnabled public String normalizedFriendlyMergeFieldName;
        @AuraEnabled public List<String> blockingIssues;
        @AuraEnabled public List<String> warnings;
        @AuraEnabled public List<String> suggestions;
        @AuraEnabled public Boolean alreadyExistsExtract;
        @AuraEnabled public Boolean alreadyExistsMapper;
        @AuraEnabled public MergeFieldCandidate extractCandidate;
        @AuraEnabled public MergeFieldCandidate mapperCandidate;
    }

    public class MergeFieldApplyResult {
        @AuraEnabled public Boolean success;
        @AuraEnabled public String mergeToken;
        @AuraEnabled public String normalizedFriendlyMergeFieldName;
        @AuraEnabled public Id createdExtractItemId;
        @AuraEnabled public Id createdMapperItemId;
        @AuraEnabled public List<String> messages;
    }

    public class TemplateMappingFieldRow {
        @AuraEnabled public Id itemId;
        @AuraEnabled public Id transformId;
        @AuraEnabled public String transformName;
        @AuraEnabled public String sourceType;
        @AuraEnabled public String inputObjectName;
        @AuraEnabled public String inputFieldName;
        @AuraEnabled public String outputObjectName;
        @AuraEnabled public String outputFieldName;
        @AuraEnabled public String formulaResultPath;
        @AuraEnabled public Boolean isDisabled;
    }

    private class TemplateFileInfo {
        Id contentDocumentId;
        Id latestContentVersionId;
        String contentDocumentTitle;
        String latestContentVersionTitle;
        String fileType;
        String fileExtension;
        Integer fileSize;
    }

    private class UsageMetrics {
        Integer timesUsed = 0;
        Integer distinctContracts = 0;
        Datetime lastUsedDate;
    }

    private class TemplateGeneratedMetrics {
        Integer generatedFiles = 0;
    }

    private class TransformInfo {
        Id id;
        String name;
    }

    private class TransformResolution {
        Id templateId;
        String templateName;
        String mapperName;
        String extractName;
        Id mapperTransformId;
        Id extractTransformId;
        Set<String> scopedObjects = new Set<String>();
        Map<String, String> basePathByObject = new Map<String, String>();
        List<OmniDataTransformItem> extractItems = new List<OmniDataTransformItem>();
        List<OmniDataTransformItem> mapperItems = new List<OmniDataTransformItem>();
        List<String> blockingIssues = new List<String>();
    }

    private class TemplateRowSorter implements Comparable {
        TemplateRow row;

        TemplateRowSorter(TemplateRow sourceRow) {
            row = sourceRow;
        }

        public Integer compareTo(Object compareToValue) {
            TemplateRowSorter other = (TemplateRowSorter) compareToValue;

            Integer thisActive = row.isActive == true ? 1 : 0;
            Integer otherActive = other.row.isActive == true ? 1 : 0;
            if (thisActive != otherActive) {
                return otherActive > thisActive ? 1 : -1;
            }

            Integer thisUsage = row.timesUsed != null ? row.timesUsed : 0;
            Integer otherUsage = other.row.timesUsed != null ? other.row.timesUsed : 0;
            if (thisUsage != otherUsage) {
                return otherUsage > thisUsage ? 1 : -1;
            }

            Long thisLastUsed = row.lastUsedDate != null ? row.lastUsedDate.getTime() : 0;
            Long otherLastUsed = other.row.lastUsedDate != null ? other.row.lastUsedDate.getTime() : 0;
            if (thisLastUsed != otherLastUsed) {
                return otherLastUsed > thisLastUsed ? 1 : -1;
            }

            String thisName = row.name != null ? row.name.toLowerCase() : '';
            String otherName = other.row.name != null ? other.row.name.toLowerCase() : '';
            return thisName.compareTo(otherName);
        }
    }

    private class TemplateUsageRowSorter implements Comparable {
        TemplateContractUsageRow row;

        TemplateUsageRowSorter(TemplateContractUsageRow sourceRow) {
            row = sourceRow;
        }

        public Integer compareTo(Object compareToValue) {
            TemplateUsageRowSorter other = (TemplateUsageRowSorter) compareToValue;

            Long thisLatest = row.latestVersionDate != null ? row.latestVersionDate.getTime() : 0;
            Long otherLatest = other.row.latestVersionDate != null ? other.row.latestVersionDate.getTime() : 0;
            if (thisLatest != otherLatest) {
                return otherLatest > thisLatest ? 1 : -1;
            }

            String thisContractNumber = row.contractNumber != null ? row.contractNumber : '';
            String otherContractNumber = other.row.contractNumber != null ? other.row.contractNumber : '';
            return thisContractNumber.compareTo(otherContractNumber);
        }
    }

    @AuraEnabled(cacheable=true)
    public static TemplateSummaryResponse getTemplateSummary(Boolean clmOnly) {
        Boolean shouldFilterClm = clmOnly != false;
        Boolean canDeleteTemplates = Schema.SObjectType.DocumentTemplate.isDeletable();

        List<DocumentTemplate> templates = shouldFilterClm
            ? [
                SELECT Id,
                       Name,
                       Status,
                       Type,
                       UsageType,
                       VersionNumber,
                       IsActive,
                       MapperOmniDataTransformName,
                       ExtractOmniDataTransformName,
                       LastModifiedDate
                FROM DocumentTemplate
                WHERE UsageType = :CLM_USAGE_TYPE
                ORDER BY LastModifiedDate DESC
                LIMIT 2000
            ]
            : [
                SELECT Id,
                       Name,
                       Status,
                       Type,
                       UsageType,
                       VersionNumber,
                       IsActive,
                       MapperOmniDataTransformName,
                       ExtractOmniDataTransformName,
                       LastModifiedDate
                FROM DocumentTemplate
                ORDER BY LastModifiedDate DESC
                LIMIT 2000
            ];

        TemplateSummaryResponse response = new TemplateSummaryResponse();
        response.kpis = new KpiSummary();
        response.templates = new List<TemplateRow>();

        if (templates.isEmpty()) {
            response.kpis.totalTemplates = 0;
            response.kpis.activeTemplates = 0;
            response.kpis.usedByContracts = 0;
            response.kpis.generatedFiles = 0;
            return response;
        }

        Set<Id> templateIds = new Set<Id>();
        Set<String> mapperNames = new Set<String>();
        for (DocumentTemplate templateRecord : templates) {
            templateIds.add(templateRecord.Id);
            if (String.isNotBlank(templateRecord.MapperOmniDataTransformName)) {
                mapperNames.add(templateRecord.MapperOmniDataTransformName);
            }
            if (String.isNotBlank(templateRecord.ExtractOmniDataTransformName)) {
                mapperNames.add(templateRecord.ExtractOmniDataTransformName);
            }
        }

        Map<Id, TemplateFileInfo> fileByTemplateId = new Map<Id, TemplateFileInfo>();
        for (DocumentTemplateContentDoc row : [
            SELECT DocumentTemplateId,
                   ContentDocumentId,
                   LatestContentVersionId,
                   ContentDocument.Title,
                   LatestContentVersion.Title,
                   LatestContentVersion.FileType,
                   LatestContentVersion.FileExtension,
                   LatestContentVersion.ContentSize,
                   CreatedDate
            FROM DocumentTemplateContentDoc
            WHERE DocumentTemplateId IN :templateIds
            ORDER BY CreatedDate DESC
            LIMIT 5000
        ]) {
            if (!fileByTemplateId.containsKey(row.DocumentTemplateId)) {
                TemplateFileInfo fileInfo = new TemplateFileInfo();
                fileInfo.contentDocumentId = row.ContentDocumentId;
                fileInfo.latestContentVersionId = row.LatestContentVersionId;
                fileInfo.contentDocumentTitle = row.ContentDocument != null ? row.ContentDocument.Title : null;
                fileInfo.latestContentVersionTitle = row.LatestContentVersion != null ? row.LatestContentVersion.Title : null;
                fileInfo.fileType = row.LatestContentVersion != null ? row.LatestContentVersion.FileType : null;
                fileInfo.fileExtension = row.LatestContentVersion != null ? row.LatestContentVersion.FileExtension : null;
                fileInfo.fileSize = row.LatestContentVersion != null ? row.LatestContentVersion.ContentSize : null;
                fileByTemplateId.put(row.DocumentTemplateId, fileInfo);
            }
        }

        Map<Id, UsageMetrics> usageByTemplateId = new Map<Id, UsageMetrics>();
        for (AggregateResult row : [
            SELECT DocumentTemplateId templateId,
                   COUNT(Id) timesUsed,
                   COUNT_DISTINCT(ContractId) distinctContracts,
                   MAX(CreatedDate) lastUsedDate
            FROM ContractDocumentVersion
            WHERE DocumentTemplateId IN :templateIds
            GROUP BY DocumentTemplateId
        ]) {
            Id templateId = (Id) row.get('templateId');
            UsageMetrics metrics = new UsageMetrics();
            metrics.timesUsed = decimalToInteger((Decimal) row.get('timesUsed'));
            metrics.distinctContracts = decimalToInteger((Decimal) row.get('distinctContracts'));
            metrics.lastUsedDate = (Datetime) row.get('lastUsedDate');
            usageByTemplateId.put(templateId, metrics);
        }

        Map<Id, TemplateGeneratedMetrics> generatedByTemplateId = new Map<Id, TemplateGeneratedMetrics>();
        for (AggregateResult row : [
            SELECT ContractDocumentVersion.DocumentTemplateId templateId,
                   COUNT(Id) generatedFiles
            FROM ContractDocVerContentDoc
            WHERE ContractDocumentVersion.DocumentTemplateId IN :templateIds
            GROUP BY ContractDocumentVersion.DocumentTemplateId
        ]) {
            Id templateId = (Id) row.get('templateId');
            TemplateGeneratedMetrics metrics = new TemplateGeneratedMetrics();
            metrics.generatedFiles = decimalToInteger((Decimal) row.get('generatedFiles'));
            generatedByTemplateId.put(templateId, metrics);
        }

        Set<String> existingMapperNames = new Set<String>();
        Map<String, Id> transformIdByName = new Map<String, Id>();
        if (!mapperNames.isEmpty()) {
            for (OmniDataTransform transformRow : [
                SELECT Id, Name
                FROM OmniDataTransform
                WHERE Name IN :mapperNames
                LIMIT 5000
            ]) {
                if (String.isNotBlank(transformRow.Name)) {
                    existingMapperNames.add(transformRow.Name);
                    transformIdByName.put(transformRow.Name, transformRow.Id);
                }
            }
        }

        Integer activeCount = 0;
        Integer usedTemplateCount = 0;
        Integer generatedFileTotal = 0;
        List<TemplateRowSorter> sortedRows = new List<TemplateRowSorter>();

        for (DocumentTemplate templateRecord : templates) {
            UsageMetrics usage = usageByTemplateId.get(templateRecord.Id);
            TemplateGeneratedMetrics generated = generatedByTemplateId.get(templateRecord.Id);
            TemplateFileInfo fileInfo = fileByTemplateId.get(templateRecord.Id);

            TemplateRow row = new TemplateRow();
            row.templateId = templateRecord.Id;
            row.name = templateRecord.Name;
            row.status = templateRecord.Status;
            row.type = templateRecord.Type;
            row.usageType = templateRecord.UsageType;
            row.versionNumber = templateRecord.VersionNumber;
            row.isActive = templateRecord.IsActive;
            row.mapperName = templateRecord.MapperOmniDataTransformName;
            row.extractName = templateRecord.ExtractOmniDataTransformName;
            row.mapperTransformId = String.isNotBlank(row.mapperName) ? transformIdByName.get(row.mapperName) : null;
            row.extractTransformId = String.isNotBlank(row.extractName) ? transformIdByName.get(row.extractName) : null;
            row.mapperExists = String.isNotBlank(row.mapperName) && existingMapperNames.contains(row.mapperName);
            row.extractExists = String.isNotBlank(row.extractName) && existingMapperNames.contains(row.extractName);
            row.timesUsed = usage != null ? usage.timesUsed : 0;
            row.distinctContracts = usage != null ? usage.distinctContracts : 0;
            row.lastUsedDate = usage != null ? usage.lastUsedDate : null;
            row.generatedFiles = generated != null ? generated.generatedFiles : 0;
            row.lastModifiedDate = templateRecord.LastModifiedDate;
            row.canDelete = canDeleteTemplates;

            if (fileInfo != null) {
                row.contentDocumentId = fileInfo.contentDocumentId;
                row.latestContentVersionId = fileInfo.latestContentVersionId;
                row.fileTitle = String.isNotBlank(fileInfo.latestContentVersionTitle)
                    ? fileInfo.latestContentVersionTitle
                    : fileInfo.contentDocumentTitle;
                row.fileType = fileInfo.fileType;
                row.fileExtension = fileInfo.fileExtension;
                row.fileSize = fileInfo.fileSize;
                if (fileInfo.contentDocumentId != null) {
                    row.downloadUrl = '/sfc/servlet.shepherd/document/download/' + fileInfo.contentDocumentId;
                }
            }

            if (row.isActive == true) {
                activeCount += 1;
            }
            if (row.timesUsed > 0) {
                usedTemplateCount += 1;
            }
            generatedFileTotal += row.generatedFiles;

            sortedRows.add(new TemplateRowSorter(row));
        }

        sortedRows.sort();
        for (TemplateRowSorter sorter : sortedRows) {
            response.templates.add(sorter.row);
        }

        response.kpis.totalTemplates = response.templates.size();
        response.kpis.activeTemplates = activeCount;
        response.kpis.usedByContracts = usedTemplateCount;
        response.kpis.generatedFiles = generatedFileTotal;
        return response;
    }

    @AuraEnabled
    public static void deleteTemplate(Id templateId) {
        if (templateId == null) {
            throw new AuraHandledException('Template id is required.');
        }
        if (!Schema.SObjectType.DocumentTemplate.isDeletable()) {
            throw new AuraHandledException('You do not have permission to delete document templates.');
        }

        List<DocumentTemplate> templates = [
            SELECT Id, Name
            FROM DocumentTemplate
            WHERE Id = :templateId
            LIMIT 1
        ];
        if (templates.isEmpty()) {
            throw new AuraHandledException('Template not found.');
        }

        try {
            delete templates[0];
        } catch (DmlException e) {
            String message = e.getNumDml() > 0 ? e.getDmlMessage(0) : e.getMessage();
            throw new AuraHandledException('Unable to delete template: ' + message);
        }
    }

    @AuraEnabled(cacheable=true)
    public static TemplateUsageResponse getTemplateUsage(Id templateId) {
        TemplateUsageResponse response = new TemplateUsageResponse();
        response.templateId = templateId;
        response.mapperName = null;
        response.extractName = null;
        response.mapperTransformId = null;
        response.extractTransformId = null;
        response.mapperExists = false;
        response.extractExists = false;
        response.mapperFieldCount = 0;
        response.extractFieldCount = 0;
        response.mappedFields = new List<TemplateMappingFieldRow>();
        response.contracts = new List<TemplateContractUsageRow>();
        response.totalContracts = 0;
        response.totalVersions = 0;
        response.totalGeneratedFiles = 0;
        response.lastUsedDate = null;

        if (templateId == null) {
            return response;
        }

        List<DocumentTemplate> templateRows = [
            SELECT Id,
                   Name,
                   MapperOmniDataTransformName,
                   ExtractOmniDataTransformName
            FROM DocumentTemplate
            WHERE Id = :templateId
            LIMIT 1
        ];
        if (!templateRows.isEmpty()) {
            response.templateName = templateRows[0].Name;
            response.mapperName = templateRows[0].MapperOmniDataTransformName;
            response.extractName = templateRows[0].ExtractOmniDataTransformName;
        }

        Set<String> transformNames = new Set<String>();
        if (String.isNotBlank(response.mapperName)) {
            transformNames.add(response.mapperName);
        }
        if (String.isNotBlank(response.extractName)) {
            transformNames.add(response.extractName);
        }

        Map<String, TransformInfo> transformByName = new Map<String, TransformInfo>();
        Map<Id, String> sourceTypeByTransformId = new Map<Id, String>();
        Map<Id, String> transformNameById = new Map<Id, String>();
        if (!transformNames.isEmpty()) {
            for (OmniDataTransform transformRow : [
                SELECT Id, Name
                FROM OmniDataTransform
                WHERE Name IN :transformNames
                LIMIT 200
            ]) {
                TransformInfo info = new TransformInfo();
                info.id = transformRow.Id;
                info.name = transformRow.Name;
                transformByName.put(transformRow.Name, info);
            }

            if (String.isNotBlank(response.mapperName) && transformByName.containsKey(response.mapperName)) {
                response.mapperTransformId = transformByName.get(response.mapperName).id;
                response.mapperExists = true;
                sourceTypeByTransformId.put(response.mapperTransformId, 'Mapper');
                transformNameById.put(response.mapperTransformId, response.mapperName);
            }
            if (String.isNotBlank(response.extractName) && transformByName.containsKey(response.extractName)) {
                response.extractTransformId = transformByName.get(response.extractName).id;
                response.extractExists = true;
                sourceTypeByTransformId.put(response.extractTransformId, 'Extract');
                transformNameById.put(response.extractTransformId, response.extractName);
            }
        }

        Set<Id> transformIds = new Set<Id>();
        if (response.mapperTransformId != null) {
            transformIds.add(response.mapperTransformId);
        }
        if (response.extractTransformId != null) {
            transformIds.add(response.extractTransformId);
        }

        if (!transformIds.isEmpty()) {
            Integer mapperCount = 0;
            Integer extractCount = 0;
            for (OmniDataTransformItem itemRow : [
                SELECT Id,
                       Name,
                       OmniDataTransformationId,
                       InputObjectName,
                       InputFieldName,
                       OutputObjectName,
                       OutputFieldName,
                       FormulaResultPath,
                       IsDisabled
                FROM OmniDataTransformItem
                WHERE OmniDataTransformationId IN :transformIds
                ORDER BY LastModifiedDate DESC
                LIMIT 1200
            ]) {
                if (itemRow.OmniDataTransformationId == response.mapperTransformId) {
                    mapperCount += 1;
                } else if (itemRow.OmniDataTransformationId == response.extractTransformId) {
                    extractCount += 1;
                }

                if (response.mappedFields.size() >= 80) {
                    continue;
                }

                TemplateMappingFieldRow mappingRow = new TemplateMappingFieldRow();
                mappingRow.itemId = itemRow.Id;
                mappingRow.transformId = itemRow.OmniDataTransformationId;
                mappingRow.transformName = transformNameById.get(itemRow.OmniDataTransformationId);
                mappingRow.sourceType = sourceTypeByTransformId.get(itemRow.OmniDataTransformationId);
                mappingRow.inputObjectName = itemRow.InputObjectName;
                mappingRow.inputFieldName = itemRow.InputFieldName;
                mappingRow.outputObjectName = itemRow.OutputObjectName;
                mappingRow.outputFieldName = itemRow.OutputFieldName;
                mappingRow.formulaResultPath = itemRow.FormulaResultPath;
                mappingRow.isDisabled = itemRow.IsDisabled;
                response.mappedFields.add(mappingRow);
            }
            response.mapperFieldCount = mapperCount;
            response.extractFieldCount = extractCount;
        }

        List<ContractDocumentVersion> versions = [
            SELECT Id,
                   ContractId,
                   Contract.Name,
                   Contract.ContractNumber,
                   Contract.Status,
                   Status,
                   VersionNumber,
                   CreatedDate
            FROM ContractDocumentVersion
            WHERE DocumentTemplateId = :templateId
            ORDER BY CreatedDate DESC
            LIMIT 5000
        ];

        if (versions.isEmpty()) {
            return response;
        }

        Map<Id, TemplateContractUsageRow> usageByContractId = new Map<Id, TemplateContractUsageRow>();
        Map<Id, Id> contractIdByVersionId = new Map<Id, Id>();
        Set<Id> versionIds = new Set<Id>();

        for (ContractDocumentVersion versionRow : versions) {
            versionIds.add(versionRow.Id);
            contractIdByVersionId.put(versionRow.Id, versionRow.ContractId);

            TemplateContractUsageRow usage = usageByContractId.get(versionRow.ContractId);
            if (usage == null) {
                usage = new TemplateContractUsageRow();
                usage.contractId = versionRow.ContractId;
                usage.contractName = versionRow.Contract != null ? versionRow.Contract.Name : null;
                usage.contractNumber = versionRow.Contract != null ? versionRow.Contract.ContractNumber : null;
                usage.contractStatus = versionRow.Contract != null ? versionRow.Contract.Status : null;
                usage.latestVersionId = versionRow.Id;
                usage.latestVersionNumber = versionRow.VersionNumber;
                usage.latestVersionStatus = versionRow.Status;
                usage.latestVersionDate = versionRow.CreatedDate;
                usage.totalVersions = 0;
                usage.generatedFiles = 0;
                usageByContractId.put(versionRow.ContractId, usage);
            }

            usage.totalVersions += 1;
            if (response.lastUsedDate == null || versionRow.CreatedDate > response.lastUsedDate) {
                response.lastUsedDate = versionRow.CreatedDate;
            }
        }

        if (!versionIds.isEmpty()) {
            for (ContractDocVerContentDoc contentDoc : [
                SELECT ContractDocumentVersionId
                FROM ContractDocVerContentDoc
                WHERE ContractDocumentVersionId IN :versionIds
                LIMIT 50000
            ]) {
                Id contractId = contractIdByVersionId.get(contentDoc.ContractDocumentVersionId);
                if (contractId != null && usageByContractId.containsKey(contractId)) {
                    usageByContractId.get(contractId).generatedFiles += 1;
                }
            }
        }

        List<TemplateUsageRowSorter> sortedUsageRows = new List<TemplateUsageRowSorter>();
        Integer versionTotal = 0;
        Integer generatedTotal = 0;
        for (TemplateContractUsageRow row : usageByContractId.values()) {
            versionTotal += row.totalVersions;
            generatedTotal += row.generatedFiles;
            sortedUsageRows.add(new TemplateUsageRowSorter(row));
        }

        sortedUsageRows.sort();
        for (TemplateUsageRowSorter sorter : sortedUsageRows) {
            response.contracts.add(sorter.row);
        }

        response.totalContracts = response.contracts.size();
        response.totalVersions = versionTotal;
        response.totalGeneratedFiles = generatedTotal;
        return response;
    }

    @AuraEnabled(cacheable=true)
    public static MergeFieldBuilderContext getMergeFieldBuilderContext(Id templateId) {
        MergeFieldBuilderContext context = new MergeFieldBuilderContext();
        context.templateId = templateId;
        context.sourceObjects = new List<MergeFieldObjectOption>();
        context.fieldsByObject = new List<MergeFieldObjectFieldGroup>();
        context.blockingIssues = new List<String>();

        if (templateId == null) {
            context.blockingIssues.add('A template id is required.');
            return context;
        }

        TransformResolution resolution = resolveTemplateTransforms(templateId, true);
        context.templateName = resolution.templateName;
        context.mapperTransformId = resolution.mapperTransformId;
        context.extractTransformId = resolution.extractTransformId;
        context.blockingIssues.addAll(resolution.blockingIssues);

        if (!context.blockingIssues.isEmpty()) {
            return context;
        }

        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
        List<String> scopedObjectNames = new List<String>();
        scopedObjectNames.addAll(resolution.scopedObjects);
        scopedObjectNames.sort();

        for (String objectApiName : scopedObjectNames) {
            Schema.SObjectType objectType = globalDescribe.get(objectApiName);
            if (objectType == null) {
                continue;
            }

            Schema.DescribeSObjectResult objectDescribe = objectType.getDescribe();
            if (!objectDescribe.isAccessible()) {
                continue;
            }

            MergeFieldObjectOption option = new MergeFieldObjectOption();
            option.objectApiName = objectApiName;
            option.objectLabel = objectDescribe.getLabel();
            context.sourceObjects.add(option);

            MergeFieldObjectFieldGroup fieldGroup = new MergeFieldObjectFieldGroup();
            fieldGroup.objectApiName = objectApiName;
            fieldGroup.objectLabel = objectDescribe.getLabel();
            fieldGroup.inferredBasePath = resolution.basePathByObject.get(objectApiName);
            fieldGroup.fields = new List<MergeFieldFieldOption>();

            Map<String, Schema.SObjectField> fieldsByApi = objectDescribe.fields.getMap();
            List<String> fieldSortKeys = new List<String>();
            Map<String, MergeFieldFieldOption> optionBySortKey = new Map<String, MergeFieldFieldOption>();
            for (String fieldApiName : fieldsByApi.keySet()) {
                Schema.DescribeFieldResult fieldDescribe = fieldsByApi.get(fieldApiName).getDescribe();
                if (!fieldDescribe.isAccessible()) {
                    continue;
                }
                if (fieldDescribe.getType() == Schema.DisplayType.Base64 ||
                    fieldDescribe.getType() == Schema.DisplayType.Address ||
                    fieldDescribe.getType() == Schema.DisplayType.Location) {
                    continue;
                }

                MergeFieldFieldOption fieldOption = new MergeFieldFieldOption();
                // Always expose canonical API name casing for downstream mapper paths.
                fieldOption.fieldApiName = fieldDescribe.getName();
                fieldOption.fieldLabel = fieldDescribe.getLabel();
                fieldOption.dataType = String.valueOf(fieldDescribe.getType());

                String sortKey = (fieldOption.fieldLabel != null ? fieldOption.fieldLabel.toLowerCase() : '') + '|' + fieldApiName;
                fieldSortKeys.add(sortKey);
                optionBySortKey.put(sortKey, fieldOption);
            }
            fieldSortKeys.sort();
            for (String key : fieldSortKeys) {
                fieldGroup.fields.add(optionBySortKey.get(key));
            }
            if (!fieldGroup.fields.isEmpty()) {
                context.fieldsByObject.add(fieldGroup);
            }
        }

        if (context.sourceObjects.isEmpty() || context.fieldsByObject.isEmpty()) {
            context.blockingIssues.add('No readable source objects and fields were inferred from this template extract context.');
        }
        return context;
    }

    @AuraEnabled
    public static MergeFieldChangePreview previewMergeFieldChange(MergeFieldChangeRequest request) {
        return buildMergeFieldPreview(request);
    }

    @AuraEnabled
    public static MergeFieldApplyResult applyMergeFieldChange(MergeFieldChangeRequest request) {
        MergeFieldApplyResult result = new MergeFieldApplyResult();
        result.success = false;
        result.messages = new List<String>();

        MergeFieldChangePreview preview = buildMergeFieldPreview(request);
        result.mergeToken = preview.mergeToken;
        result.normalizedFriendlyMergeFieldName = preview.normalizedFriendlyMergeFieldName;

        if (!Schema.SObjectType.OmniDataTransformItem.isCreateable()) {
            result.messages.add('You do not have permission to create DataRaptor transform items.');
            return result;
        }

        if (!preview.canApply) {
            if (preview.alreadyExistsExtract == true && preview.alreadyExistsMapper == true) {
                result.success = true;
                result.messages.add('No changes applied. Matching extract and mapper mappings already exist.');
                return result;
            }
            result.messages.addAll(preview.blockingIssues);
            return result;
        }

        List<OmniDataTransformItem> rowsToInsert = new List<OmniDataTransformItem>();

        if (preview.alreadyExistsExtract != true && preview.extractCandidate != null) {
            OmniDataTransformItem extractInsert = new OmniDataTransformItem();
            extractInsert.Name = preview.extractCandidate.name;
            extractInsert.OmniDataTransformationId = preview.extractCandidate.omniDataTransformationId;
            extractInsert.InputObjectName = preview.extractCandidate.inputObjectName;
            extractInsert.InputFieldName = preview.extractCandidate.inputFieldName;
            extractInsert.OutputObjectName = preview.extractCandidate.outputObjectName;
            extractInsert.OutputFieldName = preview.extractCandidate.outputFieldName;
            extractInsert.FormulaResultPath = preview.extractCandidate.formulaResultPath;
            extractInsert.OutputCreationSequence =
                preview.extractCandidate.outputCreationSequence != null
                    ? preview.extractCandidate.outputCreationSequence
                    : 1;
            extractInsert.IsDisabled = preview.extractCandidate.isDisabled == true;
            rowsToInsert.add(extractInsert);
        }

        if (preview.alreadyExistsMapper != true && preview.mapperCandidate != null) {
            OmniDataTransformItem mapperInsert = new OmniDataTransformItem();
            mapperInsert.Name = preview.mapperCandidate.name;
            mapperInsert.OmniDataTransformationId = preview.mapperCandidate.omniDataTransformationId;
            mapperInsert.InputObjectName = preview.mapperCandidate.inputObjectName;
            mapperInsert.InputFieldName = preview.mapperCandidate.inputFieldName;
            mapperInsert.OutputObjectName = preview.mapperCandidate.outputObjectName;
            mapperInsert.OutputFieldName = preview.mapperCandidate.outputFieldName;
            mapperInsert.FormulaResultPath = preview.mapperCandidate.formulaResultPath;
            mapperInsert.OutputCreationSequence =
                preview.mapperCandidate.outputCreationSequence != null
                    ? preview.mapperCandidate.outputCreationSequence
                    : 1;
            mapperInsert.IsDisabled = preview.mapperCandidate.isDisabled == true;
            rowsToInsert.add(mapperInsert);
        }

        if (rowsToInsert.isEmpty()) {
            result.success = true;
            result.messages.add('No changes applied. Mappings are already present.');
            return result;
        }

        insert rowsToInsert;

        for (OmniDataTransformItem createdRow : rowsToInsert) {
            if (preview.extractCandidate != null &&
                createdRow.OmniDataTransformationId == preview.extractCandidate.omniDataTransformationId &&
                createdRow.InputFieldName == preview.extractCandidate.inputFieldName &&
                createdRow.OutputFieldName == preview.extractCandidate.outputFieldName) {
                result.createdExtractItemId = createdRow.Id;
            } else if (preview.mapperCandidate != null &&
                createdRow.OmniDataTransformationId == preview.mapperCandidate.omniDataTransformationId &&
                createdRow.InputFieldName == preview.mapperCandidate.inputFieldName &&
                createdRow.OutputFieldName == preview.mapperCandidate.outputFieldName) {
                result.createdMapperItemId = createdRow.Id;
            }
        }

        result.success = true;
        result.messages.add('Merge field mapping created successfully.');
        return result;
    }

    private static MergeFieldChangePreview buildMergeFieldPreview(MergeFieldChangeRequest request) {
        MergeFieldChangePreview preview = new MergeFieldChangePreview();
        preview.blockingIssues = new List<String>();
        preview.warnings = new List<String>();
        preview.suggestions = new List<String>();
        preview.alreadyExistsExtract = false;
        preview.alreadyExistsMapper = false;
        preview.canApply = false;

        if (request == null) {
            preview.blockingIssues.add('Merge field request payload is required.');
            return finalizePreview(preview);
        }
        if (request.templateId == null) {
            preview.blockingIssues.add('Template id is required.');
        }
        if (String.isBlank(request.sourceObjectApiName)) {
            preview.blockingIssues.add('Source object is required.');
        }
        if (String.isBlank(request.sourceFieldApiName)) {
            preview.blockingIssues.add('Source field is required.');
        }

        String normalizedFriendlyName = normalizeFriendlyMergeFieldName(request.friendlyMergeFieldName);
        preview.normalizedFriendlyMergeFieldName = normalizedFriendlyName;
        preview.mergeToken = normalizedFriendlyName != null ? '{{' + normalizedFriendlyName + '}}' : null;
        if (String.isBlank(request.friendlyMergeFieldName)) {
            preview.blockingIssues.add('Friendly merge field name is required.');
        } else if (String.isBlank(normalizedFriendlyName)) {
            preview.blockingIssues.add('Friendly merge field name must contain alphanumeric characters and begin with a letter.');
        }

        TransformResolution resolution = resolveTemplateTransforms(request.templateId, true);
        preview.blockingIssues.addAll(resolution.blockingIssues);
        if (!preview.blockingIssues.isEmpty()) {
            return finalizePreview(preview);
        }

        if (!resolution.scopedObjects.contains(request.sourceObjectApiName)) {
            preview.blockingIssues.add('Selected source object is not available in this template extract scope.');
            return finalizePreview(preview);
        }

        Schema.SObjectType sourceObjectType = Schema.getGlobalDescribe().get(request.sourceObjectApiName);
        if (sourceObjectType == null) {
            preview.blockingIssues.add('Selected source object does not exist in this org.');
            return finalizePreview(preview);
        }

        Schema.DescribeSObjectResult objectDescribe = sourceObjectType.getDescribe();
        if (!objectDescribe.isAccessible()) {
            preview.blockingIssues.add('You do not have read access to the selected source object.');
            return finalizePreview(preview);
        }

        Map<String, Schema.SObjectField> fieldsByApi = objectDescribe.fields.getMap();
        if (!fieldsByApi.containsKey(request.sourceFieldApiName)) {
            preview.blockingIssues.add('Selected source field does not exist on the chosen object.');
            return finalizePreview(preview);
        }

        Schema.DescribeFieldResult fieldDescribe = fieldsByApi.get(request.sourceFieldApiName).getDescribe();
        if (!fieldDescribe.isAccessible()) {
            preview.blockingIssues.add('You do not have read access to the selected source field.');
            return finalizePreview(preview);
        }
        String canonicalSourceFieldApiName = fieldDescribe.getName();

        String basePath = resolution.basePathByObject.get(request.sourceObjectApiName);
        if (String.isBlank(basePath)) {
            preview.blockingIssues.add('Could not infer extract base path for the selected object from current DataRaptor configuration.');
            return finalizePreview(preview);
        }

        String extractAliasKey = request.sourceObjectApiName + ':' + canonicalSourceFieldApiName;
        String extractInputPath = basePath + ':' + canonicalSourceFieldApiName;

        preview.extractCandidate = new MergeFieldCandidate();
        preview.extractCandidate.name = resolution.extractName;
        preview.extractCandidate.omniDataTransformationId = resolution.extractTransformId;
        preview.extractCandidate.inputObjectName = null;
        preview.extractCandidate.inputFieldName = extractInputPath;
        preview.extractCandidate.outputObjectName = JSON_OUTPUT_OBJECT;
        preview.extractCandidate.outputFieldName = extractAliasKey;
        preview.extractCandidate.formulaResultPath = null;
        preview.extractCandidate.outputCreationSequence = 1;
        preview.extractCandidate.isDisabled = false;

        preview.mapperCandidate = new MergeFieldCandidate();
        preview.mapperCandidate.name = resolution.mapperName;
        preview.mapperCandidate.omniDataTransformationId = resolution.mapperTransformId;
        preview.mapperCandidate.inputObjectName = null;
        preview.mapperCandidate.inputFieldName = extractAliasKey;
        preview.mapperCandidate.outputObjectName = JSON_OUTPUT_OBJECT;
        preview.mapperCandidate.outputFieldName = normalizedFriendlyName;
        preview.mapperCandidate.formulaResultPath = null;
        preview.mapperCandidate.outputCreationSequence = 1;
        preview.mapperCandidate.isDisabled = false;

        Set<String> mapperOutputNames = new Set<String>();
        for (OmniDataTransformItem mapperItem : resolution.mapperItems) {
            if (mapperItem.IsDisabled == true) {
                continue;
            }
            if (String.isNotBlank(mapperItem.OutputFieldName)) {
                mapperOutputNames.add(mapperItem.OutputFieldName);
            }

            Boolean isExactMapperMatch =
                mapperItem.InputFieldName == preview.mapperCandidate.inputFieldName &&
                mapperItem.OutputFieldName == preview.mapperCandidate.outputFieldName &&
                mapperItem.OutputObjectName == preview.mapperCandidate.outputObjectName;
            if (isExactMapperMatch) {
                preview.alreadyExistsMapper = true;
            }
        }

        for (OmniDataTransformItem extractItem : resolution.extractItems) {
            if (extractItem.IsDisabled == true) {
                continue;
            }
            Boolean isExactExtractMatch =
                extractItem.InputFieldName == preview.extractCandidate.inputFieldName &&
                extractItem.OutputFieldName == preview.extractCandidate.outputFieldName &&
                extractItem.OutputObjectName == preview.extractCandidate.outputObjectName;
            if (isExactExtractMatch) {
                preview.alreadyExistsExtract = true;
            }
        }

        if (mapperOutputNames.contains(normalizedFriendlyName) && preview.alreadyExistsMapper != true) {
            preview.blockingIssues.add('Merge field name "' + normalizedFriendlyName + '" already exists in the mapper output.');
            preview.suggestions.addAll(generateNameSuggestions(normalizedFriendlyName, mapperOutputNames));
        }

        if (preview.alreadyExistsExtract == true && preview.alreadyExistsMapper == true) {
            preview.warnings.add('This mapping already exists. Applying again will be a no-op.');
        }

        return finalizePreview(preview);
    }

    private static MergeFieldChangePreview finalizePreview(MergeFieldChangePreview preview) {
        preview.canApply = preview.blockingIssues.isEmpty();
        return preview;
    }

    private static TransformResolution resolveTemplateTransforms(Id templateId, Boolean includeItemContext) {
        TransformResolution resolution = new TransformResolution();
        resolution.templateId = templateId;

        if (templateId == null) {
            resolution.blockingIssues.add('Template id is required.');
            return resolution;
        }

        List<DocumentTemplate> templates = [
            SELECT Id,
                   Name,
                   MapperOmniDataTransformName,
                   ExtractOmniDataTransformName
            FROM DocumentTemplate
            WHERE Id = :templateId
            LIMIT 1
        ];
        if (templates.isEmpty()) {
            resolution.blockingIssues.add('Template was not found.');
            return resolution;
        }

        DocumentTemplate templateRecord = templates[0];
        resolution.templateName = templateRecord.Name;
        resolution.mapperName = templateRecord.MapperOmniDataTransformName;
        resolution.extractName = templateRecord.ExtractOmniDataTransformName;

        if (String.isBlank(resolution.mapperName)) {
            resolution.blockingIssues.add('Template is missing Mapper OmniDataTransform name.');
        }
        if (String.isBlank(resolution.extractName)) {
            resolution.blockingIssues.add('Template is missing Extract OmniDataTransform name.');
        }
        if (!resolution.blockingIssues.isEmpty()) {
            return resolution;
        }

        Set<String> transformNames = new Set<String>{ resolution.mapperName, resolution.extractName };
        Map<String, Id> transformIdByName = new Map<String, Id>();
        for (OmniDataTransform transformRow : [
            SELECT Id, Name
            FROM OmniDataTransform
            WHERE Name IN :transformNames
            LIMIT 200
        ]) {
            transformIdByName.put(transformRow.Name, transformRow.Id);
        }

        resolution.mapperTransformId = transformIdByName.get(resolution.mapperName);
        resolution.extractTransformId = transformIdByName.get(resolution.extractName);

        if (resolution.mapperTransformId == null) {
            resolution.blockingIssues.add('Mapper transform "' + resolution.mapperName + '" was not found.');
        }
        if (resolution.extractTransformId == null) {
            resolution.blockingIssues.add('Extract transform "' + resolution.extractName + '" was not found.');
        }
        if (!resolution.blockingIssues.isEmpty()) {
            return resolution;
        }

        if (!includeItemContext) {
            return resolution;
        }

        resolution.extractItems = [
            SELECT Id,
                   InputObjectName,
                   InputFieldName,
                   OutputObjectName,
                   OutputFieldName,
                   FormulaResultPath,
                   IsDisabled
            FROM OmniDataTransformItem
            WHERE OmniDataTransformationId = :resolution.extractTransformId
            LIMIT :MAX_CONTEXT_ITEMS
        ];
        resolution.mapperItems = [
            SELECT Id,
                   InputObjectName,
                   InputFieldName,
                   OutputObjectName,
                   OutputFieldName,
                   FormulaResultPath,
                   IsDisabled
            FROM OmniDataTransformItem
            WHERE OmniDataTransformationId = :resolution.mapperTransformId
            LIMIT :MAX_CONTEXT_ITEMS
        ];

        for (OmniDataTransformItem item : resolution.extractItems) {
            if (item.IsDisabled == true) {
                continue;
            }
            if (String.isNotBlank(item.InputObjectName)) {
                resolution.scopedObjects.add(item.InputObjectName);
            }
            if (String.isNotBlank(item.InputObjectName) &&
                item.InputFieldName == 'Id' &&
                String.isNotBlank(item.OutputFieldName) &&
                !resolution.basePathByObject.containsKey(item.InputObjectName)) {
                resolution.basePathByObject.put(item.InputObjectName, item.OutputFieldName);
            }
        }

        // Fallback path inference when ID anchor rows aren't available.
        for (OmniDataTransformItem item : resolution.extractItems) {
            if (item.IsDisabled == true) {
                continue;
            }
            if (String.isBlank(item.OutputFieldName) || String.isBlank(item.InputFieldName)) {
                continue;
            }
            Integer outputSplit = item.OutputFieldName.indexOf(':');
            Integer inputSplit = item.InputFieldName.lastIndexOf(':');
            if (outputSplit <= 0 || inputSplit <= 0) {
                continue;
            }
            String objectName = item.OutputFieldName.substring(0, outputSplit);
            if (!resolution.scopedObjects.contains(objectName) || resolution.basePathByObject.containsKey(objectName)) {
                continue;
            }
            resolution.basePathByObject.put(objectName, item.InputFieldName.substring(0, inputSplit));
        }

        if (resolution.scopedObjects.isEmpty()) {
            resolution.blockingIssues.add('No source objects were inferred from the selected extract transform.');
        }
        return resolution;
    }

    private static String normalizeFriendlyMergeFieldName(String inputValue) {
        if (String.isBlank(inputValue)) {
            return null;
        }

        String splitCamel = inputValue.replaceAll('([a-z0-9])([A-Z])', '$1 $2');
        String sanitized = splitCamel.replaceAll('[^A-Za-z0-9]+', ' ').trim();
        if (String.isBlank(sanitized)) {
            return null;
        }

        List<String> tokens = sanitized.split('\\s+');
        String normalized = '';
        for (String token : tokens) {
            if (String.isBlank(token)) {
                continue;
            }
            String lowered = token.toLowerCase();
            normalized += lowered.substring(0, 1).toUpperCase() + lowered.substring(1);
        }

        if (String.isBlank(normalized)) {
            return null;
        }

        String firstChar = normalized.substring(0, 1);
        if (!'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'.contains(firstChar)) {
            return null;
        }
        return normalized;
    }

    private static List<String> generateNameSuggestions(String baseName, Set<String> existingNames) {
        List<String> suggestions = new List<String>();
        if (String.isBlank(baseName)) {
            return suggestions;
        }

        Integer suffix = 2;
        while (suggestions.size() < MAX_NAME_SUGGESTIONS && suffix <= 99) {
            String candidate = baseName + String.valueOf(suffix);
            if (!existingNames.contains(candidate)) {
                suggestions.add(candidate);
            }
            suffix += 1;
        }
        return suggestions;
    }

    private static Integer decimalToInteger(Decimal value) {
        return value == null ? 0 : Integer.valueOf(String.valueOf(value.intValue()));
    }
}
