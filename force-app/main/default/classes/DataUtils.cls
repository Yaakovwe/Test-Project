public class DataUtils {
	public void createAccounts(Integer numOfAccounts){
		List<Account> accs = new List<Account>(); 
		for(Integer i = 0; i < numOfAccounts; i++){
			Account acc = new Account(Name = 'Test' + i,
			Customer_Id__c = 'Test' + i);
			accs.add(acc);
		}

		Database.insert(accs);
	}

	public void createOpportunities(Integer numOfOpportunities){
		List<Opportunity> opps = new List<Opportunity>(); 
		for(Integer i = 0; i < numOfOpportunities; i++){
			Opportunity opp = new Opportunity(Name = 'Test' + i,
			Customer_Id__c = 'Test' + i,
			StageName = 'Prospecting',
			CloseDate = date.today());
			opps.add(opp);
		}

		Database.insert(opps);
	}
}
