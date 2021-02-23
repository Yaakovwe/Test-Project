trigger AccountTrigger on Account (after insert, before update) {
	if (Trigger.isAfter && Trigger.isInsert){
		AccountTriggerHelper.onAfterInsert(Trigger.new);
	} else if(Trigger.isBefore && Trigger.isUpdate){
		AccountTriggerHelper.onBeforeUpdate((Map<Id,Account>)Trigger.oldMap,
			(List<Account>)Trigger.new);
	}
}