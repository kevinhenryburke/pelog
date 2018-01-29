@isTest
private class PELog_Test {
 
    static testMethod void debug() {
        List<PELog__e> logEvents = PELog.debug('test');

        System.assertEquals(1, logEvents.size());

        PELog__e logEvent = logEvents[0];
        System.assertEquals('test', logEvent.msg__c);
        
    }

}
