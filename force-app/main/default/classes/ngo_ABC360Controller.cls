public with sharing class ngo_ABC360Controller {

    @AuraEnabled(cacheable=true)
    public static List<Ngo_ABC360__x> getABC360Records(String searchKey) {
        // 1. Get the Org Identifier from Custom Metadata
        String orgIdentifier = '';
        try {
            List<QLabs__mdt> config = [SELECT Identifier__c FROM QLabs__mdt WHERE DeveloperName = 'Org_Identifier' LIMIT 1];
            if (!config.isEmpty()) {
                orgIdentifier = config[0].Identifier__c;
            }
        } catch (Exception e) {
            System.debug('Error fetching QLabs metadata: ' + e.getMessage());
        }

        // 2. Map Identifier to IDO Type ('ngo', 'edu', 'gps')
        String idoType = 'ngo'; // Default fallback
        if (orgIdentifier == '8807b134-6330-c20d-4a62-30acb7632a2a') {
            idoType = 'ngo';
        } else if (orgIdentifier == '2c40803f-85c5-bc50-6092-39686eb2d0c5') {
            idoType = 'gps';
        } else if (orgIdentifier == '0212f83a-e45e-610c-e3df-2cef6a947d5f') {
            idoType = 'edu';
        } else {
            System.debug('Unknown Org Identifier: ' + orgIdentifier + '. Defaulting to ngo.');
        }

        // 3. Fetch Existing Installations to Filter Out
        Set<String> installedIds = new Set<String>();
        for (IDO_BugFix_Installations__c install : [SELECT Bug_Id__c FROM IDO_BugFix_Installations__c]) {
            if (install.Bug_Id__c != null) {
                installedIds.add(install.Bug_Id__c);
            }
        }

        // 4. Build Query with mapped IDO__c Filter and new Brix_Name__c field
        String query = 'SELECT Id, Name__c, Description__c, Video_URL__c, Flow_Name__c, IDO__c, Brix_Name__c, ExternalId FROM Ngo_ABC360__x WHERE IDO__c = :idoType';
        
        if (String.isNotBlank(searchKey)) {
            String key = '%' + searchKey + '%';
            query += ' AND Name__c LIKE :key';
        }
        query += ' ORDER BY Name__c ASC LIMIT 200';
        
        try {
            List<Ngo_ABC360__x> allRecords = Database.query(query);
            List<Ngo_ABC360__x> filteredRecords = new List<Ngo_ABC360__x>();

            // 5. Filter records in memory
            for (Ngo_ABC360__x rec : allRecords) {
                // Determine the ID used for tracking (must match deployContent logic)
                String trackingId = String.isNotBlank(rec.Flow_Name__c) ? rec.Flow_Name__c : rec.ExternalId;
                
                // Only add if no corresponding installation record exists
                if (!installedIds.contains(trackingId)) {
                    filteredRecords.add(rec);
                }
            }

            return filteredRecords;

        } catch (Exception e) {
            throw new AuraHandledException('Error fetching ABC360 records: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static void deployContent(List<Ngo_ABC360__x> selectedRecords) {
        if (selectedRecords == null || selectedRecords.isEmpty()) {
            return;
        }

        // List to hold the tracking records to be inserted
        List<IDO_BugFix_Installations__c> installationsToInsert = new List<IDO_BugFix_Installations__c>();

        // Group records by their Brix Name to handle mixed selections
        Map<String, List<String>> itemsByBrixName = new Map<String, List<String>>();

        for (Ngo_ABC360__x row : selectedRecords) {
            // 1. Prepare Brix Deployment Data
            // Use provided Brix_Name__c, defaulting to a fallback if missing
            String brixName = String.isNotBlank(row.Brix_Name__c) ? row.Brix_Name__c : 'QBrix-6-NGO'; 
            
            if (!itemsByBrixName.containsKey(brixName)) {
                itemsByBrixName.put(brixName, new List<String>());
            }
            // Use Flow_Name__c as the item identifier passed to the deployer if available
            String itemId = String.isNotBlank(row.Flow_Name__c) ? row.Flow_Name__c : row.ExternalId;
            itemsByBrixName.get(brixName).add(itemId);

            // 2. Create Installation Tracking Record (exact mimic of bug fix logic)
            IDO_BugFix_Installations__c install = new IDO_BugFix_Installations__c();
            // User requested Bug_Id__c be the flow_name value
            install.Bug_Id__c = itemId; 
            install.Bug_Name__c = row.Name__c;
            install.Bug_Description__c = row.Description__c;
            install.Video_URL__c = row.Video_URL__c;
            install.Status__c = 'Started'; // Mimic "Started" status
            install.Start_Time__c = System.now();
            
            installationsToInsert.add(install);
        }

        try {
            // Insert tracking records first
            if (!installationsToInsert.isEmpty()) {
                insert installationsToInsert;
            }

            // Trigger deployment for each Brix Name group
            for (String brixName : itemsByBrixName.keySet()) {
                List<String> items = itemsByBrixName.get(brixName);
                if (!items.isEmpty()) {
                    ngo_BrixDeployerMultiple.deployGenericItems(items, brixName);
                }
            }
            
            // Update status to indicate deployment is in progress for the LWC to switch to "Check Status"
            ABC360_Status__c statusSetting = ABC360_Status__c.getOrgDefaults();
            statusSetting.Sync_in_Progress__c = true; // Sets "Deployment In Progress" flag for UI
            upsert statusSetting;

        } catch (Exception e) {
            throw new AuraHandledException('Error deploying content: ' + e.getMessage());
        }
    }
}