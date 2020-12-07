/**
 * @author         Comity Designs, Inc.
 * @version        3.2
 * @date           Aug 30 2017
 * @description    Test class for the Controller and Util Class
 */
@isTest // Using isTest annotation
private class ProductsToAssetsTester {
  @testSetup
  static void setupTestData() {
    //Create test Account
    Account a1 = new Account(Name = 'CTest');
    insert a1;
    // Create and Insert Opportunity
    Opportunity o1 = new Opportunity(Name = 'CTestOpp', AccountId = a1.Id, StageName = 'Closed Won', CloseDate = Date.today());
    insert o1;
    //Add products to the oppty
    Product2 prod = new Product2(Name = 'Laptop X200',
      Family = 'Hardware');
    insert prod;
    //Setup Stanard Pricebook
    Id pricebookId = Test.getStandardPricebookId();
    PricebookEntry standardPrice = new PricebookEntry(
      Pricebook2Id = pricebookId, Product2Id = prod.Id,
      UnitPrice = 10000, IsActive = true);
    insert standardPrice;
    //Custom Pricebook Entry
    Pricebook2 customPB = new Pricebook2(Name = 'Custom Pricebook', isActive = true);
    insert customPB;
    PricebookEntry customPrice = new PricebookEntry(
      Pricebook2Id = customPB.Id, Product2Id = prod.Id,
      UnitPrice = 12000, IsActive = true);
    insert customPrice;
    Id PBE_Id = customPrice.Id;
    //insert Olis for oppty
    OpportunityLineItem oli1 = new OpportunityLineItem(OpportunityId = o1.id, Quantity = 2, TotalPrice = 200, PriceBookEntryID = PBE_Id);
    insert oli1;
    OpportunityLineItem oli2 = new OpportunityLineItem(OpportunityId = o1.id, Quantity = 2, TotalPrice = 200, PriceBookEntryID = PBE_Id);
    insert oli2;
  }
  // Test Methods [Each test method is self-sufficient]
  public static testMethod void testOIDQueryParamsMissing() {
    PageReference PTAPage;
    ProductsToAssetsCtrl PTAController;
    try {
      Test.startTest();
      PTAPage = new PageReference('/apex/ProductsToAssets');
      Test.setCurrentPage(PTAPage);
      PTAController = new ProductsToAssetsCtrl(true);
      Test.stopTest();
    } catch (Exception e) {
      //System.debug(e.getMessage());
      System.AssertEquals(e.getMessage(), 'Manual Exception: OID is null!');
      //System.Assert(e.getMessage().contains('Manual Exception'));
      //System.debug('Info: AssertEquals just occured!');
    }
  }
  // Test Methods [Each test method is self-sufficient]
  public static testMethod void testOIDQueryParamsMissing2() {
    PageReference PTAPage;
    ProductsToAssetsCtrl PTAController;
    try {
      Test.startTest();
      PTAPage = new PageReference('/apex/ProductsToAssets');
      Test.setCurrentPage(PTAPage);
      PTAController = new ProductsToAssetsCtrl();
      Test.stopTest();
    } catch (Exception e) {
      //System.debug(e.getMessage());
      System.AssertEquals(e.getMessage(), 'Manual Exception: OID is null!');
      //System.debug('Info: AssertEquals just occured!');
    }
  }
  // Test Methods [Each test method is self-sufficient]
  public static testMethod void testOIDAccountMissing() {
    PageReference PTAPage;
    ProductsToAssetsCtrl PTAController;
    Opportunity o1 = new Opportunity(Name = 'CTestOpp2', StageName = 'Closed Lost', CloseDate = Date.today());
    insert o1;
    try {
      Test.startTest();
      PTAPage = new PageReference('/apex/ProductsToAssets?oid=' + o1.Id);
      Test.setCurrentPage(PTAPage);
      PTAController = new ProductsToAssetsCtrl();
      Test.stopTest();
    } catch (Exception e) {
      //System.debug(e.getMessage());
      System.AssertEquals(e.getMessage(), 'No Account found on this Opportunity. Please fix and try again.');
      //System.debug('Info: AssertEquals just occured!');
    }
  }
  @isTest
  public static void testSelectDeselectAll() {
    PageReference PTAPage;
    ProductsToAssetsCtrl PTAController;
    Account a1;
    Opportunity o1;
    PageReference opportunityPage;
    PageReference accountPage;
    Double quantity = 2.00;
    try {
      //Creating Data for the test
      //System.debug('Test Info: Starting "selectAll()" and "deselectAll()" test.');
      // Create and Insert Opportunity
      o1 = [SELECT Id FROM Opportunity LIMIT 1];
      a1 = new Account(id = ([SELECT Opportunity.Account.Id FROM Opportunity WHERE Id =: o1.Id LIMIT 1])[0].Account.Id);
      //System.debug('Test Info: testGetters - Inserted Opportunity Line Item!');
      // Run with Valid OID and Valid AID
      PTAPage = new PageReference('/apex/ProductsToAssets?oid=' + o1.Id);
      Test.setCurrentPage(PTAPage);
      Test.startTest();
      accountPage = new ApexPages.StandardController(a1).view();
      opportunityPage = new ApexPages.StandardController(o1).view();
      PTAController = new ProductsToAssetsCtrl(true);
      //System.debug('Test Info: Running "selectAll()"');
      PTAController.selectAll();
      for (AssetWrapper a: PTAController.assetW) {
        System.assertEquals(true, a.getIsAssetSelected());
      }
      //System.debug('Test Info: Running "deselectAll()"');
      PTAController.deselectAll();
      for (AssetWrapper a: PTAController.assetW) {
        System.assertEquals(false, a.getIsAssetSelected());
      }
      PTAController.selectAllCheckbox = false;
      PTAController.selectDeselectAll();
      for (AssetWrapper a: PTAController.assetW) {
        System.assertEquals(false, a.getIsAssetSelected());
      }
      PTAController.selectAllCheckbox = true;
      PTAController.selectDeselectAll();
      for (AssetWrapper a: PTAController.assetW) {
        System.assertEquals(true, a.getIsAssetSelected());
      }
      PTAController.assetStatus.Status = 'Installed';
      PTAController.selectAllStatus();
      for (AssetWrapper a: PTAController.assetW) {
        System.assertEquals('Installed', a.getAsset().Status);
      }
      Test.stopTest();
      //System.debug('Test Info: select/deselect All test ended.');
    } catch (Exception e) {}
  }
  public static testMethod void testInvalidOIDQueryParam() {
    PageReference PTAPage;
    ProductsToAssetsCtrl PTAController;
    String invalidOID;
    String invalidAID;
    Boolean flag;
    try {
      invalidOID = '006123456789123';
      invalidAID = '001A123456789123';
      // Run with Invalid OID
      PTAPage = new PageReference('/apex/ProductsToAssets?oid=' + invalidOID);
      Test.setCurrentPage(PTAPage);
      Test.startTest();
      PTAController = new ProductsToAssetsCtrl(true);
      Test.stopTest();
    } catch (Exception e) {
      //System.debug('Wanted Excpetion Caught: ' + e.getMessage());
      System.AssertEquals(e.getMessage(), 'Invalid id: 006123456789123');
      //System.debug('Test Info: AssertEquals just occured!');
    }
  }
  public static testMethod void testButtons() {
    // Testing Cancel, gotoAccount, convert, Toggle View
    PageReference PTAPage;
    ProductsToAssetsCtrl PTAController;
    Account a1;
    Opportunity o1;
    PageReference opportunityPage;
    PageReference accountPage;
    Double quantity = 2.00;
    try {
      // Create and Insert Account
      o1 = [SELECT Id FROM Opportunity LIMIT 1];
      a1 = new Account(id = ([SELECT Opportunity.Account.Id FROM Opportunity WHERE Id =: o1.Id LIMIT 1])[0].Account.Id);
      // Run with Valid OID and Valid AID
      PTAPage = new PageReference('/apex/ProductsToAssets?oid=' + o1.Id);
      Test.setCurrentPage(PTAPage);
      //System.debug('testButtons() PTA Page created');
      Test.startTest();
      //System.debug('testButtons() Test Started');
      accountPage = new ApexPages.StandardController(a1).view();
      opportunityPage = new ApexPages.StandardController(o1).view();
      PTAController = new ProductsToAssetsCtrl(true);
      //System.debug('testButtons() Testing Cancel Button Started');
      // Testing Cancel Button
      PageReference cancelPage = PTAController.cancel();
      System.AssertEquals(cancelPage.getUrl(), opportunityPage.getUrl());
      //System.debug('Test Info: Cancel Button - AssertEquals just occured!');
      // Testing convert Button without any Opportunity Line Items [including case for none selected]
      PTAController = new ProductsToAssetsCtrl(true);
      PageReference convertPage = PTAController.convert();
      System.AssertEquals(convertPage, null);
      //System.debug('Test Info: convert Button - AssertEquals just occured!');
      // Select Items so we can have a successful convert [Lets Deselect all first and then Select All]
      PageReference deselectAllPage = PTAController.deselectAll();
      PageReference selectAllPage = PTAController.selectAll();
      PTAPage = new PageReference('/apex/ProductsToAssets?oid=' + o1.Id);
      Test.setCurrentPage(PTAPage);
      //System.debug('SELECT AND DESELECT ALL');
      PTAController = new ProductsToAssetsCtrl(true);
      PTAController.getAssetW().get(0).setIsAssetSelected(true);
      // Run convert method
      convertPage = PTAController.convert();
      System.AssertEquals(convertPage.getUrl(), accountPage.getUrl());
      //System.debug('Test Info: convert Button convertPage2 - AssertEquals just occured!');
      // Testing ToggleView
      PTAController = new ProductsToAssetsCtrl(true);
      // Test 1 - ToggleView not called [Initial view should be multiple quantity asset view]
      System.assertEquals(PTAController.assetW.size(), 1.00);
      //System.debug('Test Info: Toggle Button [Test1: ToggleView not Called] - AssertEquals just occured!');
      // Test 2 - ToggleView called [Now multiple quantity assets will be broken into single quantities]
      PTAController.setToggleFlag(false);
      PageReference toggleViewPage = PTAController.toggleView();
      System.assertEquals(PTAController.getAssetW().size(), quantity);
      //System.debug('Test Info: Toggle Button [Test2: ToggleView Called once] - AssertEquals just occured!');
      // Test 3 - ToggleView called [Now multiple quantity assets view is shown again - Quantity of 1]
      PTAController.setToggleFlag(true);
      //System.debug('ToggleFlag set to true? ' + PTAController.getToggleFlag());
      toggleViewPage = PTAController.toggleView();
      System.assertEquals(PTAController.assetW.size(), 1.00);
      //System.debug('(Ending testButtons()) Test Info: Toggle Button [Test3: ToggleView Called twice] - AssertEquals just occured!');
      Test.stopTest();
    } catch (Exception e) {
      //System.debug('Unwanted Excpetion Caught: ' + e.getMessage());
    }
  }
  public static testMethod void testGetters() {
    PageReference PTAPage;
    ProductsToAssetsCtrl PTAController;
    Account a1;
    Opportunity o1;
    PageReference opportunityPage;
    PageReference accountPage;
    Double quantity = 2.00;
    try {
      o1 = [SELECT Id FROM Opportunity LIMIT 1];
      a1 = new Account(id = ([SELECT Opportunity.Account.Id FROM Opportunity WHERE Id =: o1.Id LIMIT 1])[0].Account.Id);
      //System.debug('Test Info: testGetters - Inserted Opportunity Line Item!');
      // Run with Valid OID and Valid AID
      PTAPage = new PageReference('/apex/ProductsToAssets?oid=' + o1.Id);
      Test.setCurrentPage(PTAPage);
      Test.startTest();
      accountPage = new ApexPages.StandardController(a1).view();
      opportunityPage = new ApexPages.StandardController(o1).view();
      PTAController = new ProductsToAssetsCtrl(true);
      // Test getOpportunityID
      System.assertEquals(PTAController.getOpportunityID(), o1.ID);
      //System.debug('Test Info: getOpportunityID - AssertEquals just occured!');
      // Test getAccountID
      System.assertEquals(PTAController.getAccountID(), a1.ID);
      //System.debug('Test Info: getAccountID - AssertEquals just occured!');
      // Test getAccount
      System.assertEquals(PTAController.getAccount().ID, a1.ID);
      //System.debug('Test Info: getAccount - AssertEquals just occured!');
      // Test getToggleFlag, Section Header, and Button Header
      System.assertEquals(PTAController.getToggleFlag(), false);
      //System.debug('Test Info: getToggleFlag - AssertEquals just occured!');
      System.assertEquals(PTAController.getToggleButtonHeader(), 'View Single Quantity Assets');
      //System.debug('Test Info: getToggleButtongHeader - View Single Quantity Asses : AssertEquals just occured!');
      System.assertEquals(PTAController.getOpportunity().Name, 'CTestOpp');
      System.assertEquals(PTAController.getSumOfQuantities(), 4);
      System.assertEquals(PTAController.getAssetStatus() != null, true);
      System.assertEquals(PTAController.getHasErrors(), false);
      /// Call ToggleView and Assert
      PageReference togglePage = PTAController.toggleView();
      System.assertEquals(PTAController.getToggleFlag(), true);
      //System.debug('Test Info: getToggleFlag - AssertEquals just occured!');
      System.assertEquals(PTAController.getToggleButtonHeader(), 'View Multiple Quantity Assets');
      //System.debug('Test Info: getToggleButtonHeader - View Multiple Quantity Assets : AssertEquals just occured!');
      System.assertEquals(PTAController.getAssetW().size(), 4);
      // Test getOLIS - Should be set to null before the constructor concludes
      System.assertEquals(PTAController.getOLIS(), null);
      //System.debug('Test Info: getOLIS - AssertEquals just occured!');
      // Test convertedAssets - Should be 0, since no assets were previously converted
      System.assertEquals(PTAController.getConvertedAssets().size(), 0);
      //System.debug('Test Info: getConvertedAssets - AssertEquals just occured!');
      System.assertEquals(PTAController.getConvertedAssetsCount(), 0);
      //System.debug('Test Info: getConvertedAssetsCount : AssertEquals just occured!');
      Test.stopTest();
    } catch (Exception e) {
      //System.debug('Unwanted Excpetion Caught: ' + e.getMessage());
    }
  }
  @isTest
  public static void testInitMethods() {
    PageReference PTAPage;
    ProductsToAssetsCtrl PTAController;
    Account a1;
    Opportunity o1;
    PageReference opportunityPage;
    PageReference accountPage;
    Double quantity = 2.00;
    try {
      // Create and Insert Account
      o1 = [SELECT Id FROM Opportunity LIMIT 1];
      a1 = new Account(id = ([SELECT Opportunity.Account.Id FROM Opportunity WHERE Id =: o1.Id LIMIT 1])[0].Account.Id);
      // Create and Insert an Opportunity Line Item
      //System.debug('Test Info: testGetters - Inserted Opportunity Line Item!');
      // Run with Valid OID and Valid AID
      PTAPage = new PageReference('/apex/ProductsToAssets?oid=' + o1.Id);
      Test.setCurrentPage(PTAPage);
      Test.startTest();
      accountPage = new ApexPages.StandardController(a1).view();
      opportunityPage = new ApexPages.StandardController(o1).view();
      PTAController = new ProductsToAssetsCtrl(true);
      PTAController.setAccountOpportunityName();
      PTAController.setOLIS();
      PTAController.setConvertedAssets();
      PTAController.setAssetWrapperList();
      PTAController.setToggleFlag(false);
      System.assertEquals(PTAController.getAccount().Name, 'CTest');
      System.assertEquals(PTAController.getOlis().size(), 2);
      System.assertEquals(PTAController.convertedAssets.size(), 0);
      System.assertEquals(PTAController.assetW.size(), 4);
      System.assertEquals(PTAController.getToggleFlag(), false);
      Test.stopTest();
    } catch (Exception e) {
      //System.debug('Unwanted Excpetion Caught: ' + e.getMessage());
    }
  }
  //Do we need to test Exceptions? According to some research I've done today, testing exceptions is not necessary
  public static testMethod void testExceptionBlocks() {
    PageReference PTAPage;
    ProductsToAssetsCtrl PTAController;
    Account a1;
    Opportunity o1;
    PageReference opportunityPage;
    PageReference accountPage;
    Double quantity = 2.00;
    Test.startTest();
    try {
      o1 = [SELECT Id FROM Opportunity LIMIT 1];
      a1 = new Account(id = ([SELECT Opportunity.Account.Id FROM Opportunity WHERE Id =: o1.Id LIMIT 1])[0].Account.Id);
      // Run with Valid OID and Valid AID
      PTAPage = new PageReference('/apex/ProductsToAssets?oid=' + o1.Id);
      Test.setCurrentPage(PTAPage);
      accountPage = new ApexPages.StandardController(a1).view();
      opportunityPage = new ApexPages.StandardController(o1).view();
    } catch (Exception e) {
      //System.debug(e.getMessage());
    }
    // setAccountName will throw an exception
    try {
      PTAController = new ProductsToAssetsCtrl(true);
      PTAController.setThrowException(true);
      PTAController.setAccountOpportunityName();
    } catch (Exception e) {
      //System.assertEquals(e.getMessage(), 'Manual Exception!');
      System.Assert(e.getMessage().contains('Manual Exception'));
    }
    // setOLIS will throw an exception
    try {
      PTAController = new ProductsToAssetsCtrl(true);
      PTAController.setThrowException(true);
      PTAController.setOLIS();
    } catch (Exception e) {
      //System.assertEquals(e.getMessage(), 'Manual Exception!');
      System.Assert(e.getMessage().contains('Manual Exception'));
    }
    // setConvertedAssets will throw an exception
    try {
      PTAController = new ProductsToAssetsCtrl(true);
      PTAController.setThrowException(true);
      PTAController.setConvertedAssets();
    } catch (Exception e) {
      //System.assertEquals(e.getMessage(), 'Manual Exception!');
      System.Assert(e.getMessage().contains('Manual Exception'));
    }
    // setAssetWrapperList will throw an exception
    try {
      PTAController = new ProductsToAssetsCtrl(true);
      PTAController.setOLIS();
      PTAController.setThrowException(true);
      PTAController.setAssetWrapperList();
    } catch (Exception e) {
      //System.assertEquals(e.getMessage(), 'Manual Exception!');
      System.Assert(e.getMessage().contains('Manual Exception'));
    }
    // Cancel will throw an exception
    try {
      PTAController = new ProductsToAssetsCtrl(true);
      PTAController.setThrowException(true);
      PTAController.cancel();
    } catch (Exception e) {
      //System.assertEquals(e.getMessage(), 'Manual Exception!');
      System.Assert(e.getMessage().contains('Manual Exception'));
    }
    // convert will throw an exception
    try {
      PTAController = new ProductsToAssetsCtrl(true);
      PTAController.setThrowException(true);
      PTAController.convert();
    } catch (Exception e) {
      //System.assertEquals(e.getMessage(), 'Manual Exception!');
      System.Assert(e.getMessage().contains('Manual Exception'));
    }
    // toggleView will throw an exception
    try {
      PTAController = new ProductsToAssetsCtrl(true);
      PTAController.setThrowException(true);
      PTAController.toggleView();
    } catch (Exception e) {
      //System.assertEquals(e.getMessage(), 'Manual Exception!');
      System.Assert(e.getMessage().contains('Manual Exception'));
    }
    Test.stopTest();
  }
  //Testing List Getters - the functions that return single and/or multiple quantity lists. 
  @isTest
  public static void testListGetters() {
    //System.debug('Single and Multiple Asset lists getters. Setting up test..');
    List < AssetWrapper > listSingle = new List < AssetWrapper > ();
    List < AssetWrapper > listMultiple = new List < AssetWrapper > ();
    Opportunity o = [SELECT Id, Name FROM Opportunity LIMIT 1][0];
    //System.debug('Single and Multiple Asset lists getters. Starting test..');  
    Test.startTest();
    listSingle = ProductsToAssetsCtrl.getSingle(o.Id);
    listMultiple = ProductsToAssetsCtrl.getMultiple(o.Id);
    for (AssetWrapper aw: listSingle) {
      System.assert(aw.asset.Quantity == 1);
    }
    for (AssetWrapper aw: listMultiple) {
      System.assert(aw.asset.Quantity == 2);
    }
    
    String fieldLabels = ProductsToAssetsCtrl.getFieldLabels();
    System.assert(fieldLabels.length()>10);
    
    Test.stopTest();
    //System.debug('Single and Multiple Asset lists getters. Stopping test..');
  }
  @isTest
  public static void testLEGetters() {
    //System.debug('Testing other getters. Setting up test..');
    Id oid = [SELECT Id FROM Opportunity LIMIT 1][0].Id;
    Opportunity oTest = [SELECT Name, StageName, Probability FROM Opportunity WHERE Id =: oid];
    Account accTest = new Account(id = ([SELECT Opportunity.Account.Id FROM Opportunity WHERE Id =: oid LIMIT 1])[0].Account.Id,
      Name = ([SELECT Opportunity.Account.Name FROM Opportunity WHERE Id =: oid LIMIT 1])[0].Account.Name);
    //System.debug('Testing other getters. Starting test..');
    Test.startTest();
    Opportunity oMethod = ProductsToAssetsCtrl.getOpportunity(oid);
    System.assertEquals(JSON.serialize(oTest), JSON.serialize(oMethod));
    Account accMethod = ProductsToAssetsCtrl.getAccount(oid);
    System.assertEquals(JSON.serialize(accTest), JSON.serialize(accMethod));
    System.assertEquals(true, ProductsToAssetsCtrl.productsOnOpportunity(oid));
    Test.stopTest();
    //System.debug('Testing other getters. Stopping test..');
  }
  @isTest
  public static void testGetPicklistValues() {
    //System.debug('Testing getPicklistValues() method. Setting up test..');
    List < String > picklistValues = new List < String > ();
    Map < String, String > optionsMap = new Map < String, String > ();
    Schema.DescribeFieldResult fieldResult =
      Asset.Status.getDescribe();
    List < Schema.PicklistEntry > ple = fieldResult.getPicklistValues();
    for (Schema.PicklistEntry f: ple) {
      optionsMap.put(f.getValue(), f.getValue());
    }
    //System.debug('Testing getPicklistValues() method. Starting test..');
    Test.startTest();
    picklistValues = ProductsToAssetsCtrl.assetPicklistValues();
    for (String pv: picklistValues) {
      System.assert(optionsMap.get(pv) != null);
    }
    Test.stopTest();
    //System.debug('Testing getPicklistValues() method. Stopping test..');
  }
  @isTest
  public static void testConvertAndGetConvertedAssets() {
    //System.debug('Testing Convert and GetConvertedAssets methods. Setting up test..');
    Opportunity o = [SELECT Id, Name FROM Opportunity LIMIT 1][0];
    AssetWrapper assetToConvert = ProductsToAssetsCtrl.getMultiple(o.Id).get(0);
    assetToConvert.setIsAssetSelected(true);
    String inputStringObject = '[' + JSON.serialize(assetToConvert) + ']';
    //System.debug('Testing Convert and GetConvertedAssets methods. Starting test..');
    Test.startTest();
    List < Asset > convertedAssets = ProductsToAssetsCtrl.getConvertedAssets(o.Id);
    System.assert(convertedAssets.size() == 0);
    System.assertEquals(0, ProductsToAssetsCtrl.getNumberOfConvertedAssets(o.Id));
    ProductsToAssetsCtrl.convert(inputStringObject);
    convertedAssets = ProductsToAssetsCtrl.getConvertedAssets(o.Id);
    System.assert(convertedAssets.size() == 1);
    ProductsToAssetsCtrl.convert(inputStringObject);
    Map < String, Integer > convertedMap = ProductsToAssetsUtil.getConvertedAssetsMap(o.Id);
    System.assertEquals(1, convertedMap.size());
    System.assertEquals(4, ProductsToAssetsCtrl.getNumberOfConvertedAssets(o.Id));
    Test.stopTest();
    //System.debug('Testing Convert and GetConvertedAssets methods. Stopping test..');
  }
  @isTest
  public static void testExceptions() {
    //System.debug('Testing Exceptions. Setting up test..');
    Opportunity o = [SELECT Id, Name FROM Opportunity LIMIT 1][0];
    AssetWrapper assetToConvert = ProductsToAssetsCtrl.getMultiple(o.Id).get(0);
    String inputStringObject = '[' + JSON.serialize(assetToConvert) + ']';
    //System.debug('Testing Exceptions. Starting test..');
    Test.startTest();
    try {
      ProductsToAssetsCtrl.convert(inputStringObject);
    } catch (Exception e) {
      System.assertEquals('No assets were selected for conversion.', e.getMessage());
    }
    Test.stopTest();
    //System.debug('Testing Exceptions. Stopping test..');
  }
}