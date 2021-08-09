@isTest
public with sharing class LeadProcessorTest {
	@TestSetup
	static void makeData(){
		List<Lead> leads = new List<Lead>();
		for(Integer i = 0; i < 200; i++){
			Lead lead  = new Lead(LastName = 'Test ' + i, 
                Company = 'Test ' + i);
			leads.add(lead);
		}
		Database.insert(leads);
	}

	@isTest
	static void testLeadProcessor(){    
		Test.startTest();
		LeadProcessor proc = new LeadProcessor();
		Id batchId = Database.executeBatch(proc);
		Test.stopTest();
		List<Lead> leads = [
			SELECT Id FROM Lead
			WHERE LeadSource = 'Dreamforce'
		];

		System.assertEquals(200, leads.size(),leads.size());
	}
}
