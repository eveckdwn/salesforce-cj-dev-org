public with sharing class ContactAndLeadSearch {
    public static List<List<SObject>> searchContactsAndLeads(String param){
    	List<List<SObject>> searchList = [FIND :param IN NAME FIELDS RETURNING LEAD(FirstName, LastName), Contact(FirstName, LastName)];
    	return searchList;
    }
}