//
// @author         Comity Designs, Inc.
// @version        1.0
// @date           Aug 30 2017
// @description    Component Controller in the managed package
//
({
  //the standard lightning init function.
  //loads data on page load, and also when called by
  //an event or an action
  doInit: function(component, event, helper) {
    
    helper.loadMultipleAssetsData(component);
    
    helper.loadSingleAssetsData(component);
    
    helper.loadConvertedAssetsData(component);
    
    helper.loadAssetPicklistValuesData(component);
    
    helper.loadRelatedAccountData(component);
    
    helper.loadCurrentOpportunityData(component);
    
    helper.loadDoWeHaveProducts(component);
    
    helper.loadNumberOfConvertedAssets(component);
    
    helper.loadFieldLabels(component);
    
  },
  
  //This function is called when convert is clicked.
  //If conversion is successful it will show a success toast message,
  //else if no assets are selected it will show a notification,
  //and it will show an Error toast if there was an error
  convertSelected: function(component, event, helper) {
    var action = component.get("c.convert");
    var paramData = component.get("v.assetList");
    var objectsToConvert = 0;
    Object.keys(paramData).forEach(function(key) {
      delete paramData[key]['leid'];
      if (paramData[key]['isAssetSelected'] == true) {
        objectsToConvert++;
      }
    });
    action.setParams({
      assetsToConvert: JSON.stringify(paramData)
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        helper.toggleClassInverse(component, 'backdrop', 'slds-backdrop--');
        helper.toggleClassInverse(component, 'modaldialog', 'slds-fade-in-');
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
          "type": "success",
          "title": "Success!",
          "message": "The products have been converted successfully."
        });
        toastEvent.fire();
        component.initMethod();
      } else if (state === "INCOMPLETE") {
        // do something
      } else if (state === "ERROR") {
        var errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {

          }
        } else {
        }
        helper.toggleClassInverse(component, 'backdrop', 'slds-backdrop--');
        helper.toggleClassInverse(component, 'modaldialog', 'slds-fade-in-');
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
          "type": "error",
          "title": "Error! Please refresh and try again.",
          "message": ""
        });
        toastEvent.fire();
      }
    });
    if (objectsToConvert > 0) {
      $A.enqueueAction(action);
      var cmpTarget = component.find('alert-convert');
      $A.util.addClass(cmpTarget, 'hide-alert');
    } else {
      var cmpTarget = component.find('alert-convert');
      $A.util.removeClass(cmpTarget, 'hide-alert');
    }
  },
  //This function is used to bind the data with the inputs.
  //data-leid is the index of the list element (assigned manually in the first action)
  //and data-field is the field we are updating
  //Ex: if we have a Name field which is the 3rd element in our list(same is with single or multiple),
  //then the element will be <input data-leid='3m' data-field="Name"
  //Warning: this function works only with fields that are in the asset object of the AssetWrapperLE class.
  updateMObject: function(component, event, helper) {
    var multipleAssets = component.get("v.assetList");
    //var answers = question.Answers__r
    var updatedIndex = event.currentTarget.getAttribute('data-leid');
    var updatedField = event.currentTarget.getAttribute('data-field');
    Object.keys(multipleAssets).forEach(function(key) {
      if (multipleAssets[key]['leid'] == updatedIndex) {
        multipleAssets[key]['asset'][updatedField] = event.currentTarget.value;
      }
    });
    component.set("v.assetList", multipleAssets);
  },
  //Selects or deselects all checkboxes when called
  selectDeselectAll: function(component, event, helper) {
    var multipleAssets = component.get("v.assetList");
    Object.keys(multipleAssets).forEach(function(key) {
      multipleAssets[key]['isAssetSelected'] = event.currentTarget.checked;
    });
    component.set('v.assetList', multipleAssets);
    component.openToolbar();
  },  
  //Changes the status of all list elements when the Status on the 
  //dropdown in the header is selected/changed
  statusAll: function(component, event, helper) {
    var multipleAssets = component.get("v.assetList");
    Object.keys(multipleAssets).forEach(function(key) {
      var e = event.currentTarget;
      if(multipleAssets[key]['isAssetSelected']){
    	  	multipleAssets[key]['asset']['Status'] = e.options[e.selectedIndex].value;
      }
    });
    component.set('v.assetList', multipleAssets);
  },
  //Change between single & multiple quantity views/tables
  //This can be improved and made in a different way to detect in which mode
  //we are via a variable, but for quickness, I did it this way.
  switchViews: function(component, event, helper) {
    var label = component.find("switchViews").get("v.label");
    var isMultipleView = component.get('v.isMultipleView')
    if (isMultipleView) {
      component.set('v.assetList', component.get('v.singleQuantity'));
      component.set('v.isMultipleView', false);
    } else {
      component.set('v.assetList', component.get('v.multipleQuantity'));
      component.set('v.isMultipleView', true);
      
    }
    var Assets = component.get("v.assetList");
    Object.keys(Assets).forEach(function(key) {
      Assets[key]['isAssetSelected'] = false;
    });
    component.set('v.assetList', Assets)
    document.getElementById("selectAllCheckbox").checked = false;
  },
  //Show the modal. We are calling the initMethod here, so that the data is fresh when the user
  //converts or adds/deletes a product and the oppty detail page is not refreshed.
  showOppmodal: function(component, event, helper) {
    //Toggle CSS styles for opening Modal
	if(component.get('v.opportunity.Probability') < 100){
	    var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
          "type": "error",
          "title": "Action not permitted",
          "message": 'Opportunity is not "Closed Won"'
        });
        toastEvent.fire();
	    
    }else if(component.get('v.account.Id')==null){
    		var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
          "type": "error",
          "title": "Action not permitted",
          "message": 'No account on this Opportunity. Please fix.'
        });
        toastEvent.fire();
    }    
    else if (!component.get('v.productsOnOpportunity')){
    		var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
          "type": "error",
          "title": "Action not permitted",
          "message": 'No products on opportunity'
        });
        toastEvent.fire();
    }
    else{
        component.initMethod(); 
		var sltTarget = component.find('selected-toolbar');
	    $A.util.addClass(sltTarget, 'hide-alert');
    	    helper.toggleClass(component, 'backdrop', 'slds-backdrop--');
	    helper.toggleClass(component, 'modaldialog', 'slds-fade-in-');
	    
    }
  },
  //hides the modal
  hideModal: function(component, event, helper) {
    //Toggle CSS styles for hiding Modal
    helper.toggleClassInverse(component, 'backdrop', 'slds-backdrop--');
    helper.toggleClassInverse(component, 'modaldialog', 'slds-fade-in-');
    var cmpTarget = component.find('alert-convert');
    $A.util.addClass(cmpTarget, 'hide-alert');
  },
  //closes the alert that shows up if no products are selected before converting
  closeAlert: function(component) {
    var cmpTarget = component.find('alert-convert');
    $A.util.addClass(cmpTarget, 'hide-alert');
  },
  openDatePicker : function(component){
	  document.getElementById('datepicker-pd').click();
  },
  openToolbar : function(component){
	var multipleAssets = component.get("v.assetList");
    var selected = 0;
    Object.keys(multipleAssets).forEach(function(key) {
      
      if(multipleAssets[key]['isAssetSelected']){
    	  	selected++;
      }
    });
    
    if(selected>0){
        var cmpTarget = component.find('selected-toolbar');
        $A.util.removeClass(cmpTarget, 'hide-alert');
    }else{
    		var cmpTarget = component.find('selected-toolbar');
        $A.util.addClass(cmpTarget, 'hide-alert');
    }
  }
})