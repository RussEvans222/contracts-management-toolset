public class XDO_MDC_CustomActivityController {
  
    @AuraEnabled
    public static List <xDO_MDC_Custom_Activity__c> getActivitiesForContact(Id recordId) {
        
                
        List<xDO_MDC_Custom_Activity__c> a = [
            SELECT Id,Name,xDO_MDC_message__c,xDO_MDC_icon__c,xDO_MDC_Icon_Color__c,xDO_MDC_days_ago__c,xDO_MDC_time__c,xDO_MDC_order__c
            FROM xDO_MDC_Custom_Activity__c
            WHERE xDO_MDC_Contact__c = :recordId
            ORDER BY xDO_MDC_days_ago__c,xDO_MDC_order__c DESC
            
        ];
        
        return a;
    }
    
    @AuraEnabled
    public static List <xDO_MDC_Custom_Activity__c> getActivitiesForAccount(Id recordId) {
                        
        List<xDO_MDC_Custom_Activity__c> a = [
            SELECT Id,Name,xDO_MDC_message__c,xDO_MDC_icon__c,xDO_MDC_Icon_Color__c,xDO_MDC_days_ago__c,xDO_MDC_time__c,xDO_MDC_order__c
            FROM xDO_MDC_Custom_Activity__c
            WHERE xDO_MDC_Contact__c in (SELECT PersonContactId FROM Account WHERE Id = :recordId)
            ORDER BY xDO_MDC_days_ago__c,xDO_MDC_order__c DESC
            
        ];
        
        return a;
    }
    
    @AuraEnabled
    public static Account getContactForAccount (Id recordId) {
        
        Account a = [SELECT PersonContactId FROM Account where Id = :recordId ];
         return a;
                
        
    }
    
   
}