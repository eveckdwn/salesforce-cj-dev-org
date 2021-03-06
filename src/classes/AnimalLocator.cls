public class AnimalLocator{
    public static String getAnimalNameById(Integer id){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/' + id);
        req.setMethod('GET');
        HttpResponse res = http.send(req);
        String name = '';
        if (res.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            Map<String, Object> animal = (Map<String, Object>) results.get('animal');
            name = (String)animal.get('name');
        }
        return name;
    }
}