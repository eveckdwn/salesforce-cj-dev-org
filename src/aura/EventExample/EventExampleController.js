({
    doInit : function(component, event, helper) {
        component.set('v.test', 'On Init');
    },

    doChange : function(component, event, helper) {
        // alert('Value Changed');
    },

    Changevalue : function(component, event, helper){
        component.set('v.test', 'Test');
        /*
         component.getEvent(''); 컴포넌트 이벤트를 선언하는 것과 달리,
         Application Event를 선언하여 Capture할 때,
         e.c:{Event Name}으로 선언한다.
        */
       var aeEvent = $A.get('e.c:aeEvent');
       aeEvent.fire();
    }
})