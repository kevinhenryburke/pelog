//TODO Class needs to be a singleton

public with sharing class PELogConfigurator {

    public static Map<String, Integer> hmLoggingLevelOrdinals = new Map<String, Integer>();  
    public static Map<String, Integer> hmCategoryLevels = new Map<String, Integer>();  
    public static boolean categoryLevelsCalculated = false;

    static {
        // Use numbers throughout for Logging Level comparisons

        // Terminology: Highest and Lowest Logging Levels are confusing. 
        // We'll use verbose as our term, "FINEST" is the most verbose, "NONE" is the least.
        // Following levels are from least verbose (None) to most verbose (Finest)

        hmLoggingLevelOrdinals.put('NONE',0); 
        hmLoggingLevelOrdinals.put('ERROR',1); 
        hmLoggingLevelOrdinals.put('WARN',2); 
        hmLoggingLevelOrdinals.put('INFO',3); 
        hmLoggingLevelOrdinals.put('DEBUG',4); 
        hmLoggingLevelOrdinals.put('FINE',5); 
        hmLoggingLevelOrdinals.put('FINER',6); 
        hmLoggingLevelOrdinals.put('FINEST',7); 
    }

    public static boolean isMoreVerbose (LoggingLevel logLevel, String compareTo) {
        return isMoreVerbose(String.valueOf(logLevel),compareTo);
    }

    public static boolean isMoreVerbose (LoggingLevel logLevel, Integer compareToInteger) {
        return isMoreVerbose(String.valueOf(logLevel),compareToInteger);
    }

    public static boolean isMoreVerbose (String current, String compareTo) {
        Integer compareToInteger = hmLoggingLevelOrdinals.get(compareTo);
        return isMoreVerbose(current,compareToInteger);
    }

    public static boolean isMoreVerbose (String current, Integer compareToInteger) {
        return hmLoggingLevelOrdinals.get(current) > compareToInteger;
    }

    /*  
        Calculate the debug logging levels of each category for the current user. 
        If already calculated in this execution context then no need to repeat.
    */

    public static void getCategoryLevels () { 
        if (!categoryLevelsCalculated) {
            List<PELogConfig__c> listConfig = 
                [select id, Category__c, LoggingLevel__c, User__c 
                from PELogConfig__c
                where User__c = :UserInfo.getUserName() or User__c = 'All']; 

            for (PELogConfig__c configItem : listConfig) {
                if (hmCategoryLevels.keySet().contains(configItem.Category__c)) {
                    if (isMoreVerbose(configItem.LoggingLevel__c, hmCategoryLevels.get(configItem.Category__c))) {
                        hmCategoryLevels.put(configItem.Category__c, hmLoggingLevelOrdinals.get(configItem.LoggingLevel__c));
                    }
                }
                else {
                    hmCategoryLevels.put(configItem.Category__c, hmLoggingLevelOrdinals.get(configItem.LoggingLevel__c));
                }
            }
        }
    }



}
