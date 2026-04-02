import {
    LightningElement,
    api,
    wire
} from 'lwc';
import {
    getRecord,
    getFieldValue
} from 'lightning/uiRecordApi';
import getContactData from '@salesforce/apex/XDO_MDC_Portfolio_Metrics.getContactMetrics'

export default class Cx_portfolio_metrics extends LightningElement {

    @api title1;
    @api Subtitle1;
    @api title2;
    @api Subtitle2;
    @api title3;
    @api Subtitle3;
    @api headerTitle;
    @api recordId;
    metric3;

    @wire(getContactData, {
        conId: '$recordId'
    })
    getContactData({
        error,
        data
    }) {
        if (data) {
            console.log(data);
            if(data.hasOwnProperty("xDO_MDC_Cust360_Metric3__c")) {
            this.metric3 = data.xDO_MDC_Cust360_Metric3__c !== null ? '$' + this.formatCash(parseInt(data.xDO_MDC_Cust360_Metric3__c.replace(/[|&;$%@"<>()+,]/g, ""))) : 'NA';
            }
            else{
                this.metric3 = this.Subtitle1;
            }
        }
    }


    formatCash(n) {
        if (n < 1e3) return n;
        if (n >= 1e3 && n < 1e6) return +(n / 1e3).toFixed(1) + "K";
        if (n >= 1e6 && n < 1e9) return +(n / 1e6).toFixed(1) + "M";
        if (n >= 1e9 && n < 1e12) return +(n / 1e9).toFixed(1) + "B";
        if (n >= 1e12) return +(n / 1e12).toFixed(1) + "T";
    }


}