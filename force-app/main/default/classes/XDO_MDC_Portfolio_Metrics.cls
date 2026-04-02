public class XDO_MDC_Portfolio_Metrics {

    @AuraEnabled(cacheable=true)
    public static Contact getContactMetrics(String conId) {
        return [SELECT Id, xDO_MDC_Cust360_Metric3__c,xDO_MDC_Propensity_to_Churn__c FROM Contact WHERE  Id = :conId ];
    }

     @AuraEnabled(cacheable=true)
    public static Contact getContactPropensityMetric(String conId) {
        return [SELECT Id ,xDO_MDC_Propensity_to_Churn__c FROM Contact WHERE  Id = :conId ];
    }
}