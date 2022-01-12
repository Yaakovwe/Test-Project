@isTest
public with sharing class AccountTriggerTest {
	@isTest
	static void testAccounts(){
		List<Account> accs = new List<Account>();
		for (Integer i = 0; i < 200; i++) {
			Account acc = new Account(
				Name = 'Test ' + i,
				BillingState = 'CA'
			);
			accs.add(acc);
		}
		Database.insert(accs);
		List<Account> accsAfterInsert = [
			SELECT ShippingState 
			FROM Account
		];
		for (Account accNew : accsAfterInsert) {
			String shipping  = accNew.ShippingState;
			System.assertEquals('CA', shipping);
		}
	}
}
