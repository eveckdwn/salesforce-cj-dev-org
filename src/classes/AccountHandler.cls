public with sharing class AccountHandler {
    public static Account insertNewAccount(String accountName){
    	try {
    		
   			// This causes an exception because 
    		//   the required Name field is not provided.
    		Account acct = new Account(Name=accountName);
    		
    		// Insert the account 
    		insert acct;
    		
    		// Get the new ID on the inserted sObject argument
			ID acctID = acct.Id;
			
			// Display this ID in the debug log
			System.debug('ID = ' + acctID);
			
    		return acct;
		} catch (DmlException e) {
			
    		System.debug('A DML exception has occurred: ' + e.getMessage());
    		
            return null;
		}
    }
    
    public static void CreateNewOpportunity(List<Account> accts) {
        List<Opportunity> opps = new List<Opportunity>();
        for (Account a : accts) {
            Opportunity opp = new Opportunity();
            opp.Name = a.Name + ' Opportunity';
            opp.AccountId = a.Id;
            opp.StageName = 'Prospecting';
            opp.CloseDate = System.Today().addMonths(1);
            opps.add(opp);
        }
        if (opps.size() > 0) {
            insert opps;
        }

		//	교육중 테스트 진행
    }
}