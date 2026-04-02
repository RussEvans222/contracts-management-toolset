import { LightningElement, wire, track } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getABC360Records from '@salesforce/apex/ngo_ABC360Controller.getABC360Records';
import deployContent from '@salesforce/apex/ngo_ABC360Controller.deployContent';
import getDeploymentStatus from '@salesforce/apex/ngo_ExternalBugController.getDeploymentStatus';
import checkStatus from '@salesforce/apex/ngo_BrixDeployerMultiple.checkStatus';

const ACTIONS = [
    { label: 'More Information', name: 'more_info', iconName: 'utility:info' }
];

const COLUMNS = [
    { label: 'Name', fieldName: 'Name__c', type: 'text' },
    { label: 'Description', fieldName: 'Description__c', type: 'text', initialWidth: 300, wrapText: true },
    { type: 'action', typeAttributes: { rowActions: ACTIONS } }
];

export default class Ngo_abc360ListView extends LightningElement {
    @track columns = COLUMNS;
    @track records;
    @track error;
    
    // Modal controls
    @track isModalOpen = false;
    @track selectedVideoUrl;
    @track selectedDescription;

    // Status Modal
    @track showLastExecutionStatus = false;
    @track lastExecutionStatusTitle = ''; 
    @track lastExecutionStatusIcon = '';
    @track lastExecutionStatusClass = '';
    @track lastExecutionDescription = '';
    @track stackTrace = '';
    @track showStackTrace = false;
    @track isCopied = false;
    @track showSpinner = false;
    
    searchKey = '';
    selectedRows = [];
    delayTimeout;
    wiredRecordResult;
    wiredStatusResult;
    
    activeQueueId;

    // Reusing the status check from the bug fix controller logic
    @wire(getDeploymentStatus)
    wiredStatus(result) {
        this.wiredStatusResult = result;
        if (result.data) {
            this.activeQueueId = result.data.queueId;
        }
    }

    @wire(getABC360Records, { searchKey: '$searchKey' })
    wiredRecords(result) {
        this.wiredRecordResult = result;
        const { error, data } = result;
        if (data) {
            this.records = data;
            this.error = undefined;
        } else if (error) {
            this.error = error.body ? error.body.message : 'Error fetching ABC360 records';
            this.records = undefined;
        }
    }

    get isDeployDisabled() {
        return this.wiredStatusResult?.data?.isDeploymentInProgress === true;
    }

    get isNoneSelected() {
        return this.selectedRows.length === 0;
    }

    get accordionSectionClass() {
        return this.showStackTrace ? 'slds-accordion__section slds-is-open' : 'slds-accordion__section';
    }

    handleSearchChange(event) {
        window.clearTimeout(this.delayTimeout);
        const searchKey = event.target.value;
        this.delayTimeout = setTimeout(() => {
            this.searchKey = searchKey;
        }, 300);
    }

    handleRowSelection(event) {
        this.selectedRows = event.detail.selectedRows;
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
            if (rawUrl.includes('vidyard')) {
                const videoId = rawUrl.split('/').pop();
                this.selectedVideoUrl = `https://play.vidyard.com/${videoId}.html`;
            } else {
                this.selectedVideoUrl = rawUrl;
            }
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

    // --- Status Check Logic ---

    async handleCheckStatus() {
        if (!this.activeQueueId) {
            this.showToast('Error', 'No Queue ID found in settings.', 'error');
            return;
        }

        this.showSpinner = true;
        
        try {
            // Call the endpoint directly from the browser
            const endpoint = `https://demo-wizard-ps.herokuapp.com/api/checkQBrixStatus/${this.activeQueueId}`;
            
            const response = await fetch(endpoint, {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json'
                }
            });

            if (!response.ok) {
                throw new Error(`HTTP Error: ${response.status}`);
            }

            const data = await response.json();

            // Handle optional 'data' wrapper if present in the direct JSON response
            const actualResult = data.data ? data.data : data;

            this.showLastExecutionStatus = true;
            this.parseStatusResult(actualResult);

        } catch (error) {
            this.showToast('Error', `Direct status check failed: ${error.message}`, 'error');
            console.error('Fetch Error:', error);
        } finally {
            this.showSpinner = false;
        }
    }   

    parseStatusResult(data) {
        let stackTraceData = [];
        if (data.aggregateResults && data.aggregateResults.length > 0) {
            stackTraceData = data.aggregateResults;
        } else if (data.detailedResults && data.detailedResults.length > 0) {
            stackTraceData = data.detailedResults;
        } else {
            stackTraceData = [JSON.stringify(data, null, 2)];
        }

        this.stackTrace = Array.isArray(stackTraceData) ? stackTraceData.join('<br/>') : stackTraceData;

        const status = data.status || 'Unknown';
        const lowerStatus = status.toLowerCase();
        
        this.lastExecutionStatusTitle = status.replace(/([a-z0-9])([A-Z])/g, '$1 $2');

        const errorStatuses = ['error', 'failed', 'errorinitauth', 'canceled', 'cancelled', 'completedwitherrors'];
        const processingStatuses = ['queued', 'processing', 'running', 'notstarted', 'inprogress', 'restart', 'started', 'hold'];
        const successStatuses = ['completed'];

        if (errorStatuses.includes(lowerStatus)) {
            this.lastExecutionStatusIcon = 'utility:error';
            this.lastExecutionStatusClass = 'slds-text-color_error'; 
            this.lastExecutionDescription = "Your task failed.<br/>You can refer to the stack trace below for more details.";
        } else if (processingStatuses.includes(lowerStatus)) {
            this.lastExecutionStatusIcon = 'utility:clock';
            this.lastExecutionStatusClass = 'slds-text-color_default';
            this.lastExecutionDescription = "Your task is running, please check back later.<br/>You can refer to the stack trace below for more details.";
        } else if (successStatuses.includes(lowerStatus)) {
            this.lastExecutionStatusIcon = 'utility:success';
            this.lastExecutionStatusClass = 'slds-text-color_success';
            this.lastExecutionDescription = "Your task ran successfully.<br/>You can refer to the stack trace below for more details.";
        } else {
            this.lastExecutionStatusIcon = 'utility:question';
            this.lastExecutionStatusClass = 'slds-text-color_weak';
            this.lastExecutionDescription = "Please wait for sometime and check status again.<br/>You can refer to the stack trace below for more details.";
        }
    }

    closeStatusModal() {
        this.showLastExecutionStatus = false;
        this.showStackTrace = false;
    }

    toggleStackTrace() {
        this.showStackTrace = !this.showStackTrace;
    }

    onClickCopyToClipboard() {
        const input = document.createElement('textarea');
        input.value = this.stackTrace.replace(/<br\/>/g, '\n');
        document.body.appendChild(input);
        input.select();
        document.execCommand('copy');
        document.body.removeChild(input);

        this.isCopied = true;
        setTimeout(() => {
            this.isCopied = false;
        }, 1000);
    }

    async handleDeploy() {
        try {
            this.showSpinner = true;
            await deployContent({ selectedRecords: this.selectedRows });
            
            this.showToast('Success', `Deployment initiated for ${this.selectedRows.length} items.`, 'success');

            this.selectedRows = [];
            const dt = this.template.querySelector('lightning-datatable');
            if (dt) {
                dt.selectedRows = [];
            }
            
            await refreshApex(this.wiredRecordResult);
            await refreshApex(this.wiredStatusResult);

        } catch (error) {
            this.showToast('Deployment Failed', error.body ? error.body.message : 'Error starting deployment', 'error');
        } finally {
            this.showSpinner = false;
        }
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant
            })
        );
    }
}