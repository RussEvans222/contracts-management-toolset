import {
    LightningElement,
    wire,
    api
} from 'lwc';
import {
    getRecord,
    getFieldValue
} from 'lightning/uiRecordApi';
import getContactData from '@salesforce/apex/XDO_MDC_Portfolio_Metrics.getContactPropensityMetric'

export default class XDO_MDC_Calculated_Insights extends LightningElement {
    @api headerTitle;
    @api title;
    @api metric;
    @api recordId;

    @wire(getContactData, {
        conId: '$recordId'
    })
    getContactData({
        error,
        data
    }) {
        if (data) {
           
            console.log(data);
            if(data.hasOwnProperty("xDO_MDC_Propensity_to_Churn__c")) {
            this.metric = data.xDO_MDC_Propensity_to_Churn__c ;
            }
        }
    }

}