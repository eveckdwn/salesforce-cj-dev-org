@RestResource(urlMapping='/UpsertLead/v1/*')
global with sharing class HappyTalk_Sync_Test {    
    global static void setResponse(Integer code, String msg, Lead record){
        String resBody = JSON.serializePretty(new RestApiWrapper.wrapperClass(code, msg, record)); 
        RestContext.response.statusCode = code;
        RestContext.response.responseBody = Blob.valueOf(resBody);
        RestContext.response.addHeader('Content-Type', 'application/json');
    }
    
    @HttpGet
    global static Lead getMethod() {
        Integer status = 200;
        String msg = '';
        //List<Lead> leadArr = [SELECT ID FROM LEAD];
        //List<RestApiWrapper.Lead> retEvents = new List<RestApiWrapper.Lead>();
        //retEvents.add(arg0);
        RestRequest restReq = RestContext.request;
        RestResponse restRes = RestContext.response;
        
        Lead obj = new Lead();
        obj.LastName = restReq.params.get('Name');
        obj.Company = restReq.params.get('company'); 
        obj.HappyTalk_ID__c = restReq.params.get('HappyTalk_ID'); 
        obj.Email = restReq.params.get('email');
        insert obj;
        setResponse(status, msg, obj);                        
        return obj;
    }       
    
    @HttpPost
    global static Lead postMethod(String Name, String company, String HappyTalk_ID,String Email) {
        Integer status = 200;
        String msg = '';
        //List<Lead> leadArr = [SELECT ID FROM LEAD];
        //List<RestApiWrapper.Lead> retEvents = new List<RestApiWrapper.Lead>();
        //retEvents.add(arg0);
        setResponse(status, msg, new Lead());                        
        Lead obj = new Lead();
        obj.LastName = Name;
        obj.Company = company;             
        obj.HappyTalk_ID__c = HappyTalk_ID; 
        obj.Email = email;
        insert obj;                   
        setResponse(status, msg, obj);                        
        return obj;
    }   
}