/**
 * This Class managees the export and import of Inspection Types along with other Utility functions of managing Inspection Types
 * 
 * @author Jeremy Blankenship (jblankenship@salesforce.com)
 * @version 3.1
 * 
 * History
 * =======
 * v1.0 - 03-24-2021 - Initial Version
 * v2.0 - 09-07-2021 - Added in support for parsing defined values
 * v3.0 - 01-31-2022 - Migrated to Omnistudio Package
 * 
 */
 global with sharing class InspectionTemplateUtils implements Callable {
 
 // Remote Action Options
    public final static String INSPECTION_EXPORT    = 'inspection_export';      // String with entire JSON Inspection Type
    public final static String INSPECTION_NAME = 'inspection_name';   // String with name of Inspection Type
    
    public class ParsingException extends Exception {}
    
    public Object call(String action, Map<String, Object> args) {

        Map<String, Object> input = (Map<String, Object>)args.get('input');
        Map<String, Object> output = (Map<String, Object>)args.get('output');
        Map<String, Object> options = (Map<String, Object>)args.get('options');

        return invokeMethod(action, input, output, options);
    }
 
    global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options) {

        if (methodName == 'export') return export(inputMap, outputMap, options);  
        
        if (methodName == 'import') return import(inputMap, outputMap, options);
        
        if (methodName == 'getRegCodeAssessmentInd') return getRegCodeAssessmentInd(inputMap, outputMap, options);
        
        if (methodName == 'getAssessmentTaskIndDefinition') return getAssessmentTaskIndDefinition(inputMap, outputMap, options);
        
        if (methodName == 'getAssessmentIndicatorDefinedValues') return getAssessmentIndicatorDefinedValues(inputMap,outputMap,options);
        
        return false;
    }
    
    private Boolean export(Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options) {
        String inspection_export = (String)options.get(INSPECTION_EXPORT);
        String inspection_name = (String)options.get(INSPECTION_NAME);
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; 
        conVer.PathOnClient = inspection_name + '.json'; 
        conVer.Title = inspection_name; 
       
        conVer.VersionData = Blob.valueOf(inspection_export); 
        insert conVer;    
        
        //Get a random Omniscript to associate the ContentDocument.  
        Id OSId = [SELECT ID from Omniprocess LIMIT 1].Id;
        
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        //create ContentDocumentLink  record 
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = OSId; // Associate the ContentDocument to a random Omniscript
        conDocLink.ContentDocumentId = conDoc;  //ContentDocumentId Id from ContentVersion
        conDocLink.shareType = 'V';
        insert conDocLink;
        
        ContentDistribution newDist = new ContentDistribution();
        newDist.ContentVersionId = conVer.Id;
        newDist.Name = 'External Link';
        
        newDist.PreferencesNotifyOnVisit = false;
        newDist.PreferencesAllowViewInBrowser = true;
        newDist.PreferencesAllowOriginalDownload=true;
        insert newDist;
        //system.debug('createContentDistribution creted');
        //system.debug('conVer.id is ' + conVer.Id);
        //system.debug('conDoc is ' +conDoc);
        
        String DocumentURL = [SELECT ContentDownloadUrl FROM ContentDistribution WHERE ContentDocumentId = :conDoc].ContentDownloadUrl;
        //system.debug('Document URL is '+DocumentURL);  
        
        outputMap.put('ExportFileLink', DocumentURL);
         
        return true;
    }
    
    private Boolean import(Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options) {
        // Get the file(s) uploaded
         Map<String, Object> files = (Map<String, Object>)options.get('vlcFilesMap');
         String fileContent = '';
         for (String key : files.keySet()) {
             
             // Load the file content - Assumes that only one file upload
             fileContent = String.valueOf(files.get(key));
             system.debug('fileContent is '+fileContent);  
         }
         outputMap.put('fileContent', decode(fileContent));
         
         return true;
    }
    
    private String decode(String content) {
         List<ContentVersion> contentVersions = (List<ContentVersion>)Database.query('SELECT FileType, VersionData FROM ContentVersion WHERE ContentDocumentId=\'' + content + '\' AND IsLatest=true LIMIT 1');
         
         if (!contentVersions.isEmpty()) {

                ContentVersion version = contentVersions.get(0);

                if (version.FileType.equalsIgnoreCase('JSON')) {

                    // Stored as a Blob, so just convert it to a String
                    return version.VersionData.toString();
                }
                else throw new ParsingException('Unable to parse file type "' + version.FileType + '".');
            }
        else throw new ParsingException('Unable to retrieve Content Document with Id=' + content + ' from Salesforce Files Repository.');
        
    }
    
    //Does a lookup on the Junction between Regulatory Codes and Assessment Indicators to avoid duplicates
    private Boolean getRegCodeAssessmentInd(Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options) {
        List<Object> argumentObjects = (List<Object>)inputMap.get('arguments');
        
        String RegCode = (String) argumentObjects[0];
        String AssessmentInd = (String) argumentObjects[1];
        
        String RegCodeAssessmentInd = '';
        
        RegulatoryCodeAssessmentInd[] RegCodeAssess = [SELECT Name FROM RegulatoryCodeAssessmentInd WHERE AssessmentIndDefinition.Name = :AssessmentInd AND RegulatoryCode.Name = :RegCode LIMIT 1];
        
        if (RegCodeAssess.size() > 0) 
            RegCodeAssessmentInd = RegCodeAssess[0].Name;
        
        outputMap.put('result',RegCodeAssessmentInd);
        
        return true;
    }
    
    //Does a lookup on the Junction between Assessment Definitions and Assessment Indicators to avoid duplicates
    private Boolean getAssessmentTaskIndDefinition(Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options) {
        List<Object> argumentObjects = (List<Object>)inputMap.get('arguments');
        
        String AssessmentTask = (String) argumentObjects[0];
        String AssessmentInd = (String) argumentObjects[1];
        
        String AssessmentTaskIndDefintion = '';
        
        AssessmentTaskIndDefinition[] AssessTaskIndDef = [SELECT Name FROM AssessmentTaskIndDefinition WHERE AssessmentIndDefinition.Name = :AssessmentInd AND AssessmentTaskDefinition.Name = :AssessmentTask LIMIT 1];
        
        if (AssessTaskIndDef.size() > 0)
            AssessmentTaskIndDefintion = AssessTaskIndDef[0].Name;
        
        outputMap.put('result',AssessmentTaskIndDefintion);
        
        return true;
    }
    
    //Parse out the Picklist so that they can be used by a Dataraptor
    private Boolean getAssessmentIndicatorDefinedValues(Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options) {
        List<Object> argumentObjects = (List<Object>)inputMap.get('arguments');
        
        String Source = (String) argumentObjects[0];
        
        system.debug('Source is ' + Source);
        
        if (Source != null)
        {
            List<Map<String,String>> result=new List<Map<String,String>>();
        
            system.debug('After Checking for null');
            
            String[] myArray;
            myArray= Source.split('\\|');
            for (integer a=0; a<myArray.size(); a++) {
    
                Map<String,String> singleRecord =new Map<String,String>();
                singleRecord.put('DefinedValue',myArray[a]);
                singleRecord.put('SequenceNumber',String.valueOf(a+1));
                result.add(singleRecord);
            }
            
            outputMap.put('result',result);
        }
        else
        {
            outputMap.put('result','');
        }
        
        
        
        return true;
    }



 }