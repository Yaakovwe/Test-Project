@isTest
public with sharing class DailyLeadProcessorTest {
	@testSetup
	static void makeData(){
		List<Lead> leads = new List<Lead>();
		for(Integer i = 0; i < 200; i++){
			Lead lead = new Lead(
				LastName = 'Test ' + i,
				Company = 'Test ' + i
			);
			leads.add(lead);
		}
		Database.insert(leads);
	}

	@isTest
	static void dailyTest(){
		String CRON_EXP = '0 0 0 15 3 ? 2022';
		List<Lead> leadsBefore = [
			SELECT Id FROM Lead
			WHERE LeadSource = 'Dreamforce'
		];
		System.assertEquals(0, leadsBefore.size());
		Test.startTest();
		String jobId = System.schedule('ScheduledApexTest',
			CRON_EXP,
			new DailyLeadProcessor());
		Test.stopTest();
		
		List<Lead> leadsAfter = [
			SELECT Id FROM Lead
			WHERE LeadSource = 'Dreamforce'
		];
		System.assertEquals(200, leadsAfter.size());
	}
}
