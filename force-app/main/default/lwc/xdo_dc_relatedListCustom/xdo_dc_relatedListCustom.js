import {LightningElement, api, track, wire} from 'lwc';
import {nanoId} from 'c/xdoToolCommonJs';
import XdoToolTrackingEventHandlerBase from 'c/xdoToolTrackingEventHandlerBase';
import HEADER_IMG from "@salesforce/resourceUrl/listHeader";
import getListHeaders from "@salesforce/apex/XDO_MDC_customRelatedListCtrl.getListHeaders";
import getListRecords from "@salesforce/apex/XDO_MDC_customRelatedListCtrl.getListRecords";
import deleteRecordHandler from "@salesforce/apex/XDO_MDC_customRelatedListCtrl.deleteRecordHandler";
import insertRecordData from "@salesforce/apex/XDO_MDC_customRelatedListCtrl.saveRecordData";
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {createRecord} from 'lightning/uiRecordApi';
import {deleteRecord} from 'lightning/uiRecordApi';
import LIST_COLUMN_HEADERS from '@salesforce/schema/xDO_MDC_customListHeaders__c';
import LIST_NAME from '@salesforce/schema/xDO_MDC_customListHeaders__c.List_Name__c';
import COLUMN1_HEADER from '@salesforce/schema/xDO_MDC_customListHeaders__c.Column_1_Header__c';
import COLUMN2_HEADER from '@salesforce/schema/xDO_MDC_customListHeaders__c.Column_2_Header__c';
import COLUMN3_HEADER from '@salesforce/schema/xDO_MDC_customListHeaders__c.Column_3_Header__c';
import COLUMN4_HEADER from '@salesforce/schema/xDO_MDC_customListHeaders__c.Column_4_Header__c';
import RELATED_RECORD_ID from '@salesforce/schema/xDO_MDC_customListHeaders__c.Related_Record_Id__c';
import TITLE_ICON from '@salesforce/schema/xDO_MDC_customListHeaders__c.Title_Icon__c';
import ICON_BG from '@salesforce/schema/xDO_MDC_customListHeaders__c.Icon_Background_Color__c';
import LIST_TITLE from '@salesforce/schema/xDO_MDC_customListHeaders__c.List_Title__c';
import LIST_SUBHEADER from '@salesforce/schema/xDO_MDC_customListHeaders__c.List_Subheader__c';
import LIST_RECORD_VALUES from '@salesforce/schema/xDO_MDC_customListRecord__c';
import COLUMN1_VALUE from '@salesforce/schema/xDO_MDC_customListRecord__c.Column_1_Value__c';
import COLUMN2_VALUE from '@salesforce/schema/xDO_MDC_customListRecord__c.Column_2_Value__c';
import COLUMN3_VALUE from '@salesforce/schema/xDO_MDC_customListRecord__c.Column_3_Value__c';
import COLUMN4_VALUE from '@salesforce/schema/xDO_MDC_customListRecord__c.Column_4_Value__c';
import REC_LIST_NAME from '@salesforce/schema/xDO_MDC_customListRecord__c.List_Name__c';
import REC_RELATED_RECORD_ID from '@salesforce/schema/xDO_MDC_customListRecord__c.Related_Record_Id__c';
import getLstRecords from "@salesforce/apex/XDO_MDC_customRelatedListCtrl.getLstRecords";
import {updateRecord} from "lightning/uiRecordApi";
import {icons} from 'c/iconData';

const actions = [
	{label: 'Edit', name: 'edit'},
	{label: 'Delete', name: 'delete'},
];

const cols = [
	{fieldName: 'column1Title', editable: true},
	{fieldName: 'column2Title', editable: true},
	{fieldName: 'column3Title', editable: true},
	{fieldName: 'column4Title', editable: true},
];

