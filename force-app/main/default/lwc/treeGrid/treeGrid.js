import { LightningElement, track, api } from "lwc";
import getExamsAndQuestions from "@salesforce/apex/ExamsController.getExamsAndQuestions";
export default class TreeGrid extends LightningElement {
  @api recordId;
  @track exams = [];
  async connectedCallback() {
    console.log(this.recordId);
    this.exams = await getExamsAndQuestions({ recordId: this.recordId });
    if (this.exams?.length) {
      const exams = [];
      this.exams.forEach((exam) => {
        const examRecord = { ...exam };
        examRecord.open = false;
        exams.push(examRecord);
      });
      this.exams = exams;
    }
    console.log(JSON.stringify(this.exams));
  }

  chevronClick(event) {
    console.log(JSON.stringify(event));
    const open = event.detail.eventChange;
    const recordId = event.detail.recordId;
    this.exams.forEach((exam) => {
      if (exam.Id === recordId) {
        exam.open = open;
      }
    });
  }
}
