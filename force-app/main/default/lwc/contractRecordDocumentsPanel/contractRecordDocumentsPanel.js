import { api, LightningElement, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';
import getContractRecordDocumentSummary from '@salesforce/apex/SDO_ContractViewerController.getContractRecordDocumentSummary';

export default class ContractRecordDocumentsPanel extends NavigationMixin(LightningElement) {
    @api recordId;

    summary;
    errorMessage;
    wiredSummaryResult;
    thumbnailCacheKey = Date.now();

    @wire(getContractRecordDocumentSummary, { contractId: '$recordId' })
    wiredSummary(value) {
        this.wiredSummaryResult = value;
        const { data, error } = value;

        if (data) {
            this.summary = this.mapSummary(data);
            this.errorMessage = undefined;
            return;
        }

        if (error) {
            this.summary = null;
            this.errorMessage = this.reduceError(error);
        }
    }

    get hasSummary() {
        return !!this.summary;
    }

    get hasDocument() {
        return this.summary?.hasDocument === true;
    }

    get signatureDateAvailable() {
        return !!this.summary?.signatureLastUpdated;
    }

    get previewDisabled() {
        return !this.hasDocument;
    }

    mapSummary(data) {
        const thumbnailCandidates = this.getThumbnailCandidates(data.latestVersionId);
        const showThumbnail = data.isPreviewable && thumbnailCandidates.length > 0;
        const contractNumber = data.contractNumber ? `#${data.contractNumber}` : '';

        return {
            ...data,
            contractLabel: contractNumber ? `Contract ${contractNumber}` : data.contractName || 'Contract',
            showThumbnail,
            thumbnailCandidates,
            thumbnailIndex: 0,
            thumbnailUrlActive: showThumbnail ? thumbnailCandidates[0] : null,
            contractStatusClass: this.getContractStatusClass(data.contractStatus),
            signatureStatusClass: this.getSignatureStatusClass(data.signatureStatus),
            signatureLabel: data.signatureStatus || 'Not Sent',
            versionLabel: data.contractDocumentVersionNumber
                ? `Version ${data.contractDocumentVersionNumber}`
                : 'No Active Version',
            fileLabel: data.fileType || 'File',
            titleLabel: data.documentTitle || 'Current Contract Document'
        };
    }

    getContractStatusClass(status) {
        if (status === 'Signed' || status === 'Activated') {
            return 'pill pill-contract pill-good';
        }
        if (status === 'Awaiting Signature' || status === 'In Approval Process' || status === 'Negotiating') {
            return 'pill pill-contract pill-warn';
        }
        if (status === 'Contract Terminated' || status === 'Canceled' || status === 'Rejected') {
            return 'pill pill-contract pill-bad';
        }
        return 'pill pill-contract';
    }

    getSignatureStatusClass(status) {
        if (status === 'Signed') {
            return 'pill pill-signature pill-good';
        }
        if (status === 'Awaiting Signature' || status === 'Sent') {
            return 'pill pill-signature pill-warn';
        }
        if (status === 'Declined' || status === 'Voided' || status === 'Canceled') {
            return 'pill pill-signature pill-bad';
        }
        return 'pill pill-signature';
    }

    async handleRefresh() {
        this.thumbnailCacheKey = Date.now();
        if (this.wiredSummaryResult) {
            await refreshApex(this.wiredSummaryResult);
        }
    }

    handleImageError() {
        if (!this.summary) {
            return;
        }

        const nextIndex = (this.summary.thumbnailIndex || 0) + 1;
        const hasNext = nextIndex < (this.summary.thumbnailCandidates || []).length;
        this.summary = {
            ...this.summary,
            thumbnailIndex: nextIndex,
            showThumbnail: hasNext,
            thumbnailUrlActive: hasNext ? this.summary.thumbnailCandidates[nextIndex] : null
        };
    }

    handleOpenViewer() {
        if (!this.recordId) {
            return;
        }

        this[NavigationMixin.Navigate]({
            type: 'standard__navItemPage',
            attributes: {
                apiName: 'SalesforceContracts_Viewer'
            },
            state: {
                c__contractId: this.recordId
            }
        });
    }

    handleOpenContract() {
        if (!this.recordId) {
            return;
        }

        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: 'Contract',
                actionName: 'view'
            }
        });
    }

    handleOpenFilePreview() {
        if (!this.summary?.contentDocumentId) {
            return;
        }

        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',
            attributes: {
                pageName: 'filePreview'
            },
            state: {
                selectedRecordId: this.summary.contentDocumentId
            }
        });
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

    reduceError(error) {
        if (!error) return 'Unknown error.';
        if (Array.isArray(error.body)) {
            return error.body.map((entry) => entry.message).join(', ');
        }
        if (typeof error.body?.message === 'string') {
            return error.body.message;
        }
        if (typeof error.message === 'string') {
            return error.message;
        }
        return 'Unable to load contract documents snapshot.';
    }
}
