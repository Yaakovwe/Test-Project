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
			if(opp.Customer_Id__c != null){
				if(isInsert){
					oppCustomerIds.add(opp.Customer_Id__c);
					opportunitiesToUpdate.add(opp);
				} else if(oldOpportunitiesMap.get(opp.Id).Customer_Id__c != opp.Customer_Id__c){
					oppCustomerIds.add(opp.Customer_Id__c);
					opportunitiesToUpdate.add(opp);
				}
			}
		}

		if(oppCustomerIds.isEmpty()){
			return;
		}

		Map<String, Id> accountToCustomerMap = getAccountsByCustomerId(oppCustomerIds);

		for(Opportunity newOpp : opportunitiesToUpdate){
			if(accountToCustomerMap == null && newOpp.Customer_Id__c != null){
				newOpp.AccountId = null;
			}
			else if(accountToCustomerMap.containsKey(newOpp.Customer_Id__c)){
				newOpp.AccountId = accountToCustomerMap.get(newOpp.Customer_Id__c);
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
			accountToCustomerIdMap.put(acc.Customer_Id__c,acc.Id);
		}
		return !accountToCustomerIdMap.isEmpty() ? accountToCustomerIdMap : null;
	}
}
