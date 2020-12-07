public with sharing class ContactSearch {
	public static Contact[] searchForContacts(String s1, String s2){
		Contact[] contact = [SELECT Name, ID FROM Contact WHERE LastName =: s1 and MailingPostalCode =: s2];
		return contact; 
	}
    
}