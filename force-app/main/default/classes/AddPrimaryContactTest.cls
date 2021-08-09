@isTest
public with sharing class AddPrimaryContactTest {
	@testSetup
	static void makeData(){
		List<Account> accs = new List<Account>();
		for(Integer i = 0; i < 50; i++){
			Account acc = new Account(
				Name = 'Test',
				BillingState = 'NY'
			);
			accs.add(acc);
		}
		for(Integer i = 0; i < 50; i++){
			Account acc = new Account(
				Name = 'Test',
				BillingState = 'CA'
			);
			accs.add(acc);
		}
		Database.insert(accs);
	}

	@isTest
	static void testExecutable(){
		Test.startTest();
		Contact coni = new Contact(LastName = 'Hola', FirstName = 'Hola');
		System.enqueueJob(new AddPrimaryContact(coni,'CA'));
		Test.stopTest();

		List<Contact> cons  = [
			SELECT Id FROM Contact
			WHERE Account.BillingState = 'CA'
		];

		System.assertEquals(50, cons.size());
	}
}
