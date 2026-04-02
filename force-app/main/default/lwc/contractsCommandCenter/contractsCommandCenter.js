import { LightningElement, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';
import getSnapshot from '@salesforce/apex/SDO_ContractsCommandCenterController.getSnapshot';

export default class ContractsCommandCenter extends NavigationMixin(LightningElement) {
    snapshot = {
        totalContracts: 0,
        draftCount: 0,
        inApprovalCount: 0,
        activatedCount: 0,
        signedCount: 0,
        awaitingSignatureCount: 0,
        expiring30Count: 0,
        stageMetrics: [],
        expiringContracts: [],
        attentionContracts: []
    };

    errorMessage;
    wiredSnapshotResult;

    @wire(getSnapshot)
    wiredSnapshot(value) {
        this.wiredSnapshotResult = value;
        const { data, error } = value;

        if (data) {
            const colorByStatus = {
                Draft: '#6f5b34',
                'In Approval Process': '#5b4a78',
                Negotiating: '#5a6f82',
                'Awaiting Signature': '#78623a',
                Activated: '#2f6a4d',
                Signed: '#375a80',
                Other: '#5e6f84'
            };

            const stageMetrics = (data.stageMetrics || []).map((metric) => {
                const color = colorByStatus[metric.status] || '#64748b';
                return {
                    ...metric,
                    color,
                    colorStyle: `background:${color};`
                };
            });

            this.snapshot = {
                ...data,
                stageMetrics,
                expiringContracts: data.expiringContracts || [],
                attentionContracts: (data.attentionContracts || []).map((entry) => ({
                    ...entry,
                    reasonClass: this.getReasonClass(entry.attentionReason)
                }))
            };
            this.errorMessage = undefined;
        } else if (error) {
            this.errorMessage = this.reduceError(error);
        }
    }

    get metricTiles() {
        return [
            {
                key: 'total',
                label: 'Total Contracts',
                value: this.snapshot.totalContracts || 0,
                className: 'metric-card metric-total'
            },
            {
                key: 'draft',
                label: 'Draft',
                value: this.snapshot.draftCount || 0,
                className: 'metric-card metric-draft'
            },
            {
                key: 'approval',
                label: 'In Approval',
                value: this.snapshot.inApprovalCount || 0,
                className: 'metric-card metric-approval'
            },
            {
                key: 'activated',
                label: 'Activated',
                value: this.snapshot.activatedCount || 0,
                className: 'metric-card metric-activated'
            },
            {
                key: 'signed',
                label: 'Signed',
                value: this.snapshot.signedCount || 0,
                className: 'metric-card metric-signed'
            }
        ];
    }

    get hasStageMetrics() {
        return (this.snapshot.stageMetrics || []).length > 0;
    }

    get donutSegments() {
        const metrics = this.snapshot.stageMetrics || [];
        if (!metrics.length) {
            return [];
        }

        const total = Number(this.snapshot.totalContracts || 0);
        const radius = 42;
        const circumference = 2 * Math.PI * radius;
        let runningFraction = 0;

        return metrics.map((metric) => {
            const count = Number(metric.count || 0);
            const percentage = total > 0 ? count / total : Number(metric.percentage || 0) / 100;
            const fraction = Math.max(0, Math.min(1, percentage));
            const dashLength = fraction * circumference;
            const dashGap = Math.max(0, circumference - dashLength);
            const dashOffset = -runningFraction * circumference;
            runningFraction += fraction;

            return {
                ...metric,
                segmentStyle: `stroke:${metric.color};stroke-dasharray:${dashLength} ${dashGap};stroke-dashoffset:${dashOffset};`
            };
        });
    }

    get hasExpiringContracts() {
        return (this.snapshot.expiringContracts || []).length > 0;
    }

    get hasAttentionContracts() {
        return (this.snapshot.attentionContracts || []).length > 0;
    }

    handleAction(event) {
        const action = event.currentTarget.dataset.action;

        switch (action) {
            case 'newContract':
                this.navigateToObject('Contract', 'new');
                break;
            case 'allContracts':
                this.navigateToList('Contract', 'AllContracts');
                break;
            case 'inApproval':
                this.navigateToList('Contract', 'AllInApprovalContracts');
                break;
            case 'activated':
                this.navigateToList('Contract', 'AllActivatedContracts');
                break;
            case 'serviceContracts':
                this.navigateToList('ServiceContract', 'All_ServiceContracts');
                break;
            case 'refresh':
                if (this.wiredSnapshotResult) {
                    refreshApex(this.wiredSnapshotResult);
                }
                break;
            case 'openContract': {
                const contractId = event.currentTarget.dataset.contractId;
                if (contractId) {
                    this.navigateToRecord(contractId, 'Contract');
                }
                break;
            }
            default:
                break;
        }
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

    getReasonClass(reason) {
        if (reason === 'New Request') return 'reason reason-new';
        if (reason === 'Expiring Soon' || reason === 'Expired') return 'reason reason-risk';
        if (reason === 'Needs Signature') return 'reason reason-signature';
        if (reason === 'Pending Approval') return 'reason reason-approval';
        if (reason === 'In Negotiation') return 'reason reason-negotiation';
        return 'reason';
    }

    navigateToObject(objectApiName, actionName) {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName,
                actionName
            }
        });
    }

    navigateToList(objectApiName, filterName) {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName,
                actionName: 'list'
            },
            state: {
                filterName
            }
        });
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

        return 'Unable to load Contracts Command Center data.';
    }
}
