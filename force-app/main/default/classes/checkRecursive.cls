public with sharing class checkRecursive {
    private static Boolean run = true;
    public static boolean runOnce(){
        if(run){
            run=false;
            return true;
        }else{
            return false;
        }
    }
}
