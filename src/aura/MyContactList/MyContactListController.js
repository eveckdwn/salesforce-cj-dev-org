({
	myAction : function(component, event, helper) {
		component.set("v.Columns", [
            {label:"First Name", fieldName:"FirstName", type:"text"},
            {label:"Last Name", fieldName:"LastName", type:"text"},
            {label:"Phone", fieldName:"Phone", type:"phone"}
        ]);
        
        //  Step1
        //  Apex Controller의 메서드를 js에 정의
        var action = component.get("c.getContacts");

        //  Step2 (Optional)
        //  메서드로 보낼 파라미터 정의
        action.setParams({
            recordId: component.get("v.recordId")
        });

        //  Step4
        //  메서드를 실행하여 반환(Return)된 값을 처리
        action.setCallback(this, function(response) {
            var responseValue = response.getReturnValue();
            console.log('responseValue ', responseValue);
            component.set("v.Contacts", responseValue);
        }, 'SUCCESS');

        //  Step3
        $A.enqueueAction(action);

	}
})