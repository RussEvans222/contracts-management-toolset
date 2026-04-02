import { LightningElement, wire } from 'lwc';
import getIDOCreationDate from '@salesforce/apex/ngo_ReleaseNotesController.getIDOCreationDate';
import getReleaseCycle from '@salesforce/apex/ngo_ReleaseNotesController.getReleaseCycle';

export default class Ngo_UpdateInstructions extends LightningElement {
    creationDate;
    releaseCycle;

    @wire(getIDOCreationDate)
    wiredDate({ error, data }) {
        if (data) {
            this.creationDate = data;
        } else if (error) {
            console.error('Error fetching creation date', error);
        }
    }

    @wire(getReleaseCycle)
    wiredReleaseCycle({ error, data }) {
        if (data) {
            this.releaseCycle = data;
        } else if (error) {
            console.error('Error fetching release cycle', error);
        }
    }
}