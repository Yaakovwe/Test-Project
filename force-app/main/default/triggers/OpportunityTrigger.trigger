trigger OpportunityTrigger on Opportunity (before insert, before update) {
	if (Trigger.isBefore && Trigger.isInsert){
		OpportunityTriggerHelper.onBeforeInsert(Trigger.new);
	} else if(Trigger.isBefore && Trigger.isUpdate){
		OpportunityTriggerHelper.onBeforeUpdate((Map<Id,Opportunity>)Trigger.oldMap,
			(List<Opportunity>)Trigger.new);
	}
}