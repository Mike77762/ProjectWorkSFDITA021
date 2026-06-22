import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import TAX_CODE_FIELD from '@salesforce/schema/Account.Tax_Code__c';
import EXPIRATION_FIELD from '@salesforce/schema/Account.ID_Expiration_Date__c';

const FIELDS = [TAX_CODE_FIELD, EXPIRATION_FIELD];

export default class AccountKycViewer extends LightningElement {
    @api recordId;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    account;

    get taxCode() {
        if (this.account.data) {
            return getFieldValue(this.account.data, TAX_CODE_FIELD);
        }
        return 'Caricamento in corso...';
    }

    get expirationDate() {
        if (this.account.data) {
            return getFieldValue(this.account.data, EXPIRATION_FIELD);
        }
        return '-- / -- / ----';
    }
}