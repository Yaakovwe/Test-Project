@isTest
public class TestAccountTriggerHelper {
	@isTest
	public static void accountsOnInsert() {
		DataUtils data = new DataUtils();
		data.createOpportunities(500);
		data.createAccounts(500);

		List<Opportunity> opps = [SELECT Customer_Id__c,AccountId FROM Opportunity ORDER BY Name ASC];
		List<Account> accs = [SELECT Customer_Id__c FROM Account ORDER BY Name ASC];

		for(Integer i = 0; i < 500; i++){
			System.assertEquals(opps[i].Customer_Id__c, accs[i].Customer_Id__c, opps[i].Customer_Id__c + ' ' + accs[i].Customer_Id__c);
			System.assertEquals(opps[i].AccountId, accs[i].Id, opps[i].AccountId + ' ' + accs[i].Id);
		}
	}

	@isTest
	public static void accountsOnUpdate() {
		DataUtils data = new DataUtils();
		data.createOpportunities(500);
		data.createAccounts(500);
		List<Opportunity> opps = [SELECT Customer_Id__c,AccountId FROM Opportunity ORDER BY Name ASC];
		List<Account> accs = [SELECT Customer_Id__c FROM Account ORDER BY Name ASC];

		for(Integer i = 0; i < 500; i++){
			System.assertEquals(opps[i].Customer_Id__c, accs[i].Customer_Id__c, opps[i].Customer_Id__c + ' ' + accs[i].Customer_Id__c);
			System.assertEquals(opps[i].AccountId, accs[i].Id, opps[i].AccountId + ' ' + accs[i].Id);
		}

		Test.startTest();
		for(Integer i = 0; i < 500; i++){
			accs[i].Customer_Id__c = 'tes' + i;
		}

		Database.update(accs);
		List<Opportunity> oppsFirstUpdate = [SELECT Customer_Id__c,AccountId FROM Opportunity WHERE AccountId != NULL];
		List<Account> accsFirstUpdate = [SELECT Customer_Id__c FROM Account ORDER BY Name ASC];
		System.assertEquals(0, oppsFirstUpdate.size());

		for(Integer i = 0; i < 500; i++){
			accsFirstUpdate[i].Customer_Id__c = 'Test' + i;
		}

		Database.update(accsFirstUpdate);
		Test.stopTest();

		List<Opportunity> oppsSecondUpdate = [SELECT Customer_Id__c,AccountId FROM Opportunity ORDER BY Name ASC];
		List<Account> accsSecondUpdate = [SELECT Customer_Id__c FROM Account ORDER BY Name ASC];

		List <Opportunity> matchingOpps = new List <Opportunity>();

		for(Opportunity opp : oppsSecondUpdate){
			for( Account acc : accsSecondUpdate){
				if (acc.Id == opp.AccountId) {
					matchingOpps.add(opp);
					continue;
				}
			}
		}
		System.assertEquals(500, matchingOpps.size(),matchingOpps.size());
	}
}
