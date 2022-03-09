import { LightningElement, api } from "lwc";

export default class QuestionsDataTable extends LightningElement {
  @api questions = [];
  connectedCallback() {
    console.log(JSON.stringify(this.questions));
  }
}
