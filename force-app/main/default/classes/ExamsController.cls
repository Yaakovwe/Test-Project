public with sharing class ExamsController {
	@AuraEnabled(cacheable = true)
	public static List<Exam__c> getExamsAndQuestions(String recordId) {
		System.debug(recordId);
		List<Exam__c> exams = [
			SELECT Name,Datetime_of_Exam__c,Contact__c,Total_Score__c,
			(SELECT Name,Score__c FROM Questions__r)
			FROM Exam__c
			WHERE Contact__c = :recordId
		];
		return exams;
	}
}
