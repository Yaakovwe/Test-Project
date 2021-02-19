import { LightningElement } from "lwc";
import getOpps from "@salesforce/apex/OpportunitiesHelper.getOpps";

const columns = [
  { label: "Customer Id", fieldName: "Customer_Id__c", editable: true },
  {
    label: "Opportunity Name",
    fieldName: "name",
    editable: true
  },
  {
    label: "Opportunity Amount",
    fieldName: "Amount",
    editable: true
  },
  {
    label: "Opportunity Owner",
    fieldName: "OwnerId",
    editable: true
  }
];

export default class opportunitiesDataTable extends LightningElement {
  data = [];
  columns = columns;
  rowOffset = 0;

  // eslint-disable-next-line @lwc/lwc/no-async-await
  async connectedCallback() {
    this.data = await getOpps({ accountId: "0014L0000077HsxQAE" });
  }
}
