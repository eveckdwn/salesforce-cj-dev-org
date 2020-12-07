//
// @author         Comity Designs, Inc.
// @version        1.0
// @date           Aug 30 2017
// @description    Component Helper in the managed package
//
({
  //helper method for the showOppModal and hideModal functions
  toggleClass: function(component, componentId, className) {
    var modal = component.find(componentId);
    $A.util.removeClass(modal, className + 'hide');
    $A.util.addClass(modal, className + 'open');
  },
  //helper method for the showOppModal and hideModal functions
  toggleClassInverse: function(component, componentId, className) {
    var modal = component.find(componentId);
    $A.util.addClass(modal, className + 'hide');
    $A.util.removeClass(modal, className + 'open');
  },
  //Get multiple quantity list. We load it first so that
  //we can assign it to the v.assetList which controls
  //which table is rendered (multiple or single)
  //on load, we are always in multiple quantity view
  loadMultipleAssetsData: function(component){
	
    var action = component.get("c.getMultiple");
    action.setParams({
      opportunityId: component.get("v.recordId")
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var dataToAssign = response.getReturnValue();
        var newObj = new Object();
        var i = 0;
        var sumOfQuantities = 0;
        Object.keys(dataToAssign).forEach(function(key) {
          dataToAssign[key]['leid'] = i + 'm';
          i++;
          sumOfQuantities += dataToAssign[key]['asset']['Quantity'];
        });
        component.set("v.multipleQuantity", dataToAssign);
        component.set("v.assetList", dataToAssign);
        component.set("v.sumOfQuantities", sumOfQuantities);
        component.set('v.isMultipleView', true);
      } else if (state === "INCOMPLETE") {
        // do something
      } else if (state === "ERROR") {
        var errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
          }
        } else {
        }
      }
    });
    $A.enqueueAction(action);
  },
  //get single quantity asset list and assign it to
  //v.singleQuantity for when we need it when user
  //clicks "View Single Quantity"
  loadSingleAssetsData : function(component){	
    var action2 = component.get("c.getSingle");
    action2.setParams({
      opportunityId: component.get("v.recordId")
    });    
    action2.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var dataToAssign = response.getReturnValue();
        var newObj = new Object();
        var i = 0;
        Object.keys(dataToAssign).forEach(function(key) {
          dataToAssign[key]['leid'] = i + 'm';
          i++;
        });
        component.set("v.singleQuantity", dataToAssign);
      } else if (state === "INCOMPLETE") {
        // do something
      } else if (state === "ERROR") {
        var errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
          }
        } else {
        }
      }
    });
    $A.enqueueAction(action2);
  },
  //Getting the list with already converted assets for this 
  //oppty & account
  loadConvertedAssetsData : function(component){
    var action3 = component.get("c.getConvertedAssets");
    action3.setParams({
      opportunityId: component.get("v.recordId")
    });    
    action3.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        component.set("v.convertedAssets", response.getReturnValue());
      } else if (state === "INCOMPLETE") {
        // do something
      } else if (state === "ERROR") {
        var errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {

          }
        } else {
        }
      }
    });
    $A.enqueueAction(action3);
  },
  //Since there is no inputField rendering like in VFClassic
  //we use controller function to get the possible picklist values
  //for the Status dropdown
  loadAssetPicklistValuesData : function(component){

    var action1 = component.get("c.assetPicklistValues");
    action1.setParams({});
    action1.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        component.set("v.picklistOptions", response.getReturnValue());
      } else if (state === "INCOMPLETE") {
        // do something
      } else if (state === "ERROR") {
        var errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {

          }
        } else {
        }
      }
    });
    $A.enqueueAction(action1);
  },
  //Since there is no inputField rendering like in VFClassic
  //we use controller function to get the possible picklist values
  //for the Status dropdown
  loadRelatedAccountData : function(component){
    var action5 = component.get("c.getAccount");
    action5.setParams({
      opportunityId: component.get("v.recordId")
    });
    action5.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        component.set("v.account", response.getReturnValue());
      } else if (state === "INCOMPLETE") {
        // do something
      } else if (state === "ERROR") {
        var errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
          }
        } else {
        }
      }
    });
    $A.enqueueAction(action5);
  },
  //getting the record for the current oppty. We need it
  //for checking if the stage is "closed won" or not
  //and display an alert and disable the buttons if it isn't
  loadCurrentOpportunityData : function(component){

    var action6 = component.get("c.getOpportunity");
    action6.setParams({
      opportunityId: component.get("v.recordId")
    });
    action6.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        component.set("v.opportunity", response.getReturnValue());
      } else if (state === "INCOMPLETE") {
        // do something
      } else if (state === "ERROR") {
        var errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
          }
        } else {
        }
      }
    });
    $A.enqueueAction(action6);
  },
  //Checking if we have products on the current oppty. 
  //if no, we throw an error toast in the showOppModal function
  loadDoWeHaveProducts : function(component){
	var action7 = component.get("c.productsOnOpportunity");
    action7.setParams({
      opportunityId: component.get("v.recordId")
    });
    action7.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        component.set("v.productsOnOpportunity", response.getReturnValue());
      } else if (state === "INCOMPLETE") {
        // do something
      } else if (state === "ERROR") {
        var errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
          }
        } else {
        }
      }
    });
    $A.enqueueAction(action7);
  },
  //Loading the number of converted assets for the account assigned to the oppty. 
  loadNumberOfConvertedAssets : function(component){
	var action7 = component.get("c.getNumberOfConvertedAssets");
    action7.setParams({
      opportunityId: component.get("v.recordId")
    });
    action7.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        component.set("v.numberOfConvertedAssets", response.getReturnValue());
      } else if (state === "INCOMPLETE") {
        // do something
      } else if (state === "ERROR") {
        var errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
          }
        } else {
        }
      }
    });
    $A.enqueueAction(action7);
  },
  
  loadFieldLabels : function(component){
	var action7 = component.get("c.getFieldLabels");
    action7.setParams({
     
    });
    action7.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
    	  	component.set("v.fieldLabels", JSON.parse(response.getReturnValue()));
    	  	
      } else if (state === "INCOMPLETE") {
        // do something
      } else if (state === "ERROR") {
        var errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
          }
        } else {
        }
      }
    });
    $A.enqueueAction(action7);
  }
})