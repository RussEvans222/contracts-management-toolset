public with sharing class XDO_MDC_customRelatedListCtrl {

    @AuraEnabled
    public static void insertListRec(xDO_MDC_customListRecord__c listRec){
        try {
            insert listRec;
            system.debug('listRec'+listRec);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<xDO_MDC_customListHeaders__c> getListHeaders(Id recordId) {
        return [
                SELECT
                    Id, List_Name__c, List_Title__c, Column_1_Header__c, Column_2_Header__c, Column_3_Header__c, Column_4_Header__c, Column1_Data_Type__c, Column2_Data_Type__c, Column3_Data_Type__c, Column4_Data_Type__c, Related_Record_Id__c, List_Icon__c, Icon_Background_Color__c, List_Subheader__c
                FROM
                    xDO_MDC_customListHeaders__c
                WHERE
                    Related_Record_Id__c = :recordId
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<xDO_MDC_customListRecord__c> getListRecords(Id recordId) {
        return [
                SELECT
                    Id, List_Name__c, Column_1_Value__c, Column_2_Value__c, Column_3_Value__c, Column_4_Value__c, Related_Record_Id__c
                FROM
                    xDO_MDC_customListRecord__c
                WHERE
                    Related_Record_Id__c = :recordId
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<xDO_MDC_customListRecord__c> getLstRecords(Id recordId) {
        return [
                SELECT
                    Id, List_Name__c, Column_1_Value__c, Column_2_Value__c, Column_3_Value__c, Column_4_Value__c, Related_Record_Id__c
                FROM
                    xDO_MDC_customListRecord__c
                WHERE
                    Related_Record_Id__c = :recordId
        ];
    }

    @AuraEnabled
    public static List<xDO_MDC_customListRecord__c> deleteRecordHandler(Id recId, Id relId){
        Database.delete(recId);
        return [Select Id, Column_1_Value__c, Column_2_Value__c, Column_3_Value__c, Column_4_Value__c, 	List_Name__c, Related_Record_Id__c from xDO_MDC_customListRecord__c where Related_Record_Id__c = :relId];
    }
    

    @AuraEnabled
    public static List<xDO_MDC_customListRecord__c> saveRecordData(String recordDataString){
        List<xDO_MDC_customListRecord__c> recordList = (List<xDO_MDC_customListRecord__c>)System.JSON.deserializeStrict(recordDataString, List<xDO_MDC_customListRecord__c>.Class);
        Database.insert(recordList);
        return recordList;
    }
}