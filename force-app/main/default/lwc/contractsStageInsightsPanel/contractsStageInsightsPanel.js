import { LightningElement, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getStageInsights from '@salesforce/apex/SDO_ContractsCommandCenterController.getStageInsights';

export default class ContractsStageInsightsPanel extends LightningElement {
    insights = {
        contractsAnalyzed: 0,
        completedContracts: 0,
        avgCompletionDays: 0,
        completionBuckets: [],
        avgStageDurations: []
    };

    errorMessage;
    wiredInsightsResult;

    @wire(getStageInsights)
    wiredInsights(value) {
        this.wiredInsightsResult = value;
        const { data, error } = value;

        if (data) {
            this.insights = {
                ...data,
                completionBuckets: this.normalizeBuckets(data.completionBuckets || []),
                avgStageDurations: this.normalizeDurations(data.avgStageDurations || [])
            };
            this.errorMessage = undefined;
        } else if (error) {
            this.errorMessage = this.reduceError(error);
        }
    }

    get hasBuckets() {
        return (this.insights.completionBuckets || []).length > 0;
    }

    get hasDurations() {
        return (this.insights.avgStageDurations || []).length > 0;
    }

    handleRefresh() {
        if (this.wiredInsightsResult) {
            refreshApex(this.wiredInsightsResult);
        }
    }

    normalizeBuckets(rows) {
        return rows.map((row) => ({
            ...row,
            barStyle: `width:${Math.max(2, Number(row.percentage || 0))}%; background:${row.color || '#1e88e5'};`
        }));
    }

    normalizeDurations(rows) {
        const sorted = [...rows].sort((a, b) => Number(b.avgDays || 0) - Number(a.avgDays || 0));
        const maxDays = sorted.reduce((maxVal, row) => Math.max(maxVal, Number(row.avgDays || 0)), 0);

        return sorted.map((row) => {
            const width = maxDays > 0 ? Math.max(4, (Number(row.avgDays || 0) / maxDays) * 100) : 4;
            return {
                ...row,
                barStyle: `width:${width}%; background:${row.color || '#546e7a'};`
            };
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

        return 'Unable to load stage insights.';
    }
}
