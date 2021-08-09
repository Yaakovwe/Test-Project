public with sharing class AddPrimaryContact implements Queueable {
	private Contact con;
	private String state;

	public AddPrimaryContact(Contact contact, String states) {
		this.con = contact;
		this.state = states;
	}

	public void execute(QueueableContext context) {
		List<Account> accs = [
			SELECT Id FROM Account
			WHERE BillingState = :state
			LIMIT 200
		];

		List<Contact> cons = new List<Contact>();
		for (Account acc : accs){
			Contact coni = con.clone();
			coni.AccountId = acc.Id;
			cons.add(coni);
		}
		
		Database.insert(cons);
	}
}
