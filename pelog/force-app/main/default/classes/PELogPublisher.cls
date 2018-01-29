public with sharing class PELogPublisher {

    // TODO - efficiency gain - if global off / user off then no need to check further
    // Have separate packages for publishing (one) and subscribers (many)

    // Add a method to post from process builder


    List<PELog__e> logEvents = new List<PELog__e>();    

    /**
    public debug() method which has the same signature as apex log events
    */ 

    public static List<PELog__e> debug(Object msg)    {
        return debug(LoggingLevel.DEBUG, msg);
    }

    /**
    public debug() method which has the same signature as apex log events.
    As Apex System.debug calls are all technical in nature, the Category is defaulted to "Technical"
    */ 
    
    public static List<PELog__e> debug(LoggingLevel logLevel, Object msg)    {
        return debug(logLevel, msg, 'Technical'); 
    }

    /**
    */ 
    
    public static List<PELog__e> debug(Object msg, String category)    {
        return debug(LoggingLevel.DEBUG, msg, category); 
    }

    /**
    */ 
    
    public static List<PELog__e> debug(LoggingLevel logLevel, Object msg, String category)    {
        System.debug(logLevel, msg);
        if (isPublishable(logLevel))
        {
            if (isPublishNow(logLevel))
            {
                return publish(logLevel, msg, category);
            }
        }
        return null;
    }

    /**
    Determine if a log event should be published. 
    1. Is there a global switch on - if not return false
    2. Is there a per user switch on within the timeframe
    3. If a class is specified in the setting then
    
    The custom settings will have user / time
     - setting for add me
    timeout
    */

    @TestVisible private static boolean isPublishable (LoggingLevel logLevel) {
        return true;
    }

    @TestVisible private static boolean isPublishNow (LoggingLevel logLevel) {
        return true;
    }

    @TestVisible private static List<PELog__e> publish (LoggingLevel logLevel, Object msg, String category) {
        PELog__e logEvent = new PELog__e();
        logEvent.msg__c = serialize(msg);
        logEvent.logginglevel__c = String.valueOf(logLevel);   
        logEvent.Category__c = category;
        List<PELog__e> logEvents = new List<PELog__e>{logEvent};

        // Call method to publish events
        List<Database.SaveResult> results = EventBus.publish(logEvents);

        for (Database.SaveResult sr : results) {
            if (sr.isSuccess()) {
                return logEvents;
            } else {
                for(Database.Error err : sr.getErrors()) {
                    System.debug('Error returned: ' +
                                err.getStatusCode() +
                                ' - ' +
                                err.getMessage());
                }
            }       
        }
        return null;
    }

    /*
    serialize an object
    TODO if the object is a string then pass it through as a string
    */

    @TestVisible private static String serialize (Object msg) {
        if (msg instanceof String)
        {
            return String.valueOf(msg);
        }
        return JSON.serialize(msg);
    }
    


}
