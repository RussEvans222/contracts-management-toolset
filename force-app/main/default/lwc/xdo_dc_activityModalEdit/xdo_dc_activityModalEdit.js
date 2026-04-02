import { LightningElement,api  } from 'lwc';
import { icons } from 'c/data';
import {nanoId} from 'c/xdoToolCommonJs'
import XdoToolTrackingEventHandlerBase from 'c/xdoToolTrackingEventHandlerBase';


export default class ActivityModalEdit extends XdoToolTrackingEventHandlerBase {
    @api isActivityModalEditOpen = false;
    @api activityId;
    
    iconValue='standard:default';

    COMPONENT_NAME = 'activityTimeline';
    HANDLER_REGISTRATION_DELAY = 100;
    VERSION = 'v1';
    NANOID = nanoId();
    hasRendered = false;

    connectedCallback(){
        this.componentName = this.COMPONENT_NAME;
        super.connectedCallback();
    }

    renderedCallback() {
        
        if (!this.hasRendered) {
            window.setTimeout(this.registerTrackingHandlers.bind(this), this.HANDLER_REGISTRATION_DELAY);
            this.hasRendered = true;
        }
    }

    get icons() {
        return icons;
    }
    handleClose() {
        this.dispatchEvent(new CustomEvent('close'));
    }
    handleIconChange(event) {
        this.iconValue = event.detail.value;
    }
    handleOnLoad(event) {
        var record = event.detail.records;
        var fields = record[this.activityId].fields; 
        this.iconValue = fields.icon__c.value;      
    }

    handleSubmit(event){ //needed for icon combobox selection
        event.preventDefault();     
        this.traceAddEvent(event);  
        const fields = event.detail.fields;
        fields.icon__c = this.iconValue;
        const recordEditForm = this.template.querySelector('lightning-record-edit-form');
        if(recordEditForm){
            recordEditForm.submit(fields);
        }
     }

     traceAddEvent(event){

        const dataset = {
            domEvent: event.type,
            version: this.VERSION,
            type: 'reporting',
            event: 'conversion',
            action: 'Edited the Activity Timeline Record.',
            minutesSaved: 1,
            value: ''
        };

        this.trackEvent(dataset);
     }
}