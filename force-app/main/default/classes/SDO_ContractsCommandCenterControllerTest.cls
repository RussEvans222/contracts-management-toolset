@IsTest
private class SDO_ContractsCommandCenterControllerTest {
    @IsTest
    static void getSnapshot_returnsMetricsAndLists() {
        Account acct = new Account(Name = 'CMD Center Test Account');
        insert acct;

        List<Contract> contracts = new List<Contract>{
            new Contract(
                AccountId = acct.Id,
                StartDate = Date.today().addDays(-30),
                ContractTerm = 12,
                Status = 'Draft'
            ),
            new Contract(
                AccountId = acct.Id,
                StartDate = Date.today().addDays(-45),
                ContractTerm = 12,
                Status = 'Draft'
            ),
            new Contract(
                AccountId = acct.Id,
                StartDate = Date.today().addDays(-60),
                ContractTerm = 12,
                Status = 'Draft'
            )
        };
        insert contracts;

        contracts[0].Status = 'In Approval Process';
        contracts[1].Status = 'Activated';
        update contracts;

        Test.startTest();
        SDO_ContractsCommandCenterController.Snapshot snapshot = SDO_ContractsCommandCenterController.getSnapshot();
        Test.stopTest();

        System.assertNotEquals(null, snapshot, 'Snapshot should be returned.');
        System.assert(snapshot.totalContracts >= 3, 'Snapshot should include inserted contracts.');
        System.assertNotEquals(null, snapshot.stageMetrics, 'Stage metrics list should not be null.');
        System.assert(snapshot.stageMetrics.size() > 0, 'Stage metrics should contain data.');
        System.assertNotEquals(null, snapshot.expiringContracts, 'Expiring list should not be null.');
        System.assertNotEquals(null, snapshot.attentionContracts, 'Attention queue should not be null.');

        Boolean foundDraftRequest = false;
        for (SDO_ContractsCommandCenterController.AttentionContract entry : snapshot.attentionContracts) {
            if (entry.status == 'Draft' && entry.attentionReason == 'New Request') {
                foundDraftRequest = true;
                break;
            }
        }
        System.assertEquals(true, foundDraftRequest, 'Draft contracts should surface in attention queue as New Request.');
    }

    @IsTest
    static void getStageInsights_returnsAllTimeMetrics() {
        Account acct = new Account(Name = 'CMD Stage Insights Account');
        insert acct;

        Contract firstContract = new Contract(
            AccountId = acct.Id,
            StartDate = Date.today().addDays(-120),
            ContractTerm = 12,
            Status = 'Draft'
        );
        Contract secondContract = new Contract(
            AccountId = acct.Id,
            StartDate = Date.today().addDays(-75),
            ContractTerm = 12,
            Status = 'Draft'
        );
        insert new List<Contract>{ firstContract, secondContract };

        firstContract.Status = 'In Approval Process';
        secondContract.Status = 'Activated';
        update new List<Contract>{ firstContract, secondContract };

        secondContract.Status = 'Signed';
        update secondContract;

        Test.startTest();
        SDO_ContractsCommandCenterController.StageInsights insights = SDO_ContractsCommandCenterController.getStageInsights();
        Test.stopTest();

        System.assertNotEquals(null, insights, 'Stage insights payload should be returned.');
        System.assert(insights.contractsAnalyzed >= 2, 'Contracts analyzed should include test records.');
        System.assertNotEquals(null, insights.completionBuckets, 'Completion buckets should be initialized.');
        System.assertEquals(5, insights.completionBuckets.size(), 'Completion bucket set should be fixed.');
        System.assertNotEquals(null, insights.avgStageDurations, 'Stage duration metrics should be initialized.');
        System.assert(insights.avgStageDurations.size() > 0, 'Stage duration metrics should include rows.');
    }
}