export default class Xdo_dc_relatedListCustom extends XdoToolTrackingEventHandlerBase {
    COMPONENT_NAME = 'xdodcRelatedListCustom';
	HANDLER_REGISTRATION_DELAY = 100;
	VERSION = 'v1';
	NANOID = nanoId();
	headerImg = HEADER_IMG;
	listTitle;
	iconBgColor;
	iconValue = 'custom:custom19';
	dataType1 = 'Text';
	dataType2 = 'Text';
	dataType3 = 'Text';
	dataType4 = 'Text';
	icon;
	columnHeaderData = [];
	tableData = [];
	column1Header;
	column2Header;
	column3Header;
	column4Header;
	relatedRecord;
	column1IsLink;
	column2IsLink;
	column3IsLink;
	column4IsLink;
	recordCount;
	draftValues = [];
	saveDraftValues;
	newListRec1;
	newListRec2;
	newListRec3;
	newListRec4;
	@api ObjectApiName;
	@api column1Override;
	@api column2Override;
	@api column3Override;
	@api column4Override;
	@api myListName;
	@api tableHeight;
	subHeader;
	listName;
	listId;
	listRecordId;
	newListRecId;
	currRecId;
	visible = true;
	listName;
	@api recordId;
	@track isShowModal = false;
	@track newListModal = false;
	@track hasRecords = false;
	@track hasList = false;
	@track editList = false;
	@track editRec = false;
	@track newListRecord = false;
	@track iconColor;
	@track iconUrl;
	recordDataWrp;
	@track blankRow = [];
	@track disabledCheckbox = true;
	@track index = 0;
	@track selectedList;
	startTime = Math.round(Date.now()) - 48;
	endTime;
	lastUpdated = Math.round(Date.now() - this.startTime);
	columns = [];
	data = [];
	dataTypes = [
		{label: 'Text', value: 'Text'},
		{label: 'Link', value: 'Link'},
	]
	recordObject = LIST_RECORD_VALUES;
	myFields = [COLUMN1_VALUE, COLUMN2_VALUE, COLUMN3_VALUE, COLUMN4_VALUE];

	get icons() {
		return icons;
	}

	get setTableHeight() {
		return 'overflow: scroll; height: ' + this.tableHeight + 'px;';
		console.log('overflow: scroll; height: ' + this.tableHeight + 'px;');
	}

	@wire(getListHeaders, {recordId: '$recordId'})
	retrievedLstHeaders({error, data}) {
		if (data) {
			console.log('record Id:', this.recordId);
			console.log('all headers:', data);
			for (let i = 0; i < data.length; i++) {
				if (data[i].List_Name__c == this.myListName) {
					this.hasRecords = true;
					console.log('data[i]: ', i, data[i]);
					console.log('columns before create: ', this.columns);
					this.createColumnHeaders(data[i]);
					console.log('here is the list Id: ', this.listId);
					console.log('columnData: ', this.columnHeaderData);
				}
			}
			for (let i = 0; i < this.columnHeaderData.length; i++) {
				if (this.columnHeaderData[i].type == 'Link') {
					this.columnHeaderData[i].type = 'phone';
				}
			}
			this.columns = this.columnHeaderData;
			console.log('columns data after columns is set: ', this.columns);

		} else if (error) {
			console.log('error: ', error);
		}
		if (this.data.length > 0) {
			console.log('we have more than 0 columns');
			this.hasList = true;
		}
		if (this.columns.length > 0) {
			console.log('we have more than 0 columns');
			this.hasList = true;
		}
		return this.columns;
	}

	@wire(getListRecords, {recordId: '$recordId'})
	retrievedListRecords({error, data}) {
		if (data) {
			console.log('all records:', data);
			for (let i = 0; i < data.length; i++) {
				if (data[i].List_Name__c == this.myListName) {
					this.tableData.push(
						{
							id: data[i].Id,
							column1Title: data[i].Column_1_Value__c,
							column2Title: data[i].Column_2_Value__c,
							column3Title: data[i].Column_3_Value__c,
							column4Title: data[i].Column_4_Value__c
						},
					)
				}
				this.listRecordId = data[i].Id;
			}
			console.log('data after create: ', this.tableData);
			this.data = this.tableData;
			this.recordCount = this.data.length;
		} else if (error) {
			console.log('error: ', error);
		}
		// this.endTime = Date.now();
		// this.lastUpdated = Math.round(((this.endTime - this.startTime)/1000)/60) + ' minutes'
		// console.log('Ayo Execution time: ', this.lastUpdated);
	}


