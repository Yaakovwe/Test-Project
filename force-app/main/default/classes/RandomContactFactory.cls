public with sharing class RandomContactFactory {
    public static List<Contact> generateRandomContacts(Integer numOfCons, String lastName){
        List<Contact> cons = new List<Contact>();
        for(Integer i = 0; i < numOfCons; i++){
            cons.add(new Contact(FirstName = ' ' + i, LastName = lastName));
        }
        return cons;
    }
}
