public with sharing class MaintenanceRequestService {
	public static Set<Id> getIdsToCheck(Map<Id,Case> oldCases, List<Case> newCases){
		Boolean isInsert = oldCases == null;
		Set<Id> idsToCheck = new Set<Id>();
		List<String> types = new List<String> {'Repair','Routine Maintenance'};
		for(Case newCase : newCases){
			if(!isInsert){
				Case oldCase = oldCases.get(newCase.Id);
				if(types.contains(oldCase.Type) && oldCase.Status == 'Closed'){
					continue;
				}
			}
			if(types.contains(newCase.Type) && newCase.Status == 'Closed'){
				idsToCheck.add(newCase.Id);
			}
		}
		return idsToCheck;
	}

	public static Map<Id,Case> getClosedCasesAndJunctions(Set<Id> idsToCheck){
		return 	new Map<Id,Case>([
			SELECT Id, Vehicle__c,Subject,
			(SELECT Id,Equipment__c,Quantity__c,Equipment__r.Maintenance_Cycle__c
				FROM Equipment_Maintenance_Items__r
				ORDER BY Equipment__r.Maintenance_Cycle__c ASC
			) 
			FROM Case WHERE Id IN :idsToCheck
		]);
	}

	public static List<Case> createsNewCases(Map<Id,Case> closedCases){
		List<Case> casesToCreate = new List<Case>();
		for(Case cti : closedCases.values()){
			List<Equipment_Maintenance_Item__c> juncs = closedCases.get(cti.Id).Equipment_Maintenance_Items__r;
			Case cta = new Case (
				ParentId = cti.Id,
				Status = 'New',
				Subject = cti.Subject,
				Type = 'Routine Maintenance',
				Vehicle__c = cti.Vehicle__c,
				Date_Reported__c = Date.today()
			);
			Integer daysToAdd = (Integer)juncs[0].Equipment__r.Maintenance_Cycle__c;
			cta.Date_Due__c = Date.today().addDays(daysToAdd);
			casesToCreate.add(cta);
		}

		if(!casesToCreate.isEmpty()){
			Database.insert(casesToCreate);
		}
		return casesToCreate;
	}

	public static void createEquipmentMaintenanceItems(List<Case> casesToCreate, Map<Id,Case> closedCases){
		List<Equipment_Maintenance_Item__c> clonedJunctions = new List<Equipment_Maintenance_Item__c>();
		for (Case ctc : casesToCreate){
			List<Equipment_Maintenance_Item__c> juncs = 
				closedCases.get(ctc.ParentId).Equipment_Maintenance_Items__r;
			for (Equipment_Maintenance_Item__c junc : juncs){
				Equipment_Maintenance_Item__c juncClone = junc.clone();
				juncClone.Maintenance_Request__c = ctc.Id;
				clonedJunctions.add(juncClone);
			}
		}
		Database.insert(clonedJunctions);
	}
}
