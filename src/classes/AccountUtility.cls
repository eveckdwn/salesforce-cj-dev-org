/**
 * Created by cj.sohn on 2020-12-28.
 */

public with sharing class AccountUtility {
    public static void viewAnnualRevenue(){
        List<Account> accountsList = [SELECT Id, Name, AnnualRevenue FROM Account];
        for(Account acct : accountsList){
            String acctRev = acct.Name + ' : ' + acct.AnnualRevenue;
            System.debug(acctRev);
        }
    }

}