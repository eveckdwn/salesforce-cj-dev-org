trigger AccountTrigger on Account (before insert, before update, before
    delete, after insert, after update, after delete,  after undelete) {
    /*
    if (Trigger.isAfter && Trigger.isInsert) {
        AccountHandler.CreateNewOpportunity(Trigger.New);
    }
    */
    
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            //call Handler method and pass it the list of Accounts to be inserted
            AccountTriggerHandler.CreateAccounts(Trigger.New);    
        }
    }
}