	createColumnHeaders(data) {
		if (data.Column_4_Header__c) {
			this.columnHeaderData.push(
				{label: data.Column_1_Header__c, fieldName: 'column1Title', type: data.Column1_Data_Type__c},
				{label: data.Column_2_Header__c, fieldName: 'column2Title', type: data.Column2_Data_Type__c},
				{label: data.Column_3_Header__c, fieldName: 'column3Title', type: data.Column3_Data_Type__c},
				{label: data.Column_4_Header__c, fieldName: 'column4Title', type: data.Column4_Data_Type__c},
			);
		} else {
			if (data.Column_3_Header__c) {
				this.columnHeaderData.push(
					{label: data.Column_1_Header__c, fieldName: 'column1Title', type: data.Column1_Data_Type__c},
					{label: data.Column_2_Header__c, fieldName: 'column2Title', type: data.Column2_Data_Type__c},
					{label: data.Column_3_Header__c, fieldName: 'column3Title', type: data.Column3_Data_Type__c},
				);
			} else {
				if (data.Column_2_Header__c) {
					this.columnHeaderData.push(
						{label: data.Column_1_Header__c, fieldName: 'column1Title', type: data.Column1_Data_Type__c},
						{label: data.Column_2_Header__c, fieldName: 'column2Title', type: data.Column2_Data_Type__c},
					);
				} else {
					if (data.Column_1_Header__c) {
						this.columnHeaderData.push(
							{label: data.Column_1_Header__c, fieldName: 'column1Title', type: data.Column1_Data_Type__c}
						);
					} else {
						this.columnHeaderData = [];
					}
				}
			}
		}
		this.columnHeaderData.push({type: 'action', typeAttributes: {rowActions: actions}})
		this.listId = data.Id;
		this.subHeader = data.List_Subheader__c;
		this.listTitle = data.List_Title__c;
		this.icon = data.List_Icon__c;
		this.iconBgColor = data.Icon_Background_Color__c;
		// this.iconUrl = ICONS + "/" + this.icon + "_60.png";
		this.iconColor = "slds-media__figure my-icon cicon-" + this.iconBgColor;
		this.column1Header = data.Column_1_Header__c;
		this.column2Header = data.Column_2_Header__c;
		this.column3Header = data.Column_3_Header__c;
		this.column4Header = data.Column_4_Header__c;
		this.dataType1 = data.Column1_Data_Type__c;
		this.dataType2 = data.Column2_Data_Type__c;
		this.dataType3 = data.Column3_Data_Type__c;
		this.dataType4 = data.Column4_Data_Type__c;
		console.log('column headers at the end of createColumnHeaders: ', this.columnHeaderData);
	}

	connectedCallback() {
		this.componentName = this.COMPONENT_NAME;
		super.connectedCallback();
	}

	renderedCallback() {
		if (!this.hasRendered) {
			window.setTimeout(this.registerTrackingHandlers.bind(this), this.HANDLER_REGISTRATION_DELAY);
			this.hasRendered = true;
		}
	}

	handleSubmitList(event) {
		event.preventDefault();
		const fields = event.detail.fields;
		// const text = this.iconValue;
		// fields.Title_Icon__c = text.split(':')[1];
		fields.List_Icon__c = this.iconValue;
		fields.Column1_Data_Type__c = this.dataType1;
		fields.Column2_Data_Type__c = this.dataType2;
		fields.Column3_Data_Type__c = this.dataType3;
		fields.Column4_Data_Type__c = this.dataType4;
		fields.List_Name__c = this.myListName;
		fields.Related_Record_Id__c = this.recordId;
		console.log('list icon: ', fields.List_Icon__c);
		const recordEditForm = this.template.querySelector('lightning-record-edit-form');
		console.log('recordEditForm: ', recordEditForm);
		recordEditForm.submit(fields);
		console.log('fields: ', fields);
		this.iconValue = 'custom:custom19';
		this.hideModalBox();

		const dataset = {
		    domEvent: "click",
		    version: this.VERSION,
		    action: 'Created New Custom Related List',
		    minutesSaved: 10,
		    source: 'QBrix-1-xDO-DataCloudMockComponents-Base'
		};

		this.trackEvent(dataset);

		window.location.reload();
		this.startTime = Date.now();
	}

	showModalBox(event) {
		this.isShowModal = true;
		// const dataset = {
		//     domEvent: event.type,
		//     version: this.VERSION,
		//     event: 'conversion',
		//     action: 'Created New Custom Related List',
		//     minutesSaved: 10,
		//     once: true,
		//     source: 'QBrix-1-xDO-DataCloudMockComponents-Base',
		//     value: this.currentState
		// };
		//
		// this.trackEvent(dataset);
	}

