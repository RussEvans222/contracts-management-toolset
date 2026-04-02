@IsTest
private class SDO_ContractHistoryTimelineCtrlTest {
    @IsTest
    static void getContractHistoryTimeline_returnsContractContext() {
        Contract contractRecord = createContract('Timeline Context');

        // Generate at least one tracked change.
        contractRecord.Status = 'In Approval Process';
        update contractRecord;

        Test.startTest();
        SDO_ContractHistoryTimelineController.TimelinePayload payload =
            SDO_ContractHistoryTimelineController.getContractHistoryTimeline(contractRecord.Id, 250);
        Test.stopTest();

        System.assertNotEquals(null, payload, 'Timeline payload should be returned.');
        System.assertEquals(contractRecord.Id, payload.contractId, 'Payload should map to requested contract.');
        System.assertNotEquals(null, payload.events, 'Events list should always be initialized.');
        System.assert(payload.returnedEvents >= 0, 'Returned event count should never be negative.');
        System.assertEquals(250, payload.appliedMaxRows, 'Provided max rows should be respected in range.');
    }

    @IsTest
    static void getContractHistoryTimeline_clampsRequestedLimit() {
        Contract contractRecord = createContract('Timeline Limits');

        Test.startTest();
        SDO_ContractHistoryTimelineController.TimelinePayload minPayload =
            SDO_ContractHistoryTimelineController.getContractHistoryTimeline(contractRecord.Id, 1);
        SDO_ContractHistoryTimelineController.TimelinePayload maxPayload =
            SDO_ContractHistoryTimelineController.getContractHistoryTimeline(contractRecord.Id, 99999);
        Test.stopTest();

        System.assertEquals(50, minPayload.appliedMaxRows, 'Minimum requested rows should be clamped to 50.');
        System.assertEquals(2000, maxPayload.appliedMaxRows, 'Maximum requested rows should be clamped to 2000.');
    }

    @IsTest
    static void getContractHistoryTimeline_requiresContractId() {
        try {
            Test.startTest();
            SDO_ContractHistoryTimelineController.getContractHistoryTimeline(null, 200);
            Test.stopTest();
            System.assert(false, 'Expected method to reject null contract id.');
        } catch (AuraHandledException expected) {
            System.assert(
                !String.isBlank(expected.getMessage()),
                'Error message should be present for null contract id.'
            );
        }
    }

    @IsTest
    static void getContractHistoryTimeline_includesActivityRows() {
        Contract contractRecord = createContract('Timeline Activity');

        insert new Task(
            WhatId = contractRecord.Id,
            Subject = 'Vendor follow-up',
            Status = 'Completed',
            Priority = 'High',
            Type = 'Email',
            ActivityDate = Date.today()
        );

        insert new Event(
            WhatId = contractRecord.Id,
            Subject = 'Contract review session',
            StartDateTime = System.now().addHours(-2),
            EndDateTime = System.now().addHours(-1),
            DurationInMinutes = 60
        );

        Test.startTest();
        SDO_ContractHistoryTimelineController.TimelinePayload payload =
            SDO_ContractHistoryTimelineController.getContractHistoryTimeline(contractRecord.Id, 300);
        Test.stopTest();

        Boolean foundTaskActivity = false;
        Boolean foundCalendarActivity = false;

        for (SDO_ContractHistoryTimelineController.TimelineEvent eventRow : payload.events) {
            if (eventRow.sourceCategory == 'Task') {
                foundTaskActivity = true;
            }
            if (eventRow.sourceCategory == 'Event') {
                foundCalendarActivity = true;
            }
        }

        System.assert(foundTaskActivity, 'Task-linked activity should appear in the timeline payload.');
        System.assert(foundCalendarActivity, 'Event-linked activity should appear in the timeline payload.');
    }

    private static Contract createContract(String accountName) {
        Account accountRecord = new Account(Name = accountName);
        insert accountRecord;

        Contract contractRecord = new Contract(
            AccountId = accountRecord.Id,
            StartDate = Date.today(),
            ContractTerm = 12,
            Status = 'Draft'
        );
        insert contractRecord;
        return contractRecord;
    }
}
