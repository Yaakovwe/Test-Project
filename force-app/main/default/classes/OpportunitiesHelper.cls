public class OpportunitiesHelper {
	@AuraEnabled(cacheable=true)
	public static List<Opportunity> getOpps(String accountId) {
		List<Opportunity> opps = [
			SELECT Name, Amount , Owner.Name , Customer_Id__c  FROM Opportunity
			WHERE AccountId = :accountId
		];
		return opps;
	}
}
