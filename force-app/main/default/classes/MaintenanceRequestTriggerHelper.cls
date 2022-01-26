public with sharing class MaintenanceRequestTriggerHelper {
	public static void onBeforeInsert(List<Case> newCases){
		createNewMaintenanceRequest(null,newCases);
	}

	public static void onBeforeUpdate(Map<Id,Case> oldCases, List<Case> newCases){
		createNewMaintenanceRequest(oldCases,newCases);
	}

	private static void createNewMaintenanceRequest(Map<Id,Case> oldCases, List<Case> newCases){
		Set<Id> idsToCheck = MaintenanceRequestService.getIdsToCheck(oldCases, newCases);
		if(!idsToCheck.isEmpty()){
			Map<Id,Case> closedCases = MaintenanceRequestService.getClosedCasesAndJunctions(idsToCheck);
			List<Case> casesToCreate = MaintenanceRequestService.createsNewCases(closedCases);
			MaintenanceRequestService.createEquipmentMaintenanceItems(casesToCreate,closedCases);
		}
	}
}
