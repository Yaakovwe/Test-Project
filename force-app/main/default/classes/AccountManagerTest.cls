@isTest
public with sharing class AccountManagerTest {
    @TestSetup
    static void makeData(){
        Account acc = new Account(
            Name = 'Testy'
        );
        Database.insert(acc);
        List<Contact> cons = new List<Contact>();
        for(Integer i = 0; i < 3; i++){
            Contact con = new Contact(
                LastName = 'Testy ' + i,
                AccountId = acc.Id
            );
            cons.add(con);
        }
        Database.insert(cons);
    }
    @isTest static void testGetAccount() {
        List<Account> accs = [
            SELECT Id From Account
        ];
        // Set up a test request
        RestRequest request = new RestRequest();
        String url = System.URL.getSalesforceBaseUrl().toExternalForm();
        request.requestUri =
            url + '/services/apexrest/Accounts/' + String.valueOf(accs[0].Id) + '/contacts/'; 
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        Account acc = AccountManager.getAccount();
        // Verify results
        System.assert(acc != null);
        System.assertEquals('Testy', acc.Name);
        System.assertEquals(3, acc.Contacts.size());
    }
}
