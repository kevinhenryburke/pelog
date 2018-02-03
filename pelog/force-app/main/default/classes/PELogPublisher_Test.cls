@isTest
private class PELogPublisher_Test {
 
    static testMethod void debug() {

        // we create a test without the current user specified in any lines and expect a less verbose logging level
        PELog_TestDataFactory.createLogConfig (false, false);

        List<PELog__e> logEvents = PELogPublisher.debug('test');

        System.assertEquals(1, logEvents.size());

        PELog__e logEvent = logEvents[0];
        System.assertEquals('test', logEvent.msg__c);
        
    }

    static testMethod void isPublishable_OneCategory() {

        // we create a test without the current user specified in any lines and expect a less verbose logging level
        PELog_TestDataFactory.createLogConfig (false, false);

        // FINER and less verbose levels should be publishable, the most verbose levels are not
        System.assert(PELogPublisher.isPublishable(LoggingLevel.ERROR, 'Technical'));
        System.assert(PELogPublisher.isPublishable(LoggingLevel.WARN, 'Technical'));
        System.assert(PELogPublisher.isPublishable(LoggingLevel.INFO, 'Technical'));
        System.assert(PELogPublisher.isPublishable(LoggingLevel.DEBUG, 'Technical'));
        System.assert(PELogPublisher.isPublishable(LoggingLevel.FINE, 'Technical'));
        System.assert(!PELogPublisher.isPublishable(LoggingLevel.FINER, 'Technical'));
        System.assert(!PELogPublisher.isPublishable(LoggingLevel.FINEST, 'Technical'));
        
    }

    static testMethod void isPublishable_MultipleCategories() {

        // we create a test with the current user specified in any lines and expect a more verbose logging level
        // we also create a second category which will have a separate logging level associated
        PELog_TestDataFactory.createLogConfig (true, true);

        // FINEST and less verbose levels should be publishable for the Technical category
        System.assert(PELogPublisher.isPublishable(LoggingLevel.ERROR, 'Technical'));
        System.assert(PELogPublisher.isPublishable(LoggingLevel.WARN, 'Technical'));
        System.assert(PELogPublisher.isPublishable(LoggingLevel.INFO, 'Technical'));
        System.assert(PELogPublisher.isPublishable(LoggingLevel.DEBUG, 'Technical'));
        System.assert(PELogPublisher.isPublishable(LoggingLevel.FINE, 'Technical'));
        System.assert(PELogPublisher.isPublishable(LoggingLevel.FINER, 'Technical'));
        System.assert(PELogPublisher.isPublishable(LoggingLevel.FINEST, 'Technical'));

        // FINEST and less verbose levels should be publishable for the Technical category
        System.assert(PELogPublisher.isPublishable(LoggingLevel.ERROR, 'Business'));
        System.assert(PELogPublisher.isPublishable(LoggingLevel.WARN, 'Business'));
        System.assert(PELogPublisher.isPublishable(LoggingLevel.INFO, 'Business'));
        System.assert(PELogPublisher.isPublishable(LoggingLevel.DEBUG, 'Business'));
        System.assert(!PELogPublisher.isPublishable(LoggingLevel.FINE, 'Business'));
        System.assert(!PELogPublisher.isPublishable(LoggingLevel.FINER, 'Business'));
        System.assert(!PELogPublisher.isPublishable(LoggingLevel.FINEST, 'Business'));
        
    }


}
