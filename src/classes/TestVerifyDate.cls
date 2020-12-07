@isTest
private class TestVerifyDate {    
    @isTest static void TestCheckDates1(){
        //	date2 < date1
        Date date1 = Date.newInstance(2018, 12, 25);
    	Date date2 = Date.newInstance(2018, 11, 29);
        Integer totalDays = Date.daysInMonth(date1.year(), date1.month());
		Date lastDay = Date.newInstance(date1.year(), date1.month(), totalDays);
        System.assertEquals(lastDay, VerifyDate.CheckDates(date1, date2));
    }  
    
    @isTest static void TestCheckDates2(){
        //	date2 >= date30days
        Date date1 = Date.newInstance(2018, 11, 29);
        Date date2 = Date.newInstance(2018, 12, 31);
        Integer totalDays = Date.daysInMonth(date1.year(), date1.month());
		Date lastDay = Date.newInstance(date1.year(), date1.month(), totalDays);
        System.assertEquals(lastDay, VerifyDate.CheckDates(date1, date2));
    }
    
    @isTest static void TestCheckDates3(){
        //	date2 < date30days
        Date date1 = Date.newInstance(2018, 11, 29);
    	Date date2 = Date.newInstance(2018, 12, 25);
        System.assertEquals(date2, VerifyDate.CheckDates(date1, date2));
    }
}