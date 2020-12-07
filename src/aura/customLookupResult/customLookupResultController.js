({
  doInit : function(component, event, helper){
    var getSelectRecord = component.get("v.oRecord");
    var recordId = getSelectRecord.Id;
    if(recordId.startsWith('500')){
      component.set("v.isCase", true);
    }else{
      component.set("v.isCase", false);
    }
    if(recordId.startsWith('00Q')){
      component.set("v.isLead", true);
    }else{
      component.set("v.isLead", false);
    }
    if(recordId.startsWith('003')){
      component.set("v.isContact", true);
    }else{
      component.set("v.isContact", false);
    }
    if(recordId.startsWith('006')){
      component.set("v.isOpportunity", true);
    }else{
      component.set("v.isOpportunity", false);
    }
  },
  selectRecord : function(component, event, helper){      
    // get the selected record from list  
    var getSelectRecord = component.get("v.oRecord");
    var recordId = getSelectRecord.Id;
    if(recordId.startsWith('500')){
      component.set("v.isCase", true);
    }else{
      component.set("v.isCase", false);
    }
    if(recordId.startsWith('00Q')){
      component.set("v.isLead", true);
    }else{
      component.set("v.isLead", false);
    }
    if(recordId.startsWith('003')){
      component.set("v.isContact", true);
    }else{
      component.set("v.isContact", false);
    }
    if(recordId.startsWith('006')){
      component.set("v.isOpportunity", true);
    }else{
      component.set("v.isOpportunity", false);
    }
    // call the event   
    var compEvent = component.getEvent("oSelectedRecordEvent");
    // set the Selected sObject Record to the event attribute.  
    compEvent.setParams({"recordByEvent" : getSelectRecord });  
    // fire the event  
    compEvent.fire();
   },
})