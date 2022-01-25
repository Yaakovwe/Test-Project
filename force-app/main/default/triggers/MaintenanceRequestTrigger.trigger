trigger MaintenanceRequestTrigger on Case (before insert,before update) {
    if (Trigger.isBefore && Trigger.isInsert){
		MaintenanceRequestTriggerHelper.onBeforeInsert(Trigger.new);
	} else if(Trigger.isBefore && Trigger.isUpdate){
		MaintenanceRequestTriggerHelper.onBeforeUpdate(Trigger.oldMap,Trigger.new);
	}
}