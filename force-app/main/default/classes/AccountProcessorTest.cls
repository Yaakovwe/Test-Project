@isTest
public with sharing class AccountProcessorTest {
	
	@isTest
	static void countContactsTest(){
		Account acc = new Account(
			Name = 'Test'
		);
		Database.insert(acc);
		Contact con = new Contact(
			FirstName = 'Test',
			LastName ='Test',
			AccountId = acc.Id
		);
		Database.insert(con);
		List<Id> accIds = new List<Id>{acc.Id};

		Test.startTest();
			AccountProcessor.countContacts(accIds);
		Test.stopTest();
		List<Account> newAccs = [
			SELECT Number_of_Contacts__c FROM Account
		];
		System.assertEquals(1, newAccs[0].Number_of_Contacts__c);	
	}
}
