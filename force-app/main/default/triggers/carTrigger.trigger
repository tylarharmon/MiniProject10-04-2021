trigger carTrigger on car__c (after insert, before update) {
    if(checkRecursive.runOnce()){
        if(Trigger.isAfter){
            carTriggerHandler.handleInsertrigger(trigger.new);
        }
        if(Trigger.isBefore){
            carTriggerHandler.handleUpdateTrigger(trigger.newMap, trigger.old);
        }
    }
}