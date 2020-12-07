/*
	Create an Apex class with a method that returns an array (or list) of strings.
	Create an Apex class with a method that returns an array (or list) of formatted strings ('Test 0', 'Test 1', ...).
	The length of the array is determined by an integer parameter.
	The Apex class must be called StringArrayTest and be in the public scope
	The Apex class must have a public static method called generateStringArray
	The generateStringArray method must return an array (or list) of strings
	The method must accept an incoming Integer as a parameter, which will be used to determine the number of returned strings
	The method must return a string value in the format Test n where n is the index of the current string in the array

*/
public class StringArrayTest {
    public static List<String> generateStringArray(Integer param){
        //	Interger를 받아서 'Test + param'으로 나타내는 메서드
        
        List<String> numbers = new List<String>();
        String test = '';
        
    	// 결과값을 담는 String 리스트
    	for(Integer i = 0; i < param; i++){
    		
	    	test = 'Test ' + String.valueOf(i);
	        //	parma으로 받은 값을 String으로 변환 후, 'Test + param'으로 변경
	        
	        numbers.add(test);
	        //	String 리스트에 담는다.
    		
    	}

        
        System.debug(numbers);
        return numbers;
    }
}