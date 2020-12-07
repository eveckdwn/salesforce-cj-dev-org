/**
 * @author         Comity Designs, Inc.
 * @version        3.2
 * @date           Aug 30 2017
 * @description    Wrapper Class for Asset Object
 */
public with sharing class AssetWrapper {
  //Variables

  @AuraEnabled
  public Boolean isAssetSelected = false;
  
  @AuraEnabled
  public Asset asset {get; set;}
  
  @AuraEnabled
  public String oliID {get; set;}
  /**
   ** Constructor
   **/
  public AssetWrapper(Asset a, String id) {
    this.setAsset(a);
    this.oliID = id;
  }
  //Getters
  

  public boolean getIsAssetSelected() {
    return this.isAssetSelected;
  }

  public Asset getAsset() {
    return this.asset;
  }

  public void setIsAssetSelected(boolean a) {
    this.isAssetSelected = a;
  }
  private void setAsset(Asset a) {
    this.asset = a;
  }
  
  @AuraEnabled
  public Asset getTheAsset(){
  	return this.asset;
  }
  
  @AuraEnabled
  public boolean getIsSelected(){
  	return this.isAssetSelected;
  }  
}