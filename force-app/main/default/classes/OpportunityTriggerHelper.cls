public with sharing class OpportunityTriggerHelper {
	public static void onBeforeInsert(List<Opportunity> newOpportunities) {
		populateAccountOnOpportunity(null, newOpportunities);
	}

	public static void onBeforeUpdate(Map<Id,Opportunity> oldOpportunitiesMap , List<Opportunity> newOpportunities) {
		populateAccountOnOpportunity(oldOpportunitiesMap, newOpportunities);
	}

	private static void populateAccountOnOpportunity(Map<Id,Opportunity> oldOpportunitiesMap, List<Opportunity> newOpportunities){
		Boolean isInsert = oldOpportunitiesMap == null;
		Set<String> oppCustomerIds = new Set<String>();
		List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
		for(Opportunity opp : newOpportunities){
			if(isInsert && opp.Customer_Id__c != null){
				System.assertEquals(true, isInsert, isInsert);
				oppCustomerIds.add(opp.Customer_Id__c);
				opportunitiesToUpdate.add(opp);
			} else if(!isInsert && oldOpportunitiesMap.get(opp.Id).Customer_Id__c != opp.Customer_Id__c){
				System.assertEquals(false, isInsert, isInsert);
				if(opp.Customer_Id__c != null){
					oppCustomerIds.add(opp.Customer_Id__c);
				}
				opportunitiesToUpdate.add(opp);
			}
		}

		if(opportunitiesToUpdate.isEmpty()){
			return;
		}

		Map<String, Id> accountToCustomerMap = getAccountsByCustomerId(oppCustomerIds);

		for(Opportunity newOpp : opportunitiesToUpdate){
			if(accountToCustomerMap.containsKey(newOpp.Customer_Id__c)){
				newOpp.AccountId = accountToCustomerMap.get(newOpp.Customer_Id__c);
			} else{
				newOpp.AccountId = null; //To be reviewed. Maybe we don't want to nullify these lookups
			}
		}
	}

	private static Map<String, Id> getAccountsByCustomerId(Set<String> oppCustomerIds){
		List<Account> accountsFromCustomerId = [
			SELECT Customer_Id__c FROM Account
			WHERE Customer_Id__c IN :oppCustomerIds
		];

		Map <String,Id> accountToCustomerIdMap = new Map<String,Id>();
		for(Account acc : accountsFromCustomerId){
			accountToCustomerIdMap.put(acc.Customer_Id__c, acc.Id); // Assuming there can't be more then one Account with the same customer Id
		}
		return accountToCustomerIdMap;
	}
}
