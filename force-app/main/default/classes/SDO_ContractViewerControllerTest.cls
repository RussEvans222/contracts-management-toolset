@IsTest(SeeAllData=true)
private class SDO_ContractViewerControllerTest {
    @IsTest
    static void getRecentContractDocuments_returnsTilesWithVersionCounts() {
        Contract targetContract = fetchContracts(1)[0];

        ContentVersion firstVersion = new ContentVersion(
            Title = 'Generated Contract Draft Test',
            PathOnClient = 'generated-contract-test.pdf',
            VersionData = Blob.valueOf('draft file body'),
            FirstPublishLocationId = targetContract.Id
        );
        insert firstVersion;

        Id contentDocumentId = [
            SELECT ContentDocumentId
            FROM ContentVersion
            WHERE Id = :firstVersion.Id
        ].ContentDocumentId;

        ContentVersion secondVersion = new ContentVersion(
            ContentDocumentId = contentDocumentId,
            Title = 'Generated Contract Final Test',
            PathOnClient = 'generated-contract-v2-test.pdf',
            VersionData = Blob.valueOf('final file body')
        );
        insert secondVersion;

        Test.startTest();
        List<SDO_ContractViewerController.ContractDocumentTile> tiles =
            SDO_ContractViewerController.getRecentContractDocuments(9, 'All', false, null);
        Test.stopTest();

        System.assertNotEquals(null, tiles, 'Tiles list should be returned.');
        System.assert(tiles.size() > 0, 'At least one tile should be returned.');

        SDO_ContractViewerController.ContractDocumentTile matchedTile;
        for (SDO_ContractViewerController.ContractDocumentTile tile : tiles) {
            if (tile.contractId == targetContract.Id) {
                matchedTile = tile;
                break;
            }
        }

        System.assertNotEquals(null, matchedTile, 'Tile should map to the contract.');
        System.assertEquals(
            matchedTile.contractStatus == 'Signed',
            matchedTile.isSigned,
            'isSigned should match contract status.'
        );
        System.assert(matchedTile.versionCount >= 2, 'Version count should include both versions.');
        System.assertNotEquals(null, matchedTile.thumbnailUrl, 'Thumbnail URL should be generated.');
    }

    @IsTest
    static void getRecentContractDocuments_prefersPreviewableFilePerContract() {
        Contract targetContract = fetchContracts(1)[0];

        insert new ContentVersion(
            Title = 'CM Generated Contract Preview SVG Test',
            PathOnClient = 'generated-contract-test.svg',
            VersionData = Blob.valueOf('<svg xmlns="http://www.w3.org/2000/svg"></svg>'),
            FirstPublishLocationId = targetContract.Id
        );

        insert new ContentVersion(
            Title = 'Signed Contract PDF Test',
            PathOnClient = 'signed-contract-test.pdf',
            VersionData = Blob.valueOf('pdf bytes'),
            FirstPublishLocationId = targetContract.Id
        );

        Test.startTest();
        List<SDO_ContractViewerController.ContractDocumentTile> tiles =
            SDO_ContractViewerController.getRecentContractDocuments(16, 'All', false, null);
        Test.stopTest();

        SDO_ContractViewerController.ContractDocumentTile matchedTile;
        for (SDO_ContractViewerController.ContractDocumentTile tile : tiles) {
            if (tile.contractId == targetContract.Id) {
                matchedTile = tile;
                break;
            }
        }

        System.assertNotEquals(null, matchedTile, 'Contract tile should be present.');
        System.assertEquals('PDF', matchedTile.fileType, 'Previewable PDF should be preferred over SVG for the contract.');
    }

