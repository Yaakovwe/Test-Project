public with sharing class AppTriggerHelper {
    public static void onBeforeInsert(List<App__c> newApps) {
        updateMultipleAppsOnAccounts(null,newApps);
    }

    public static void onBeforeUpdate(Map<Id,App__c> oldAppsMap, List<App__c> newApps) {
        updateMultipleAppsOnAccounts(oldAppsMap,newApps);
    }

    private static void updateMultipleAppsOnAccounts(Map<Id,App__c> oldAppsMap, List<App__c> newApps){
        try {
            Set<Id> oppIdsToCheck = processOppsToCheck(oldAppsMap,newApps);
            if(oppIdsToCheck.isEmpty()){
                return;
            }
            List<Account> accounts = fetchAccountsAndContacts(oppIdsToCheck);
            List<Account> accsToUpdate = new List<Account>();
            Set<String> emailAddresses = new Set<String>();
            for (Account acc : accounts) {
                acc.Multiple_Apps__c = true;
                accsToUpdate.add(acc);
                getEmailAddresses(acc.Contacts,emailAddresses);
            }
            if (!accsToUpdate.isEmpty()) {
                Database.update(accsToUpdate);
            }

            sendEmails(emailAddresses);
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }
    }

    private static Set<Id> processOppsToCheck(Map<Id,App__c> oldAppsMap, List<App__c> newApps){
        Boolean isInsert = oldAppsMap == null;
        Set<Id> oppIdsToCheck = new Set<Id>();
        for (App__c newApp : newApps){
            if (isInsert && newApp.Opportunity__c != null){
                oppIdsToCheck.add(newApp.Opportunity__c);
            } else if(oldAppsMap.get(newApp.Id).Opportunity__c != newApp.Opportunity__c){
                oppIdsToCheck.add(newApp.Opportunity__c); // do we need to set back to false if the Opportunity__c LU is nullifed?
            }
        }
        return oppIdsToCheck;
    }

    private static List<Account> fetchAccountsAndContacts(Set<Id> oppIdsToCheck){
        return [
            SELECT Multiple_Apps__c,
            (SELECT Email FROM Contacts)
            FROM Account
            WHERE Id IN (SELECT AccountId FROM Opportunity WHERE Id IN :oppIdsToCheck)
            AND Multiple_Apps__c = FALSE
        ];
    }

    private static void getEmailAddresses(List<Contact> contacts,Set<String> emails){
        for (Contact contact : contacts) {
            if(String.isNotBlank(contact.Email)){
                emails.add(contact.Email);
            }   
        }
    }

    private static void sendEmails(Set<String> emailAddresses) {
        Messaging.SingleEmailMessage[] messages = new Messaging.SingleEmailMessage[0];
        for(String email : emailAddresses) {
            messaging.SingleEmailMessage message = new messaging.SingleEmailMessage();
            message.settargetobjectid(userinfo.getUserId());
            message.setsubject('Test');
            message.setplaintextbody('Test');
            message.setsaveasactivity(false);
            messages.add(message);
        }
        messaging.sendEmail(messages);
    }
}