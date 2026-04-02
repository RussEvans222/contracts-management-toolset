import { LightningElement, wire, track } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getExternalBugs from '@salesforce/apex/ngo_ExternalBugController.getExternalBugs';
import startLwcDeployment from '@salesforce/apex/ngo_BrixDeployerMultiple.startLwcDeployment';
import getDeploymentStatus from '@salesforce/apex/ngo_ExternalBugController.getDeploymentStatus';
import checkStatus from '@salesforce/apex/ngo_BrixDeployerMultiple.checkStatus';

const ACTIONS = [
    { label: 'More Information', name: 'more_info', iconName: 'utility:info' }
];

const COLUMNS = [
    { label: 'Bug Name', fieldName: 'Name__c', type: 'text' },
    { label: 'Bug ID', fieldName: 'Bug_Id__c', type: 'text' },
    { label: 'Installation Status', fieldName: 'installationStatus', type: 'text' },
    { label: 'Started At', fieldName: 'startTime', type: 'date', 
        typeAttributes: {
            year: 'numeric', month: 'short', day: '2-digit', hour: '2-digit', minute: '2-digit'
        } 
    },
    { 
        type: 'action',
        typeAttributes: { rowActions: ACTIONS } 
    }
];

export default class Ngo_bugListView extends LightningElement {
    @track columns = COLUMNS;
    @track bugs = [];
    @track error;
    
    // Bug Details Modal
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
    selectedBugIds = [];
    delayTimeout;
    wiredBugResult;
    wiredStatusResult;
    
    activeQueueId;

    @wire(getDeploymentStatus)
    wiredStatus(result) {
        this.wiredStatusResult = result;
        if (result.data) {
            this.activeQueueId = result.data.queueId;
        }
    }

    @wire(getExternalBugs, { searchKey: '$searchKey' })
    wiredBugs(result) {
        this.wiredBugResult = result;
        const { error, data } = result;
        if (data) {
            this.bugs = data.map(wrapper => {
                return {
                    ...wrapper.record,
                    installationStatus: wrapper.installationStatus,
                    startTime: wrapper.startTime
                };
            });
            this.error = undefined;
        } else if (error) {
            this.error = error.body ? error.body.message : 'Unknown error';
            this.bugs = undefined;
        }
    }

    get isDeployDisabled() {
        return this.wiredStatusResult?.data?.isDeploymentInProgress === true;
    }

    get isNoneSelected() {
        return this.selectedBugIds.length === 0;
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
        const selectedRows = event.detail.selectedRows;
        this.selectedBugIds = selectedRows.map(row => row.Bug_Id__c);
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
        const rawUrl = row.videoURL__c;
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

    // --- Status Check Logic ---

    async handleCheckStatus() {
        if (!this.activeQueueId) {
            this.showToast('Error', 'No Queue ID found in settings.', 'error');
            return;
        }

        this.showSpinner = true;
        try {
            const resultJson = await checkStatus({ queueId: this.activeQueueId });
            const rootResult = JSON.parse(resultJson);

            // --- MODIFIED SECTION: Handle 'data' wrapper ---
            // The API response is wrapped in { "data": { ... } }
            // We check if rootResult.data exists, otherwise use rootResult directly
            const actualResult = rootResult.data ? rootResult.data : rootResult;

            this.showLastExecutionStatus = true;
            this.parseStatusResult(actualResult);

        } catch (error) {
            this.showToast('Error', error.body ? error.body.message : 'Error checking status', 'error');
        } finally {
            this.showSpinner = false;
        }
    }

    parseStatusResult(data) {
        // Handle Stack Trace
        let stackTraceData = [];
        if (data.aggregateResults && data.aggregateResults.length > 0) {
            stackTraceData = data.aggregateResults;
        } else if (data.detailedResults && data.detailedResults.length > 0) {
            stackTraceData = data.detailedResults;
        } else {
            stackTraceData = [JSON.stringify(data, null, 2)];
        }

        this.stackTrace = Array.isArray(stackTraceData) ? stackTraceData.join('<br/>') : stackTraceData;

        // Determine Status Visuals
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
            await startLwcDeployment({ bugIds: this.selectedBugIds });
            
            this.showToast('Success', `Deployment initiated for ${this.selectedBugIds.length} bugs.`, 'success');

            this.selectedBugIds = [];
            const dt = this.template.querySelector('lightning-datatable');
            if (dt) {
                dt.selectedRows = [];
            }
            
            await refreshApex(this.wiredBugResult);
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