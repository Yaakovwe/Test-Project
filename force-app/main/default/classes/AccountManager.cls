@RestResource(urlMapping='/Accounts//contacts')
global with sharing class AccountManager {
	@HttpGet 
	global static Account getAccount() {
		RestRequest request = RestContext.request;
		String[] reqArray = request.requestURI.split('/');
        String accId = reqArray[reqArray.size()-2];
		Account acc = [
			SELECT Id,Name,
			(SELECT Id,Name FROM Contacts)
			FROM Account
			WHERE Id = :accId
		];
		return acc;
	}
}
