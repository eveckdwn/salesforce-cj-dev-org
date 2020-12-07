public with sharing class LookupController {
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName) {
        system.debug('ObjectName-->' + ObjectName);
        String searchKey = '%' + searchKeyWord + '%';
        
        List < sObject > returnList = new List < sObject > ();
      
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        String sQuery = '';
        switch on ObjectName {
            when 'lead' {
                sQuery =  'SELECT Id, Name, Title, Phone, MobilePhone, Email FROM ' + ObjectName + ' WHERE Name LIKE: searchKey OR Phone LIKE: searchKey OR MobilePhone LIKE: searchKey ORDER BY createdDate DESC limit 5';
            }

            when 'contact' {
                sQuery =  'SELECT Id, Name, Title, Phone, MobilePhone, Email, Account.Name FROM ' + ObjectName + ' WHERE Name LIKE: searchKey OR Phone LIKE: searchKey OR MobilePhone LIKE: searchKey OR Account.Name LIKE: searchKey ORDER BY createdDate DESC limit 5';
            }
            
            when 'opportunity' {
                sQuery =  'SELECT Id, Name, Account.Name, StageName, Amount FROM ' + ObjectName + ' WHERE Name LIKE: searchKey OR Account.Name LIKE: searchKey ORDER BY createdDate DESC limit 5';
            }

            when 'case' {
                sQuery =  'SELECT Id, CaseNumber, Account.Name, Contact.Name, Subject FROM ' + ObjectName + ' WHERE CaseNumber LIKE: searchKey OR Subject LIKE: searchKey OR Account.Name LIKE: searchKey OR Contact.Name LIKE: searchKey ORDER BY createdDate DESC limit 5';
            }

            when else {
                sQuery =  'SELECT Id, Name FROM ' + ObjectName + ' WHERE Name LIKE: searchKey ORDER BY createdDate DESC limit 5';
            }
        }

        List < sObject > lstOfRecords = Database.query(sQuery);
        System.debug('lstOfRecords size: ' + lstOfRecords.size());

        for (sObject obj: lstOfRecords) {
            System.debug('lstOfRecords obj: ' + obj);
            returnList.add(obj);
        }
        return returnList;
    }
}