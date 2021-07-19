public with sharing class LeadProcessor implements Database.Batchable<sObject>{
	public Database.QueryLocator start(Database.BatchableContext bc) {
		String query = 'SELECT Id FROM Lead';
		return Database.getQueryLocator(query);
	}

	public void execute(Database.BatchableContext BC, List<Lead> leads){
		for (Lead leady : leads) {
			leady.LeadSource = 'Dreamforce';
		}
		Database.update(leads);
	} 
	public void finish(Database.BatchableContext BC){} 
}
