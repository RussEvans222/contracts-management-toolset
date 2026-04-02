public with sharing class SDO_ContractHistoryTimelineController {
    private static final Integer DEFAULT_MAX_ROWS = 400;
    private static final Integer MAX_ALLOWED_ROWS = 2000;
    private static final Integer MIN_ALLOWED_ROWS = 50;
    private static final String SOURCE_HISTORY = 'Field History';
    private static final String SOURCE_TASK = 'Task';
    private static final String SOURCE_EVENT = 'Event';
    private static final String SOURCE_EMAIL = 'Email';
    private static final String SOURCE_APPROVAL = 'Approval';

    private static Map<String, String> contractFieldLabelByApiName;

    public class TimelinePayload {
        @AuraEnabled public Id contractId;
        @AuraEnabled public String contractName;
        @AuraEnabled public String contractNumber;
        @AuraEnabled public String contractStatus;
        @AuraEnabled public Integer totalAvailableEvents;
        @AuraEnabled public Integer returnedEvents;
        @AuraEnabled public Integer appliedMaxRows;
        @AuraEnabled public Boolean isTruncated;
        @AuraEnabled public Datetime newestEventAt;
        @AuraEnabled public Datetime oldestEventAt;
        @AuraEnabled public List<TimelineEvent> events;
    }

    public class TimelineEvent implements Comparable {
        @AuraEnabled public Id historyId;
        @AuraEnabled public Id contractId;
        @AuraEnabled public String fieldApiName;
        @AuraEnabled public String fieldLabel;
        @AuraEnabled public String dataType;
        @AuraEnabled public String oldValue;
        @AuraEnabled public String newValue;
        @AuraEnabled public String changeType;
        @AuraEnabled public Datetime createdDate;
        @AuraEnabled public Id createdById;
        @AuraEnabled public String createdByName;
        @AuraEnabled public String sourceCategory;
        @AuraEnabled public String iconName;

        public Integer compareTo(Object compareToValue) {
            TimelineEvent other = (TimelineEvent) compareToValue;
            Long thisTime = createdDate == null ? 0 : createdDate.getTime();
            Long otherTime = other == null || other.createdDate == null ? 0 : other.createdDate.getTime();
            if (thisTime == otherTime) {
                return 0;
            }
            return thisTime > otherTime ? -1 : 1;
        }
    }

    @AuraEnabled(cacheable=true)
    public static TimelinePayload getContractHistoryTimeline(Id contractId, Integer maxRows) {
        if (contractId == null) {
            throw new AuraHandledException('A Contract Id is required to load history timeline.');
        }

        Integer rowLimit = normalizeLimit(maxRows);

        Contract contractRecord = [
            SELECT Id, Name, ContractNumber, Status
            FROM Contract
            WHERE Id = :contractId
            LIMIT 1
        ];

        Integer totalHistoryRows = countHistoryRows(contractId);
        Integer totalTaskRows = isObjectQueryable('Task') ? countTaskRows(contractId) : 0;
        Integer totalEventRows = isObjectQueryable('Event') ? countEventRows(contractId) : 0;
        Integer totalEmailRows = isObjectQueryable('EmailMessage') ? countEmailRows(contractId) : 0;
        Integer totalApprovalRows = countApprovalRows(contractId);

        List<TimelineEvent> allEvents = new List<TimelineEvent>();
        allEvents.addAll(buildHistoryEvents(contractId, rowLimit));
        allEvents.addAll(buildTaskEvents(contractId, rowLimit));
        allEvents.addAll(buildEventEvents(contractId, rowLimit));
        allEvents.addAll(buildEmailEvents(contractId, rowLimit));
        allEvents.addAll(buildApprovalEvents(contractId, rowLimit));
        allEvents.sort();

        if (allEvents.size() > rowLimit) {
            List<TimelineEvent> trimmedEvents = new List<TimelineEvent>();
            for (Integer index = 0; index < rowLimit; index++) {
                trimmedEvents.add(allEvents[index]);
            }
            allEvents = trimmedEvents;
        }

        TimelinePayload payload = new TimelinePayload();
        payload.contractId = contractRecord.Id;
        payload.contractName = contractRecord.Name;
        payload.contractNumber = contractRecord.ContractNumber;
        payload.contractStatus = contractRecord.Status;
        payload.totalAvailableEvents = totalHistoryRows + totalTaskRows + totalEventRows + totalEmailRows + totalApprovalRows;
        payload.returnedEvents = allEvents.size();
        payload.appliedMaxRows = rowLimit;
        payload.isTruncated = payload.totalAvailableEvents > payload.returnedEvents;
        payload.events = allEvents;

        if (!payload.events.isEmpty()) {
            payload.newestEventAt = payload.events[0].createdDate;
            payload.oldestEventAt = payload.events[payload.events.size() - 1].createdDate;
        }

        return payload;
    }

    private static Integer normalizeLimit(Integer requested) {
        Integer candidate = requested == null ? DEFAULT_MAX_ROWS : requested;
        if (candidate < MIN_ALLOWED_ROWS) {
            return MIN_ALLOWED_ROWS;
        }
        if (candidate > MAX_ALLOWED_ROWS) {
            return MAX_ALLOWED_ROWS;
        }
        return candidate;
    }

    private static String stringifyAnyValue(Object value) {
        if (value == null) {
            return null;
        }
        String stringValue = String.valueOf(value);
        return String.isBlank(stringValue) ? null : stringValue;
    }

    private static String deriveChangeType(String oldValue, String newValue) {
        Boolean hasOld = !String.isBlank(oldValue);
        Boolean hasNew = !String.isBlank(newValue);
        if (!hasOld && hasNew) {
            return 'Set';
        }
        if (hasOld && !hasNew) {
            return 'Cleared';
        }
        if (hasOld && hasNew) {
            return 'Updated';
        }
        return 'Event';
    }

    private static Integer countHistoryRows(Id contractId) {
        return [
            SELECT COUNT()
            FROM ContractHistory
            WHERE ContractId = :contractId
        ];
    }

    private static Integer countTaskRows(Id contractId) {
        try {
            return [
                SELECT COUNT()
                FROM Task
                WHERE WhatId = :contractId
            ];
        } catch (Exception ignored) {
            return 0;
        }
    }

    private static Integer countEventRows(Id contractId) {
        try {
            return [
                SELECT COUNT()
                FROM Event
                WHERE WhatId = :contractId
            ];
        } catch (Exception ignored) {
            return 0;
        }
    }

    private static Integer countEmailRows(Id contractId) {
        try {
            return [
                SELECT COUNT()
                FROM EmailMessage
                WHERE RelatedToId = :contractId
            ];
        } catch (Exception ignored) {
            return 0;
        }
    }

    private static Integer countApprovalRows(Id contractId) {
        Integer total = 0;

        if (!isObjectQueryable('ProcessInstance')) {
            return 0;
        }

        try {
            total += [
                SELECT COUNT()
                FROM ProcessInstance
                WHERE TargetObjectId = :contractId
            ];
        } catch (Exception ignored) {
            // Continue and count any approval child rows that are queryable.
        }

        if (isObjectQueryable('ProcessInstanceStep')) {
            try {
                total += [
                    SELECT COUNT()
                    FROM ProcessInstanceStep
                    WHERE ProcessInstanceId IN (
                        SELECT Id
                        FROM ProcessInstance
                        WHERE TargetObjectId = :contractId
                    )
                ];
            } catch (Exception ignored) {
                // Ignore in orgs where this relationship is not exposed.
            }
        }

        if (isObjectQueryable('ProcessInstanceWorkitem')) {
            try {
                total += [
                    SELECT COUNT()
                    FROM ProcessInstanceWorkitem
                    WHERE ProcessInstanceId IN (
                        SELECT Id
                        FROM ProcessInstance
                        WHERE TargetObjectId = :contractId
                    )
                ];
            } catch (Exception ignored) {
                // Ignore in orgs where this relationship is not exposed.
            }
        }

        return total;
    }

    private static List<TimelineEvent> buildHistoryEvents(Id contractId, Integer rowLimit) {
        List<TimelineEvent> events = new List<TimelineEvent>();
        List<ContractHistory> historyRows = [
            SELECT Id,
                   ContractId,
                   Field,
                   DataType,
                   OldValue,
                   NewValue,
                   CreatedDate,
                   CreatedById,
                   CreatedBy.Name
            FROM ContractHistory
            WHERE ContractId = :contractId
            ORDER BY CreatedDate DESC
            LIMIT :rowLimit
        ];

        for (ContractHistory historyRow : historyRows) {
            TimelineEvent eventRow = new TimelineEvent();
            eventRow.historyId = historyRow.Id;
            eventRow.contractId = historyRow.ContractId;
            eventRow.fieldApiName = historyRow.Field;
            eventRow.fieldLabel = resolveFieldLabel(historyRow.Field);
            eventRow.dataType = historyRow.DataType;
            eventRow.oldValue = stringifyAnyValue(historyRow.OldValue);
            eventRow.newValue = stringifyAnyValue(historyRow.NewValue);
            eventRow.changeType = deriveChangeType(eventRow.oldValue, eventRow.newValue);
            eventRow.createdDate = historyRow.CreatedDate;
            eventRow.createdById = historyRow.CreatedById;
            eventRow.createdByName = historyRow.CreatedBy != null ? historyRow.CreatedBy.Name : null;
            eventRow.sourceCategory = SOURCE_HISTORY;
            eventRow.iconName = 'utility:trail';
            events.add(eventRow);
        }
        return events;
    }

    private static List<TimelineEvent> buildTaskEvents(Id contractId, Integer rowLimit) {
        List<TimelineEvent> events = new List<TimelineEvent>();
        if (!isObjectQueryable('Task')) {
            return events;
        }

        try {
            for (Task taskRow : [
                SELECT Id, WhatId, Subject, Status, Priority, ActivityDate, Type, CreatedDate, CreatedById, CreatedBy.Name
                FROM Task
                WHERE WhatId = :contractId
                ORDER BY CreatedDate DESC
                LIMIT :rowLimit
            ]) {
                TimelineEvent eventRow = new TimelineEvent();
                eventRow.historyId = taskRow.Id;
                eventRow.contractId = contractId;
                eventRow.fieldApiName = 'Task';
                eventRow.fieldLabel = 'Task • ' + defaultString(taskRow.Subject, 'Activity');
                eventRow.dataType = 'Task';
                eventRow.oldValue = null;
                eventRow.newValue =
                    'Status: ' + defaultString(taskRow.Status, 'Unknown') +
                    ' | Priority: ' + defaultString(taskRow.Priority, 'Normal') +
                    ' | Type: ' + defaultString(taskRow.Type, 'General') +
                    (taskRow.ActivityDate == null ? '' : ' | Due: ' + String.valueOf(taskRow.ActivityDate));
                eventRow.changeType = 'Activity';
                eventRow.createdDate = taskRow.CreatedDate;
                eventRow.createdById = taskRow.CreatedById;
                eventRow.createdByName = taskRow.CreatedBy != null ? taskRow.CreatedBy.Name : null;
                eventRow.sourceCategory = SOURCE_TASK;
                eventRow.iconName = 'standard:task';
                events.add(eventRow);
            }
        } catch (Exception ignored) {
            return new List<TimelineEvent>();
        }
        return events;
    }

    private static List<TimelineEvent> buildEventEvents(Id contractId, Integer rowLimit) {
        List<TimelineEvent> events = new List<TimelineEvent>();
        if (!isObjectQueryable('Event')) {
            return events;
        }

        try {
            for (Event eventRecord : [
                SELECT Id, WhatId, Subject, ActivityDateTime, DurationInMinutes, Location, CreatedDate, CreatedById, CreatedBy.Name
                FROM Event
                WHERE WhatId = :contractId
                ORDER BY ActivityDateTime DESC NULLS LAST, CreatedDate DESC
                LIMIT :rowLimit
            ]) {
                TimelineEvent eventRow = new TimelineEvent();
                eventRow.historyId = eventRecord.Id;
                eventRow.contractId = contractId;
                eventRow.fieldApiName = 'Event';
                eventRow.fieldLabel = 'Event • ' + defaultString(eventRecord.Subject, 'Meeting');
                eventRow.dataType = 'Event';
                eventRow.oldValue = null;
                eventRow.newValue =
                    'Starts: ' + (eventRecord.ActivityDateTime == null ? 'Unknown' : String.valueOf(eventRecord.ActivityDateTime)) +
                    (eventRecord.DurationInMinutes == null ? '' : ' | Duration: ' + String.valueOf(eventRecord.DurationInMinutes) + 'm') +
                    (String.isBlank(eventRecord.Location) ? '' : ' | Location: ' + eventRecord.Location);
                eventRow.changeType = 'Activity';
                eventRow.createdDate = eventRecord.ActivityDateTime == null ? eventRecord.CreatedDate : eventRecord.ActivityDateTime;
                eventRow.createdById = eventRecord.CreatedById;
                eventRow.createdByName = eventRecord.CreatedBy != null ? eventRecord.CreatedBy.Name : null;
                eventRow.sourceCategory = SOURCE_EVENT;
                eventRow.iconName = 'standard:event';
                events.add(eventRow);
            }
        } catch (Exception ignored) {
            return new List<TimelineEvent>();
        }
        return events;
    }

    private static List<TimelineEvent> buildEmailEvents(Id contractId, Integer rowLimit) {
        List<TimelineEvent> events = new List<TimelineEvent>();
        if (!isObjectQueryable('EmailMessage')) {
            return events;
        }

        try {
            for (EmailMessage emailRow : [
                SELECT Id, RelatedToId, Subject, Status, FromName, ToAddress, MessageDate, CreatedDate, CreatedById, CreatedBy.Name
                FROM EmailMessage
                WHERE RelatedToId = :contractId
                ORDER BY MessageDate DESC NULLS LAST, CreatedDate DESC
                LIMIT :rowLimit
            ]) {
                TimelineEvent eventRow = new TimelineEvent();
                eventRow.historyId = emailRow.Id;
                eventRow.contractId = contractId;
                eventRow.fieldApiName = 'EmailMessage';
                eventRow.fieldLabel = 'Email • ' + defaultString(emailRow.Subject, 'Email Thread');
                eventRow.dataType = 'EmailMessage';
                eventRow.oldValue = null;
                eventRow.newValue =
                    'From: ' + defaultString(emailRow.FromName, 'Unknown') +
                    ' | To: ' + defaultString(emailRow.ToAddress, 'Unknown') +
                    ' | Status: ' + defaultString(emailRow.Status, 'Unknown');
                eventRow.changeType = 'Activity';
                eventRow.createdDate = emailRow.MessageDate == null ? emailRow.CreatedDate : emailRow.MessageDate;
                eventRow.createdById = emailRow.CreatedById;
                eventRow.createdByName = emailRow.CreatedBy != null ? emailRow.CreatedBy.Name : null;
                eventRow.sourceCategory = SOURCE_EMAIL;
                eventRow.iconName = 'standard:email';
                events.add(eventRow);
            }
        } catch (Exception ignored) {
            return new List<TimelineEvent>();
        }
        return events;
    }

    private static List<TimelineEvent> buildApprovalEvents(Id contractId, Integer rowLimit) {
        List<TimelineEvent> events = new List<TimelineEvent>();
        if (!isObjectQueryable('ProcessInstance')) {
            return events;
        }

        try {
            for (ProcessInstance processRow : [
                SELECT Id, TargetObjectId, Status, CreatedDate, CompletedDate, SubmittedById, SubmittedBy.Name
                FROM ProcessInstance
                WHERE TargetObjectId = :contractId
                ORDER BY CreatedDate DESC
                LIMIT :rowLimit
            ]) {
                TimelineEvent eventRow = new TimelineEvent();
                eventRow.historyId = processRow.Id;
                eventRow.contractId = contractId;
                eventRow.fieldApiName = 'ApprovalSubmission';
                eventRow.fieldLabel = 'Approval Submitted';
                eventRow.dataType = 'Approval';
                eventRow.oldValue = null;
                eventRow.newValue =
                    'Status: ' + defaultString(processRow.Status, 'Unknown') +
                    (processRow.CompletedDate == null ? '' : ' | Completed: ' + String.valueOf(processRow.CompletedDate));
                eventRow.changeType = 'Activity';
                eventRow.createdDate = processRow.CreatedDate;
                eventRow.createdById = processRow.SubmittedById;
                eventRow.createdByName = processRow.SubmittedBy != null ? processRow.SubmittedBy.Name : null;
                eventRow.sourceCategory = SOURCE_APPROVAL;
                eventRow.iconName = 'utility:check';
                events.add(eventRow);
            }
        } catch (Exception ignored) {
            // Ignore object availability and continue with step/workitem attempts.
        }

        if (isObjectQueryable('ProcessInstanceStep')) {
            try {
                for (ProcessInstanceStep stepRow : [
                    SELECT Id, ProcessInstanceId, StepStatus, Comments, CreatedDate, ActorId, Actor.Name
                    FROM ProcessInstanceStep
                    WHERE ProcessInstanceId IN (
                        SELECT Id
                        FROM ProcessInstance
                        WHERE TargetObjectId = :contractId
                    )
                    ORDER BY CreatedDate DESC
                    LIMIT :rowLimit
                ]) {
                    TimelineEvent eventRow = new TimelineEvent();
                    eventRow.historyId = stepRow.Id;
                    eventRow.contractId = contractId;
                    eventRow.fieldApiName = 'ApprovalStep';
                    eventRow.fieldLabel = 'Approval Step • ' + defaultString(stepRow.StepStatus, 'Updated');
                    eventRow.dataType = 'Approval';
                    eventRow.oldValue = null;
                    eventRow.newValue = String.isBlank(stepRow.Comments)
                        ? 'Status: ' + defaultString(stepRow.StepStatus, 'Unknown')
                        : stepRow.Comments;
                    eventRow.changeType = 'Activity';
                    eventRow.createdDate = stepRow.CreatedDate;
                    eventRow.createdById = stepRow.ActorId;
                    eventRow.createdByName = stepRow.Actor != null ? stepRow.Actor.Name : null;
                    eventRow.sourceCategory = SOURCE_APPROVAL;
                    eventRow.iconName = 'utility:check';
                    events.add(eventRow);
                }
            } catch (Exception ignored) {
                // Ignore when the step object can't be queried in this org.
            }
        }

        if (isObjectQueryable('ProcessInstanceWorkitem')) {
            try {
                for (ProcessInstanceWorkitem pendingRow : [
                    SELECT Id, ProcessInstanceId, CreatedDate, ActorId, Actor.Name
                    FROM ProcessInstanceWorkitem
                    WHERE ProcessInstanceId IN (
                        SELECT Id
                        FROM ProcessInstance
                        WHERE TargetObjectId = :contractId
                    )
                    ORDER BY CreatedDate DESC
                    LIMIT :rowLimit
                ]) {
                    TimelineEvent eventRow = new TimelineEvent();
                    eventRow.historyId = pendingRow.Id;
                    eventRow.contractId = contractId;
                    eventRow.fieldApiName = 'ApprovalPending';
                    eventRow.fieldLabel = 'Approval Pending';
                    eventRow.dataType = 'Approval';
                    eventRow.oldValue = null;
                    eventRow.newValue = 'Pending with: ' + defaultString(pendingRow.Actor != null ? pendingRow.Actor.Name : null, 'Queue/User');
                    eventRow.changeType = 'Activity';
                    eventRow.createdDate = pendingRow.CreatedDate;
                    eventRow.createdById = pendingRow.ActorId;
                    eventRow.createdByName = pendingRow.Actor != null ? pendingRow.Actor.Name : null;
                    eventRow.sourceCategory = SOURCE_APPROVAL;
                    eventRow.iconName = 'utility:clock';
                    events.add(eventRow);
                }
            } catch (Exception ignored) {
                // Ignore when the work item object can't be queried in this org.
            }
        }

        return events;
    }

    private static String resolveFieldLabel(String fieldApiName) {
        if (String.isBlank(fieldApiName)) {
            return 'System Event';
        }

        Map<String, String> labelMap = getContractFieldLabelMap();
        if (labelMap.containsKey(fieldApiName)) {
            return labelMap.get(fieldApiName);
        }

        return humanizeFieldToken(fieldApiName);
    }

    private static Boolean isObjectQueryable(String objectApiName) {
        Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectApiName);
        return objectType != null && objectType.getDescribe().isQueryable();
    }

    private static String defaultString(String value, String fallback) {
        return String.isBlank(value) ? fallback : value;
    }

    private static Map<String, String> getContractFieldLabelMap() {
        if (contractFieldLabelByApiName != null) {
            return contractFieldLabelByApiName;
        }

        contractFieldLabelByApiName = new Map<String, String>();
        Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Contract.fields.getMap();
        for (String apiName : fieldMap.keySet()) {
            contractFieldLabelByApiName.put(apiName, fieldMap.get(apiName).getDescribe().getLabel());
        }

        return contractFieldLabelByApiName;
    }

    private static String humanizeFieldToken(String token) {
        String cleaned = token;
        if (cleaned.endsWith('__c')) {
            cleaned = cleaned.substring(0, cleaned.length() - 3);
        }
        cleaned = cleaned.replace('__', ' ');
        cleaned = cleaned.replace('_', ' ');

        String spaced = '';
        for (Integer index = 0; index < cleaned.length(); index++) {
            String current = cleaned.substring(index, index + 1);
            if (index > 0 && isUppercaseLetter(current)) {
                String previous = cleaned.substring(index - 1, index);
                if (isLowercaseLetter(previous) || isDigit(previous)) {
                    spaced += ' ';
                }
            }
            spaced += current;
        }

        return toTitleCase(spaced.trim());
    }

    private static String toTitleCase(String sourceText) {
        if (String.isBlank(sourceText)) {
            return 'System Event';
        }

        List<String> words = sourceText.toLowerCase().split('\\s+');
        List<String> normalizedWords = new List<String>();
        for (String word : words) {
            if (String.isBlank(word)) {
                continue;
            }
            normalizedWords.add(word.substring(0, 1).toUpperCase() + word.substring(1));
        }
        return String.join(normalizedWords, ' ');
    }

    private static Boolean isUppercaseLetter(String value) {
        if (String.isBlank(value) || value.length() != 1) {
            return false;
        }
        return value == value.toUpperCase() && value != value.toLowerCase();
    }

    private static Boolean isLowercaseLetter(String value) {
        if (String.isBlank(value) || value.length() != 1) {
            return false;
        }
        return value == value.toLowerCase() && value != value.toUpperCase();
    }

    private static Boolean isDigit(String value) {
        return !String.isBlank(value) && value.length() == 1 && '0123456789'.contains(value);
    }
}