    @IsTest
    static void getRecentContractDocuments_filtersAndSortsLatestFirst() {
        List<Contract> contracts = fetchContracts(2);
        Contract firstContract = contracts[0];
        Contract secondContract = contracts[1];

        insert new ContentVersion(
            Title = 'Older Contract Document Test',
            PathOnClient = 'older-contract-test.pdf',
            VersionData = Blob.valueOf('older'),
            FirstPublishLocationId = firstContract.Id
        );

        insert new ContentVersion(
            Title = 'Newer Contract Document Test',
            PathOnClient = 'newer-contract-test.pdf',
            VersionData = Blob.valueOf('newer'),
            FirstPublishLocationId = secondContract.Id
        );

        Test.startTest();
        List<SDO_ContractViewerController.ContractDocumentTile> allTiles =
            SDO_ContractViewerController.getRecentContractDocuments(16, 'All', false, null);
        List<SDO_ContractViewerController.ContractDocumentTile> statusTiles =
            SDO_ContractViewerController.getRecentContractDocuments(16, secondContract.Status, false, null);
        Test.stopTest();

        System.assert(allTiles.size() >= 2, 'All status should include at least two contracts.');
        System.assertEquals(secondContract.Id, allTiles[0].contractId, 'Newest contract document should appear first.');
        System.assert(statusTiles.size() >= 1, 'Status filter should return at least one matching contract.');
        System.assertEquals(secondContract.Status, statusTiles[0].contractStatus, 'Filtered tile should retain selected status.');
    }

    @IsTest
    static void getContractRecordDocumentSummary_returnsRecordAndDocumentSnapshot() {
        Contract targetContract = fetchContracts(1)[0];

        insert new ContentVersion(
            Title = 'Contract Summary Preview Test',
            PathOnClient = 'contract-summary-preview-test.pdf',
            VersionData = Blob.valueOf('preview bytes'),
            FirstPublishLocationId = targetContract.Id
        );

        Test.startTest();
        SDO_ContractViewerController.ContractRecordDocumentSummary summary =
            SDO_ContractViewerController.getContractRecordDocumentSummary(targetContract.Id);
        Test.stopTest();

        System.assertNotEquals(null, summary, 'Summary should be returned for a valid contract.');
        System.assertEquals(targetContract.Id, summary.contractId, 'Summary should map to the requested contract.');
        System.assert(!String.isBlank(summary.signatureStatus), 'Signature status should always be populated.');
        System.assertEquals(true, summary.hasDocument, 'Summary should indicate a document exists.');
        System.assertNotEquals(null, summary.contentDocumentId, 'Document id should be populated.');
        System.assert(summary.versionCount >= 1, 'Version count should be at least 1.');
    }

    @IsTest
    static void getRecentContractDocuments_contractScopedRequest_onlyReturnsRequestedContract() {
        List<Contract> contracts = fetchContracts(2);
        Contract scopedContract = contracts[0];
        Contract otherContract = contracts[1];

        insert new ContentVersion(
            Title = 'Scoped Contract PDF Test',
            PathOnClient = 'scoped-contract-test.pdf',
            VersionData = Blob.valueOf('scoped'),
            FirstPublishLocationId = scopedContract.Id
        );
        insert new ContentVersion(
            Title = 'Other Contract PDF Test',
            PathOnClient = 'other-contract-test.pdf',
            VersionData = Blob.valueOf('other'),
            FirstPublishLocationId = otherContract.Id
        );

        Test.startTest();
        List<SDO_ContractViewerController.ContractDocumentTile> scopedTiles =
            SDO_ContractViewerController.getRecentContractDocuments(16, 'All', false, scopedContract.Id);
        Test.stopTest();

        System.assertEquals(1, scopedTiles.size(), 'Contract-scoped query should return one tile.');
        System.assertEquals(scopedContract.Id, scopedTiles[0].contractId, 'Tile should belong to requested contract.');
    }

    private static List<Contract> fetchContracts(Integer howMany) {
        List<Contract> contracts = [
            SELECT Id, Name, ContractNumber, Status
            FROM Contract
            ORDER BY LastModifiedDate DESC
            LIMIT :howMany
        ];
        System.assert(
            contracts.size() >= howMany,
            'Expected at least ' + howMany + ' existing Contract records in org test data.'
        );
        return contracts;
    }

}
