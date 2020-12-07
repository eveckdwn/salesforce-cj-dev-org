@isTest
private class AccountTriggerTest {
    @isTest static void TestCreateNewAccountInBulk() {
        // Test Setup data
        // Create 200 new Accounts
        List<Account> accts = new List<Account>();
        for(Integer i=0; i < 200; i++) {
            Account acct = new Account(Name='Test Account ' + i, BillingState='CA');
            accts.add(acct);
        }              
        // Perform Test
        Test.startTest();
        insert accts;
        Test.stopTest();
        
        List<Account> verifyAccts = [SELECT Id, name, BillingState, ShippingState FROM Account WHERE name like 'Test Account%'];
        for(Account acct : verifyAccts){
	        System.assertEquals(acct.BillingState, acct.ShippingState);    
        }
    }
}