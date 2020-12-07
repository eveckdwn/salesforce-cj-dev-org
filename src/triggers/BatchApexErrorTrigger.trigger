trigger BatchApexErrorTrigger on BatchApexErrorEvent (after insert) {

      List<BatchLeadConvertErrors__c> batchLst = new List<BatchLeadConvertErrors__c>();
    //insert records 
    for(BatchApexErrorEvent batchObj : Trigger.new){
        BatchLeadConvertErrors__c  tempObj = new BatchLeadConvertErrors__c (AsyncApexJobId__c = batchObj.AsyncApexJobId,Records__c = batchObj.JobScope,StackTrace__c = batchObj.StackTrace);
        batchLst.add(tempObj);
    }
    if(batchLst.size() >0)
        insert batchLst;
}