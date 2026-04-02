public with sharing class RecipeFlowDeployer {

    // --- Constants ---
    // Inferred from the 'OrderUtility.cls' provided in our previous discussion
    private static final string SYSTEMID = 'QLABS_BRIX_RECIPE'; 
    private static final string DEFAULT_ENDPOINT = 'https://qbrix-core-stage-int.herokuapp.com';

    // --- Inner class for Flow input variables ---
    // MODIFIED: Removed the 'username' InvocableVariable
    public class FlowRequest {
        @InvocableVariable(label='Recipe Name or Alias' description='The API Name or Alias of the Brix Recipe to be deployed.' required=true)
        public String recipeAlias;
    }

    // --- Invocable Method (Wrapper for the future call) ---
    /**
     * @description Invocable method to be called from a Salesforce Flow to request a Brix Recipe deployment.
     * @param requests A list of recipe requests from the flow.
     */
    @InvocableMethod(label='Request Brix Recipe' description='Invokes the Brix Recipe deployment process via the ViaRecipe endpoint.' category='Brix')
    public static void executeRecipeRequest(List<FlowRequest> requests) {
        if (requests != null && !requests.isEmpty()) {
            FlowRequest req = requests[0];
            
            // MODIFIED: Get the username from the active user running the Flow
            String targetUsername = UserInfo.getUserName();

            if (String.isNotBlank(req.recipeAlias)) {
                // Pass the active user's name and the recipe alias to the future method
                RequestRecipeFuture(targetUsername, req.recipeAlias);
            } else {
                System.debug(LoggingLevel.ERROR, 'RecipeFlowRequestor: recipeAlias was not provided.');
            }
        }
    }

    // --- Future Method (Unchanged) ---
    /**
     * @description Asynchronous callout method from the provided sample.
     * @param username The target username for the operation.
     * @param recipeAlias The name or alias of the recipe to run.
     */
    @future(callout=true)
    public static void RequestRecipeFuture(string username, string recipeAlias) {
        // Call the synchronous method (from sample)
        String queueId = RequestRecipe(username, recipeAlias);
        
        if (String.isNotBlank(queueId)) {
            System.debug(LoggingLevel.INFO, 'Brix Recipe requested. Queue ID: ' + queueId);
        } else {
            System.debug(LoggingLevel.WARN, 'Brix Recipe request submitted, but no Queue ID was returned.');
        }
    }

    // --- Synchronous Callout Method (Unchanged) ---
    /**
     * @description Synchronous helper method containing the exact callout logic from the sample.
     * @param username The target username.
     * @param recipeAlias The recipe name or alias.
     * @return The queueId if successful, otherwise an empty string.
     */
    private static string RequestRecipe(string username, string recipeAlias) {
        // This logic is directly from the provided sample
        Map<string,object> authData = new Map<string,Object>(); // This is the outer payload
        Map<string,object> payload = new Map<string,Object>();  // This is the inner 'authenticationData' object
        
        payload.put('authTokenType','DEFAULT');
        // This 'username' parameter is now guaranteed to be the active user's
        payload.put('userName',username); 
        
        authData.put('authenticationData',payload);
        authData.put('recipeName',recipeAlias);
        authData.put('systemId',SYSTEMID);
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint(DEFAULT_ENDPOINT + '/QBrixOrder/ViaRecipe'); 
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // The Authorization header *also* correctly uses the active user's session ID
        request.setHeader('Authorization', 'Bearer '+UserInfo.getSessionID());  
        request.setBody(JSON.serialize(authData));
        request.setTimeout(120000); 

        try {
            HttpResponse response = http.send(request);

            if (response.getStatusCode() == 200) {
                Map<string,Object> rs = (Map<string,Object>)JSON.deserializeUntyped(response.getBody());
                if(rs.containsKey('queueId')) {
                    string queueId = (string)rs.get('queueId');
                    return queueId;
                }
            } else {
                System.debug(LoggingLevel.ERROR, 'Recipe Request Failed. Status: ' + response.getStatus() + '. Body: ' + response.getBody());
            }

        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'An exception occurred during the Recipe request: ' + e.getMessage());
        }

        return '';
    }
}