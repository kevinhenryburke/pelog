@isTest
private class PELogPublisher_Test {
 
    static testMethod void debug() {
        PELog_TestDataFactory.createLogConfig (false);

        List<PELog__e> logEvents = PELogPublisher.debug('test');

        System.assertEquals(1, logEvents.size());

        PELog__e logEvent = logEvents[0];
        System.assertEquals('test', logEvent.msg__c);
        
    }

    static testMethod void isPublishable() {

        // we create a test without the current user specified in any lines and expect a less verbose logging level
        PELog_TestDataFactory.createLogConfig (false);

        // everything up to FINER should be publishable, the most verbose levels are not
        System.assert(PELogPublisher.isPublishable(LoggingLevel.ERROR, 'Technical'));
        System.assert(PELogPublisher.isPublishable(LoggingLevel.WARN, 'Technical'));
        System.assert(PELogPublisher.isPublishable(LoggingLevel.INFO, 'Technical'));
        System.assert(PELogPublisher.isPublishable(LoggingLevel.DEBUG, 'Technical'));
        System.assert(PELogPublisher.isPublishable(LoggingLevel.FINE, 'Technical'));
        System.assert(!PELogPublisher.isPublishable(LoggingLevel.FINER, 'Technical'));
        System.assert(!PELogPublisher.isPublishable(LoggingLevel.FINEST, 'Technical'));
        
    }


}
