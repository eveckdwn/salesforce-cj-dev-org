public class ContactsListController {
    // Controller code goes here
    private String sortOrder = 'LastName';
    
    @AuraEnabled
    public static List<Contact> getContactList(String accountId){
        List<Contact> contactList = new List<Contact>([SELECT Id, FirstName, LastName, Name, Email, Phone FROM Contact WHERE Email != null AND AccountId =: accountId LIMIT 10]);
        return contactList;
    }

    @AuraEnabled
    public static Contact createContact(Contact con, Id AccountId){
        con.AccountId = AccountId;
        insert con;
        return con;
    }

    public List<Contact> getContacts() {
        List<Contact> results = Database.query(
            'SELECT Id, FirstName, LastName, Title, Email ' +
            'FROM Contact ' +
            'ORDER BY ' + sortOrder + ' ASC ' +
            'LIMIT 10'
        );
        return results;
    }

    public void sortByLastName() {
        this.sortOrder = 'LastName';
    }
        
    public void sortByFirstName() {
        this.sortOrder = 'FirstName';
    }
}