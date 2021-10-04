public with sharing class manufacturingInfoTriggerHandler {
    public static void handleInsertrigger(List<Manufacturing_Info__c> newTrigger){
        List<Car__c> newCars = new List<Car__c>();
        Map<Id,Manufacturing_Info__c> cars2Update = new Map<Id,Manufacturing_Info__c>();
        Map<Manufacturing_Info__c, Car__c> MIToCar = new Map<Manufacturing_Info__c, Car__c>();
        for(Manufacturing_Info__c MI:newTrigger){
            if(MI.car__c == null){
                Car__c newCar = new Car__c(
                    name='default name', 
                    production_start__c=MI.manufacturing_start_date__c
                    );
                newCars.add(newCar);
                MIToCar.put(MI, newCar);
            }else{
                cars2Update.put(MI.Car__c, MI);
            }
        }
        insert newCars;
        for(Manufacturing_Info__c MI:MIToCar.keySet()){
            MI.car__c = MIToCar.get(MI).Id;
        }
        List<Car__c> cars = [SELECT Id, production_start__c FROM Car__c WHERE Id IN :cars2Update.keySet()];
        for(Car__c c:cars){
            Manufacturing_Info__c MI = cars2Update.get(c.Id);
            c.production_start__c = MI.manufacturing_start_date__c;
        }
        update cars;
    }

    public static void handleUpdateTrigger(List<Manufacturing_Info__c> newTrigger, Map<Id, Manufacturing_Info__c> oldMap){
        List<Manufacturing_Info__c> MI2Update = new List<Manufacturing_Info__c>();
        for(Manufacturing_Info__c MI : newTrigger){
            if(oldMap.get(MI.Id).manufacturing_start_date__c != MI.manufacturing_start_date__c){
                MI2Update.add(MI);
            }
        }
        Map<Id,Manufacturing_Info__c> cars2Update = new Map<Id,Manufacturing_Info__c>();
        for(Manufacturing_Info__c MI:MI2Update){
            cars2Update.put(MI.Car__c, MI);
        }
        List<Car__c> cars = [SELECT Id, production_start__c FROM Car__c WHERE Id IN :cars2Update.keySet()];
        for(Car__c c:cars){
            Manufacturing_Info__c MI = cars2Update.get(c.Id);
            c.production_start__c = MI.manufacturing_start_date__c;
        }
        update cars;
    }
    
}
