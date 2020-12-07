/**
 * @author         Comity Designs, Inc.
 * @version        1.0
 * @date           Aug 30 2017
 * @description    Controller for Visualforce page and Lightning Component
 */
public with sharing class ProductsToAssetsCtrl {
  //Variables
  //EXCEPTION STRINGS
  private final string OidIsNull = 'Manual Exception: OID is null!';
  private final string AidIsNull = 'Exception: AccountID is null!';
  private final string ManualException = 'Manual Exception!';
  private final string NoAccountPresent = 'No Account found on this Opportunity. Please fix and try again.';
  // The toggleFlag changes from true to false to true, all depending on the user toggling the various
  ///quantity asset view on the VF page. This flag needs to be set to false as the initial load value.
  private Boolean toggleFlag = false;
  //Based on the value of this bool, which is controlled by the checkbox on the header of all available OLIs
  // we select/deselect all items for conversion. On click, this checkbox value gets set 
  //and the method run is SelectDeselectAll().
  public Boolean selectAllCheckbox {
    get;
    set;
  }
  //Are we in lightning or Visualforce Classic? This variable is set via a method called CheckLE(),
  //Which is called in the constructor
  public Boolean Lightning {
    get;
    set;
  }
  public Boolean AccountIdNull {
    get;
    set;
  }
  // The toggle Button variables define the button label, as the user toggles between the single asset quantity view
  ///and the multiple asset quantity view.
  public String toggleButtonHeader;
  private final String toggleButtonHeaderSingle = 'View Single Quantity Assets';
  private final String toggleButtonHeaderMultiple = 'View Multiple Quantity Assets';
  public String getToggleButtonHeader() {
    return this.toggleButtonHeader;
  }
  // SObject variables and Lists
  private Opportunity opportunity;
  private Account account;
  // List of Opportunity Line Items [Retreived via DB Query]
  private List < OpportunityLineItem > olis;
  // Stores final list of assets to be upserted into SFDC
  public List < Asset > assets;
  // List of Converted Assets [Retreived via DB Query]
  public List < Asset > convertedAssets;
  private Map < String, Integer > convertedAssetsMap = new Map < String, Integer > ();
  // Asset object for setting mass status on all entries from VF page.
  private Asset assetStatus = new Asset();
  // AssetWrapper lists - aid in defining the view that is displayed to the end-user
  ///Multiple Asset Quantity view, or the, Single Asset Quantity view
  public List < AssetWrapper > assetW;
  private List < AssetWrapper > assetW_Single = new List < AssetWrapper > ();
  private List < AssetWrapper > assetW_Multiple = new List < AssetWrapper > ();
  // Inner Exception Class
  private class InnerException extends Exception {}
  //Boolean to decide if multiple asset view button is rendered or not
  public boolean renderMultipleAssetButton {
    get;
    set;
  }
  //SUM of Quantities for products for this opportunity
  private Integer sumOfQuantities = 0;
  //are there any errors?
  public Boolean getHasErrors() {
    return ApexPages.hasMessages();
  }
  //getter: get summ of quantities of UNconverted products
  public Integer getSumOfQuantities() {
    return this.sumOfQuantities;
  }
  // Debug and Exception flags - Only for Test Cases
  Boolean isDebug = true;
  Boolean throwException = false;
  /** 
   ** Constructor: takes no arugments 
   ** -isDebug is always false
   **/
  public ProductsToAssetsCtrl() {
    selectAllCheckbox = false;
    try {
      //Call init
      init();
    } catch (InnerException e) {
      System.debug(e.getMessage());
      throw e;
    }
  }
  /**
   ** Overloaded Constructor: only for testing purposes, sets isDebug = input argument
   **/
  public ProductsToAssetsCtrl(Boolean dBug) {
    try {
      // Set isDebug
      this.isDebug = dBug;
      // Call 
      init();
    } catch (InnerException e) {
      if (isDebug) System.debug(e.getMessage());
      throw e;
    }
  }
  /**
   ** Init Method
   **/
  public void init() {
    try {
      checkLE();
      //Has to be assigned before setOLIs;
      renderMultipleAssetButton = true;
      //Set AssetWrapper List reference, 
      setAssetW();
      //setToggleButtonHeader();
      setToggleButtonHeader();
      //Get query parameters - OID & AID [Opportunity ID, Account ID]        
      getOIDQueryParameter();
      //getAIDQueryParameter();   --------> Moving Account fetching in OID for easier implementation in LE
      //Set Account and Opportunity names
      setAccountOpportunityName();
      //Query Opportunity Line Item table and store in opportunity line item list
      setOLIS();
      //Query the Assets table to isolate Converted Assets on the Account for display 
      setConvertedAssets();
      //Utilize the OLI list to set the Asset Wrapper List to be used by the VF Page
      setAssetWrapperList();
      // Setup OLIS to null - speedup controller.
      olis = null;
    } catch (InnerException e) {
      if (isDebug) System.debug(e.getMessage());
      throw e;
    }
  }
  // Getters
  /**
   ** getOIDQueryParameter: gets the OID Query parameter [Opportunity ID]
   **/
  public Boolean getOIDQueryParameter() {
    try {
      opportunity = new Opportunity(id = ApexPages.currentPage().getParameters().get('oid'));
      if (opportunity.ID == null) {
        throw new InnerException(OidIsNull);
      } else {
        account = new Account(id = ([SELECT Opportunity.Account.Id FROM Opportunity WHERE Id =: this.opportunity.Id LIMIT 1])[0].Account.Id);
        if (account.ID == null) {
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, NoAccountPresent));
          throw new InnerException(NoAccountPresent);
          return true;
        }
        return true;
      }
      return true;
    } catch (Exception e) {
      if (isDebug) System.debug(e.getMessage());
      if (e.getMessage().equals(NoAccountPresent)) {
        return true;
      } else throw e;
    }
  }
  public String getOpportunityID() {
    return this.opportunity.ID;
  }
  public Account getAccount() {
    return this.account;
  }
  public Opportunity getOpportunity() {
    return this.opportunity;
  }
  public String getAccountID() {
    return this.account.ID;
  }
  public Asset getAssetStatus() {
    return assetStatus;
  }
  public Boolean getToggleFlag() {
    return this.toggleFlag;
  }
  public List < OpportunityLineItem > getOlis() {
    return this.olis;
  }
  public List < AssetWrapper > getAssetW() {
    return this.assetW;
  }
  public List < Asset > getConvertedAssets() {
    return this.convertedAssets;
  }
  public Integer getConvertedAssetsCount() {
    return ProductsToAssetsUtil.getTotalOfConvertedAssets(opportunity.Id);
  }
  // Setters
  public void setThrowException(Boolean te) {
    this.throwException = te;
  }
  public void setToggleFlag(Boolean a) {
    this.toggleFlag = a;
  }
  /**
   ** setAccountName: runs query to get Account name
   **/
  public void setAccountOpportunityName() {
    try {
      Opportunity opp = [Select o.Name,
        o.Account.Name
        from Opportunity o
        where o.ID =: opportunity.ID LIMIT 1
      ];
      this.opportunity.Name = opp.Name;
      this.account.Name = opp.Account.Name;
      // For debugging purposes only
      if (throwException) throw new InnerException(ManualException);
    } catch (DmlException e) {
      for (Integer i = 0; i < e.getNumDml(); i++)
        if (isDebug) System.debug(e.getDmlMessage(i));
      throw new InnerException(e);
    } catch (InnerException e) {
      if (isDebug) System.debug(e.getMessage());
      throw e;
    }
  }
  /**
   ** setAssetW:
   ** -if toggleFlag=false, then assetW=assetW_Multiple [displays editable data list for multiple quantity asset view]
   ** -else, assetW=assetW_Single [displays editable data list for single quantity asset view]
   **/
  public void setAssetW() {
    if (!toggleFlag) {
      assetW = assetW_Multiple;
    } else {
      assetW = assetW_Single;
    }
  }
  /**
   ** setToggleButtonHeader:
   ** -if toggleFlag=false, then toggleButtonHeader=toggleButtonHeaderSingle [displays button header to toggle to single quantity asset view]
   ** -else, toggleButtonHeader=toggleButtonHeaderMultiple [displays button header to toggle to multiple quantity asset view]
   **/
  public void setToggleButtonHeader() {
    if (!toggleFlag) {
      this.toggleButtonHeader = toggleButtonHeaderSingle;
    } else {
      this.toggleButtonHeader = toggleButtonHeaderMultiple;
    }
  }
  /**
  When we are in lightning mode, the iframe url has a parameter exp=LE (meaning lighrning experience). 
  So, if we are in Visual Force Classic, that parameter is not existent, which equals null. Depeneding
  on these conditions, the variable Lighning will be set to true or false.   
  **/
  public void checkLE() {
    if (ApexPages.currentPage().getParameters().get('exp') == null) {
      Lightning = false;
      return;
    }
    Lightning = true;
  }
  /**
   ** setOLIS: runs query on Opportunity Line Item table to retrieve products on opportunity 
   **/
  public void setOLIS() {
    try {
      olis = ProductsToAssetsUtil.getOlis(this.opportunity.ID);
      // For debugging purposes only
      if (throwException) throw new InnerException(ManualException);
    } catch (DmlException e) {
      for (Integer i = 0; i < e.getNumDml(); i++)
        if (isDebug) System.debug(e.getDmlMessage(i));
      throw new InnerException(e);
    } catch (InnerException e) {
      if (isDebug) System.debug(e.getMessage());
      throw e;
    }
  }
  /**
   ** setConvertedAssets: runs query against Assets table to retreive already converted assets against the account for read-only view.
   **/
  public void setConvertedAssets() {
    try {
      this.convertedAssets = ProductsToAssetsUtil.getConvertedAssets(this.opportunity.ID);
      convertedAssetsMap = ProductsToAssetsUtil.getConvertedAssetsMap(this.opportunity.ID);
      // For debugging purposes only
      if (throwException) throw new InnerException(ManualException);
    } catch (DmlException e) {
      for (Integer i = 0; i < e.getNumDml(); i++)
        if (isDebug) System.debug(e.getDmlMessage(i));
      throw new InnerException(e);
    } catch (InnerException e) {
      if (isDebug) System.debug(e.getMessage());
      throw e;
    }
  }
  /**
   ** setAssetWrapperList: creates the single quantity asset list, and the multiple quanity list view
   ** -Depending on the toggleFlag, one or the other will be displayed.
   **/
  public void setAssetWrapperList() {
    try {
      Integer counter = 0;
      Asset a1, b1;
      if (this.sumOfQuantities > 1000) {
        this.renderMultipleAssetButton = false;
      }
      for (OpportunityLineItem o: olis) {
        a1 = ProductsToAssetsUtil.getAssetFromOli(opportunity.Id, o, account.Id);
        Integer convertedAssetsQuantity = convertedAssetsMap.get(o.Id) == null ? 0 : convertedAssetsMap.get(o.Id);
        if (a1.Quantity > 0) {
          assetW_Multiple.add(new AssetWrapper(a1, o.Id));
        }
        this.sumOfQuantities += a1.Quantity.intValue();
        b1 = a1.clone();
        if (o.Quantity > 1.00) {
          b1.Quantity = 1.00;
          b1.Price = (o.TotalPrice - (convertedAssetsQuantity * (o.TotalPrice / o.Quantity))) / (o.Quantity.intValue() - convertedAssetsQuantity == 0 ? 1 : o.Quantity.intValue() - convertedAssetsQuantity);
        }
        if (this.renderMultipleAssetButton) {
          counter = o.Quantity.intValue() - convertedAssetsQuantity;
          for (Integer i = 0; i < counter; i++) {
            assetW_Single.add(new AssetWrapper(b1.clone(), o.Id));
          }
        }
      }
      // For debugging purposes only
      if (throwException) throw new InnerException(ManualException);
    } catch (Exception e) {
      if (isDebug) System.debug(e.getMessage());
      throw e;
    }
  }
  /**
   ** setAssetLists: creates the final asset list to be upserted 
   **/
  public void setAssetLists() {
    try {
      assets = new List < Asset > ();
      for (AssetWrapper aW1: assetW) {
        if (aW1.getIsAssetSelected())
          assets.add(aW1.getAsset().clone());
      }
      // For debugging purposes only
      if (throwException) throw new InnerException(ManualException);
    } catch (Exception e) {
      if (isDebug) System.debug(e.getMessage());
      throw e;
    }
  }
  // PageReference Methods for handling buttons on the VF page
  /** 
   ** Cancel Button
   **/
  public PageReference cancel() {
    try {
      PageReference opportunityPage = new ApexPages.StandardController(opportunity).view();
      opportunityPage.setRedirect(true);
      // For debugging purposes only
      if (throwException) throw new InnerException(ManualException);
      return opportunityPage;
    } catch (Exception e) {
      if (isDebug) System.debug(e.getMessage());
      throw e;
    }
  }
  /**
   ** Toggle Button - 'View Single Asset Quantities' / 'View Multiple Asset Quantities'
   **/
  public PageReference toggleView() {
    try {
      if (toggleFlag) {
        System.debug('Toggle: true');
        this.toggleButtonHeader = toggleButtonHeaderSingle;
        assetW = assetW_Multiple;
        toggleFlag = false;
        System.debug(this.toggleButtonHeader);
      } else {
        System.debug('Toggle: false');
        this.toggleButtonHeader = toggleButtonHeaderMultiple;
        assetW = assetW_Single;
        toggleFlag = true;
        System.debug(this.toggleButtonHeader);
      }
      assetStatus.Status = null;
      // For debugging purposes only
      if (throwException) throw new InnerException(ManualException);
      return null;
    } catch (Exception e) {
      if (isDebug) System.debug(e.getMessage());
      throw e;
    }
  }
  /**
   **This method is called when the SelectAll checkbox is clicked on the Header of the table with all available
   **assets for conversion. On click, the checkbox value is set, and this method is called to determine if
   **we are selecting or deselecting all.
   */
  public PageReference selectDeselectAll() {
    if (this.selectAllCheckbox) {
      selectAll();
      return null;
    }
    deselectAll();
    return null;
  }
  /**
   ** selectAll: checks/selects all checkboxes
   **/
  public PageReference selectAll() {
    for (AssetWrapper aW: assetW) {
      aW.setIsAssetSelected(true);
    }
    return null;
  }
  /** 
   ** deslectAll: unchecks all checkboxes
   **/
  public PageReference deselectAll() {
    for (AssetWrapper aW: assetW) {
      aW.setIsAssetSelected(false);
    }
    return null;
  }
  /**
   ** selectAllStatus: Global select all picklist for Status
   **/
  public PageReference selectAllStatus() {
    for (AssetWrapper aw: AssetW) {
      aw.getAsset().Status = assetStatus.Status;
    }
    return null;
  }
  /** 
   ** Convert Button
   **/
  public PageReference convert() {
    PageReference accountPage;
    try {
      Integer num_of_assets = 0;
      // Setup the assets to be upserted
      setAssetLists();
      num_of_assets = assets.size();
      if (num_of_assets > 0) {
        // Insert or Update Assets [Upsert]
        upsert assets;
      } else {
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'ERROR: You have not selected any line items!');
        ApexPages.addMessage(myMsg);
      }
    } catch (Exception e) {
      if (isDebug) System.debug('Convert: ' + e.getMessage());
      ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, e.getMessage()));
    }
    return null;
  }
  
  //AURA STARTS HERE 
  @AuraEnabled
  public static Account getAccount(Id opportunityId) {
    return new Account(id = ([SELECT Opportunity.Account.Id FROM Opportunity WHERE Id =: opportunityId LIMIT 1])[0].Account.Id,
      Name = ([SELECT Opportunity.Account.Name FROM Opportunity WHERE Id =: opportunityId LIMIT 1])[0].Account.Name);
  }
  
  @AuraEnabled
  public static Opportunity getOpportunity(Id opportunityId) {
    Opportunity opty = [SELECT Name, StageName, Probability FROM Opportunity WHERE Id =: opportunityId LIMIT 1];
    return opty;
  }
  
  @AuraEnabled
  public static boolean productsOnOpportunity(Id opportunityId) {
    Integer numOfProducts = [Select COUNT() FROM OpportunityLineItem WHERE OpportunityId =: opportunityId];
    return numOfProducts > 0;
  }
  
  @AuraEnabled
  public static List < AssetWrapper > getMultiple(Id opportunityId) {
    List < AssetWrapper > assetW_Multiple = new List < AssetWrapper > ();
    Map < String, Integer > convertedAssetsMap = ProductsToAssetsUtil.getConvertedAssetsMap(opportunityId);
    String accountId = ([SELECT Opportunity.Account.Id FROM Opportunity WHERE Id =: opportunityId LIMIT 1])[0].Account.Id;
    for (OpportunityLineItem o: ProductsToAssetsUtil.getOlis(opportunityId)) {
      Asset a1 = ProductsToAssetsUtil.getAssetFromOli(opportunityId, o, accountId);
      if (a1.Quantity > 0) {
        assetW_Multiple.add(new AssetWrapper(a1, o.Id));
      }
    }
    return assetW_Multiple;
  }
  
  @AuraEnabled
  public static List < AssetWrapper > getSingle(Id opportunityId) {
    List < AssetWrapper > assetW_Single = new List < AssetWrapper > ();
    Map < String, Integer > convertedAssetsMap = ProductsToAssetsUtil.getConvertedAssetsMap(opportunityId);
    String accountId = ([SELECT Opportunity.Account.Id FROM Opportunity WHERE Id =: opportunityId LIMIT 1])[0].Account.Id;
    for (OpportunityLineItem o: ProductsToAssetsUtil.getOlis(opportunityId)) {
      Integer convertedAssetsQuantity = convertedAssetsMap.get(o.Id) == null ? 0 : convertedAssetsMap.get(o.Id);
      Asset b1 = ProductsToAssetsUtil.getAssetFromOli(opportunityId, o, accountId);
      if (o.Quantity > 1.00) {
        b1.Quantity = 1.00;
        b1.Price = (o.TotalPrice - (convertedAssetsQuantity * (o.TotalPrice / o.Quantity))) / (o.Quantity.intValue() - convertedAssetsQuantity == 0 ? 1 : o.Quantity.intValue() - convertedAssetsQuantity);
      }
      Integer counter = o.Quantity.intValue() - convertedAssetsQuantity;
      for (Integer i = 0; i < counter; i++) {
        assetW_Single.add(new AssetWrapper(b1.clone(), o.Id));
      }
    }
    return assetW_Single;
  }
  
  @AuraEnabled
  public static List < Asset > getConvertedAssets(Id opportunityId) {
    String accountId = ([SELECT Opportunity.Account.Id FROM Opportunity WHERE Id =: opportunityId LIMIT 1])[0].Account.Id;
    return ProductsToAssetsUtil.getConvertedAssets(opportunityId);
  }
  
  @AuraEnabled
  public static Integer getNumberOfConvertedAssets(Id opportunityId) {
    return ProductsToAssetsUtil.getTotalOfConvertedAssets(opportunityId);
  }
  
  @AuraEnabled
  public static List < String > assetPicklistValues()
  {
    List < String > options = new List < String > ();
    Schema.DescribeFieldResult fieldResult =
      Asset.Status.getDescribe();
    List < Schema.PicklistEntry > ple = fieldResult.getPicklistValues();
    for (Schema.PicklistEntry f: ple)
    {
      options.add(f.getValue());
    }
    return options;
  }
  
  
  @AuraEnabled
  public static void convert(String assetsToConvert) {
    List < AssetWrapper > ARLI = (AssetWrapper[]) JSON.deserialize(assetsToConvert, List < AssetWrapper > .class);
    try {
      List < Asset > assets = new List < Asset > ();
      Integer num_of_assets = 0;
      for (AssetWrapper aW1: ARLI) {
        if (aW1.getIsSelected()) {
          assets.add(aW1.getTheAsset());
        }
      }
      num_of_assets = assets.size();
      if (num_of_assets > 0) {
        // Insert or Update Assets [Upsert]
        upsert assets;
      } else {
        throw new AuraHandledException('No assets were selected for conversion.');
      }
    } catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, e.getMessage()));
    }
  }
  
  //Used by lightning component only. 
  @AuraEnabled 
  public static String getFieldLabels(){     
    Map<String, String> fieldsAndLabels = new Map<String, String>();
	Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
	
	Schema.SObjectType assetFieldSchema = schemaMap.get('Asset');
	
	Map<String, Schema.SObjectField> fieldMap = assetFieldSchema.getDescribe().fields.getMap();
	for (String fieldName: fieldMap.keySet()) {
		fieldsAndLabels.put(fieldName,fieldMap.get(fieldName).getDescribe().getLabel());		
	}
	
	Schema.SObjectType product2Schema = schemaMap.get('Product2');	
	fieldsAndLabels.put('ProductName', product2Schema.getDescribe().fields.getMap().get('Name').getDescribe().getLabel());     
    return JSON.serialize(fieldsAndLabels); 
  }
}