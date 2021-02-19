public with sharing class AccountTriggerHelper {
	public static void onAfterInsert(List<Account> newAccounts) {
		populateAccountOnOpportunity(null, newAccounts);
	}

	public static void onBeforeUpdate(Map<Id,Account> oldAccountsMap , List<Account> newAccounts) {
		populateAccountOnOpportunity(oldAccountsMap, newAccounts);
	}

	public static void populateAccountOnOpportunity(Map<Id,Account> oldAccountsMap , List<Account> newAccounts){
		Boolean isInsert = oldAccountsMap == null;
		Set<String> accCustomerIds = new Set<String>();
		Set<String> accIds = new Set<String>();
		List<Account> accsToUpdate = new List<Account>();
		
		for(Account acc : newAccounts){
			if(acc.Customer_Id__c != null){
				if(isInsert){
					accCustomerIds.add(acc.Customer_Id__c);
					accIds.add(acc.Id);
					accsToUpdate.add(acc);
				} else if(oldAccountsMap.get(acc.Id).Customer_Id__c != acc.Customer_Id__c){
					accCustomerIds.add(acc.Customer_Id__c);
					accsToUpdate.add(acc);
					accIds.add(acc.Id);
				}
			}
		}

		if(accCustomerIds.isEmpty()){
			return;
		}

		Map <String, List<Opportunity>> oppToCustomerIdMap = getOppsByCustomerId(accCustomerIds, accIds);

		if(oppToCustomerIdMap.isEmpty()){
			return;
		}

		List<Opportunity> oppsToUpdate = new List<Opportunity>();
		for(Account acc : newAccounts){
			if(oppToCustomerIdMap.containsKey(acc.Customer_Id__c)){
				for(Opportunity oppFromMap : oppToCustomerIdMap.get(acc.Customer_Id__c)){
					if(acc.Id != oppFromMap.AccountId){
						Opportunity opp = new Opportunity(
							Id = oppFromMap.Id,
							AccountId = acc.Id
						);
						oppsToUpdate.add(opp);
					}
				}
				oppToCustomerIdMap.remove(acc.Customer_Id__c);
			}
		}

		if(!oppToCustomerIdMap.isEmpty()){
			for(String custId : oppToCustomerIdMap.keyset()){
				for(Opportunity emptyOpp : oppToCustomerIdMap.get(custId)){
					Opportunity opp = new Opportunity(
						Id = emptyOpp.Id,
						AccountId = null
					);
					oppsToUpdate.add(opp);
				}
			}
		}

		if(!oppsToUpdate.isEmpty()){
			Database.update(oppsToUpdate);
		}
	}

	private static Map<String, List<Opportunity>> getOppsByCustomerId(Set<String> accsToUpdate, Set<String> accIds){
		List<Opportunity> oppsFromCustomerOrAccountId = [
			SELECT Customer_Id__c, AccountId FROM Opportunity
			WHERE Customer_Id__c IN :accsToUpdate
			OR AccountId IN :accIds
		];

		Map <String, List<Opportunity>> oppToCustomerIdMap = new Map<String, List<Opportunity>>();
		for(Opportunity opp : oppsFromCustomerOrAccountId){
			if(!oppToCustomerIdMap.containsKey(opp.Customer_Id__c)){
				List<Opportunity> opps = new List<Opportunity>();
				opps.add(opp);
				oppToCustomerIdMap.put(opp.Customer_Id__c, opps);
			} else{
				oppToCustomerIdMap.get(opp.Customer_Id__c).add(opp);
			}
		}
		return oppToCustomerIdMap;
	}
}
