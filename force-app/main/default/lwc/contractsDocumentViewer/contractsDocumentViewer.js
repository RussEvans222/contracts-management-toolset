import { LightningElement, wire } from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';
import getRecentContractDocuments from '@salesforce/apex/SDO_ContractViewerController.getRecentContractDocuments';
import getContractVersionTimeline from '@salesforce/apex/SDO_ContractViewerController.getContractVersionTimeline';

const STATUS_ORDER = [
    'Activated',
    'Signed',
    'Contract Terminated',
    'Awaiting Signature',
    'Draft',
    'In Approval Process',
    'Negotiating',
    'Rejected',
    'Canceled',
    'Contract Expired',
    'Unknown'
];

export default class ContractsDocumentViewer extends NavigationMixin(LightningElement) {
    tiles = [];
    errorMessage;
    wiredTilesResult;
    contextContractId;

    thumbnailCacheKey = Date.now();
    fetchAll = false;
    selectedStatus = 'All';
    latestTileLimit = 16;

    showVersionsModal = false;
    versionsLoading = false;
    versionRows = [];
    versionsError;
    selectedContractId;
    selectedContractLabel;

    showCompareModal = false;
    compareLeftId;
    compareRightId;

    @wire(CurrentPageReference)
    handlePageReference(pageRef) {
        const nextContractId = this.extractContractIdFromPageRef(pageRef);
        if (nextContractId === this.contextContractId) {
            return;
        }
        this.contextContractId = nextContractId;
        if (this.contextContractId) {
            this.fetchAll = true;
            this.selectedStatus = 'All';
        }
        this.thumbnailCacheKey = Date.now();
    }

    @wire(getRecentContractDocuments, {
        maxTiles: '$requestedMaxTiles',
        statusFilter: '$selectedStatus',
        fetchAll: '$fetchAll',
        contractId: '$contextContractId'
    })
    wiredTiles(value) {
        this.wiredTilesResult = value;
        const { data, error } = value;

        if (data) {
            this.tiles = data.map((tile) => {
                const thumbnailCandidates = this.getThumbnailCandidates(tile.latestVersionId);
                const contractNumber = tile.contractNumber ? `#${tile.contractNumber}` : '';
                const displayTitle = tile.isSigned
                    ? `Signed Contract ${contractNumber}`.trim()
                    : `Contract ${contractNumber}`.trim();

                return {
                    ...tile,
                    displayTitle: displayTitle || 'Contract Document',
                    contractLabel: tile.contractNumber
                        ? `Contract #${tile.contractNumber}`
                        : tile.contractName || 'Contract',
                    showThumbnail: tile.isPreviewable && thumbnailCandidates.length > 0,
                    isStacked: Number(tile.versionCount || 0) > 1,
                    thumbClass: Number(tile.versionCount || 0) > 1 ? 'thumb-wrap thumb-wrap-stacked' : 'thumb-wrap',
                    statusClass: tile.isSigned ? 'status status-signed' : 'status',
                    statusLabel: this.getStatusDisplayLabel(tile.contractStatus || 'Unknown'),
                    signedRibbonClass: tile.isSigned ? 'signed-ribbon' : 'signed-ribbon hidden',
                    thumbnailCandidates,
                    thumbnailIndex: 0,
                    thumbnailUrlActive:
                        tile.isPreviewable && thumbnailCandidates.length > 0 ? thumbnailCandidates[0] : null
                };
            });
            this.errorMessage = undefined;
        } else if (error) {
            this.errorMessage = this.reduceError(error);
        }
    }

    get requestedMaxTiles() {
        if (this.contextContractId) {
            return 200;
        }
        return this.fetchAll ? 2000 : this.latestTileLimit;
    }

    get isContractScoped() {
        return !!this.contextContractId;
    }

    get showGlobalControls() {
        return !this.isContractScoped;
    }

    get hasTiles() {
        return this.tiles.length > 0;
    }

    get hasVersionRows() {
        return this.versionRows.length > 0;
    }

    get canCompareVersions() {
        return this.versionRows.length > 1;
    }

    get compareModalTitle() {
        return this.selectedContractLabel
            ? `Compare Versions • ${this.selectedContractLabel}`
            : 'Compare Versions';
    }

    get compareVersionOptions() {
        return this.versionRows.map((row) => ({
            label: `${row.versionLabel} • ${row.versionStatus}`,
            value: row.versionRecordId
        }));
    }

    get compareLeftRow() {
        return this.versionRows.find((row) => row.versionRecordId === this.compareLeftId) || null;
    }

    get compareRightRow() {
        return this.versionRows.find((row) => row.versionRecordId === this.compareRightId) || null;
    }

    get compareSelectionError() {
        if (!this.compareLeftId || !this.compareRightId) {
            return 'Select two versions to compare.';
        }
        if (this.compareLeftId === this.compareRightId) {
            return 'Pick two different versions to compare.';
        }
        return null;
    }

