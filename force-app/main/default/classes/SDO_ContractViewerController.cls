public with sharing class SDO_ContractViewerController {
    private static final Set<String> PREVIEWABLE_FILE_TYPES = new Set<String>{
        'PDF', 'DOC', 'DOCX', 'PPT', 'PPTX', 'XLS', 'XLSX', 'PNG', 'JPG', 'JPEG', 'GIF'
    };

    public class ContractDocumentTile {
        @AuraEnabled public Id contractId;
        @AuraEnabled public String contractName;
        @AuraEnabled public String contractNumber;
        @AuraEnabled public String contractStatus;
        @AuraEnabled public Boolean isSigned;
        @AuraEnabled public Id contentDocumentId;
        @AuraEnabled public Id latestVersionId;
        @AuraEnabled public String documentTitle;
        @AuraEnabled public String fileType;
        @AuraEnabled public Integer versionCount;
        @AuraEnabled public Datetime documentCreatedDate;
        @AuraEnabled public String thumbnailUrl;
        @AuraEnabled public Boolean isPreviewable;
    }

    public class ContractVersionFile {
        @AuraEnabled public Id contentDocumentId;
        @AuraEnabled public Id latestVersionId;
        @AuraEnabled public String title;
        @AuraEnabled public String fileType;
        @AuraEnabled public Datetime createdDate;
        @AuraEnabled public String thumbnailUrl;
        @AuraEnabled public String downloadUrl;
        @AuraEnabled public Boolean isPreviewable;
    }

    public class ContractVersionGroup {
        @AuraEnabled public Id versionRecordId;
        @AuraEnabled public Id contractId;
        @AuraEnabled public String versionName;
        @AuraEnabled public Integer versionNumber;
        @AuraEnabled public String versionStatus;
        @AuraEnabled public String creationProcessType;
        @AuraEnabled public Datetime createdDate;
        @AuraEnabled public Datetime lastModifiedDate;
        @AuraEnabled public Boolean isActive;
        @AuraEnabled public Integer fileCount;
        @AuraEnabled public Boolean hasPreviewableFile;
        @AuraEnabled public String primaryFileTitle;
        @AuraEnabled public String primaryFileType;
        @AuraEnabled public Id primaryContentDocumentId;
        @AuraEnabled public Id primaryContentVersionId;
        @AuraEnabled public String primaryThumbnailUrl;
        @AuraEnabled public List<ContractVersionFile> files;
    }

    public class ContractRecordDocumentSummary {
        @AuraEnabled public Id contractId;
        @AuraEnabled public String contractName;
        @AuraEnabled public String contractNumber;
        @AuraEnabled public String contractStatus;
        @AuraEnabled public String signatureStatus;
        @AuraEnabled public String signatureVendor;
        @AuraEnabled public Datetime signatureLastUpdated;
        @AuraEnabled public Id contractDocumentVersionId;
        @AuraEnabled public Integer contractDocumentVersionNumber;
        @AuraEnabled public String contractDocumentVersionStatus;
        @AuraEnabled public Id contentDocumentId;
        @AuraEnabled public Id latestVersionId;
        @AuraEnabled public String documentTitle;
        @AuraEnabled public String fileType;
        @AuraEnabled public Integer versionCount;
        @AuraEnabled public Datetime documentCreatedDate;
        @AuraEnabled public String thumbnailUrl;
        @AuraEnabled public Boolean isPreviewable;
        @AuraEnabled public Boolean hasDocument;
    }

    private class ScopedDocumentLink {
        Id contractId;
        ContentDocumentLink link;

        ScopedDocumentLink(Id contractIdValue, ContentDocumentLink linkValue) {
            contractId = contractIdValue;
            link = linkValue;
        }
    }

    private class TileCandidate implements Comparable {
        ContractDocumentTile tile;

        TileCandidate(ContractDocumentTile tileValue) {
            tile = tileValue;
        }

        public Integer compareTo(Object otherValue) {
            TileCandidate other = (TileCandidate) otherValue;
            Long thisTime = tile.documentCreatedDate != null ? tile.documentCreatedDate.getTime() : 0;
            Long otherTime = other.tile.documentCreatedDate != null ? other.tile.documentCreatedDate.getTime() : 0;
            if (thisTime == otherTime) {
                return 0;
            }
            return otherTime > thisTime ? 1 : -1;
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<ContractDocumentTile> getRecentContractDocuments(
        Integer maxTiles,
        String statusFilter,
        Boolean fetchAll,
        Id contractId
    ) {
        Boolean includeAll = fetchAll == true;
        Integer tileLimit = includeAll
            ? 2000
            : ((maxTiles == null || maxTiles <= 0) ? 16 : Math.min(maxTiles, 200));
        Integer linkLimit = includeAll
            ? 5000
            : Math.min(Math.max(tileLimit * 8, 200), 1200);
        String normalizedStatus = normalizeStatusFilter(statusFilter);

        List<ContentDocumentLink> links;
        if (contractId != null) {
            if (String.isBlank(normalizedStatus)) {
                links = [
                    SELECT LinkedEntityId,
                           ContentDocumentId,
                           ContentDocument.Title,
                           ContentDocument.FileType,
                           ContentDocument.CreatedDate,
                           ContentDocument.LatestPublishedVersionId
                    FROM ContentDocumentLink
                    WHERE LinkedEntityId = :contractId
                    ORDER BY ContentDocument.CreatedDate DESC
                    LIMIT :linkLimit
                ];
            } else {
                links = [
                    SELECT LinkedEntityId,
                           ContentDocumentId,
                           ContentDocument.Title,
                           ContentDocument.FileType,
                           ContentDocument.CreatedDate,
                           ContentDocument.LatestPublishedVersionId
                    FROM ContentDocumentLink
                    WHERE LinkedEntityId IN (
                        SELECT Id FROM Contract WHERE Id = :contractId AND Status = :normalizedStatus
                    )
                    ORDER BY ContentDocument.CreatedDate DESC
                    LIMIT :linkLimit
                ];
            }
        } else if (String.isBlank(normalizedStatus)) {
            links = [
                SELECT LinkedEntityId,
                       ContentDocumentId,
                       ContentDocument.Title,
                       ContentDocument.FileType,
                       ContentDocument.CreatedDate,
                       ContentDocument.LatestPublishedVersionId
                FROM ContentDocumentLink
                WHERE LinkedEntityId IN (SELECT Id FROM Contract)
                ORDER BY ContentDocument.CreatedDate DESC
                LIMIT :linkLimit
            ];
        } else {
            links = [
                SELECT LinkedEntityId,
                       ContentDocumentId,
                       ContentDocument.Title,
                       ContentDocument.FileType,
                       ContentDocument.CreatedDate,
                       ContentDocument.LatestPublishedVersionId
                FROM ContentDocumentLink
                WHERE LinkedEntityId IN (SELECT Id FROM Contract WHERE Status = :normalizedStatus)
                ORDER BY ContentDocument.CreatedDate DESC
                LIMIT :linkLimit
            ];
        }

        Map<Id, Id> contractIdByVersionId = new Map<Id, Id>();
        List<ContentDocumentLink> versionLinks = new List<ContentDocumentLink>();
        if (contractId != null && !links.isEmpty()) {
            Set<Id> versionIds = new Set<Id>();
            for (ContractDocumentVersion versionRecord : [
                SELECT Id, ContractId
                FROM ContractDocumentVersion
                WHERE ContractId = :contractId
                ORDER BY CreatedDate DESC
                LIMIT :Math.min(linkLimit, 500)
            ]) {
                versionIds.add(versionRecord.Id);
                contractIdByVersionId.put(versionRecord.Id, versionRecord.ContractId);
            }
            if (!versionIds.isEmpty()) {
                versionLinks = [
                    SELECT LinkedEntityId,
                           ContentDocumentId,
                           ContentDocument.Title,
                           ContentDocument.FileType,
                           ContentDocument.CreatedDate,
                           ContentDocument.LatestPublishedVersionId
                    FROM ContentDocumentLink
                    WHERE LinkedEntityId IN :versionIds
                    ORDER BY ContentDocument.CreatedDate DESC
                    LIMIT :linkLimit
                ];
            }
        }

        List<ScopedDocumentLink> scopedLinks = new List<ScopedDocumentLink>();
        for (ContentDocumentLink link : links) {
            scopedLinks.add(new ScopedDocumentLink(link.LinkedEntityId, link));
        }
        for (ContentDocumentLink link : versionLinks) {
            Id mappedContractId = contractIdByVersionId.get(link.LinkedEntityId);
            if (mappedContractId != null) {
                scopedLinks.add(new ScopedDocumentLink(mappedContractId, link));
            }
        }

        if (scopedLinks.isEmpty()) {
            return new List<ContractDocumentTile>();
        }

        Set<Id> contractIds = new Set<Id>();
        Set<Id> contentDocumentIds = new Set<Id>();
        for (ScopedDocumentLink scopedLink : scopedLinks) {
            contractIds.add(scopedLink.contractId);
            contentDocumentIds.add(scopedLink.link.ContentDocumentId);
        }
        if (contractIds.isEmpty()) {
            return new List<ContractDocumentTile>();
        }

        Map<Id, Contract> contractById = new Map<Id, Contract>([
            SELECT Id, Name, ContractNumber, Status
            FROM Contract
            WHERE Id IN :contractIds
        ]);

        Map<Id, Integer> versionsByDocumentId = new Map<Id, Integer>();
        for (AggregateResult row : [
            SELECT ContentDocumentId docId, COUNT(Id) versionCount
            FROM ContentVersion
            WHERE ContentDocumentId IN :contentDocumentIds
            GROUP BY ContentDocumentId
        ]) {
            versionsByDocumentId.put(
                (Id) row.get('docId'),
                (Integer) row.get('versionCount')
            );
        }

        Map<Id, Integer> contractDocVersionCounts = new Map<Id, Integer>();
        for (AggregateResult row : [
            SELECT ContractId contractId, COUNT(Id) versionCount
            FROM ContractDocumentVersion
            WHERE ContractId IN :contractIds
            GROUP BY ContractId
        ]) {
            contractDocVersionCounts.put(
                (Id) row.get('contractId'),
                (Integer) row.get('versionCount')
            );
        }

        Map<Id, ScopedDocumentLink> selectedLinkByContractId = new Map<Id, ScopedDocumentLink>();

        for (ScopedDocumentLink scopedLink : scopedLinks) {
            Contract contractRecord = contractById.get(scopedLink.contractId);
            if (contractRecord == null) {
                continue;
            }

            ScopedDocumentLink existingScopedLink = selectedLinkByContractId.get(scopedLink.contractId);
            if (existingScopedLink == null) {
                selectedLinkByContractId.put(scopedLink.contractId, scopedLink);
                continue;
            }

            if (isPreferredForContract(scopedLink.link, existingScopedLink.link)) {
                selectedLinkByContractId.put(scopedLink.contractId, scopedLink);
            }
        }

        List<TileCandidate> candidates = new List<TileCandidate>();
        for (ScopedDocumentLink scopedLink : selectedLinkByContractId.values()) {
            ContentDocumentLink link = scopedLink.link;
            Contract contractRecord = contractById.get(scopedLink.contractId);
            if (contractRecord == null) {
                continue;
            }

            ContractDocumentTile tile = new ContractDocumentTile();
            tile.contractId = contractRecord.Id;
            tile.contractName = contractRecord.Name;
            tile.contractNumber = contractRecord.ContractNumber;
            tile.contractStatus = contractRecord.Status;
            tile.isSigned = contractRecord.Status == 'Signed';
            tile.contentDocumentId = link.ContentDocumentId;
            tile.latestVersionId = link.ContentDocument.LatestPublishedVersionId;
            tile.documentTitle = link.ContentDocument.Title;
            tile.fileType = link.ContentDocument.FileType;
            Integer documentVersionCount = versionsByDocumentId.containsKey(link.ContentDocumentId)
                ? versionsByDocumentId.get(link.ContentDocumentId)
                : 1;
            Integer contractDocVersionCount = contractDocVersionCounts.containsKey(contractRecord.Id)
                ? contractDocVersionCounts.get(contractRecord.Id)
                : 1;
            tile.versionCount = Math.max(documentVersionCount, contractDocVersionCount);
            tile.documentCreatedDate = link.ContentDocument.CreatedDate;
            tile.thumbnailUrl = buildThumbnailUrl(link.ContentDocument.LatestPublishedVersionId);
            tile.isPreviewable = isPreviewableFileType(link.ContentDocument.FileType);
            candidates.add(new TileCandidate(tile));
        }

        candidates.sort();
        List<ContractDocumentTile> sortedTiles = new List<ContractDocumentTile>();
        for (TileCandidate candidate : candidates) {
            if (sortedTiles.size() >= tileLimit) {
                break;
            }
            sortedTiles.add(candidate.tile);
        }

        return sortedTiles;
    }

    @AuraEnabled(cacheable=true)
    public static ContractRecordDocumentSummary getContractRecordDocumentSummary(Id contractId) {
        if (contractId == null) {
            return null;
        }

        List<Contract> contracts = [
            SELECT Id,
                   Name,
                   ContractNumber,
                   Status,
                   ContractDocumentVersionId,
                   CompanySignedDate,
                   CustomerSignedDate
            FROM Contract
            WHERE Id = :contractId
            LIMIT 1
        ];
        if (contracts.isEmpty()) {
            return null;
        }
        Contract contractRecord = contracts[0];

        ContractRecordDocumentSummary summary = new ContractRecordDocumentSummary();
        summary.contractId = contractRecord.Id;
        summary.contractName = contractRecord.Name;
        summary.contractNumber = contractRecord.ContractNumber;
        summary.contractStatus = contractRecord.Status;
        summary.signatureStatus = deriveSignatureStatus(contractRecord, null);
        summary.contractDocumentVersionId = contractRecord.ContractDocumentVersionId;
        summary.isPreviewable = false;
        summary.hasDocument = false;
        Integer contractDocumentVersionCount = 0;
        for (AggregateResult row : [
            SELECT COUNT(Id) versionCount
            FROM ContractDocumentVersion
            WHERE ContractId = :contractRecord.Id
        ]) {
            contractDocumentVersionCount = (Integer) row.get('versionCount');
        }

        if (contractRecord.ContractDocumentVersionId != null) {
            List<ContractDocumentVersion> activeVersions = [
                SELECT Id, VersionNumber, Status
                FROM ContractDocumentVersion
                WHERE Id = :contractRecord.ContractDocumentVersionId
                LIMIT 1
            ];
            if (!activeVersions.isEmpty()) {
                summary.contractDocumentVersionNumber = activeVersions[0].VersionNumber == null
                    ? null
                    : Integer.valueOf(String.valueOf(activeVersions[0].VersionNumber));
                summary.contractDocumentVersionStatus = activeVersions[0].Status;
            }

            List<DocumentEnvelope> envelopes = [
                SELECT Status, Vendor, FinalStatusDateTime, CreatedDate
                FROM DocumentEnvelope
                WHERE ContractDocumentVersionId = :contractRecord.ContractDocumentVersionId
                ORDER BY CreatedDate DESC
                LIMIT 1
            ];
            if (!envelopes.isEmpty()) {
                DocumentEnvelope latestEnvelope = envelopes[0];
                summary.signatureStatus = deriveSignatureStatus(contractRecord, latestEnvelope);
                summary.signatureVendor = latestEnvelope.Vendor;
                summary.signatureLastUpdated = latestEnvelope.FinalStatusDateTime != null
                    ? latestEnvelope.FinalStatusDateTime
                    : latestEnvelope.CreatedDate;
            }
        }

        Set<Id> linkedIds = new Set<Id>{ contractRecord.Id };
        if (contractRecord.ContractDocumentVersionId != null) {
            linkedIds.add(contractRecord.ContractDocumentVersionId);
        }

        List<ContentDocumentLink> links = [
            SELECT LinkedEntityId,
                   ContentDocumentId,
                   ContentDocument.Title,
                   ContentDocument.FileType,
                   ContentDocument.CreatedDate,
                   ContentDocument.LatestPublishedVersionId
            FROM ContentDocumentLink
            WHERE LinkedEntityId IN :linkedIds
            ORDER BY ContentDocument.CreatedDate DESC
            LIMIT 300
        ];

        ContentDocumentLink preferredLink;
        for (ContentDocumentLink link : links) {
            if (preferredLink == null ||
                isPreferredForRecordPanel(link, preferredLink, contractRecord.ContractDocumentVersionId)) {
                preferredLink = link;
            }
        }

        if (preferredLink != null) {
            Integer versionCount = 1;
            for (AggregateResult row : [
                SELECT COUNT(Id) versionCount
                FROM ContentVersion
                WHERE ContentDocumentId = :preferredLink.ContentDocumentId
            ]) {
                versionCount = (Integer) row.get('versionCount');
            }

            summary.contentDocumentId = preferredLink.ContentDocumentId;
            summary.latestVersionId = preferredLink.ContentDocument.LatestPublishedVersionId;
            summary.documentTitle = preferredLink.ContentDocument.Title;
            summary.fileType = preferredLink.ContentDocument.FileType;
            summary.versionCount = Math.max(versionCount, contractDocumentVersionCount > 0 ? contractDocumentVersionCount : 1);
            summary.documentCreatedDate = preferredLink.ContentDocument.CreatedDate;
            summary.thumbnailUrl = buildThumbnailUrl(preferredLink.ContentDocument.LatestPublishedVersionId);
            summary.isPreviewable = isPreviewableFileType(preferredLink.ContentDocument.FileType);
            summary.hasDocument = true;
        }

        return summary;
    }

    @AuraEnabled(cacheable=true)
    public static List<ContractVersionGroup> getContractVersionTimeline(Id contractId) {
        if (contractId == null) {
            return new List<ContractVersionGroup>();
        }

        List<ContractDocumentVersion> versionRecords = [
            SELECT Id,
                   Name,
                   VersionNumber,
                   Status,
                   CreationProcessType,
                   CreatedDate,
                   LastModifiedDate
            FROM ContractDocumentVersion
            WHERE ContractId = :contractId
            ORDER BY VersionNumber DESC, CreatedDate DESC
            LIMIT 100
        ];

        if (versionRecords.isEmpty()) {
            return new List<ContractVersionGroup>();
        }

        Set<Id> versionIds = new Set<Id>();
        for (ContractDocumentVersion versionRecord : versionRecords) {
            versionIds.add(versionRecord.Id);
        }

        Map<Id, List<ContentDocumentLink>> linksByVersionId = new Map<Id, List<ContentDocumentLink>>();
        for (ContentDocumentLink link : [
            SELECT LinkedEntityId,
                   ContentDocumentId,
                   ContentDocument.Title,
                   ContentDocument.FileType,
                   ContentDocument.CreatedDate,
                   ContentDocument.LatestPublishedVersionId
            FROM ContentDocumentLink
            WHERE LinkedEntityId IN :versionIds
            ORDER BY ContentDocument.CreatedDate DESC
            LIMIT 1000
        ]) {
            if (!linksByVersionId.containsKey(link.LinkedEntityId)) {
                linksByVersionId.put(link.LinkedEntityId, new List<ContentDocumentLink>());
            }
            linksByVersionId.get(link.LinkedEntityId).add(link);
        }

        List<ContractVersionGroup> groups = new List<ContractVersionGroup>();
        for (ContractDocumentVersion versionRecord : versionRecords) {
            ContractVersionGroup versionGroup = new ContractVersionGroup();
            versionGroup.versionRecordId = versionRecord.Id;
            versionGroup.contractId = contractId;
            versionGroup.versionName = versionRecord.Name;
            versionGroup.versionNumber = versionRecord.VersionNumber == null
                ? null
                : Integer.valueOf(String.valueOf(versionRecord.VersionNumber));
            versionGroup.versionStatus = versionRecord.Status;
            versionGroup.creationProcessType = versionRecord.CreationProcessType;
            versionGroup.createdDate = versionRecord.CreatedDate;
            versionGroup.lastModifiedDate = versionRecord.LastModifiedDate;
            versionGroup.isActive = versionRecord.Status == 'Active';
            versionGroup.fileCount = 0;
            versionGroup.hasPreviewableFile = false;
            versionGroup.files = new List<ContractVersionFile>();

            List<ContentDocumentLink> versionLinks = linksByVersionId.containsKey(versionRecord.Id)
                ? linksByVersionId.get(versionRecord.Id)
                : new List<ContentDocumentLink>();

            ContentDocumentLink primaryLink;
            for (ContentDocumentLink link : versionLinks) {
                ContractVersionFile fileEntry = new ContractVersionFile();
                fileEntry.contentDocumentId = link.ContentDocumentId;
                fileEntry.latestVersionId = link.ContentDocument.LatestPublishedVersionId;
                fileEntry.title = link.ContentDocument.Title;
                fileEntry.fileType = link.ContentDocument.FileType;
                fileEntry.createdDate = link.ContentDocument.CreatedDate;
                fileEntry.thumbnailUrl = buildThumbnailUrl(link.ContentDocument.LatestPublishedVersionId);
                fileEntry.downloadUrl = buildDownloadUrl(link.ContentDocumentId);
                fileEntry.isPreviewable = isPreviewableFileType(link.ContentDocument.FileType);
                versionGroup.files.add(fileEntry);

                if (primaryLink == null || isPreferredForVersion(link, primaryLink)) {
                    primaryLink = link;
                }
            }

            versionGroup.fileCount = versionGroup.files.size();

            if (primaryLink != null) {
                versionGroup.primaryFileTitle = primaryLink.ContentDocument.Title;
                versionGroup.primaryFileType = primaryLink.ContentDocument.FileType;
                versionGroup.primaryContentDocumentId = primaryLink.ContentDocumentId;
                versionGroup.primaryContentVersionId = primaryLink.ContentDocument.LatestPublishedVersionId;
                versionGroup.primaryThumbnailUrl = buildThumbnailUrl(primaryLink.ContentDocument.LatestPublishedVersionId);
                versionGroup.hasPreviewableFile = isPreviewableFileType(primaryLink.ContentDocument.FileType);
            }

            groups.add(versionGroup);
        }

        return groups;
    }

    private static String normalizeStatusFilter(String statusFilter) {
        if (String.isBlank(statusFilter)) {
            return null;
        }
        String trimmed = statusFilter.trim();
        if (trimmed.equalsIgnoreCase('All')) {
            return null;
        }
        if (trimmed.equalsIgnoreCase('Waiting Signature')) {
            return 'Awaiting Signature';
        }
        if (trimmed.equalsIgnoreCase('In Approval')) {
            return 'In Approval Process';
        }
        if (trimmed.equalsIgnoreCase('Terminated')) {
            return 'Contract Terminated';
        }
        return trimmed;
    }

    private static Boolean isPreferredForRecordPanel(
        ContentDocumentLink candidate,
        ContentDocumentLink existing,
        Id preferredLinkedEntityId
    ) {
        Boolean candidateOnPreferred = preferredLinkedEntityId != null && candidate.LinkedEntityId == preferredLinkedEntityId;
        Boolean existingOnPreferred = preferredLinkedEntityId != null && existing.LinkedEntityId == preferredLinkedEntityId;
        if (candidateOnPreferred != existingOnPreferred) {
            return candidateOnPreferred;
        }
        return isPreferredForVersion(candidate, existing);
    }

    private static String deriveSignatureStatus(Contract contractRecord, DocumentEnvelope envelopeRecord) {
        if (envelopeRecord != null && !String.isBlank(envelopeRecord.Status)) {
            String envelopeStatus = envelopeRecord.Status;
            if (envelopeStatus.equalsIgnoreCase('Completed')) {
                return 'Signed';
            }
            if (envelopeStatus.equalsIgnoreCase('Sent')) {
                return 'Awaiting Signature';
            }
            return envelopeStatus;
        }

        if (!String.isBlank(contractRecord.Status)) {
            if (contractRecord.Status.equalsIgnoreCase('Signed')) {
                return 'Signed';
            }
            if (contractRecord.Status.equalsIgnoreCase('Awaiting Signature')) {
                return 'Awaiting Signature';
            }
        }

        if (contractRecord.CompanySignedDate != null || contractRecord.CustomerSignedDate != null) {
            return 'Signed';
        }
        return 'Not Sent';
    }

    private static Boolean isPreferredForContract(ContentDocumentLink candidate, ContentDocumentLink existing) {
        Boolean candidatePreviewable = isPreviewableFileType(candidate.ContentDocument.FileType);
        Boolean existingPreviewable = isPreviewableFileType(existing.ContentDocument.FileType);
        if (candidatePreviewable != existingPreviewable) {
            return candidatePreviewable;
        }

        Boolean candidateNonSynthetic = !isSyntheticSeedTitle(candidate.ContentDocument.Title);
        Boolean existingNonSynthetic = !isSyntheticSeedTitle(existing.ContentDocument.Title);
        if (candidateNonSynthetic != existingNonSynthetic) {
            return candidateNonSynthetic;
        }

        Long candidateCreated = candidate.ContentDocument.CreatedDate != null
            ? candidate.ContentDocument.CreatedDate.getTime()
            : 0;
        Long existingCreated = existing.ContentDocument.CreatedDate != null
            ? existing.ContentDocument.CreatedDate.getTime()
            : 0;
        return candidateCreated > existingCreated;
    }

    private static Boolean isPreferredForVersion(ContentDocumentLink candidate, ContentDocumentLink existing) {
        Boolean candidateIsPdf = isPdfFileType(candidate.ContentDocument.FileType);
        Boolean existingIsPdf = isPdfFileType(existing.ContentDocument.FileType);
        if (candidateIsPdf != existingIsPdf) {
            return candidateIsPdf;
        }
        return isPreferredForContract(candidate, existing);
    }

    private static String buildThumbnailUrl(Id latestVersionId) {
        if (latestVersionId == null) {
            return null;
        }
        return '/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId='
            + String.valueOf(latestVersionId)
            + '&operationContext=CHATTER';
    }

    private static String buildDownloadUrl(Id contentDocumentId) {
        if (contentDocumentId == null) {
            return null;
        }
        return '/sfc/servlet.shepherd/document/download/' + String.valueOf(contentDocumentId);
    }

    private static Boolean isPreviewableFileType(String fileType) {
        if (String.isBlank(fileType)) {
            return false;
        }
        return PREVIEWABLE_FILE_TYPES.contains(fileType.toUpperCase());
    }

    private static Boolean isPdfFileType(String fileType) {
        return !String.isBlank(fileType) && fileType.equalsIgnoreCase('PDF');
    }

    private static Boolean isSyntheticSeedTitle(String title) {
        if (String.isBlank(title)) {
            return false;
        }
        return title.startsWith('CM Generated Contract');
    }
}
