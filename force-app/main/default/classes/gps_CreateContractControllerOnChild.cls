public class gps_CreateContractControllerOnChild {
@AuraEnabled
    public static List<String> getCreatedRecord(String sourceRecordId, Boolean autoDocgen) {
        
        String childId = [SELECT Id FROM gps_FundingAwardContract__c WHERE ParentId__c = :sourceRecordId ORDER BY LastModifiedDate DESC LIMIT 1].Id;
       
        ConnectApi.ContractInputRepresentation objInput = new ConnectApi.ContractInputRepresentation();
        objInput.sourceObjectId = childId;
        objInput.isAutoDocgenRequired = autoDocgen;
        ConnectApi.ContractOutputRepresentation objOutput = ConnectApi.Clm.createContract(objInput);
         List<String> contractData = new List<String>();
        contractData.add(objOutput.data[0]);
         List<Contract> contractName = [SELECT Name FROM Contract WHERE Id =:objOutput.data[0]];
        contractData.add(contractName[0].Name);
        return contractData;
        
    }
}