    get canRenderCompareResults() {
        return !!this.compareLeftRow && !!this.compareRightRow && !this.compareSelectionError;
    }

    get tileCountLabel() {
        if (this.isContractScoped) {
            return `${this.tiles.length} shown • This Contract`;
        }
        const scopeLabel = this.fetchAll ? 'All Contracts' : `Latest ${this.latestTileLimit}`;
        const filterLabel =
            this.selectedStatus === 'All' ? '' : ` • ${this.getStatusDisplayLabel(this.selectedStatus)}`;
        return `${this.tiles.length} shown • ${scopeLabel}${filterLabel}`;
    }

    get subtitleText() {
        if (this.isContractScoped) {
            return 'Showing generated files for this contract. Open Versions to compare changes over time.';
        }
        return this.fetchAll
            ? 'All contracts with generated files. Sorted by newest document first.'
            : 'Latest contracts with generated files. Sorted by newest document first.';
    }

    get latestModeVariant() {
        return this.fetchAll ? 'neutral' : 'brand';
    }

    get allModeVariant() {
        return this.fetchAll ? 'brand' : 'neutral';
    }

    get versionsModalTitle() {
        return this.selectedContractLabel
            ? `Version History • ${this.selectedContractLabel}`
            : 'Version History';
    }

    get versionEmptyMessage() {
        return 'No contract document versions were found for this contract yet.';
    }

    get statusPills() {
        const counts = {};
        this.tiles.forEach((tile) => {
            const status = tile.contractStatus || 'Unknown';
            counts[status] = (counts[status] || 0) + 1;
        });

        const orderedStatuses = [];
        STATUS_ORDER.forEach((status) => {
            if (counts[status]) {
                orderedStatuses.push(status);
            }
        });

        Object.keys(counts)
            .filter((status) => !orderedStatuses.includes(status))
            .sort((a, b) => a.localeCompare(b))
            .forEach((status) => orderedStatuses.push(status));

        const pills = [
            {
                value: 'All',
                label: 'All',
                count: this.tiles.length,
                className: this.selectedStatus === 'All' ? 'status-pill status-pill-active' : 'status-pill'
            }
        ];

        orderedStatuses.forEach((status) => {
            pills.push({
                value: status,
                label: this.getStatusDisplayLabel(status),
                count: counts[status],
                className: this.selectedStatus === status ? 'status-pill status-pill-active' : 'status-pill'
            });
        });

        return pills;
    }

    get emptyMessage() {
        if (this.selectedStatus !== 'All') {
            return `No ${this.getStatusDisplayLabel(this.selectedStatus)} contracts with generated files were found.`;
        }
        return 'No generated contract files were found on Contract records.';
    }

    getStatusDisplayLabel(status) {
        if (status === 'Awaiting Signature') {
            return 'Waiting Signature';
        }
        if (status === 'In Approval Process') {
            return 'In Approval';
        }
        if (status === 'Contract Terminated') {
            return 'Terminated';
        }
        return status;
    }

    handleModeChange(event) {
        if (this.isContractScoped) {
            return;
        }
        const mode = event.currentTarget.dataset.mode;
        this.fetchAll = mode === 'all';
        this.thumbnailCacheKey = Date.now();
    }

    handleStatusChange(event) {
        if (this.isContractScoped) {
            return;
        }
        const status = event.currentTarget.dataset.status;
        this.selectedStatus = status || 'All';
        this.thumbnailCacheKey = Date.now();
    }

    handleOpenContract(event) {
        const contractId = event.currentTarget.dataset.contractId;
        if (!contractId) return;
        this.navigateToRecord(contractId, 'Contract');
    }

    handleOpenContractFromVersion(event) {
        const contractId = event.currentTarget.dataset.contractId || this.selectedContractId;
        if (!contractId) {
            return;
        }
        this.navigateToRecord(contractId, 'Contract');
    }

    async handleViewVersions(event) {
        const contractId = event.currentTarget.dataset.contractId;
        const contractLabel = event.currentTarget.dataset.contractLabel || 'Contract';
        if (!contractId) {
            return;
        }

        this.selectedContractId = contractId;
        this.selectedContractLabel = contractLabel;
        this.showVersionsModal = true;
        this.showCompareModal = false;
        this.thumbnailCacheKey = Date.now();
        await this.loadVersionTimeline();
    }

