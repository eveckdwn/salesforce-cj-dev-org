({
    doSave : function(component, event, helper) {
        var action = component.get('c.createContact');
        var contc = component.get('v.CreateContact');
        /*
        if(contc.FirstName === null || contc.FirstName === '' || contc.FirstName === undefined){
            //  JS 안에서 자체적인 Validation Rule을 만들 수 있음.
            alert('Please input FName');
            return ;
        }else{
            action.setParams({
                con : component.get('v.CreateContact'),
                AccountId : component.get('v.accountId')
            });
            action.setCallback(this, function(response) {
                var state = response.getState();            
                // alert(state);
                if(state === 'SUCCESS' || state === 'DRAFT'){
                    var responseValue = response.getReturnValue();
                }else if(state === 'INCOMPLETE'){
    
                }else if(state === 'ERROR'){
                    var errors = response.getError();   //  Array of Error
                    console.log('Error ', errors);  //  ERROR시 browser console에 로그가 남음.
                    console.log('Error ', errors[0].duplicateResults);
                    console.log('Error ', errors[0].fieldErrors);
                    console.log('Error ', errors[0].pageErrors);
                    if(errors || error[0].message){
    
                    }
                }
            }, 'ALL');
    
            $A.enqueueAction(action);
        }
        */

        //  위 주석된 부분을 다음과 같이 진행할 수 있음.
        var validContact = component.find('contactForm').reduce(function (validSoFar, inputCmp){
            inputCmp.showHelpMessageIfInvalid();
            inputCmp.set('v.validity', {valid:false, badInput:true});

            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);

        // alert(validContact);

        if(validContact){
            action.setParams({
                con : component.get('v.CreateContact'),
                AccountId : component.get('v.accountId')
            });
            action.setCallback(this, function(response) {
                var state = response.getState();            
                // alert(state);
                if(state === 'SUCCESS' || state === 'DRAFT'){
                    var responseValue = response.getReturnValue();
                    //  등록된 이벤트에 파라미터를 전달
                    var componentEvent = component.getEvent('quickContact');
                    componentEvent.setParams({
                        ContactRecord: responseValue
                    });
                    componentEvent.fire();
                }else if(state === 'INCOMPLETE'){
    
                }else if(state === 'ERROR'){
                    var errors = response.getError();   //  Array of Error
                    console.log('Error ', errors);  //  ERROR시 browser console에 로그가 남음.
                    console.log('Error ', errors[0].duplicateResults);
                    console.log('Error ', errors[0].fieldErrors);
                    console.log('Error ', errors[0].pageErrors[0].message);
                    component.set('v.ErrorMessage', 'Error :' + errors[0].pageErrors[0].message);
                    if(errors || error[0].message){
    
                    }
                }
            }, 'ALL');
    
            $A.enqueueAction(action);
        }else{
            component.set('v.ErrorMessage', 'Please input All of Fields');
            console.log('Please input All of Fields');
        }
    }
})