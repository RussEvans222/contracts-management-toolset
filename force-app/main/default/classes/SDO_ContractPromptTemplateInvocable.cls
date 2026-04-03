public with sharing class SDO_ContractPromptTemplateInvocable {
    @TestVisible
    private static final String PROMPT_TEMPLATE_API_NAME = 'Contracts_Summary';

    public class Request {
        @InvocableVariable(required=true label='Contract Id')
        public String recordId;

        @InvocableVariable(required=true label='Obligations Summary')
        public String obligationsSummary;
    }

    public class Response {
        @InvocableVariable(label='Agent Response')
        public String agentResponse;
    }

    @InvocableMethod(
        label='Generate Contract Summary'
        description='Calls Prompt Template Contracts_Summary with contract context and obligations summary'
        callout=true
    )
    public static List<Response> generate(List<Request> requests) {
        List<Response> results = new List<Response>();
        if (requests == null) {
            return results;
        }

        for (Request requestItem : requests) {
            Response responseItem = new Response();
            responseItem.agentResponse = generateSummary(requestItem);
            results.add(responseItem);
        }
        return results;
    }

    private static String generateSummary(Request requestItem) {
        if (requestItem == null || String.isBlank(requestItem.recordId)) {
            return 'Unable to generate summary: Contract Id is required.';
        }

        if (Test.isRunningTest()) {
            return 'TEST_AGENT_RESPONSE for Contract ' + requestItem.recordId;
        }

        ConnectApi.EinsteinPromptTemplateGenerationsInput promptInput =
            new ConnectApi.EinsteinPromptTemplateGenerationsInput();
        promptInput.isPreview = false;
        promptInput.inputParams = new Map<String, ConnectApi.WrappedValue>();

        ConnectApi.WrappedValue contractValue = new ConnectApi.WrappedValue();
        contractValue.value = new Map<String, String>{ 'id' => requestItem.recordId };
        promptInput.inputParams.put('Input:Contracts', contractValue);

        ConnectApi.WrappedValue obligationsValue = new ConnectApi.WrappedValue();
        obligationsValue.value = String.isBlank(requestItem.obligationsSummary)
            ? ''
            : requestItem.obligationsSummary;
        promptInput.inputParams.put('Input:obligationsSummary', obligationsValue);

        promptInput.additionalConfig = new ConnectApi.EinsteinLlmAdditionalConfigInput();
        promptInput.additionalConfig.applicationName = 'PromptTemplateGenerationsInvocable';

        try {
            ConnectApi.EinsteinPromptTemplateGenerationsRepresentation generationsOutput =
                ConnectApi.EinsteinLLM.generateMessagesForPromptTemplate(
                    PROMPT_TEMPLATE_API_NAME,
                    promptInput
                );

            if (
                generationsOutput != null &&
                generationsOutput.generations != null &&
                !generationsOutput.generations.isEmpty() &&
                !String.isBlank(generationsOutput.generations[0].text)
            ) {
                return generationsOutput.generations[0].text;
            }
            return 'No response returned from prompt template.';
        } catch (Exception ex) {
            return 'Prompt generation failed: ' + ex.getMessage();
        }
    }
}
