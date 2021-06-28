@isTest
public with sharing class TestRestrictContactByName {
    @IsTest
    static void checkContact(){
        Contact con = new Contact(
            LastName = 'INVALIDNAME'
        );
        try {
            Database.insert(con);
        } catch (Exception ex) {
            System.assertEquals(ex.getMessage().contains('The Last Name '), true);
            List<Contact> cons = [
                SELECT Id FROM Contact
            ];
    
            System.assertEquals(0, cons.size());
        }


    }
}
