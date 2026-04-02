public class XDO_MDC_GenieHighlightCardCT {
    
    @AuraEnabled
    public static Contact getContact (Id currentRecord) {
        String sObjName = currentRecord.getSObjectType().getDescribe().getName();
        DescribeSObjectResult describeResult = Contact.sObjectType.getDescribe();
        List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());
        
        if(sObjName == 'Contact'){
            return Database.query('Select ' + String.join(fieldNames, ',') + ' From Contact Where Id =:currentRecord');    
        } else if(sObjName == 'Account'){
            return Database.query('Select ' + String.join(fieldNames, ',') + ' From Contact where Account.Id = :currentRecord');   
        } else if(sObjName == 'Case'){
            return Database.query('Select ' + String.join(fieldNames, ',') + ' From Contact where Id in (Select ContactId from Case where Id = :currentRecord)');            
        } else {
            return null;
        }
    }  
    
    
}