trigger QuestionTrigger on Question__c (after insert,after update,after delete) {
	if (Trigger.isAfter && Trigger.isInsert){
		QuestionTriggerHelper.onAfterInsert(Trigger.new);
	} else if(Trigger.isAfter && Trigger.isUpdate){
		QuestionTriggerHelper.onAfterUpdate(Trigger.oldMap,Trigger.new);
	} else if(Trigger.isAfter && Trigger.isDelete){
		QuestionTriggerHelper.onAfterDelete(Trigger.oldMap);
	}
}