public with sharing class AccountTriggerHandler {
	public static void createAccounts(List<Account> accs) {
		for (Account acc : accs) {
			acc.ShippingState = acc.BillingState;
		}
	}
}
