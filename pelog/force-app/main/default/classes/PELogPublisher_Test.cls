@isTest
private class PELogPublisher_Test {
 
    static testMethod void debug() {
        PELog_TestDataFactory.createLogConfig (false);

        List<PELog__e> logEvents = PELogPublisher.debug('test');

        System.assertEquals(1, logEvents.size());

        PELog__e logEvent = logEvents[0];
        System.assertEquals('test', logEvent.msg__c);
        
    }

    //TODO - move to another class
    static testMethod void isMoreVerbose() {
        System.assert(PELogConfigurator.isMoreVerbose('FINEST','NONE'));
        System.assert(!PELogConfigurator.isMoreVerbose('FINEST','FINEST'));
        System.assert(!PELogConfigurator.isMoreVerbose('INFO','DEBUG'));
    }


    //TODO - move to another class
    static testMethod void getCategoryLevels_WithoutCurrentUser() {

        // we create a test without the current user specified in any lines and expect a less verbose logging level
        PELog_TestDataFactory.createLogConfig (false);

        PELogConfigurator logConfigurator = new PELogConfigurator();
        logConfigurator.getCategoryLevels();

        System.assertEquals(1, PELogConfigurator.hmCategoryLevels.size());
        System.assertEquals(PELogConfigurator.hmLoggingLevelOrdinals.get('FINE'), PELogConfigurator.hmCategoryLevels.get('Technical'));
        
    }

    //TODO - move to another class
    static testMethod void getCategoryLevels_WithCurrentUser() {

        // we create a test with the current user specified in any lines and expect a more verbose logging level
        PELog_TestDataFactory.createLogConfig (true);

        PELogConfigurator logConfigurator = new PELogConfigurator();
        logConfigurator.getCategoryLevels();

        System.assertEquals(1, PELogConfigurator.hmCategoryLevels.size());
        System.assertEquals(PELogConfigurator.hmLoggingLevelOrdinals.get('FINEST'), PELogConfigurator.hmCategoryLevels.get('Technical'));
        
    }

    static testMethod void isPublishable() {

        // we create a test without the current user specified in any lines and expect a less verbose logging level
        PELog_TestDataFactory.createLogConfig (false);

        System.assert(PELogPublisher.isPublishable(LoggingLevel.DEBUG, 'Technical'));
        System.assert(PELogPublisher.isPublishable(LoggingLevel.FINE, 'Technical'));
        System.assert(!PELogPublisher.isPublishable(LoggingLevel.FINER, 'Technical'));
        
    }


}
