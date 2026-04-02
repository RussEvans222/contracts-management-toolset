import { LightningElement, wire, track } from 'lwc';
import getInstalledFixes from '@salesforce/apex/ngo_InstalledFixesController.getInstalledFixes';

const ACTIONS = [
    { label: 'More Information', name: 'more_info', iconName: 'utility:info' }
];

const COLUMNS = [
    { label: 'Bug Name', fieldName: 'Bug_Name__c', type: 'text' },
    { label: 'Status', fieldName: 'Status__c', type: 'text' },
    { 
        label: 'Finish Time', 
        fieldName: 'Finish_Time__c', 
        type: 'date',
        typeAttributes: {
            year: 'numeric', month: 'short', day: '2-digit', hour: '2-digit', minute: '2-digit'
        }
    },
    { type: 'action', typeAttributes: { rowActions: ACTIONS } }
];

export default class Ngo_InstalledFixes extends LightningElement {
    @track columns = COLUMNS;
    @track records;
    @track error;
    @track isModalOpen = false;
    @track selectedVideoUrl;
    @track selectedDescription;

    @wire(getInstalledFixes)
    wiredFixes({ error, data }) {
        if (data) {
            this.records = data;
            this.error = undefined;
        } else if (error) {
            this.error = error.body ? error.body.message : 'Error fetching installed fixes';
            this.records = undefined;
        }
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;

        if (actionName === 'more_info') {
            this.selectedDescription = row.Bug_Description__c;
            const rawUrl = row.Video_URL__c;
            
            // Replicating the Vidyard parsing logic from ngo_bugListView
            if (rawUrl) {
                if (rawUrl.includes('vidyard')) {
                    const videoId = rawUrl.split('/').pop();
                    this.selectedVideoUrl = `https://play.vidyard.com/${videoId}.html`;
                } else {
                    // Fallback if standard URL
                    this.selectedVideoUrl = rawUrl;
                }
            } else {
                this.selectedVideoUrl = null;
            }
            this.isModalOpen = true;
        }
    }

    closeModal() {
        this.isModalOpen = false;
        this.selectedVideoUrl = undefined;
        this.selectedDescription = undefined;
    }
}