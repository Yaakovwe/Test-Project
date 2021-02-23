import { LightningElement, api, wire } from "lwc";
import getOpps from "@salesforce/apex/OpportunitiesHelper.getOpps";

const columns = [
  { label: "Customer Id", fieldName: "Customer_Id__c" },
  {
    label: "Opportunity Name",
    fieldName: "Name"
  },
  {
    label: "Opportunity Amount",
    fieldName: "Amount"
  },
  {
    label: "Opportunity Owner",
    fieldName: "OwnerName"
  }
];

export default class opportunitiesDataTable extends LightningElement {
  @api recordId;
  data = [];
  columns = columns;
  rowOffset = 0;
  saveDraftValues = [];

  @wire(getOpps, {
    accountId: "$recordId"
  })
  wiredOpps({ error, data }) {
    if (error) {
      console.log(error);
    } else if (data) {
      let tempData = [];
      data.forEach((row) => {
        let tempRecord = { ...row };
        tempRecord.OwnerName = row.Owner.Name;
        tempData.push(tempRecord);
      });
      this.data = tempData;
    }
  }
}
