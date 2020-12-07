trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {
    List<Task> tasks = new List<Task>();
    Task t = new Task();
    for(Opportunity opp: Trigger.New){
        if(opp.StageName == 'Closed Won'){
            t = new Task();
            t.Subject = 'Follow Up Test Task';
            t.WhatId = opp.id;
            tasks.add(t);
        }
    }
    Insert tasks;
}