	hideModalBox() {
		this.isShowModal = false;
	}

	showNewListModal() {
		this.newListModal = true;
	}

	hideNewListModal() {
		this.newListModal = false;
	}

	showEditListModal() {
		this.editList = true;
	}

	hideEditListModal() {
		this.editList = false;
	}

	showEditRecModal() {
		this.editRec = true;
	}

	hideEditRecModal() {
		this.editRec = false;
	}

	showNewRecordModal() {
		this.newListRecord = true;
		if (this.data) {
			this.recordDataWrp = this.data;
			console.log('data has been stored in recordDataWrap: ', this.recordDataWrp);
		} else {
			this.blankRow = [];
			this.index = 0;
			this.recordDataWrp = [];
		}
	}

	hideNewRecordModal() {
		this.newListRecord = false;
	}

	saveEditList() {
		this.editList = false;
		window.location.reload();
	}

	saveEditRec() {
		this.editRec = false;
		window.location.reload();
	}

	handleRecChange1(event) {
		this.newListRec1 = event.detail.value;
	}

	handleRecChange2(event) {
		this.newListRec2 = event.detail.value;
	}

	handleRecChange3(event) {
		this.newListRec3 = event.detail.value;
	}

	handleRecChange4(event) {
		this.newListRec4 = event.detail.value;
	}

	handleIconChange(event) {
		this.iconValue = event.detail.value;
	}

	handleDT1Change(event) {
		this.dataType1 = event.detail.value;
	}

	handleDT2Change(event) {
		this.dataType2 = event.detail.value;
	}

	handleDT3Change(event) {
		this.dataType3 = event.detail.value;
	}

	handleDT4Change(event) {
		this.dataType4 = event.detail.value;
	}

	recordSaveSuccess(event) {
		this.newListRecord = false;
		// this.handleNewRecReset();
		window.location.reload();
	}

	setCheckBox(event) {
		let blankrow = this.blankRow;
		if (blankrow[event.target.name].isChecked) {
			blankrow[event.target.name].isChecked = false;
		} else {
			blankrow[event.target.name].isChecked = true;
		}
		this.blankRow = blankrow;
	}

	deleteNewRecord(event) {
		const selectedRecord = this.recordDataWrp[event.target.value];
		console.log('selectedRecord: ', selectedRecord.Id, selectedRecord.Related_Record_Id__c);
		window.alert(JSON.stringify(this.recordDataWrp) + ' & ' + event.target.value + ' & ' + JSON.stringify(selectedRecord));
		deleteRecordHandler({recId: selectedRecord.Id, relId: selectedRecord.Related_Record_Id__c}).then(result => {
			this.recordDataWrp = result;
		}).catch(error => {
			window.alert(JSON.stringify(error));
		})
	}

	addRow(event) {
		this.index++;
		let i = this.index;
		let newRecord = new Object();
		let blankRow = this.blankRow;
		newRecord.Id = i;
		newRecord.isChecked = false;
		blankRow.push(newRecord);
		this.blankRow = blankRow;
	}

	removeRow(event) {
		const eventName = event.target.name;
		console.log('event name: ', eventName);
		let blankRow = this.blankRow;
		if (eventName === 'multipleRowRemoval') {
			for (let i = 0; i < blankRow.length; i++) {
				if (blankRow[i].isChecked) {
					blankRow.splice(i, 1);
					i--;
				}
			}
		} else {
			blankRow.splice(event.target.value, 1);
		}
		this.blankRow = blankRow;
	}

	setCol1Value(event) {
		const eventName = event.target.name;
		let blankRow = this.blankRow;
		blankRow[eventName].Column_1_Value__c = event.target.value;
		this.blankRow = blankRow;
	}

	setCol2Value(event) {
		const eventName = event.target.name;
		let blankRow = this.blankRow;
		blankRow[eventName].Column_2_Value__c = event.target.value;
		this.blankRow = blankRow;
	}

	setCol3Value(event) {
		const eventName = event.target.name;
		let blankRow = this.blankRow;
		blankRow[eventName].Column_3_Value__c = event.target.value;
		this.blankRow = blankRow;
	}

	setCol4Value(event) {
		const eventName = event.target.name;
		let blankRow = this.blankRow;
		blankRow[eventName].Column_4_Value__c = event.target.value;
		this.blankRow = blankRow;
	}

