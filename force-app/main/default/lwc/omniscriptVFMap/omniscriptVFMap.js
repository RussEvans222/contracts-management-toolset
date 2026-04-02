import { LightningElement, track } from 'lwc';
import { OmniscriptBaseMixin } from "omnistudio/omniscriptBaseMixin";
export default class OmniscriptVFMap extends OmniscriptBaseMixin(LightningElement) {

    receivedMessage = '';
    @track Address = '';
    @track DomainName = '';
    @track URLAddress = '';

    /*****Called on LOAD of LWC  *****/
    connectedCallback() {
        // Binding EventListener here when Data received from VF
        //console.log("Next is omniJsonDef");
        //console.log(JSON.stringify(this.omniJsonDef));

        //console.log("Next is omniJsonData");
        //console.log(JSON.stringify(this.omniJsonData));
        
        this.Address = this.omniJsonData.Address;
        console.log("Address is "+ this.Address);
        this.DomainName = this.omniJsonData.DomainName;

        console.log("DomainName is " + this.DomainName);

        //this.URLAddress = "https://esri-lpi-2021-demo--c.visualforce.com/apex/ESRIMap?Address=" + this.omniJsonData.Address;
       //this.URLAddress = "https://" + this.DomainName + "--c.visualforce.com/apex/ESRIMap?Address=" + this.omniJsonData.Address;
       // Added to simplify ESRI iFrame
       this.URLAddress = "/LPI/apex/ESRIMap?Address=" + this.omniJsonData.Address;
        
        
        window.addEventListener("message", this.handleVFResponse.bind(this));
    }

    handleVFResponse(message) {
        
            console.log("Message Received");
            //this.receivedMessage = message.data;
            this.omniNextStep();

            let myData = {"Coords":message.data};

            this.omniApplyCallResp(myData);
        
    }
}