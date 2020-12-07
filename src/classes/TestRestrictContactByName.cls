@isTest
public class TestRestrictContactByName {
	 @isTest static void TestRestrictContactsByName() {
        // Test data setup
        Contact c = new Contact(LastName = 'INVALIDNAME', CurrencyIsoCode='KRW');
        insert c;
        
        // Perform test
        Test.startTest();
        Database.SaveResult result = Database.insert(c, false);
        Test.stopTest();
        // Verify 
        // In this case the deletion should have been stopped by the trigger,
        // so verify that we got back an error.
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('Cannot update contact',
                             result.getErrors()[0].getMessage());
    }
}