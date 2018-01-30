public with sharing class PELog_TestDataFactory {
    public PELog_TestDataFactory() {

    }

    public static List<PELogConfig__c> createLogConfig (boolean includeCurrentUser) {

        String username = UserInfo.getUserName();

        List<PELogConfig__c> listConfig = new List<PELogConfig__c>();
        listConfig.add(new PELogConfig__c(Name = 'Config1', LoggingLevel__c = 'DEBUG',Category__c = 'Technical',User__c = 'All'));
        listConfig.add(new PELogConfig__c(Name = 'Config2', LoggingLevel__c = 'FINE',Category__c = 'Technical',User__c = 'All'));
        listConfig.add(new PELogConfig__c(Name = 'Config3', LoggingLevel__c = 'FINER',Category__c = 'Technical',User__c = 'Bert@Bert.com'));
        if (includeCurrentUser) {
            listConfig.add(new PELogConfig__c(Name = 'Config4', LoggingLevel__c = 'FINEST',Category__c = 'Technical',User__c = username));
        }
        insert listConfig;
        return listConfig;
    }
}