	saveData(event) {
		let blankRow = this.blankRow;
		let recordDataList = [];
		for (let i = 0; i < blankRow.length; i++) {
			// if(blankRow[i] !== undefined && blankRow[i].isChecked){
			let recData = new Object();
			recData.Related_Record_Id__c = this.recordId;
			recData.List_Name__c = this.myListName;
			recData.Column_1_Value__c = blankRow[i].Column_1_Value__c;
			recData.Column_2_Value__c = blankRow[i].Column_2_Value__c;
			recData.Column_3_Value__c = blankRow[i].Column_3_Value__c;
			recData.Column_4_Value__c = blankRow[i].Column_4_Value__c;
			recordDataList.push(recData);
			// }
		}
		console.log('recordDataList: ', recordDataList);
		if (recordDataList.length > 0) {
			insertRecordData({recordDataString: JSON.stringify(recordDataList)}).then(result => {
				let newRecordList = this.recordDataWrp;
				for (let i = 0; i < result.length; i++) {
					if (result[i] !== undefined) {
						let rowRecord = {'sobjectType': 'xDO_MDC_customListRecord__c'};
						rowRecord.Id = result[i].Id;
						rowRecord.Related_Record_Id__c = this.recordId;
						rowRecord.List_Name__c = this.myListName;
						rowRecord.Column_1_Value__c = result[i].Column_1_Value__c;
						rowRecord.Column_2_Value__c = result[i].Column_2_Value__c;
						rowRecord.Column_3_Value__c = result[i].Column_3_Value__c;
						rowRecord.Column_4_Value__c = result[i].Column_4_Value__c;
						newRecordList.push(rowRecord);
					}
				}
				this.recordDataWrp = newRecordList;
				this.blankRow = [];
				this.index = newRecordList.length;
			}).catch(error => {
				window.alert('Please contact system admin: ' + JSON.stringify(error));
			})
			this.hideNewRecordModal();
			console.log('recordDataWrp: ', this.recordDataWrp);
			window.location.reload();
		} else {
			window.alert('Please select any row to insert data.');
		}
		// this.endTime = Date.now();
		// this.lastUpdated = Math.round(((this.endTime - this.startTime)/1000)/60);
		this.startTime = Date.now();
	}

	async saveLstRecord(event) {
		event.preventDefault();
		const fields = {};
		fields[COLUMN1_VALUE.fieldApiName] = this.newListRec1;
		fields[COLUMN2_VALUE.fieldApiName] = this.newListRec2;
		fields[COLUMN3_VALUE.fieldApiName] = this.newListRec3;
		fields[COLUMN4_VALUE.fieldApiName] = this.newListRec4;
		fields[REC_LIST_NAME.fieldApiName] = this.myListName;
		fields[REC_RELATED_RECORD_ID.fieldApiName] = this.recordId;
		const recordInput = {apiName: LIST_RECORD_VALUES.objectApiName, fields};
		try {
			const list = await createRecord(recordInput);
			this.dispatchEvent(
				new ShowToastEvent({
					title: 'Success',
					message: 'New List Record Created!',
					variant: 'success'
				})
			);
			this.newListRecord = false;
			window.location.reload();
		} catch (error) {
			this.dispatchEvent(
				new ShowToastEvent({
					title: 'Error creating record',
					message: reduceErrors(error).join(', '),
					variant: 'error'
				})
			);
		}
		console.log('new row records: ', fields.Column_1_Value__c, fields.Column_2_Value__c, fields.Column_3_Value__c, fields.Column_4_Value__c, fields.List_Name__c, fields.Related_Record_Id__c);
	}

	// handleNewRecReset(event) {
	//     const inputFields = this.template.querySelectorAll('.newRecordInput');
	//     if (inputFields) {
	//         inputFields.forEach(field => {
	//             field.reset();
	//         });
	//     }
	// }

	handleInputChange(event) {
		this.listName = event.detail.value;
	}

	async deleteRow(recordId) {
		try {
			await deleteRecord(recordId);
			this.dispatchEvent(
				new ShowToastEvent({
					title: 'Success',
					message: 'Row deleted',
					variant: 'success'
				})
			);
			window.location.reload();
			// await refreshApex(this.wiredAccountsResult);
		} catch (error) {
			this.dispatchEvent(
				new ShowToastEvent({
					title: 'Error deleting record',
					message: reduceErrors(error).join(', '),
					variant: 'error'
				})
			);
		}
		// this.endTime = Date.now();
		// this.lastUpdated = Math.round(((this.endTime - this.startTime)/1000)/60);
		this.startTime = Date.now();
	}

