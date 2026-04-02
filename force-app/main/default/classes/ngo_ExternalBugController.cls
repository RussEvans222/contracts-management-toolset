public with sharing class ngo_ExternalBugController {
    @AuraEnabled(cacheable=true)
    public static List<BugWrapper> getExternalBugs(String searchKey) {
        try {
            // 1. Get IDs of bugs that are 'Completed' to exclude them entirely
            Set<String> completedBugIds = new Set<String>();
            
            // 2. Get status for bugs that are 'Started' or 'Not Installed' to show in the list
            Map<String, IDO_BugFix_Installations__c> installationMap = new Map<String, IDO_BugFix_Installations__c>();
            
            for (IDO_BugFix_Installations__c install : [
                SELECT Bug_Id__c, Status__c, Start_Time__c 
                FROM IDO_BugFix_Installations__c
            ]) {
                if (install.Bug_Id__c == null) continue;

                if (install.Status__c == 'Completed') {
                    completedBugIds.add(install.Bug_Id__c);
                } else {
                    installationMap.put(install.Bug_Id__c, install);
                }
            }

            // 3. Determine Release Cycle Prefix
            ngo_IDO_Creation_Date__c setting = ngo_IDO_Creation_Date__c.getOrgDefaults();
            String releaseCycle = (setting != null && setting.Release_Cycle__c != null) 
                ? setting.Release_Cycle__c 
                : '258';
            
            String targetPrefix = releaseCycle + '_';

            // 4. Query External Object
            String query = 'SELECT Id, ExternalId, Name__c, Description__c, Bug_Id__c, videoURL__c FROM NGO_IDO_Bug__x';
            
            if (!completedBugIds.isEmpty()) {
                query += ' WHERE Bug_Id__c NOT IN :completedBugIds';
            }

            if (String.isNotBlank(searchKey)) {
                String key = '%' + searchKey + '%';
                if (completedBugIds.isEmpty()) {
                    query += ' WHERE Name__c LIKE :key';
                } else {
                    query += ' AND Name__c LIKE :key';
                }
            }
            
            List<NGO_IDO_Bug__x> externalBugs = Database.query(query);
            List<BugWrapper> wrappedBugs = new List<BugWrapper>();

            // 5. Wrap the data
            for (NGO_IDO_Bug__x eb : externalBugs) {
                if (eb.Bug_Id__c == null || completedBugIds.contains(eb.Bug_Id__c)) {
                    continue; 
                }

                if (!eb.Bug_Id__c.startsWith(targetPrefix)) {
                    continue;
                }

                BugWrapper wrapper = new BugWrapper();
                wrapper.record = eb;
                
                if (installationMap.containsKey(eb.Bug_Id__c)) {
                    IDO_BugFix_Installations__c inst = installationMap.get(eb.Bug_Id__c);
                    wrapper.installationStatus = inst.Status__c;
                    wrapper.startTime = inst.Start_Time__c;
                } else {
                    wrapper.installationStatus = 'Not Installed';
                    wrapper.startTime = null;
                }
                wrappedBugs.add(wrapper);
            }

            return wrappedBugs;
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching external bugs: ' + e.getMessage());
        }
    }

    // --- MODIFIED METHOD: Returns Map with Status and QueueId ---
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getDeploymentStatus() {
        ABC360_Status__c setting = ABC360_Status__c.getOrgDefaults();
        Map<String, Object> result = new Map<String, Object>();
        
        if (setting != null) {
            result.put('isDeploymentInProgress', setting.Sync_in_Progress__c);
            result.put('queueId', setting.Queue_Id__c);
        } else {
            result.put('isDeploymentInProgress', false);
            result.put('queueId', null);
        }
        return result;
    }
    // -----------------------------------------------------------

    public class BugWrapper {
        @AuraEnabled public NGO_IDO_Bug__x record;
        @AuraEnabled public String installationStatus;
        @AuraEnabled public DateTime startTime;
    }
}