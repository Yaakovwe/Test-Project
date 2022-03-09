import { LightningElement, api } from "lwc";
export default class ChevronButton extends LightningElement {
  @api recordId;
  open = false;
  openRow() {
    this.open = !this.open;
    const eventChange = this.open;
    const selectedEvent = new CustomEvent("clicked", {
      detail: { eventChange: eventChange, recordId: this.recordId }
    });
    this.dispatchEvent(selectedEvent);
  }
}
