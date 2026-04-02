import { LightningElement } from 'lwc';
import { loadScript } from "lightning/platformResourceLoader";
import { OmniscriptBaseMixin } from 'omnistudio/omniscriptBaseMixin';
import MAMMOTH_JS from "@salesforce/resourceUrl/gpsMammothJS";

export default class gpsMammothExtract extends OmniscriptBaseMixin(LightningElement) {

    base64file;
    
    connectedCallback() {
        loadScript(this, MAMMOTH_JS)
        .catch(e => console.error('Mammoth not loaded: ', e));
      }

    handleFilesChange(event) {
        //Get the base64 version of the file to create a Content Version
        const file = event.target.files[0];

        var reader = new FileReader()
        reader.onload = () => {
            var base64 = reader.result.split(',')[1]
            this.omniUpdateDataJson({"base64":base64});
        }
        reader.readAsDataURL(file);
        
        this.convert(event.detail.files[0]);
    }

    convert(blob) {
    //Use the Mammoth Library to get the HTML content of the Resume
        const reader = new FileReader();

        reader.onload = () => {
            window.mammoth.convertToHtml({ arrayBuffer : reader.result })
            .then((result) => {
                this.omniUpdateDataJson({"htmlcontent":result.value});
             
            })
            .catch(e =>{
                console.error(e);
            });
        }
        reader.readAsArrayBuffer(blob);

        
    }
}