	editRow(recordId) {
		this.currRecId = recordId;
		this.editRec = true;
	}

	handleRowAction(event) {
		const recordId = event.detail.row.id;
		const actionName = event.detail.action.name;
		const row = event.detail.row;
		console.log('row record Id: ', recordId);
		console.log('row action name: ', actionName);
		console.log('row: ', row);

		switch (actionName) {
			case 'delete':
				this.deleteRow(recordId);
				break;
			case 'edit':
				this.editRow(recordId);
				break;
			default:
		}
	}

	async handleSave(event) {
		const records = event.detail.draftValues.slice().map((draftValue) => {
			const fields = Object.assign({}, draftValue);
			return {fields};
		});
		console.log('draft values: ', this.draftValues);
		this.draftValues = [];
		try {
			// Update all records in parallel thanks to the UI API
			const recordUpdatePromises = records.map((record) => updateRecord(record));
			await Promise.all(recordUpdatePromises);

			// Report success with a toast
			this.dispatchEvent(
				new ShowToastEvent({
					title: "Success",
					message: "row updated",
					variant: "success",
				}),
			);

			// Display fresh data in the datatable
			await refreshApex(this.contacts);
		} catch (error) {
			this.dispatchEvent(
				new ShowToastEvent({
					title: "Error updating or reloading row",
					message: error.body.message,
					variant: "error",
				}),
			);
		}
		// this.endTime = Date.now();
		// this.lastUpdated = Math.round(((this.endTime - this.startTime)/1000)/60);
		this.startTime = Date.now();
	}

	async saveListRecord() {
		console.log('New list name: ', this.listName);
		const fields = {};
		fields[LIST_NAME.fieldApiName] = this.listName;
		fields[COLUMN1_HEADER.fieldApiName] = this.column1Override;
		fields[COLUMN2_HEADER.fieldApiName] = this.column2Override;
		fields[COLUMN3_HEADER.fieldApiName] = this.column3Override;
		fields[COLUMN4_HEADER.fieldApiName] = this.column4Override;
		fields[RELATED_RECORD_ID.fieldApiName] = this.recordId;
		fields[TITLE_ICON.fieldApiName] = this.icon;
		fields[ICON_BG.fieldApiName] = this.iconBgColor;
		fields[COLUMN4_HEADER.fieldApiName] = this.column4Override;
		fields[LIST_TITLE.fieldApiName] = this.listTitle;
		fields[LIST_SUBHEADER.fieldApiName] = this.subHeader;
		const recordInput = {apiName: LIST_COLUMN_HEADERS.objectApiName, fields};
		try {
			const list = await createRecord(recordInput);
			this.dispatchEvent(
				new ShowToastEvent({
					title: 'Success',
					message: 'New Custom List Created!',
					variant: 'success'
				})
			);
		} catch (error) {
			this.dispatchEvent(
				new ShowToastEvent({
					title: 'Error creating record',
					message: reduceErrors(error).join(', '),
					variant: 'error'
				})
			);
		}
		this.newListModal = false;
	}

	get inputVariables() {
		return [
			{
				name: 'recordId',
				type: 'String',
				value: this.recordId
			},
			{
				name: 'listName',
				type: 'String',
				value: this.myListName
			}
		];
	}

	handleStatusChange(event) {
		if (event.detail.status === 'FINISHED') {
			const outputVariables = event.detail.outputVariables;
			console.log('here are the output variables: ', outputVariables);
			for (let i = 0; i < outputVariables.length; i++) {
				const outputVar = outputVariables[i];
				if (outputVar.name === "column1IsLink") {
					this.column1IsLink = outputVar.value;
				} else if (outputVar.name === "column2IsLink") {
					this.column2IsLink = outputVar.value;
				} else if (outputVar.name === "column3IsLink") {
					this.column3IsLink = outputVar.value;
				} else if (outputVar.name === "column4IsLink") {
					this.column4IsLink = outputVar.value;
				}
			}
			console.log('here are output variables at end: ', this.column1IsLink, this.column2IsLink, this.column3IsLink, this.column4IsLink);
			this.hideModalBox();
			// window.location.reload();
		}
	}
}