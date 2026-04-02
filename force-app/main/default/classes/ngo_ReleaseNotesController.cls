public with sharing class ngo_ReleaseNotesController {
    
    @AuraEnabled(cacheable=true)
    public static List<Ngo_IDO_ReleaseNotes__x> getReleaseNotes(String searchKey) {
        try {
            String query = 'SELECT Id, ExternalId, Name__c, Product_Line__c, Type__c, Release_Date__c, Description__c, Video_URL__c FROM Ngo_IDO_ReleaseNotes__x';
            if (String.isNotBlank(searchKey)) {
                String key = '%' + searchKey + '%';
                query += ' WHERE Name__c LIKE :key';
            }
            query += ' ORDER BY Release_Date__c DESC LIMIT 200';
            return Database.query(query);
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching release notes: ' + e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static Date getIDOCreationDate() {
        ngo_IDO_Creation_Date__c setting = ngo_IDO_Creation_Date__c.getOrgDefaults();
        return (setting != null && setting.Creation_Date__c != null) 
            ? setting.Creation_Date__c 
            : null;
    }

    @AuraEnabled(cacheable=true)
    public static String getReleaseCycle() {
        ngo_IDO_Creation_Date__c setting = ngo_IDO_Creation_Date__c.getOrgDefaults();
        return (setting != null && setting.Release_Cycle__c != null) 
            ? setting.Release_Cycle__c 
            : '258'; // Default to 258 if not set
    }

    @AuraEnabled
    public static String getAISummary() { 
        try {

            ngo_IDO_Creation_Date__c setting = ngo_IDO_Creation_Date__c.getOrgDefaults();
            Date referenceDate = (setting != null && setting.Creation_Date__c != null) 
                ? setting.Creation_Date__c
                : Date.today();


            List<Ngo_IDO_ReleaseNotes__x> allNotes = [
                SELECT Name__c, Product_Line__c, Type__c, Release_Date__c, Description__c 
                FROM Ngo_IDO_ReleaseNotes__x 
                ORDER BY Release_Date__c DESC 
                LIMIT 200
            ];


            Date targetPlatformDate = null;
            for (Ngo_IDO_ReleaseNotes__x note : allNotes) {
                if (note.Release_Date__c == null) continue;
                Date noteDate = note.Release_Date__c; 
                if (note.Type__c == 'Platform' && noteDate < referenceDate) {
                    if (targetPlatformDate == null || noteDate > targetPlatformDate) {
                        targetPlatformDate = noteDate;
                    }
                }
            }


            String platformXML = '<PlatformUpdates>';
            Boolean hasPlatform = false;

            for (Ngo_IDO_ReleaseNotes__x note : allNotes) {
                if (note.Release_Date__c == null) continue;
                Date noteDate = note.Release_Date__c;

                if (note.Type__c == 'Platform' && targetPlatformDate != null && noteDate == targetPlatformDate) {
                    String cleanDesc = (note.Description__c != null) ? note.Description__c.left(250) : '';
                    platformXML += '<Note>' +
                                   '<Name>' + note.Name__c + '</Name>' +
                                   '<Product>' + note.Product_Line__c + '</Product>' +
                                   '<Desc>' + cleanDesc + '</Desc>' +
                                   '</Note>';
                    hasPlatform = true;
                } 
            }
            platformXML += '</PlatformUpdates>';
            if (!hasPlatform) platformXML = 'No recent platform updates found prior to installation.';


            String bugXML = '<BugFixes>';
            Boolean hasBugs = false;

            List<IDO_BugFix_Installations__c> installedBugs = [
                SELECT Bug_Name__c, Bug_Description__c, Finish_Time__c 
                FROM IDO_BugFix_Installations__c 
                WHERE Finish_Time__c > :setting.Creation_Date__c
                ORDER BY Finish_Time__c DESC
            ];

            for (IDO_BugFix_Installations__c bug : installedBugs) {
                String cleanBugDesc = (bug.Bug_Description__c != null) ? bug.Bug_Description__c.left(250) : '';
                bugXML += '<Bug>' +
                          '<Name>' + bug.Bug_Name__c + '</Name>' +
                          '<Time>' + bug.Finish_Time__c + '</Time>' +
                          '<Desc>' + cleanBugDesc + '</Desc>' +
                          '</Bug>';
                hasBugs = true;
            }
            bugXML += '</BugFixes>';
            if (!hasBugs) bugXML = 'No outstanding hot fixes found.';

            Map<String, ConnectApi.WrappedValue> inputParams = new Map<String, ConnectApi.WrappedValue>();

            ConnectApi.WrappedValue platformVal = new ConnectApi.WrappedValue();
            platformVal.value = platformXML;
            inputParams.put('Input:platformXML', platformVal);

            ConnectApi.WrappedValue bugVal = new ConnectApi.WrappedValue();
            bugVal.value = bugXML;
            inputParams.put('Input:bugXML', bugVal);

            ConnectApi.EinsteinPromptTemplateGenerationsInput promptInput = new ConnectApi.EinsteinPromptTemplateGenerationsInput();
            promptInput.inputParams = inputParams;
            promptInput.isPreview = false;
            promptInput.additionalConfig = new ConnectApi.EinsteinLlmAdditionalConfigInput();
            promptInput.additionalConfig.applicationName = 'PromptBuilderPreview';

            ConnectApi.EinsteinPromptTemplateGenerationsRepresentation response = 
                ConnectApi.EinsteinLLM.generateMessagesForPromptTemplate('House_Tour_Release_Summary', promptInput);

            if (response.generations != null && !response.generations.isEmpty()) {
                return response.generations[0].text;
            } else {
                return 'Einstein returned no summary.';
            }

        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'Einstein Failure: ' + e.getMessage());
            throw new AuraHandledException('Einstein Error: ' + e.getMessage());
        }
    }
}