public with sharing class AccountUtils {
    public static List<Account> accountsByState(String stateAbbreviation){
    	List<Account> accounts = [SELECT ID, name FROM Account WHERE BillingState=:stateAbbreviation];
    	return accounts;  
    }
}