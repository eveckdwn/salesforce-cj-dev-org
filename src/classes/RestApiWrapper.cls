public class RestApiWrapper {
       public class wrapperClass{
        public String code{get; set;}
        public String message{get; set;}
        public Object data{get; set;}
        public wrapperClass(Integer cd, String m, Object da){
            code = String.valueOf(cd);
            message = m;
            data = da;
        }
    }
    public class Lead{
        public string HappyTalk_ID{get;set;}
        public string LastName{get;set;}
        public string Company{get;set;}
        public string email{get;set;}
    }
        
}