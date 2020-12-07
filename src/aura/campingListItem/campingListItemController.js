({
	packItem : function(component, event, helper) {
        var btnClicked = event.getSource();         
        component.set("v.item.Packed__c", true).set("v.disabled",true);     
	}
})