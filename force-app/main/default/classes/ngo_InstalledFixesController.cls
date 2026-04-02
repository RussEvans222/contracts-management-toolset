public with sharing class ngo_InstalledFixesController {
    @AuraEnabled(cacheable=true)
    public static List<IDO_BugFix_Installations__c> getInstalledFixes() {
        return [
            SELECT Id, Bug_Description__c, Bug_Id__c, Bug_Name__c, 
                   Finish_Time__c, Start_Time__c, Status__c, Video_URL__c 
            FROM IDO_BugFix_Installations__c 
            ORDER BY Finish_Time__c DESC NULLS LAST
        ];
    }
}