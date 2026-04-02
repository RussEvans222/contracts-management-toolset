import { LightningElement, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LightningConfirm from 'lightning/confirm';
import getTemplateSummary from '@salesforce/apex/SDO_ContractTemplateManagerController.getTemplateSummary';
import getTemplateUsage from '@salesforce/apex/SDO_ContractTemplateManagerController.getTemplateUsage';
import getMergeFieldBuilderContext from '@salesforce/apex/SDO_ContractTemplateManagerController.getMergeFieldBuilderContext';
import previewMergeFieldChange from '@salesforce/apex/SDO_ContractTemplateManagerController.previewMergeFieldChange';
import applyMergeFieldChange from '@salesforce/apex/SDO_ContractTemplateManagerController.applyMergeFieldChange';
import deleteTemplate from '@salesforce/apex/SDO_ContractTemplateManagerController.deleteTemplate';

export default class ContractsTemplateManager extends NavigationMixin(LightningElement) {
    clmOnly = true;
    thumbnailCacheKey = Date.now();
    activeMappedSections = [];
    activeMergeSections = [];
    mergeBuilderContext = null;
    mergeBuilderLoading = false;
    mergeBuilderError;
    mergeSourceObject = '';
    mergeSourceField = '';
    mergeFriendlyName = '';
    mergeFriendlyNameManuallyEdited = false;
    mergePreview = null;
    mergePreviewLoading = false;
    mergeApplyLoading = false;
    mergeApplyMessage;
    mergeApplyError;
    recentlyAddedMergeFieldName;
    templateDeleteLoading = false;

    kpis = {
        totalTemplates: 0,
        activeTemplates: 0,
        usedByContracts: 0,
        generatedFiles: 0
    };

    templates = [];
    selectedTemplateId;
    usage = null;

    summaryError;
    usageError;
    usageLoading = false;
    summaryLoading = true;
    lastRefreshed;

    wiredSummaryResult;

    @wire(getTemplateSummary, { clmOnly: '$clmOnly' })
    wiredSummary(value) {
        this.wiredSummaryResult = value;
        const { data, error } = value;

        if (data) {
            this.summaryLoading = false;
            this.summaryError = undefined;
            this.kpis = data.kpis || this.kpis;
            this.templates = (data.templates || []).map((row) => ({
                ...row,
                ...this.mapTemplatePreview(row),
                usageStatus: row.timesUsed > 0 ? 'Used' : 'Unused',
                usageStatusClass: row.timesUsed > 0 ? 'usage-pill usage-pill-used' : 'usage-pill',
                statusClass: this.getTemplateStatusClass(row.status),
                hasDownload: !!row.downloadUrl,
                downloadDisabled: !row.downloadUrl,
                selectedClass: row.templateId === this.selectedTemplateId ? 'template-card selected' : 'template-card'
            }));
            this.lastRefreshed = new Date().toISOString();

            if (this.templates.length === 0) {
                this.selectedTemplateId = null;
                this.usage = null;
                this.mergeBuilderContext = null;
                this.mergePreview = null;
                this.mergeBuilderError = undefined;
                return;
            }

            if (!this.selectedTemplateId || !this.templates.some((row) => row.templateId === this.selectedTemplateId)) {
                this.selectedTemplateId = this.templates[0].templateId;
            }

            this.updateRowSelectionClasses();
            this.loadUsage(this.selectedTemplateId);
            this.loadMergeBuilderContext(this.selectedTemplateId);
            return;
        }

        if (error) {
            this.summaryLoading = false;
            this.summaryError = this.reduceError(error);
            this.templates = [];
            this.selectedTemplateId = null;
            this.usage = null;
            this.mergeBuilderContext = null;
            this.mergePreview = null;
            this.mergeBuilderError = undefined;
        }
    }

    get kpiCards() {
        return [
            {
                key: 'total',
                label: 'Total CLM Templates',
                value: this.kpis.totalTemplates || 0,
                className: 'kpi-card kpi-total'
            },
            {
                key: 'active',
                label: 'Active',
                value: this.kpis.activeTemplates || 0,
                className: 'kpi-card kpi-active'
            },
            {
                key: 'used',
                label: 'Used by Contracts',
                value: this.kpis.usedByContracts || 0,
                className: 'kpi-card kpi-used'
            },
            {
                key: 'generated',
                label: 'Generated Files',
                value: this.kpis.generatedFiles || 0,
                className: 'kpi-card kpi-generated'
            }
        ];
    }

    get hasTemplates() {
        return this.templates.length > 0;
    }

    get selectedTemplate() {
        return this.templates.find((row) => row.templateId === this.selectedTemplateId) || null;
    }

    get canDeleteSelectedTemplate() {
        return this.selectedTemplate?.canDelete === true;
    }

    get isDeleteSelectedTemplateDisabled() {
        return !this.canDeleteSelectedTemplate || this.templateDeleteLoading;
    }

    get hasUsageContracts() {
        return (this.usage?.contracts || []).length > 0;
    }

    get usageContracts() {
        return (this.usage?.contracts || []).map((row) => ({
            ...row,
            contractLabel: row.contractNumber ? `#${row.contractNumber}` : 'Contract',
            statusClass: this.getStatusClass(row.contractStatus)
        }));
    }

    get usageHeader() {
        if (!this.usage) {
            return 'Select a template to view contract usage';
        }
        return `${this.usage.totalContracts || 0} contracts · ${this.usage.totalVersions || 0} versions · ${this.usage.totalGeneratedFiles || 0} files`;
    }

    get scopedLabel() {
        return this.clmOnly ? 'Scope: CLM templates only' : 'Scope: All templates';
    }

    get selectedTemplateFileType() {
        const row = this.selectedTemplate;
        if (!row) {
            return 'No file linked';
        }
        if (!row.fileType) {
            return 'No file metadata';
        }
        return row.fileExtension ? `${row.fileType} (.${row.fileExtension.toLowerCase()})` : row.fileType;
    }

    get mapperTransformId() {
        return this.usage?.mapperTransformId || this.selectedTemplate?.mapperTransformId || null;
    }

    get extractTransformId() {
        return this.usage?.extractTransformId || this.selectedTemplate?.extractTransformId || null;
    }

    get mapperName() {
        return this.usage?.mapperName || this.selectedTemplate?.mapperName || 'Not set';
    }

    get extractName() {
        return this.usage?.extractName || this.selectedTemplate?.extractName || 'Not set';
    }

    get hasMappedFields() {
        return this.mapperFields.length > 0;
    }

    get mappedFields() {
        const highlightedToken = this.recentlyAddedMergeFieldName ? `{{${this.recentlyAddedMergeFieldName}}}` : null;
        return (this.usage?.mappedFields || []).map((row) => {
            const inputParts = [];
            if (row.inputObjectName) {
                inputParts.push(row.inputObjectName);
            }
            if (row.inputFieldName) {
                inputParts.push(row.inputFieldName);
            }

            const outputParts = [];
            if (row.outputObjectName) {
                outputParts.push(row.outputObjectName);
            }
            if (row.outputFieldName) {
                outputParts.push(row.outputFieldName);
            } else if (row.formulaResultPath) {
                outputParts.push(row.formulaResultPath);
            }

            const mergeFieldToken = this.buildMergeFieldToken(row);

            return {
                ...row,
                sourceTypeLabel: row.sourceType || 'Mapper',
                sourceTypeNormalized: row.sourceType === 'Extract' ? 'Extract' : 'Mapper',
                sourceTypeClass: row.sourceType === 'Extract' ? 'status-pill status-approval' : 'status-pill status-activated',
                inputDisplay: inputParts.join(' • ') || '—',
                outputDisplay: outputParts.join(' • ') || '—',
                mergeFieldToken,
                rowClass: mergeFieldToken !== '—' && mergeFieldToken === highlightedToken ? 'mapping-row mapping-row-new' : 'mapping-row'
            };
        });
    }

    get mapperFields() {
        return this.mappedFields.filter((row) => row.sourceTypeNormalized === 'Mapper');
    }

    get mappedFieldSummary() {
        if (!this.usage) {
            return 'Mapped fields load after selecting a template.';
        }
        return `Data Mapper fields: ${this.usage.mapperFieldCount || 0}`;
    }

    get mappedFieldAccordionLabel() {
        if (!this.usage) {
            return 'Data Mapper Merge Fields';
        }
        return `Data Mapper Merge Fields (${this.usage.mapperFieldCount || 0})`;
    }

    get mapperList() {
        const names = new Set();
        this.mapperFields.forEach((row) => {
            if (row.transformName) {
                names.add(row.transformName);
            }
        });
        if (!names.size && this.mapperName && this.mapperName !== 'Not set') {
            names.add(this.mapperName);
        }
        return Array.from(names).map((name) => ({ key: name, label: name }));
    }

    get hasMapperList() {
        return this.mapperList.length > 0;
    }

    get mappedSectionClass() {
        const isOpen = Array.isArray(this.activeMappedSections) && this.activeMappedSections.includes('mappedFields');
        return isOpen ? 'mapping-section' : 'mapping-section mapping-section-collapsed';
    }

    get sourceObjectOptions() {
        return (this.mergeBuilderContext?.sourceObjects || []).map((row) => ({
            label: row.objectLabel ? `${row.objectLabel} (${row.objectApiName})` : row.objectApiName,
            value: row.objectApiName
        }));
    }

    get selectedObjectFieldGroup() {
        if (!this.mergeSourceObject) {
            return null;
        }
        return (this.mergeBuilderContext?.fieldsByObject || []).find((row) => row.objectApiName === this.mergeSourceObject) || null;
    }

    get sourceFieldOptions() {
        const fieldGroup = this.selectedObjectFieldGroup;
        if (!fieldGroup?.fields) {
            return [];
        }
        return fieldGroup.fields.map((fieldRow) => ({
            label: fieldRow.fieldLabel ? `${fieldRow.fieldLabel} (${fieldRow.fieldApiName})` : fieldRow.fieldApiName,
            value: fieldRow.fieldApiName
        }));
    }

    get hasSuggestedMergeName() {
        return !!this.suggestedFriendlyMergeFieldName;
    }

    get suggestedFriendlyMergeFieldName() {
        return this.buildSuggestedFriendlyName(this.mergeSourceObject, this.mergeSourceField);
    }

    get suggestedMergeToken() {
        return this.suggestedFriendlyMergeFieldName ? `{{${this.suggestedFriendlyMergeFieldName}}}` : '—';
    }

    get suggestedMergeDisplay() {
        if (!this.mergeSourceObject || !this.mergeSourceField || !this.suggestedFriendlyMergeFieldName) {
            return '';
        }
        return `${this.mergeSourceObject}:${this.mergeSourceField} = {{${this.suggestedFriendlyMergeFieldName}}}`;
    }

    get isUseSuggestedNameDisabled() {
        return !this.hasSuggestedMergeName ||
            this.mergeFriendlyName === this.suggestedFriendlyMergeFieldName ||
            this.mergeApplyLoading;
    }

    get liveMergeToken() {
        if (this.mergePreview?.mergeToken) {
            return this.mergePreview.mergeToken;
        }
        const normalized = this.normalizeFriendlyNameClient(this.mergeFriendlyName);
        return normalized ? `{{${normalized}}}` : '—';
    }

    get hasMergeBuilderContext() {
        return !!this.mergeBuilderContext && !this.mergeBuilderError;
    }

    get mergeBuilderBlockingIssues() {
        return this.mergeBuilderContext?.blockingIssues || [];
    }

    get hasMergeBuilderBlockingIssues() {
        return this.mergeBuilderBlockingIssues.length > 0;
    }

    get isSourceObjectDisabled() {
        return this.mergeBuilderLoading || this.mergeApplyLoading;
    }

    get isSourceFieldDisabled() {
        return !this.mergeSourceObject ||
            this.sourceFieldOptions.length === 0 ||
            this.mergeBuilderLoading ||
            this.mergeApplyLoading;
    }

    get isFriendlyNameDisabled() {
        return !this.mergeSourceObject ||
            !this.mergeSourceField ||
            this.mergeBuilderLoading ||
            this.mergeApplyLoading;
    }

    get canPreviewMergeChange() {
        return !!this.selectedTemplateId &&
            !!this.mergeSourceObject &&
            !!this.mergeSourceField &&
            !!this.mergeFriendlyName &&
            !this.mergePreviewLoading &&
            !this.mergeApplyLoading;
    }

    get canApplyMergeChange() {
        return this.mergePreview?.canApply === true &&
            !this.mergePreviewLoading &&
            !this.mergeApplyLoading;
    }

    get isPreviewDisabled() {
        return !this.canPreviewMergeChange;
    }

    get isApplyDisabled() {
        return !this.canApplyMergeChange;
    }

    get hasMergePreview() {
        return !!this.mergePreview;
    }

    get mergePreviewBlockingIssues() {
        return this.mergePreview?.blockingIssues || [];
    }

    get mergePreviewWarnings() {
        return this.mergePreview?.warnings || [];
    }

    get mergePreviewSuggestions() {
        return this.mergePreview?.suggestions || [];
    }

    get hasMergePreviewBlockingIssues() {
        return this.mergePreviewBlockingIssues.length > 0;
    }

    get hasMergePreviewWarnings() {
        return this.mergePreviewWarnings.length > 0;
    }

    get hasMergePreviewSuggestions() {
        return this.mergePreviewSuggestions.length > 0;
    }

    get hasMergeApplyMessage() {
        return !!this.mergeApplyMessage;
    }

    get hasMergeApplyError() {
        return !!this.mergeApplyError;
    }

    async handleRefresh() {
        if (this.wiredSummaryResult) {
            this.summaryLoading = true;
            this.thumbnailCacheKey = Date.now();
            await refreshApex(this.wiredSummaryResult);
        }
    }

    handleSelectTemplate(event) {
        const templateId = event.currentTarget?.dataset?.templateId;
        if (!templateId || templateId === this.selectedTemplateId) {
            return;
        }
        this.selectedTemplateId = templateId;
        this.resetMergeBuilderInput();
        this.updateRowSelectionClasses();
        this.loadUsage(templateId);
        this.loadMergeBuilderContext(templateId);
    }

    handleOpenTemplate(event) {
        const templateId = event.currentTarget?.dataset?.templateId || this.selectedTemplateId;
        if (!templateId) {
            return;
        }
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: templateId,
                objectApiName: 'DocumentTemplate',
                actionName: 'view'
            }
        });
    }

    async handleDeleteTemplate(event) {
        if (event) {
            event.stopPropagation();
        }

        const templateId = event.currentTarget?.dataset?.templateId || this.selectedTemplateId;
        if (!templateId || this.templateDeleteLoading) {
            return;
        }

        const templateRow = this.templates.find((row) => row.templateId === templateId);
        if (!templateRow || templateRow.canDelete !== true) {
            return;
        }

        const isConfirmed = await LightningConfirm.open({
            message: `Delete template "${templateRow.name}"? This action cannot be undone.`,
            label: 'Delete Document Template',
            theme: 'warning'
        });
        if (!isConfirmed) {
            return;
        }

        this.templateDeleteLoading = true;
        this.summaryError = undefined;

        try {
            await deleteTemplate({ templateId });

            if (this.selectedTemplateId === templateId) {
                this.selectedTemplateId = null;
                this.usage = null;
                this.mergeBuilderContext = null;
                this.resetMergeBuilderInput();
            }

            await this.handleRefresh();
            this.dispatchEvent(new ShowToastEvent({
                title: 'Template Deleted',
                message: `${templateRow.name} was deleted successfully.`,
                variant: 'success'
            }));
        } catch (error) {
            const message = this.reduceError(error);
            this.summaryError = message;
            this.dispatchEvent(new ShowToastEvent({
                title: 'Unable To Delete Template',
                message,
                variant: 'error'
            }));
        } finally {
            this.templateDeleteLoading = false;
        }
    }

    handleOpenTemplateApp() {
        this[NavigationMixin.Navigate]({
            type: 'standard__navItemPage',
            attributes: {
                apiName: 'omnistudio__DocumentTemplate'
            }
        });
    }

    handleOpenDataTransform(event) {
        const transformId = event.currentTarget?.dataset?.transformId;
        if (!transformId) {
            return;
        }

        const builderUrl =
            `${window.location.origin}/builder_omnistudio/omnistudioBuilder.app` +
            `?type=dataraptor&id=${encodeURIComponent(transformId)}`;

        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: builderUrl
            }
        });
    }

    handleMappedAccordionToggle(event) {
        this.activeMappedSections = this.normalizeSectionNames(event.detail?.openSections);
    }

    handleMergeBuilderAccordionToggle(event) {
        this.activeMergeSections = this.normalizeSectionNames(event.detail?.openSections);
    }

    handleDownloadTemplate(event) {
        const url = event.currentTarget?.dataset?.downloadUrl;
        if (!url) {
            return;
        }
        window.open(url, '_blank');
    }

    handleOpenFilePreview(event) {
        const contentDocumentId = event.currentTarget?.dataset?.contentDocumentId;
        if (!contentDocumentId) {
            return;
        }

        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',
            attributes: {
                pageName: 'filePreview'
            },
            state: {
                selectedRecordId: contentDocumentId
            }
        });
    }

    handlePreviewImageError(event) {
        const templateId = event.currentTarget?.dataset?.templateId;
        if (!templateId) {
            return;
        }

        this.templates = this.templates.map((row) => {
            if (row.templateId !== templateId) {
                return row;
            }

            const nextIndex = (row.thumbnailIndex || 0) + 1;
            const hasNext = nextIndex < (row.thumbnailCandidates || []).length;
            return {
                ...row,
                thumbnailIndex: nextIndex,
                hasThumbnail: hasNext,
                thumbnailUrlActive: hasNext ? row.thumbnailCandidates[nextIndex] : null
            };
        });
    }

    handleOpenContract(event) {
        const contractId = event.currentTarget?.dataset?.contractId;
        if (!contractId) {
            return;
        }
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: contractId,
                objectApiName: 'Contract',
                actionName: 'view'
            }
        });
    }

    handleMergeSourceObjectChange(event) {
        this.mergeSourceObject = event.detail.value || '';
        this.mergeSourceField = '';
        this.applySuggestedFriendlyNameFromSelection();
        this.clearMergePreview();
    }

    handleMergeSourceFieldChange(event) {
        this.mergeSourceField = event.detail.value || '';
        this.applySuggestedFriendlyNameFromSelection();
        this.clearMergePreview();
    }

    handleMergeFriendlyNameChange(event) {
        this.mergeFriendlyName = event.detail.value || '';
        this.mergeFriendlyNameManuallyEdited = true;
        this.clearMergePreview();
    }

    handleUseSuggestedMergeName() {
        if (!this.suggestedFriendlyMergeFieldName) {
            return;
        }
        this.mergeFriendlyName = this.suggestedFriendlyMergeFieldName;
        this.mergeFriendlyNameManuallyEdited = false;
        this.clearMergePreview();
    }

    async handlePreviewMergeChange() {
        if (!this.canPreviewMergeChange) {
            return;
        }
        this.mergePreviewLoading = true;
        this.mergeApplyMessage = undefined;
        this.mergeApplyError = undefined;
        this.recentlyAddedMergeFieldName = null;

        try {
            this.mergePreview = await previewMergeFieldChange({
                request: this.buildMergeFieldRequest()
            });
        } catch (error) {
            this.mergePreview = null;
            this.mergeApplyError = this.reduceError(error);
        } finally {
            this.mergePreviewLoading = false;
        }
    }

    async handleApplyMergeChange() {
        if (!this.canApplyMergeChange) {
            return;
        }

        this.mergeApplyLoading = true;
        this.mergeApplyMessage = undefined;
        this.mergeApplyError = undefined;

        try {
            const result = await applyMergeFieldChange({
                request: this.buildMergeFieldRequest()
            });

            if (result?.success) {
                this.mergeApplyMessage = (result.messages || ['Merge field mapping created successfully.']).join(' ');
                const token = result.mergeToken || '';
                this.recentlyAddedMergeFieldName = token.replace(/\{/g, '').replace(/\}/g, '');
                await Promise.all([
                    this.loadUsage(this.selectedTemplateId),
                    this.loadMergeBuilderContext(this.selectedTemplateId)
                ]);
                this.clearMergePreview(false);
            } else {
                this.mergeApplyError = (result?.messages || ['Unable to apply merge field mapping.']).join(' ');
            }
        } catch (error) {
            this.mergeApplyError = this.reduceError(error);
        } finally {
            this.mergeApplyLoading = false;
        }
    }

    handleResetMergeBuilder() {
        this.resetMergeBuilderInput();
    }

    async loadUsage(templateId) {
        if (!templateId) {
            this.usage = null;
            return;
        }

        this.usageLoading = true;
        this.usageError = undefined;

        try {
            this.usage = await getTemplateUsage({ templateId });
        } catch (error) {
            this.usage = null;
            this.usageError = this.reduceError(error);
        } finally {
            this.usageLoading = false;
        }
    }

    async loadMergeBuilderContext(templateId) {
        if (!templateId) {
            this.mergeBuilderContext = null;
            return;
        }

        this.mergeBuilderLoading = true;
        this.mergeBuilderError = undefined;
        try {
            this.mergeBuilderContext = await getMergeFieldBuilderContext({ templateId });
            if ((this.mergeBuilderContext?.blockingIssues || []).length > 0) {
                this.mergeBuilderError = this.mergeBuilderContext.blockingIssues.join(' ');
            }

            const availableObjects = new Set((this.mergeBuilderContext?.sourceObjects || []).map((row) => row.objectApiName));
            if (!availableObjects.has(this.mergeSourceObject)) {
                this.mergeSourceObject = '';
                this.mergeSourceField = '';
            } else {
                const fieldGroup = (this.mergeBuilderContext?.fieldsByObject || []).find((row) => row.objectApiName === this.mergeSourceObject);
                const availableFields = new Set((fieldGroup?.fields || []).map((fieldRow) => fieldRow.fieldApiName));
                if (!availableFields.has(this.mergeSourceField)) {
                    this.mergeSourceField = '';
                }
            }
            this.applySuggestedFriendlyNameFromSelection();
        } catch (error) {
            this.mergeBuilderContext = null;
            this.mergeBuilderError = this.reduceError(error);
        } finally {
            this.mergeBuilderLoading = false;
        }
    }

    updateRowSelectionClasses() {
        this.templates = this.templates.map((row) => ({
            ...row,
            selectedClass: row.templateId === this.selectedTemplateId ? 'template-card selected' : 'template-card'
        }));
    }

    buildMergeFieldRequest() {
        return {
            templateId: this.selectedTemplateId,
            sourceObjectApiName: this.mergeSourceObject,
            sourceFieldApiName: this.mergeSourceField,
            friendlyMergeFieldName: this.mergeFriendlyName
        };
    }

    resetMergeBuilderInput() {
        this.mergeSourceObject = '';
        this.mergeSourceField = '';
        this.mergeFriendlyName = '';
        this.mergeFriendlyNameManuallyEdited = false;
        this.mergePreview = null;
        this.mergeApplyMessage = undefined;
        this.mergeApplyError = undefined;
        this.recentlyAddedMergeFieldName = null;
    }

    clearMergePreview(clearMessages = true) {
        this.mergePreview = null;
        if (clearMessages) {
            this.mergeApplyMessage = undefined;
            this.mergeApplyError = undefined;
            this.recentlyAddedMergeFieldName = null;
        }
    }

    mapTemplatePreview(row) {
        const thumbnailCandidates = this.getThumbnailCandidates(row.latestContentVersionId);
        const hasThumbnail = thumbnailCandidates.length > 0;
        return {
            thumbnailCandidates,
            thumbnailIndex: 0,
            hasThumbnail,
            thumbnailUrlActive: hasThumbnail ? thumbnailCandidates[0] : null
        };
    }

    getThumbnailCandidates(versionId) {
        if (!versionId) {
            return [];
        }
        const base = '/sfc/servlet.shepherd/version/renditionDownload?operationContext=CHATTER';
        const cacheBust = `&cb=${this.thumbnailCacheKey}`;
        return [
            `${base}&rendition=THUMB720BY480&versionId=${versionId}${cacheBust}`,
            `${base}&rendition=THUMB720BY480&versionId=${versionId}&page=0${cacheBust}`,
            `${base}&rendition=THUMB120BY90&versionId=${versionId}${cacheBust}`
        ];
    }

    getStatusClass(status) {
        if (status === 'Signed') return 'status-pill status-signed';
        if (status === 'Activated') return 'status-pill status-activated';
        if (status === 'In Approval Process') return 'status-pill status-approval';
        if (status === 'Draft') return 'status-pill status-draft';
        return 'status-pill';
    }

    getTemplateStatusClass(status) {
        if (status === 'Active') return 'status-pill status-activated';
        if (status === 'Draft') return 'status-pill status-draft';
        return 'status-pill';
    }

    buildMergeFieldToken(row) {
        const raw = (row?.outputFieldName || row?.formulaResultPath || '').trim();
        if (!raw) {
            return '—';
        }

        let normalized = raw
            .replace(/^json[.:]/i, '')
            .replace(/^json$/i, '')
            .replace(/:+/g, '.')
            .replace(/\s+/g, '')
            .replace(/^\.+|\.+$/g, '');

        if (!normalized) {
            return '—';
        }
        return `{{${normalized}}}`;
    }

    normalizeFriendlyNameClient(value) {
        if (!value || !value.trim()) {
            return '';
        }
        const splitCamel = value.replace(/([a-z0-9])([A-Z])/g, '$1 $2');
        const sanitized = splitCamel.replace(/[^A-Za-z0-9]+/g, ' ').trim();
        if (!sanitized) {
            return '';
        }
        const normalized = sanitized
            .split(/\s+/)
            .filter(Boolean)
            .map((token) => token.charAt(0).toUpperCase() + token.slice(1).toLowerCase())
            .join('');
        if (!normalized || !/^[A-Za-z]/.test(normalized)) {
            return '';
        }
        return normalized;
    }

    buildSuggestedFriendlyName(objectApiName, fieldApiName) {
        if (!objectApiName || !fieldApiName) {
            return '';
        }
        return this.normalizeFriendlyNameClient(`${objectApiName} ${fieldApiName}`);
    }

    applySuggestedFriendlyNameFromSelection() {
        const suggestedName = this.suggestedFriendlyMergeFieldName;
        if (!suggestedName) {
            return;
        }
        if (!this.mergeFriendlyName || !this.mergeFriendlyNameManuallyEdited) {
            this.mergeFriendlyName = suggestedName;
        }
    }

    normalizeSectionNames(openSections) {
        if (!openSections) {
            return [];
        }
        if (Array.isArray(openSections)) {
            return [...openSections];
        }
        return [openSections];
    }

    reduceError(error) {
        if (!error) {
            return 'Unknown error while loading contract templates.';
        }
        if (Array.isArray(error.body)) {
            return error.body.map((entry) => entry.message).join(', ');
        }
        if (typeof error.body?.message === 'string') {
            return error.body.message;
        }
        if (typeof error.message === 'string') {
            return error.message;
        }
        return 'Unable to load contract templates.';
    }
}
