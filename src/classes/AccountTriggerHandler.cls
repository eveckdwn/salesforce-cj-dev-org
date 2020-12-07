public class AccountTriggerHandler {
    public static void CreateAccounts(List<Account> accounts){
       //loop through and set Shipping State to match Billing State
        for(Account acct: accounts){
            acct.ShippingState = acct.BillingState;
        }
    }
}