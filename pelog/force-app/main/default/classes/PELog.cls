public with sharing class PELog {
    public PELog() {
        
    }

    public static Void debug(Object msg)    {
        debug(LoggingLevel.DEBUG, msg);
    }

    public static Void debug(LoggingLevel logLevel, Object msg)    {
        System.debug(logLevel, msg);
        if (isPublishable(logLevel))
        {
            publish(logLevel, msg);
        }
    }

    @TestVisible private static boolean isPublishable (LoggingLevel logLevel) {
        return true;
    }

    @TestVisible private static void publish (LoggingLevel logLevel, Object msg) {

    }
}
