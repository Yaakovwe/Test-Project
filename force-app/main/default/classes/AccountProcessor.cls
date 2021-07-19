public with sharing class AccountProcessor {
	@future
	public static void countContacts(List<Id> accs) {
		List<Account> newAccs = getContacts(accs);
		for(Account acc : newAccs){
			acc.Number_of_Contacts__c = acc.Contacts.size();
		}
		Database.update(newAccs);
	}

	private static List<Account> getContacts(List<Id> accs){
		List<Account> cons = [
			SELECT Id, (SELECT Id FROM Contacts)
			FROM Account
			WHERE Id IN :accs
		];

		return cons;
	}
}
