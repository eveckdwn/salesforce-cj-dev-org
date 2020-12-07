({
    doInit : function(component, event, helper) {
        //  Step1
        //  Apex Controller의 메서드를 js에 정의
        var action = component.get("c.getContactList");

        //  Step2 (Optional)
        //  메서드로 보낼 파라미터 정의
        action.setParams({
            accountId : component.get("v.recordId")
        });

        //  Step4
        //  메서드를 실행하여 반환(Return)된 값을 처리
        action.setCallback(this, function(response) {
            var responseValue = response.getReturnValue();
            console.log('responseValue ', responseValue);
            component.set("v.contactList", responseValue);
        }, 'SUCCESS');

        //  Step3
        $A.enqueueAction(action);
    },
    doRedirect : function(component, event, helper){
        var eventSource = event.getSource();
        var id = eventSource.get('v.name');
        alert(id);
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
        "recordId": id,
        "slideDevName": "detail"
        });
        navEvt.fire();
    },
    handleCompEvent : function(component, event, helper){
        var availableContact = component.get("v.contactList");
        var ContactRecord = event.getParam('ContactRecord');
        console.log(ContactRecord);
        availableContact.push(ContactRecord);
        component.set('v.contactList', availableContact);
    }
})