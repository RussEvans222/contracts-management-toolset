/**
 * @description A callable Apex class to initiate an e-signature request.
 * This class is designed to be invoked from an OmniStudio Integration Procedure or OmniScript.
 */
global with sharing class DocumentESigner implements System.Callable {

    /**
     * @description Main entry point for the callable interface.
     * @param action The action to be performed (not used in this implementation).
     * @param args A map of arguments passed from the caller. Expected keys:
     * 'namedcred', 'parentId', 'email', 'name', 'documentName', 'sourceId'.
     * @return A map containing the success status and a message.
     * @throws CalloutException if the HTTP request fails or input is invalid.
     */
    public Object call(String action, Map<String, Object> args) {
        // 1. More robustly handle the input map structure.
        Map<String, Object> inputMap;
        if (args != null && args.containsKey('input') && args.get('input') instanceof Map<String, Object>) {
            inputMap = (Map<String, Object>) args.get('input');
        } else {
            inputMap = args; // Fallback to using the args map directly.
        }

        if (inputMap == null) {
            throw new CalloutException('Input arguments cannot be null.');
        }

        // Extract parameters
        String namedcred = (String) inputMap.get('namedcred');
        String parentId = (String) inputMap.get('parentId');
        String email = (String) inputMap.get('email');
        String name = (String) inputMap.get('name');
        String documentName = (String) inputMap.get('documentName');
        String sourceId = (String) inputMap.get('sourceId');

        // Call the callout method
        sendSignatureRequest(namedcred, parentId, email, name, documentName, sourceId);

        // Return a success map, which is a good practice for OmniStudio
        return new Map<String, Object>{
            'success' => true,
            'message' => 'Request sent successfully.'
        };
    }

    /**
     * @description Constructs and sends the HTTP request for the e-signature.
     * @throws CalloutException on a non-2xx HTTP response.
     */
    private void sendSignatureRequest(String namedcred, String parentId, String email, String name, String documentName, String sourceId) {
        HttpRequest req = new HttpRequest();
        String endpoint = 'callout:' + namedcred + '/services/data/v64.0/connect/e-sign/signature-requests/' + parentId + '/envelope/send';

        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json; charset=UTF-8');
        req.setBody(getJsonPayload(parentId, email, name, documentName, sourceId));

        Http http = new Http();
        HttpResponse res = http.send(req);

        // 2. Implement proper error handling.
        // Throw an exception on failure so the OmniScript/IP can catch it.
        if (res.getStatusCode() < 200 || res.getStatusCode() >= 300) {
            System.debug(LoggingLevel.ERROR, 'Failed to send request. Status: ' + res.getStatus() + '. Body: ' + res.getBody());
            throw new CalloutException('Failed to send E-Sign request. Status: ' + res.getStatus() + '. Response: ' + res.getBody());
        }

        System.debug('E-Sign request sent successfully. Response Body: ' + res.getBody());
    }

    /**
     * @description Creates the JSON payload using a Map and JSON.serialize for safety and clarity.
     * @return A serialized JSON string.
     */
    private static String getJsonPayload(String parentId, String email, String name, String documentName, String sourceId) {
        // 3. Use a Map and JSON.serialize instead of string concatenation.
        Map<String, Object> payload = new Map<String, Object>{
            'parentId' => parentId,
            'emailSettings' => new Map<String, Object>{
                'emailSubject' => 'Please sign this ' + documentName,
                'emailBody' => documentName + '-Sent Via DocuSign Envelope'
            },
            'recipients' => new Map<String, Object>{
                'signers' => new List<Map<String, Object>>{
                    new Map<String, Object>{
                        'email' => email,
                        'name' => name,
                        'recipientType' => 'signer',
                        'signerRole' => '1',
                        'routingOrder' => 1,  // API may prefer Integer over String
                        'recipientId' => '1',
                        'recipientLocale' => 'EN'
                    }
                }
            },
            'documents' => new List<Map<String, Object>>{
                new Map<String, Object>{
                    'documentId' => '1',
                    'name' => documentName,
                    'fileExtension' => 'docx',
                    'sourceType' => 'Content',
                    'sourceId' => sourceId
                }
            }
        };

        return JSON.serialize(payload);
    }
}