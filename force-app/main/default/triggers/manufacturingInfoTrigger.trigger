trigger manufacturingInfoTrigger on Manufacturing_Info__c (before insert, before update) {
    if(checkRecursive.runOnce()){
        if(trigger.isInsert){
            manufacturingInfoTriggerHandler.handleInsertrigger(trigger.new);
        }
        if(trigger.isUpdate){
            manufacturingInfoTriggerHandler.handleUpdateTrigger(trigger.new, trigger.oldMap);
        }
    }   
}