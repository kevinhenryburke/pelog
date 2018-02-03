public with sharing class PELogPublisher {

    // TODO - efficiency gain - if global off / user off then no need to check further
    // Have separate packages for publishing (one) and subscribers (many)

    // Have a Customer Metadata type for "permanent" settings and custom setting for "temporary". In code bring these together in one Map
    // The "permanent" settings should have an Event option to publish to other events. The temporary should not

    // Add a method to post from process builder
    // Add a method to post from Lightning Components.

    // Singleton pattern: http://www.tgerm.com/2010/03/apex-implementing-singleton-design.html

    // Lack of destructors kills this
    // only useful option now is to capture Apex AND Lightning console.log in same calls? not great though is it?
    // would need methods to pass back log events which defeats the zero footprint paradigm?

    List<PELog__e> logEvents = new List<PELog__e>();    

    /**
    public debug() method which has the same signature as apex log events
    As Apex System.debug calls are all technical in nature, the Category is defaulted to "Technical"
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
        if (isPublishable(logLevel, category))
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

    @TestVisible private static boolean isPublishable (LoggingLevel logLevel, String category) {
        PELogConfigurator.getCategoryLevels();
        if (PELogConfigurator.hmCategoryLevels.keyset().contains(category)) {
            // I will publish a message if the statement log level is not more verbose than the configured category
            return !PELogConfigurator.isMoreVerbose(logLevel, PELogConfigurator.hmCategoryLevels.get(category));
        }
        return false;        
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
                System.debug('published to PELog: ' + logEvents.size());
                System.debug('results ' + results);
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
