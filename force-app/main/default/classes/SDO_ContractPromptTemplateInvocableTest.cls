@IsTest
private class SDO_ContractPromptTemplateInvocableTest {
    @IsTest
    static void generateReturnsTestResponseWhenValidInputProvided() {
        SDO_ContractPromptTemplateInvocable.Request req =
            new SDO_ContractPromptTemplateInvocable.Request();
        req.recordId = '800000000000001AAA';
        req.obligationsSummary = 'Outstanding Obligations (Top 20):\n- Test | Status: Not Started | Due: 2026-04-15';

        List<SDO_ContractPromptTemplateInvocable.Response> results =
            SDO_ContractPromptTemplateInvocable.generate(
                new List<SDO_ContractPromptTemplateInvocable.Request>{ req }
            );

        System.assertEquals(1, results.size());
        System.assertNotEquals(null, results[0].agentResponse);
        System.assert(results[0].agentResponse.contains('TEST_AGENT_RESPONSE'));
    }

    @IsTest
    static void generateReturnsValidationMessageWhenRecordIdMissing() {
        SDO_ContractPromptTemplateInvocable.Request req =
            new SDO_ContractPromptTemplateInvocable.Request();
        req.recordId = '';
        req.obligationsSummary = 'sample';

        List<SDO_ContractPromptTemplateInvocable.Response> results =
            SDO_ContractPromptTemplateInvocable.generate(
                new List<SDO_ContractPromptTemplateInvocable.Request>{ req }
            );

        System.assertEquals(1, results.size());
        System.assert(results[0].agentResponse.startsWith('Unable to generate summary'));
    }
}
