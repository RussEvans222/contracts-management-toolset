/*
  This custom LWC renders an address lookup component.  This LWC was built to overcome many of the issues
  encountered when using the standard OmniStudio Places Typeahead that have been encountered.
  
  The lookup will function as normal, it just generates an event as well through
  the pub-sub framework.

  To make this component as dynamic as possible, it will publish an event to the following channel
  
  OS-Step-Channel-<step-element-name>

  where:
  <step-element-name> is the element name of the Step on which this lookup copmonent has been placed.

  This component was created from a similar component created by Joe McMaster and adopted for GPS IDO Use

  @author Jeremy Blankenship
  @version 1.0
    
  History
  =======
  June 24, 2024 - v1.0 - Initial version

  Notes
  =====
  -Other components will need to explicitly subscribe to the OS-Step-Channel-<step-element-name> to receive any event(s).
  -The event's action name will always be "result"
  -When adding this component to an Omniscript the address search and the individual address fields can have a placeholder prepopulated by passing in the prefilladdress property on the Component
  -The default label is Address.  To override this value pass in a value with the label property on the Component
  -If you want to add a prefix to the label Street, City, State, Postal Code and Country fields (ex.  If you want them all to start with Facility) pass a value with the labelprefix property in the component

  Properties that can be passed in (None are required)
  =================================
  label - Label that will be shown at the top of the LWC - Default is Address
  labelprefix - Prefix that will be added to the front of Street, City, State, Postal Code, and Country - Default is null
  prefilladdress - Comma delimited Address field that will be used to add a placeholder to show a prefilled in value - Default is null

  THIS SOFTWARE, IS PROVIDED “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED,
  INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
  AND NONINFRINGEMENT.

*/
import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'omnistudio/omniscriptBaseMixin';
import pubsub from 'omnistudio/pubsub';

export default class GpsOmniscriptAddressLookup extends OmniscriptBaseMixin(LightningElement) {

   @track
   address = "";
   displaylabel = "";
   addresslookup = "";
   displaystreetlabel = "Street";
   displaycitylabel = "City";
   displaycountrylabel = "Country";
   displaystatelabel = "State/Province";
   displaypostalcodelabel = "Postal Code";
   streetplaceholder = "";
   stateplaceholder = "";
   postalcodeplaceholder = "";
   countrycodeplaceholder = "";
  
    @api
    get label() {
        return this.displaylabel;
    }
    set label(val) {
        if (val === null) {
           // console.log("No Label provided to component");
            val = 'Address';   
        }
        this.displaylabel = val;  
    }
    @api
    get prefilladdress(){
        return this.addresslookup;
    }
    set prefilladdress(val) {
        if (val == null) {
           // console.log("No prefill address");
            return;
        }
        
        this.addresslookup = val;
        const addressarray = val.split(",");
        this.streetplaceholder = addressarray[0];
        this.cityplaceholder = addressarray[1];
        this.stateplaceholder = addressarray[2];
        this.postalcodeplaceholder = addressarray[3];
        this.countryplaceholder = addressarray[4];
    }
    @api
    get labelprefix(){
        return;
    }
    set labelprefix(val) {
        if (val === null) {
            val ="";
        }
        else{
            val = val + " ";
        }
        this.displaystreetlabel = val + "Street";
        this.displaycitylabel = val + "City";
        this.displaystatelabel = val + "State/Province";
        this.displaycountrylabel = val + "Country";
        this.displaypostalcodelabel = val + "Postal Code";
    }


   /**
     * Called whenever the address is resolved/changed in the LWC
     * 
     * @param event  The change event
     */
   addressChange(event) {

        try {

            let _address = "";

            if (event.target.validity && event.target.validity.valid) {

                // Update OmniScript Address
                _address = event.target.street + ", " + event.target.city + ", " + event.target.province + ", " + event.target.postalCode + ", " + event.target.country;
                //console.log("Address = " + address);

                // Clear the old value
                let update = {};
                this.omniUpdateDataJson(update);

                // Update the OmniScript Data
                update = {
                    Address: _address,
                    Street: event.target.street,
                    City: event.target.city,
                    Province: event.target.province,
                    PostalCode: event.target.postalCode,
                    Country: event.target.country,
                    valid: event.target.validity.valid
                };
                this.omniUpdateDataJson(update);

                // Generate a channel name based on the Element Name of the Step
                let stepChannel = "OS-Step-Channel-" + super.omniJsonDef.JSONPath.split(":")[0];

                // Publish the event
                console.log(super.omniJsonDef.name + " (" + super.omniJsonDef.type + ") -> Publishing Event to " + stepChannel);
                pubsub.fire(stepChannel, "result", update);
            }
            else {
                
                console.warn("Invalid Address");
                //console.warn(event.target.validity);

                let update = {
                    valid: false
                };
                this.omniUpdateDataJson(update);

                _address = "Invalid Address";
            }

            // Update LWC field
            this.address = _address;

        } catch (err) {
            console.error("Error in addressChange() --> " + err, err);
        }
    }    
}