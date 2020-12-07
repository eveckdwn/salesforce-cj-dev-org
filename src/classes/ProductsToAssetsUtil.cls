/**
 * @author         Comity Designs, Inc.
 * @version        1.0
 * @date           Aug 30 2017
 * @description    Util class for the Controller for Visualforce page and Lightning Component (ProductsToAssetsCtrl)
 */
 
public with sharing class ProductsToAssetsUtil {
    
    public static List<Asset> getConvertedAssets(Id OpportunityId){
    	  
    	  String accountId = ([SELECT Opportunity.Account.Id FROM Opportunity WHERE Id =:opportunityId LIMIT 1])[0].Account.Id;
    	  
    	  return new List < Asset > ([Select Name,
      Quantity,
      Price,
      Product2.Name,
      Status,
      InstallDate,
      PurchaseDate,
      UsageEndDate,
      SerialNumber,
      Account.Name,
      Purchase_Opportunity__r.Name,
      Oli__c
      from Asset
      where Converted_Asset__c = true and
      AccountId =: accountId and
      Purchase_Opportunity__r.ID =: opportunityId
      order by CreatedDate desc
    ]);
    }
    
    public static List<OpportunityLineItem> getOlis(Id opportunityId){
    		return new List<OpportunityLineItem>([Select o.Id,
        o.IsDeleted,
        o.ListPrice,
        o.OpportunityId,
        o.Opportunity.CloseDate,
        o.PricebookEntry.Product2Id,
        o.PricebookEntryId,
        o.PricebookEntry.Name,
        o.Quantity,
        o.ServiceDate,
        o.TotalPrice,
        o.UnitPrice
        from OpportunityLineItem o
        where o.IsDeleted = false and
        o.OpportunityId =: opportunityId
      ]);
     
    }
    
    public static Map < String, Integer > getConvertedAssetsMap(Id opportunityId){
	    Map < String, Integer > convertedAssetsMap = new Map < String, Integer > ();
	    for (Asset a: getConvertedAssets(opportunityId)) {
	      if (convertedAssetsMap.get(a.Oli__c) == null) {
	        convertedAssetsMap.put(a.Oli__c, a.Quantity.intValue());
	      } else {
	        convertedAssetsMap.put(a.Oli__c, convertedAssetsMap.get(a.Oli__c) + a.Quantity.intValue());
	      }
	    }
	    return convertedAssetsMap;  	
    }
    
    public static Asset getAssetFromOli(Id opportunityId, OpportunityLineItem o, String accountId){
    	  Asset a1 = new Asset();
    	  Map < String, Integer > convertedAssetsMap = getConvertedAssetsMap(opportunityId);
    	  Integer convertedAssetsQuantity = convertedAssetsMap.get(o.Id) == null ? 0 : convertedAssetsMap.get(o.Id);
      
      a1.Name = o.PriceBookEntry.Name;
      a1.Product2Id = o.PriceBookEntry.Product2Id;
      a1.AccountId = accountId;
      a1.Purchase_Opportunity__c = opportunityId;
      a1.Contact = null;
      a1.Quantity = o.Quantity - convertedAssetsQuantity;
      a1.Price = o.TotalPrice - (convertedAssetsQuantity * (o.TotalPrice / o.Quantity));
      a1.InstallDate = o.ServiceDate;
      a1.PurchaseDate = o.Opportunity.CloseDate;
      a1.Converted_Asset__c = true;
      a1.Oli__c = o.Id;
      
      return a1;
    }
    
    public static Integer getTotalOfConvertedAssets(Id opportunityId){
	    	Map < String, Integer > convertedAssetsMap = getConvertedAssetsMap(opportunityId);
	  	Integer sum = 0;
	  	if(convertedAssetsMap.isEmpty()){
	  		return sum;
	  		
	  	}else{
	  		
	  		for(Integer num : convertedAssetsMap.values()){
	  			sum+=num;
	  		}
	  		return sum;
	  	}
    }
    
}