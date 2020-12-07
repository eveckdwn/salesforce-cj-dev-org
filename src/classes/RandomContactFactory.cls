public class RandomContactFactory {
    public static List<Contact> generateRandomContacts(Integer i, String s){
        List<Contact> cons = new List<Contact>();
        Contact con;
        for(Integer index = 0; index < i; index++){
            con = new Contact(lastname = s, firstname = 'Test ' + index);
            cons.add(con);
        }
        
        return cons;
    }
}