public with sharing class SDO_ContractsCommandCenterController {
    public class Snapshot {
        @AuraEnabled public Datetime lastRefreshed;
        @AuraEnabled public Integer totalContracts;
        @AuraEnabled public Integer draftCount;
        @AuraEnabled public Integer inApprovalCount;
        @AuraEnabled public Integer activatedCount;
        @AuraEnabled public Integer signedCount;
        @AuraEnabled public Integer awaitingSignatureCount;
        @AuraEnabled public Integer expiring30Count;
        @AuraEnabled public List<StageMetric> stageMetrics;
        @AuraEnabled public List<ExpiringContract> expiringContracts;
        @AuraEnabled public List<AttentionContract> attentionContracts;
    }

    public class StageMetric {
        @AuraEnabled public String status;
        @AuraEnabled public Integer count;
        @AuraEnabled public Decimal percentage;
    }

    public class ExpiringContract {
        @AuraEnabled public Id contractId;
        @AuraEnabled public String contractNumber;
        @AuraEnabled public String accountName;
        @AuraEnabled public String status;
        @AuraEnabled public Date endDate;
    }

    public class MonthlyPoint {
        @AuraEnabled public String label;
        @AuraEnabled public Integer count;
    }

    public class AttentionContract {
        @AuraEnabled public Id contractId;
        @AuraEnabled public String contractNumber;
        @AuraEnabled public String accountName;
        @AuraEnabled public String status;
        @AuraEnabled public Date endDate;
        @AuraEnabled public String attentionReason;
    }

    public class StageInsights {
        @AuraEnabled public Datetime lastRefreshed;
        @AuraEnabled public Integer contractsAnalyzed;
        @AuraEnabled public Integer completedContracts;
        @AuraEnabled public Decimal avgCompletionDays;
        @AuraEnabled public List<CompletionBucket> completionBuckets;
        @AuraEnabled public List<StageDuration> avgStageDurations;
    }

    public class CompletionBucket {
        @AuraEnabled public String label;
        @AuraEnabled public Integer count;
        @AuraEnabled public Decimal percentage;
        @AuraEnabled public String color;
    }

    public class StageDuration {
        @AuraEnabled public String status;
        @AuraEnabled public Decimal avgDays;
        @AuraEnabled public Decimal totalDays;
        @AuraEnabled public Integer occurrences;
        @AuraEnabled public String color;
    }

    @AuraEnabled(cacheable=true)
    public static Snapshot getSnapshot() {
        Snapshot snapshot = new Snapshot();
        snapshot.lastRefreshed = System.now();
        snapshot.totalContracts = [SELECT COUNT() FROM Contract];

        Map<String, Integer> statusCounts = new Map<String, Integer>();

        for (AggregateResult row : [
            SELECT Status statusValue, COUNT(Id) recordCount
            FROM Contract
            GROUP BY Status
            ORDER BY COUNT(Id) DESC
            LIMIT 20
        ]) {
            String status = (String) row.get('statusValue');
            Integer count = (Integer) row.get('recordCount');
            statusCounts.put(status, count);

        }

        // Keep stage distribution focused on the primary lifecycle states and roll the rest into "Other".
        List<String> primaryStages = new List<String>{
            'Draft',
            'In Approval Process',
            'Negotiating',
            'Awaiting Signature',
            'Activated',
            'Signed'
        };

        Integer representedCount = 0;
        List<StageMetric> stageMetrics = new List<StageMetric>();
        for (String stageName : primaryStages) {
            Integer stageCount = statusCounts.containsKey(stageName) ? statusCounts.get(stageName) : 0;
            if (stageCount <= 0) {
                continue;
            }
            representedCount += stageCount;

            StageMetric metric = new StageMetric();
            metric.status = stageName;
            metric.count = stageCount;
            metric.percentage = snapshot.totalContracts > 0
                ? (Decimal.valueOf(stageCount) * 100 / Decimal.valueOf(snapshot.totalContracts)).setScale(1)
                : 0;
            stageMetrics.add(metric);
        }

        Integer otherCount = Math.max(0, snapshot.totalContracts - representedCount);
        if (otherCount > 0) {
            StageMetric otherMetric = new StageMetric();
            otherMetric.status = 'Other';
            otherMetric.count = otherCount;
            otherMetric.percentage = snapshot.totalContracts > 0
                ? (Decimal.valueOf(otherCount) * 100 / Decimal.valueOf(snapshot.totalContracts)).setScale(1)
                : 0;
            stageMetrics.add(otherMetric);
        }

        snapshot.stageMetrics = stageMetrics;
        snapshot.draftCount = statusCounts.containsKey('Draft') ? statusCounts.get('Draft') : 0;
        snapshot.inApprovalCount = statusCounts.containsKey('In Approval Process') ? statusCounts.get('In Approval Process') : 0;
        snapshot.activatedCount = statusCounts.containsKey('Activated') ? statusCounts.get('Activated') : 0;
        snapshot.signedCount = statusCounts.containsKey('Signed') ? statusCounts.get('Signed') : 0;
        snapshot.awaitingSignatureCount = statusCounts.containsKey('Awaiting Signature') ? statusCounts.get('Awaiting Signature') : 0;
        snapshot.expiring30Count = [SELECT COUNT() FROM Contract WHERE EndDate != null AND EndDate >= :Date.today() AND EndDate <= :Date.today().addDays(30)];

        snapshot.expiringContracts = new List<ExpiringContract>();
        for (Contract contractRecord : [
            SELECT Id, ContractNumber, Status, EndDate, Account.Name
            FROM Contract
            WHERE EndDate != null
            ORDER BY EndDate ASC
            LIMIT 8
        ]) {
            ExpiringContract entry = new ExpiringContract();
            entry.contractId = contractRecord.Id;
            entry.contractNumber = contractRecord.ContractNumber;
            entry.accountName = contractRecord.Account != null ? contractRecord.Account.Name : null;
            entry.status = contractRecord.Status;
            entry.endDate = contractRecord.EndDate;
            snapshot.expiringContracts.add(entry);
        }

        Date today = Date.today();
        Date soon = today.addDays(30);
        Integer queueLimit = 12;
        Set<Id> queuedContractIds = new Set<Id>();
        List<AttentionContract> attentionQueue = new List<AttentionContract>();

        // Draft contracts represent new incoming requests and should appear at the top of the queue.
        for (Contract contractRecord : [
            SELECT Id, ContractNumber, Status, EndDate, Account.Name
            FROM Contract
            WHERE Status = 'Draft'
            ORDER BY CreatedDate DESC
            LIMIT 8
        ]) {
            if (queuedContractIds.contains(contractRecord.Id)) {
                continue;
            }
            queuedContractIds.add(contractRecord.Id);
            attentionQueue.add(mapAttentionContract(contractRecord, today, soon));
            if (attentionQueue.size() >= queueLimit) {
                break;
            }
        }

        if (attentionQueue.size() < queueLimit) {
            for (Contract contractRecord : [
                SELECT Id, ContractNumber, Status, EndDate, Account.Name
                FROM Contract
                WHERE Status IN ('Awaiting Signature', 'In Approval Process', 'Negotiating')
                   OR (EndDate != null AND EndDate <= :soon)
                ORDER BY EndDate ASC NULLS LAST, LastModifiedDate DESC
                LIMIT 24
            ]) {
                if (queuedContractIds.contains(contractRecord.Id)) {
                    continue;
                }
                queuedContractIds.add(contractRecord.Id);
                attentionQueue.add(mapAttentionContract(contractRecord, today, soon));
                if (attentionQueue.size() >= queueLimit) {
                    break;
                }
            }
        }

        snapshot.attentionContracts = attentionQueue;

        return snapshot;
    }

    private static AttentionContract mapAttentionContract(Contract contractRecord, Date today, Date soon) {
        AttentionContract entry = new AttentionContract();
        entry.contractId = contractRecord.Id;
        entry.contractNumber = contractRecord.ContractNumber;
        entry.accountName = contractRecord.Account != null ? contractRecord.Account.Name : null;
        entry.status = contractRecord.Status;
        entry.endDate = contractRecord.EndDate;
        entry.attentionReason = deriveAttentionReason(contractRecord, today, soon);
        return entry;
    }

    private static String deriveAttentionReason(Contract contractRecord, Date today, Date soon) {
        if (contractRecord.Status == 'Draft') {
            return 'New Request';
        }
        if (contractRecord.EndDate != null && contractRecord.EndDate < today) {
            return 'Expired';
        }
        if (contractRecord.EndDate != null && contractRecord.EndDate <= soon) {
            return 'Expiring Soon';
        }
        if (contractRecord.Status == 'Awaiting Signature') {
            return 'Needs Signature';
        }
        if (contractRecord.Status == 'In Approval Process') {
            return 'Pending Approval';
        }
        if (contractRecord.Status == 'Negotiating') {
            return 'In Negotiation';
        }
        return 'Review Needed';
    }

    @AuraEnabled(cacheable=true)
    public static StageInsights getStageInsights() {
        StageInsights insights = new StageInsights();
        insights.lastRefreshed = System.now();
        insights.contractsAnalyzed = 0;
        insights.completedContracts = 0;
        insights.avgCompletionDays = 0;
        insights.completionBuckets = new List<CompletionBucket>();
        insights.avgStageDurations = new List<StageDuration>();

        List<Contract> contracts = [
            SELECT Id, Status, StartDate, EndDate, CreatedDate
            FROM Contract
            WHERE StartDate != null
            ORDER BY CreatedDate ASC
            LIMIT 5000
        ];

        if (contracts.isEmpty()) {
            return insights;
        }

        insights.contractsAnalyzed = contracts.size();

        Set<String> completionStatuses = new Set<String>{
            'Activated',
            'Signed',
            'Rejected',
            'Canceled',
            'Contract Expired',
            'Contract Terminated'
        };

        List<Integer> completionDays = new List<Integer>();
        for (Contract contractRecord : contracts) {
            if (!completionStatuses.contains(contractRecord.Status)) {
                continue;
            }

            Date completionDate = contractRecord.EndDate != null ? contractRecord.EndDate : Date.today();
            Integer daySpan = contractRecord.StartDate.daysBetween(completionDate);
            if (daySpan >= 0) {
                completionDays.add(daySpan);
            }
        }

        insights.completedContracts = completionDays.size();
        if (!completionDays.isEmpty()) {
            Decimal totalDays = 0;
            for (Integer value : completionDays) {
                totalDays += value;
            }
            insights.avgCompletionDays = (totalDays / completionDays.size()).setScale(1);
        }

        Map<String, Integer> bucketCounts = new Map<String, Integer>{
            '0-30 days' => 0,
            '31-60 days' => 0,
            '61-90 days' => 0,
            '91-180 days' => 0,
            '180+ days' => 0
        };

        for (Integer value : completionDays) {
            if (value <= 30) {
                bucketCounts.put('0-30 days', bucketCounts.get('0-30 days') + 1);
            } else if (value <= 60) {
                bucketCounts.put('31-60 days', bucketCounts.get('31-60 days') + 1);
            } else if (value <= 90) {
                bucketCounts.put('61-90 days', bucketCounts.get('61-90 days') + 1);
            } else if (value <= 180) {
                bucketCounts.put('91-180 days', bucketCounts.get('91-180 days') + 1);
            } else {
                bucketCounts.put('180+ days', bucketCounts.get('180+ days') + 1);
            }
        }

        List<String> bucketOrder = new List<String>{'0-30 days', '31-60 days', '61-90 days', '91-180 days', '180+ days'};
        Map<String, String> bucketColors = new Map<String, String>{
            '0-30 days' => '#2e7d32',
            '31-60 days' => '#43a047',
            '61-90 days' => '#f9a825',
            '91-180 days' => '#ef6c00',
            '180+ days' => '#c62828'
        };

        for (String bucket : bucketOrder) {
            CompletionBucket bucketEntry = new CompletionBucket();
            Integer count = bucketCounts.get(bucket);
            bucketEntry.label = bucket;
            bucketEntry.count = count;
            bucketEntry.percentage = insights.completedContracts > 0
                ? (Decimal.valueOf(count) * 100 / Decimal.valueOf(insights.completedContracts)).setScale(1)
                : 0;
            bucketEntry.color = bucketColors.get(bucket);
            insights.completionBuckets.add(bucketEntry);
        }

        Map<String, Decimal> totalDaysByStage = new Map<String, Decimal>();
        Map<String, Integer> occurrencesByStage = new Map<String, Integer>();

        for (Contract contractRecord : contracts) {
            String currentStage = String.isBlank(contractRecord.Status) ? 'Unknown' : contractRecord.Status;
            Date terminalDate = completionStatuses.contains(contractRecord.Status) && contractRecord.EndDate != null
                ? contractRecord.EndDate
                : Date.today();
            Integer stageDays = Math.max(0, contractRecord.StartDate.daysBetween(terminalDate));
            addStageDuration(totalDaysByStage, occurrencesByStage, currentStage, stageDays);
        }

        List<StageDuration> stageDurations = new List<StageDuration>();
        for (String stage : totalDaysByStage.keySet()) {
            Integer occurrences = occurrencesByStage.get(stage);
            Decimal totalDays = totalDaysByStage.get(stage);

            StageDuration stageDuration = new StageDuration();
            stageDuration.status = stage;
            stageDuration.totalDays = totalDays.setScale(1);
            stageDuration.occurrences = occurrences;
            stageDuration.avgDays = occurrences > 0 ? (totalDays / occurrences).setScale(1) : 0;
            stageDuration.color = getStageColor(stage);
            stageDurations.add(stageDuration);
        }
        insights.avgStageDurations = stageDurations;

        return insights;
    }

    private static void addStageDuration(
        Map<String, Decimal> totalDaysByStage,
        Map<String, Integer> occurrencesByStage,
        String stage,
        Integer segmentDays
    ) {
        if (String.isBlank(stage)) {
            stage = 'Unknown';
        }
        Decimal runningTotal = totalDaysByStage.containsKey(stage) ? totalDaysByStage.get(stage) : 0;
        Integer runningCount = occurrencesByStage.containsKey(stage) ? occurrencesByStage.get(stage) : 0;

        totalDaysByStage.put(stage, runningTotal + segmentDays);
        occurrencesByStage.put(stage, runningCount + 1);
    }

    private static String getStageColor(String stage) {
        if (stage == 'Draft') return '#90a4ae';
        if (stage == 'In Approval Process') return '#5c6bc0';
        if (stage == 'Negotiating') return '#00897b';
        if (stage == 'Awaiting Signature') return '#f9a825';
        if (stage == 'Activated') return '#2e7d32';
        if (stage == 'Signed') return '#1e88e5';
        if (stage == 'Rejected') return '#d32f2f';
        if (stage == 'Canceled') return '#8e24aa';
        if (stage == 'Contract Expired') return '#ef6c00';
        if (stage == 'Contract Terminated') return '#6d4c41';
        return '#546e7a';
    }
}
