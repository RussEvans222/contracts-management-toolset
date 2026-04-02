import { LightningElement,api  } from 'lwc';
import { icons } from 'c/data';
import retrieveRelatedIndividualId from '@salesforce/apex/xdo_dc_Timeline_Activity_Controller.retrieveRelatedIndividualId';
import {nanoId} from 'c/xdoToolCommonJs'
import XdoToolTrackingEventHandlerBase from 'c/xdoToolTrackingEventHandlerBase';

export default class ActivityModalNew extends XdoToolTrackingEventHandlerBase {

    @api isActivityModalNewOpen = false;
    @api relatedToId;
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
    handleSubmit(event){ //needed for icon combobox selection
        event.preventDefault();       
        this.traceAddEvent(event);
        const fields = event.detail.fields;
        fields.icon__c = this.iconValue;
        const recordEditForm = this.template.querySelector('lightning-record-edit-form');

        if(recordEditForm){
            recordEditForm.submit(fields);
        }
        this.iconValue='standard:default';
    }

     traceAddEvent(event){

        const dataset = {
            domEvent: event.type,
            version: this.VERSION,
            type: 'reporting',
            event: 'conversion',
            action: 'Added the Activity Timeline Record.',
            minutesSaved: 1,
            value: ''
        };

        this.trackEvent(dataset);
     }

     formatCreatedDatae(daysAgo, timeStr){

        var date = new Date();
        date.setTime(date.getTime() - daysAgo * 86400000);

        const [time, meridiem] = timeStr.trim().split(' ');

        // Extract hours and minutes from the time string
        const [hours, minutes] = time.split(':').map(Number);

        // Convert 12-hour format to 24-hour format
        let hours24 = hours;
        if (meridiem === 'PM' && hours < 12) {
            hours24 += 12;
        } else if (meridiem === 'AM' && hours === 12) {
            hours24 = 0;
        }

        // Set the time to the current date
        date.setHours(hours24, minutes);
     

        return date;
     }
}