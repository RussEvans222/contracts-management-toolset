public with sharing class ngo_BrixDeployerMultiple {

    @AuraEnabled
    public static void startLwcDeployment(List<String> bugIds) {
        if (bugIds == null || bugIds.isEmpty()) {
            throw new AuraHandledException('No bugs selected.');
        }

        String brixName = 'QBrix-6-NGO-BugFix';
        String entryPointType = 'flow';
        Map<String, Object> emptyParams = new Map<String, Object>();
        String serializedParams = JSON.serialize(emptyParams);

        bulkDeploy(brixName, entryPointType, bugIds, serializedParams);
    }

    // New method to support dynamic Brix Names for ABC360
    @AuraEnabled
    public static void deployGenericItems(List<String> itemIds, String brixName) {
        if (itemIds == null || itemIds.isEmpty()) {
            throw new AuraHandledException('No items selected.');
        }
        if (String.isBlank(brixName)) {
            throw new AuraHandledException('Brix Name is required.');
        }

        String entryPointType = 'flow';
        Map<String, Object> emptyParams = new Map<String, Object>();
        String serializedParams = JSON.serialize(emptyParams);

        bulkDeploy(brixName, entryPointType, itemIds, serializedParams);
    }

    // --- UPDATED METHOD: Check Status using Header Endpoint ---
    @AuraEnabled
    public static String checkStatus(String queueId) {
        if (String.isBlank(queueId)) {
            return null;
        }
        
        HttpRequest request = new HttpRequest();
        // Updated to use the demo-wizard-ps endpoint structure from your console logs
        request.setEndpoint('https://demo-wizard-ps.herokuapp.com/api/checkQBrixStatus/' + queueId);
        request.setMethod('GET');
        request.setTimeout(120000);

        try {
            Http http = new Http();
            HttpResponse response = http.send(request);
            return response.getBody();
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching status: ' + e.getMessage());
        }
    }
    // ----------------------------------------------------------

    @future(callout=true)
    private static void bulkDeploy(String brixName, String entryPointType, List<String> bugIds, String serializedParams) {
        Map<String, Object> qbrixParameters = (Map<String, Object>) JSON.deserializeUntyped(serializedParams);
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://qbrix-core-internal.herokuapp.com/QBrixOrder/SubmitFullOrder');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setTimeout(120000);

        DeploymentPayload payload = new DeploymentPayload(
            'DEMO WIZARD',
            brixName,
            entryPointType,
            bugIds,
            qbrixParameters
        );
        
        request.setBody(JSON.serialize(payload, true));

        try {
            Http http = new Http();
            HttpResponse response = http.send(request);

            if (response.getStatusCode() == 200) {
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                String queueId = (String) results.get('queueId');
                
                System.debug(LoggingLevel.INFO, 'Bulk Brix Deployment successful. Queue ID: ' + queueId);

                ABC360_Status__c statusSetting = ABC360_Status__c.getOrgDefaults();
                statusSetting.Queue_Id__c = queueId;
                statusSetting.Sync_in_Progress__c = true;
                upsert statusSetting;
                
            } else {
                System.debug(LoggingLevel.ERROR, 'Deployment Failed: ' + response.getBody());
            }
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'Exception: ' + e.getMessage());
        }
    }

    private class DeploymentPayload {
        public String systemId;
        public List<DeploymentItem> items;
        public AuthenticationData authenticationData;
        public Map<String, Object> parameters;

        public DeploymentPayload(String systemId, String brixName, String actionType, List<String> bugIds, Map<String, Object> brixParams) {
            this.systemId = systemId;
            this.parameters = brixParams;
            this.authenticationData = new AuthenticationData();
            this.items = new List<DeploymentItem>();

            for (String bugId : bugIds) {
                // If the ID seems to be a flow name (no underscore prefix logic for generic use), use as is, 
                // or keep the prefix logic if it applies universally. Assuming generic usage here:
                String actionName = bugId;
                
                // Fallback for BugFix logic if needed, but generic items likely pass the exact action name
                if (brixName.contains('BugFix')) {
                     actionName = 'deploy_bugfix_' + bugId;
                }
                
                this.items.add(new DeploymentItem(brixName, actionType, actionName));
            }

            // Always add the reset_queue_id action as the final item
            this.items.add(new DeploymentItem('QBrix-6-NGO-BugFix', 'flow', 'reset_queue_id'));
        }
    }

    private class DeploymentItem {
        public String type = 'QBRIX';
        public Integer processingOrder = 0;
        public String qbrixName;
        public String actionType;
        public String actionName;

        public DeploymentItem(String brixName, String actionType, String actionName) {
            this.qbrixName = brixName;
            this.actionType = actionType;
            this.actionName = actionName;
        }
    }

    private class AuthenticationData {
        public String UserName;
        public String AccessToken;
        public String InstanceUrl;
        public String AuthTokenType = 'DEFAULT';

        public AuthenticationData() {
            this.UserName = UserInfo.getUserName();
            this.AccessToken = UserInfo.getSessionId();
            this.InstanceUrl = System.URL.getOrgDomainUrl().toExternalForm();
        }
    }
}