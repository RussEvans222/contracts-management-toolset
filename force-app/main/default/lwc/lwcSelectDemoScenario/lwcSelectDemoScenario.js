import { LightningElement,api,track } from 'lwc';
import { OmniscriptBaseMixin } from "omnistudio/omniscriptBaseMixin";

const columns = [
    { label: 'Type', fieldName: 'Type' },
    { label: 'Scenario Name', fieldName: 'ScenarioName' },
];

export default class lwcdatatable extends OmniscriptBaseMixin(LightningElement) {
    @track columns = columns;
    _jsonDef;
    _headerJson;
    _omniJsonData;
    _showResults=false;
    _zeroRecord=false;
    _scenarioList; // Needs to match the OS parameter
    
    @api
    set omniJsonDef(json) {
        if(json) {
            this._jsonDef = json;
        }
    }

    get omniJsonDef() {
        return this._jsonDef;
    }

    @api 
    set omniScriptHeaderDef(headerJson) {
        if(headerJson) {
            this._headerJson = headerJson;
        }
    }

    get omniScriptHeaderDef() {
        return this._headerJson;
    }

    @api
    set omniJsonData(omniData) {
        if(omniData) {
            this._omniJsonData = omniData;
        }
    }

    get omniJsonData() {
        return this._omniJsonData;
    }

    // Needs to match the OS parameter
    @api
    set scenarioList(myscenarios) {
        console.log('### this._scenarioList:  ' + myscenarios + ';');
        if(myscenarios) {
            this._scenarioList = myscenarios;

            if (myscenarios.length == 0) {
                console.log('Found zero record');
                this._zeroRecord=true;
                this._showResults=false;
            }
            else
            {
                this._zeroRecord=false;
                this._showResults=true;
            }
        }
    }
    
    // Needs to match the OS parameter
    get scenarioList() {
        console.log('$$$ this._scenarioList:  ' + this._scenarioList + ';');
        return this._scenarioList;
    }

    getSelectedName(event) {
        const selectedRows = event.detail.selectedRows;
        // this will update the OS's data json with the last selected row. If you want this selectable items to allow user to select more than one row and write all the selected rows in the data json, then update this
        for (let i = 0; i < selectedRows.length; i++){
            //Doesn't work with standard runtime
            //this.omniUpdateDataJson(selectedRows[i]);
            let myData = {"SelectScenario":selectedRows[i]};
            this.omniApplyCallResp(myData);
        }
    }
}