import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getReleaseNotes from '@salesforce/apex/ngo_ReleaseNotesController.getReleaseNotes';
import getAISummary from '@salesforce/apex/ngo_ReleaseNotesController.getAISummary';
import AGENT_BRINI_LOGO from '@salesforce/contentAssetUrl/agentCarpenterTN';

const ACTIONS = [
    { label: 'More Information', name: 'more_info', iconName: 'utility:info' }
];

const COLUMNS = [
    { label: 'Release Name', fieldName: 'Name__c', type: 'text', sortable: true },
    { label: 'Product Line', fieldName: 'Product_Line__c', type: 'text', sortable: true },
    { label: 'Type', fieldName: 'Type__c', type: 'text', sortable: true },
    { label: 'Release Date', fieldName: 'Release_Date__c', type: 'date', sortable: true,
        typeAttributes: { year: 'numeric', month: 'short', day: '2-digit', timeZone: 'UTC' } 
    },
    { type: 'action', typeAttributes: { rowActions: ACTIONS } }
];

export default class Ngo_ReleaseNotes extends LightningElement {
    agentBriniLogo = AGENT_BRINI_LOGO;
    @track columns = COLUMNS;
    @track records = [];
    @track error;
    @track isModalOpen = false;
    @track isSummaryModalOpen = false;
    @track isSummarizing = false;
    @track aiSummaryResult;
    @track selectedVideoUrl;
    @track selectedDescription;
    @track sortedBy = 'Release_Date__c';
    @track sortedDirection = 'desc';
    
    searchKey = '';
    delayTimeout;

@wire(getReleaseNotes, { searchKey: '$searchKey' })
    wiredReleaseNotes({ error, data }) {
        if (data) {
            // CLONE and SORT the data immediately
            // The server returns default order; we enforce Date DESC here.
            let sortedData = [...data];
            
            sortedData.sort((a, b) => {
                let dateA = new Date(a.Release_Date__c);
                let dateB = new Date(b.Release_Date__c);
                // Descending sort: B - A
                return dateB - dateA;
            });

            this.records = sortedData;
            this.error = undefined;
        } else if (error) {
            this.error = error.body ? error.body.message : 'Error fetching release notes';
            this.records = undefined;
        }
    }

    async handleSummarize() {
        this.isSummarizing = true;
        this.isSummaryModalOpen = true;

        try {
            // CRITICAL: Call must be empty (). 
            // If you pass data here, you are using the old version.
            this.aiSummaryResult = await getAISummary();
        } catch (error) {
            this.aiSummaryResult = 'Error generating summary. Please check your Einstein permissions.';
            console.error('Einstein Error: ', error);
        } finally {
            this.isSummarizing = false;
        }
    }

    closeSummaryModal() {
        this.isSummaryModalOpen = false;
        this.aiSummaryResult = undefined;
    }

    handleSearchChange(event) {
        window.clearTimeout(this.delayTimeout);
        const searchKey = event.target.value;
        this.delayTimeout = setTimeout(() => {
            this.searchKey = searchKey;
        }, 300);
    }

    handleSort(event) {
        const { fieldName: sortedBy, sortDirection: sortedDirection } = event.detail;
        const cloneData = [...this.records];
        cloneData.sort(this.sortBy(sortedBy, sortedDirection === 'asc' ? 1 : -1));
        this.records = cloneData;
        this.sortedBy = sortedBy;
        this.sortedDirection = sortedDirection;
    }

    sortBy(field, reverse) {
        const key = (x) => x[field];
        return (a, b) => {
            a = key(a) ? key(a) : '';
            b = key(b) ? key(b) : '';
            return reverse * ((a > b) - (b > a));
        };
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        if (actionName === 'more_info') {
            this.handleMoreInfo(row);
        }
    }

    handleMoreInfo(row) {
        this.selectedDescription = row.Description__c;
        const rawUrl = row.Video_URL__c;
        if (rawUrl) {
            const videoId = rawUrl.split('/').pop();
            this.selectedVideoUrl = `https://play.vidyard.com/${videoId}.html`;
        } else {
            this.selectedVideoUrl = null;
        }
        this.isModalOpen = true;
    }

    closeModal() {
        this.isModalOpen = false;
        this.selectedVideoUrl = undefined;
        this.selectedDescription = undefined;
    }
}