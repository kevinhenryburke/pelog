@IsTest
private class PELogConfigurator_Test {

    static testMethod void isMoreVerbose() {
        System.assert(PELogConfigurator.isMoreVerbose('INFO','WARN'));
        System.assert(!PELogConfigurator.isMoreVerbose('INFO','INFO'));
        System.assert(!PELogConfigurator.isMoreVerbose('INFO','DEBUG'));

        System.assert(PELogConfigurator.isMoreVerbose(LoggingLevel.INFO,'WARN'));
        System.assert(!PELogConfigurator.isMoreVerbose(LoggingLevel.INFO,'INFO'));
        System.assert(!PELogConfigurator.isMoreVerbose(LoggingLevel.INFO,'DEBUG'));

    }

    static testMethod void getCategoryLevels_WithoutCurrentUser() {

        // we create a test without the current user specified in any lines and expect a less verbose logging level
        PELog_TestDataFactory.createLogConfig (false, false);

        PELogConfigurator.getCategoryLevels();

        System.assertEquals(1, PELogConfigurator.hmCategoryLevels.size());
        System.assertEquals(PELogConfigurator.hmLoggingLevelOrdinals.get('FINE'), PELogConfigurator.hmCategoryLevels.get('Technical'));
        
    }

    static testMethod void getCategoryLevels_WithCurrentUser() {

        // we create a test with the current user specified in any lines and expect a more verbose logging level
        PELog_TestDataFactory.createLogConfig (true, true);

        PELogConfigurator.getCategoryLevels();

        System.assertEquals(2, PELogConfigurator.hmCategoryLevels.size());
        System.assertEquals(PELogConfigurator.hmLoggingLevelOrdinals.get('DEBUG'), PELogConfigurator.hmCategoryLevels.get('Business'));
        System.assertEquals(PELogConfigurator.hmLoggingLevelOrdinals.get('FINEST'), PELogConfigurator.hmCategoryLevels.get('Technical'));
        
    }

}
