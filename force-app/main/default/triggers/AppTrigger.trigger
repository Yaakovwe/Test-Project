trigger AppTrigger on App__c (before insert,before update) {
    if (Trigger.isBefore && Trigger.isInsert){
		AppTriggerHelper.onBeforeInsert(Trigger.new);
	} else if(Trigger.isBefore && Trigger.isUpdate){
		AppTriggerHelper.onBeforeUpdate(Trigger.oldMap,Trigger.new);
	}
}