    async loadVersionTimeline() {
        if (!this.selectedContractId) {
            return;
        }

        this.versionsLoading = true;
        this.versionsError = undefined;
        const previousLeft = this.compareLeftId;
        const previousRight = this.compareRightId;

        try {
            const rows = await getContractVersionTimeline({ contractId: this.selectedContractId });
            this.versionRows = (rows || []).map((row) => {
                const files = (row.files || []).map((file, index) => ({
                    ...file,
                    fileKey: `${row.versionRecordId}-${file.contentDocumentId}-${index}`,
                    fileLabel: `${file.fileType || 'File'} ${index + 1}`
                }));

                const primaryContentDocumentId =
                    row.primaryContentDocumentId || (files.length > 0 ? files[0].contentDocumentId : null);

                return {
                    ...row,
                    files,
                    rowKey: row.versionRecordId,
                    versionLabel: row.versionNumber ? `Version ${row.versionNumber}` : row.versionName,
                    badgeClass: row.isActive ? 'version-badge version-badge-active' : 'version-badge',
                    processLabel: row.creationProcessType || 'Manual',
                    showPrimaryThumbnail: row.hasPreviewableFile && !!row.primaryThumbnailUrl,
                    primaryThumbnailUrlActive: this.appendCacheBust(row.primaryThumbnailUrl),
                    hasFiles: files.length > 0,
                    filePills: files.slice(0, 6),
                    fileOverflowCount: Math.max(0, files.length - 6),
                    primaryContentDocumentId
                };
            });
            this.initializeCompareSelection(previousLeft, previousRight);
        } catch (error) {
            this.versionRows = [];
            this.versionsError = this.reduceError(error);
            this.compareLeftId = null;
            this.compareRightId = null;
        } finally {
            this.versionsLoading = false;
        }
    }

    initializeCompareSelection(previousLeft, previousRight) {
        if (!this.canCompareVersions) {
            this.compareLeftId = this.versionRows.length > 0 ? this.versionRows[0].versionRecordId : null;
            this.compareRightId = this.compareLeftId;
            return;
        }

        const ids = this.versionRows.map((row) => row.versionRecordId);
        const fallbackLeft = ids[0];
        const fallbackRight = ids[1] || ids[0];

        this.compareLeftId = ids.includes(previousLeft) ? previousLeft : fallbackLeft;
        this.compareRightId =
            ids.includes(previousRight) && previousRight !== this.compareLeftId
                ? previousRight
                : ids.find((id) => id !== this.compareLeftId) || fallbackRight;
    }

    handleOpenCompareModal() {
        if (!this.canCompareVersions) {
            return;
        }
        this.showCompareModal = true;
    }

    handleCloseCompareModal() {
        this.showCompareModal = false;
    }

    handleCompareLeftChange(event) {
        this.compareLeftId = event.detail.value;
    }

    handleCompareRightChange(event) {
        this.compareRightId = event.detail.value;
    }

    handleSwapCompare() {
        const previousLeft = this.compareLeftId;
        this.compareLeftId = this.compareRightId;
        this.compareRightId = previousLeft;
    }

    handleCloseVersions() {
        this.showVersionsModal = false;
        this.showCompareModal = false;
    }

    async handleRefresh() {
        this.thumbnailCacheKey = Date.now();
        if (this.wiredTilesResult) {
            await refreshApex(this.wiredTilesResult);
        }
        if (this.showVersionsModal) {
            await this.loadVersionTimeline();
        }
    }

    handleImageError(event) {
        const docId = event.currentTarget.dataset.docId;
        if (!docId) return;

        this.tiles = this.tiles.map((tile) => {
            if (tile.contentDocumentId !== docId) {
                return tile;
            }

            const nextIndex = (tile.thumbnailIndex || 0) + 1;
            const hasNext = nextIndex < (tile.thumbnailCandidates || []).length;
            return {
                ...tile,
                thumbnailIndex: nextIndex,
                showThumbnail: hasNext,
                thumbnailUrlActive: hasNext ? tile.thumbnailCandidates[nextIndex] : null
            };
        });
    }

    handleVersionImageError(event) {
        const versionId = event.currentTarget.dataset.versionId;
        if (!versionId) {
            return;
        }

        this.versionRows = this.versionRows.map((row) => {
            if (row.versionRecordId !== versionId) {
                return row;
            }
            return {
                ...row,
                showPrimaryThumbnail: false,
                primaryThumbnailUrlActive: null
            };
        });
    }

    handlePreviewFile(event) {
        const contentDocumentId = event.currentTarget.dataset.docId;
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

    navigateToRecord(recordId, objectApiName) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId,
                objectApiName,
                actionName: 'view'
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

    appendCacheBust(url) {
        if (!url) {
            return null;
        }
        return `${url}&cb=${this.thumbnailCacheKey}`;
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
        return 'Unable to load contract document viewer.';
    }

    extractContractIdFromPageRef(pageRef) {
        const candidate = pageRef?.state?.c__contractId || pageRef?.state?.contractId;
        return this.isSalesforceId(candidate) ? candidate : null;
    }

    isSalesforceId(value) {
        return typeof value === 'string' && /^[a-zA-Z0-9]{15,18}$/.test(value);
    }
}
