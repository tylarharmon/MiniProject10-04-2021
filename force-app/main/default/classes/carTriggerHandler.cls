public with sharing class carTriggerHandler {
    public static void handleInserTrigger(List<Car__c> newTrigger){
        List<Manufacturing_Info__c> newMI = new List<Manufacturing_Info__c>();
        for(Car__c car:newTrigger){
            newMI.add(new Manufacturing_Info__c(
                name='default name', 
                manufacturing_start_date__c=car.production_start__c, 
                car__c=car.Id
                ));
        }
        insert newMI;
    }

    public static void handleUpdateTrigger(Map<Id, Car__c> newMap, List<Car__c> oldTrigger){
        List<Car__c> Car2Update = new List<Car__c>();
        for(Car__c c : oldTrigger){
            if(newMap.get(c.Id).production_start__c != c.production_start__c){
                Car2Update.add(c);
            }
        }
        List<Car__c> MI2Update = [SELECT Id, (SELECT Id, Manufacturing_Start_Date__c FROM Manufacturing_Info__r)
                                 FROM Car__c WHERE Id IN :oldTrigger];
        List<Manufacturing_Info__c> MIs = new List<Manufacturing_Info__c>();
        for(Car__c c:MI2Update){
            for(Manufacturing_Info__c MI:c.Manufacturing_Info__r){
                MI.manufacturing_start_date__c = newMap.get(c.Id).production_start__c;
                MIs.add(MI);
            }
        }
        update MIs;
    }
}