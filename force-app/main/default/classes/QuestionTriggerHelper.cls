public with sharing class QuestionTriggerHelper {
	public static void onAfterInsert(List<Question__c> questions) {
		calcScoreOnExam(null,questions);
	}

	public static void onAfterUpdate(Map<Id,Question__c> oldQuestions, List<Question__c> newQuestions) {
		calcScoreOnExam(oldQuestions,newQuestions);
	}

	public static void onAfterDelete(Map<Id,Question__c> oldQuestions) {
		calcScoreOnExam(null,oldQuestions.values());
	}

	private static void calcScoreOnExam(Map<Id,Question__c> oldQuestions, List<Question__c> newQuestions){
		Map<Id,Question__c> newQuestionsMap = new Map<Id,Question__c>();
		Set<Id> examsIds = getExamIdsToProcess(oldQuestions,newQuestions,newQuestionsMap);
		if(examsIds.isEmpty()){
			return;
		}

		Map<Id,Question__c> questionsFromDB = new Map<Id,Question__c>([
			SELECT Exam__c,Score__c
			FROM Question__c
			WHERE Exam__c IN :examsIds
		]);
		
		Map<Id,Exam__c> examsToUpdate = new Map<Id,Exam__c>();
		for (Question__c ques : questionsFromDB.values()) {
			Boolean inTrigger = newQuestionsMap.get(ques.Id) != null;
			Decimal scoreToAdd = inTrigger ? newQuestionsMap.get(ques.Id).Score__c :
				ques.Score__c;
			Decimal valueOrZero = scoreToAdd != null ? scoreToAdd : 0;
			Exam__c exam = new Exam__c(Id = ques.Exam__c);
			if(examsToUpdate.containsKey(ques.Exam__c)){
				exam.Total_Score__c = examsToUpdate.get(ques.Exam__c).Total_Score__c + valueOrZero;
			} else {
				exam.Total_Score__c = valueOrZero;
			}
			if(ques.Exam__c != null){
				examsToUpdate.put(ques.Exam__c,exam);
			}	
		}
		Database.update(examsToUpdate.values());
	}

	private static Set<Id> getExamIdsToProcess(Map<Id,Question__c> oldQuestions, List<Question__c> newQuestions,
		Map<Id,Question__c> newQuestionsMap){
		Boolean isInsert = oldQuestions == null;
		Set<Id> examsIds = new Set<Id>();
		for (Question__c question : newQuestions) {
			if (!isInsert) {
				Boolean scoreChanged = oldQuestions.get(question.Id).Score__c != question.Score__c;
				Boolean examChanged = oldQuestions.get(question.Id).Exam__c != question.Exam__c;
				if(!scoreChanged && !examChanged){
					continue;
				}
				if(question.Exam__c == null || examChanged){
					examsIds.add(oldQuestions.get(question.Id).Exam__c);
				}
			}
			examsIds.add(question.Exam__c);
			newQuestionsMap.put(question.Id,question);
		}
		return examsIds;
	}
}
