@isTest
public with sharing class TestVerifyDate {
@IsTest
    static void testCheckDates(){
        Date todayDate = date.today();
        Date testDate = VerifyDate.CheckDates(date.today(), date.today() - 5);
        Integer totalDays = Date.daysInMonth(todayDate.year(), todayDate.month());
		Date lastDay = Date.newInstance(todayDate.year(), todayDate.month(), totalDays);
        System.assertEquals(testDate, lastDay);

        Date testDate2 = VerifyDate.CheckDates(date.today(), date.today() + 5);
        System.assertEquals(date.today() + 5, testDate2);
    }
}
