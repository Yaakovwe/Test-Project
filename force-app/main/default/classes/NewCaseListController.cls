public with sharing class NewCaseListController {
	public List<Case> getNewCases() {
		return new List<Case>([
			SELECT Id,CaseNumber 
			FROM Case
			WHERE Status = 'New'
		]);
	}
}
