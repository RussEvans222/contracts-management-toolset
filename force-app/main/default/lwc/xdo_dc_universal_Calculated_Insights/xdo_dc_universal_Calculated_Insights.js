import {
    LightningElement,
    wire,
    api
} from 'lwc';

export default class Xdo_dc_universal_Calculated_Insights extends LightningElement {

    @api headerTitle;
    @api titleIcon;
    @api title;
    @api metric;
    @api recordId;
}