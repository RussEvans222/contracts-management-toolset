public class gps_UpdateContractControllerOnChild {
@AuraEnabled
    public static List<String> getUpdatedRecord(String sourceRecordId, Boolean autoDocgen) {
        
        String childId = [SELECT Id FROM gps_FundingAwardContract__c WHERE ParentId__c = :sourceRecordId ORDER BY LastModifiedDate DESC LIMIT 1].Id;
        
        ConnectApi.ContractInputRepresentation objInput = new ConnectApi.ContractInputRepresentation();
        objInput.sourceObjectId = childId;
        objInput.isAutoDocgenRequired = autoDocgen;
        ConnectApi.ContractOutputRepresentation objOutput = ConnectApi.Clm.updateContract(objInput);
         List<String> contractData = new List<String>();
        contractData.add(objOutput.data[0]);
        return contractData;
        
    }
}