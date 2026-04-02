# Contract Versioning Data Model Reference

## Purpose + Scope
This document is a local reference for how contract document versions are modeled in this org. It is context for admins/developers/agents and is not a change request or implementation plan.

- Target org: `cm-prod-demo` (`https://storm-67f93fa3759a67.my.salesforce.com`)
- Verification date: April 1, 2026
- Verification method: `sf data query` and Tooling API queries (`EntityDefinition`, `FieldDefinition`)

## Verified In This Org

### Objects Present
Verified objects:
- `Contract`
- `ContractDocumentVersion`
- `DocumentEnvelope`
- `ContentDocumentLink`
- `ContentVersion`
- `ExternalDataSource`

### Key Fields Used In This Org
`Contract`
- `ContractNumber` (`Auto Number`)
- `Status` (`Picklist`)
- `ContractDocumentVersionId` (`Lookup(Contract Document Version)`)
- `CompanySignedDate` (`Date`)
- `CustomerSignedDate` (`Date`)

`ContractDocumentVersion`
- `ContractId` (`Master-Detail(Contract)`)
- `VersionNumber` (`Number(9, 0)`)
- `Status` (`Picklist`)
- `CreationProcessType` (`Picklist`)
- `Name` (`Text(80)`)

`DocumentEnvelope`
- `ContractDocumentVersionId` (`Lookup(Contract Document Version)`)
- `Status` (`Picklist`)
- `Vendor` (`Picklist`)
- `FinalStatusDateTime` (`Date/Time`)
- `CreatedDate` (`Date/Time`)

`ContentVersion`
- `ContentDocumentId` (`Lookup(Content Document)`)
- `VersionNumber` (`Text(20)`)
- `IsLatest` (`Checkbox`)
- `IsMajorVersion` (`Checkbox`)
- `Origin` (`Picklist`)
- `ExternalDocumentInfo1` (`Text(1000)`)
- `ExternalDocumentInfo2` (`Text(1000)`)
- `ContentUrl` (`URL(1333)`)
- `FileType` (`Text(20)`)
- `Title` (`Text(255)`)

### Not Detected Currently
Not returned in object inventory checks:
- `ContractDocument`
- `dsfs__DocuSign_Status__c`
- `DSFS__Envelope__c`

External-origin files:
- `SELECT COUNT() FROM ContentVersion WHERE Origin = 'E'` returned `0` (no external-origin file versions detected at this time).

### Sample Validation Snapshot
For `ContractNumber = '00000214'`:
- Contract has active `ContractDocumentVersionId = 0qtHu0000008ymdIAA`
- Version timeline includes:
  - `v2` (`Active`, `CheckoutModify`)
  - `v1` (`Inactive`, `Generate`)
- File links exist on both:
  - the `Contract` record itself, and
  - `ContractDocumentVersion` records
- At least one envelope exists in `DocumentEnvelope` with `Status = Completed`, `Vendor = DocuSign`.

## How Versioning Works (Practical Model)
This org behaves as a dual model:

1. Contract lifecycle/version metadata:
- `Contract` + `ContractDocumentVersion` + `DocumentEnvelope`

2. Physical files and file revisions:
- `ContentDocumentLink` + `ContentDocument` + `ContentVersion`

Canonical chain in this org:

`Contract -> ContractDocumentVersion -> ContentDocumentLink -> ContentDocument -> ContentVersion`

Supplemental chain also present:

`Contract -> ContentDocumentLink -> ContentDocument -> ContentVersion`

Why counts can diverge:
- `ContractDocumentVersion.VersionNumber` and `ContentVersion.VersionNumber` are independent counters.
- A contract can have multiple files linked to a single contract document version (DOCX/PDF/signed variants).
- The same `ContentDocument` may be linked to both `Contract` and `ContractDocumentVersion`, creating duplicates in naive queries.

## SOQL Cookbook
Replace example IDs/numbers as needed.

### 1) Get Contract + Active Version Pointer
```sql
SELECT Id, ContractNumber, Status, ContractDocumentVersionId
FROM Contract
WHERE ContractNumber = '00000214'
LIMIT 1
```

### 2) Get All `ContractDocumentVersion` Rows For a Contract
```sql
SELECT Id, ContractId, VersionNumber, Status, CreationProcessType, CreatedDate
FROM ContractDocumentVersion
WHERE ContractId = '800Hu000006wxDhIAI'
ORDER BY VersionNumber DESC, CreatedDate DESC
```

### 3) Get File Links For Contract + Each Version
Contract-level links:
```sql
SELECT LinkedEntityId, ContentDocumentId, ContentDocument.Title, ContentDocument.FileType, ContentDocument.CreatedDate
FROM ContentDocumentLink
WHERE LinkedEntityId = '800Hu000006wxDhIAI'
ORDER BY ContentDocument.CreatedDate DESC
```

Version-level links:
```sql
SELECT LinkedEntityId, ContentDocumentId, ContentDocument.Title, ContentDocument.FileType, ContentDocument.CreatedDate
FROM ContentDocumentLink
WHERE LinkedEntityId IN (
    SELECT Id
    FROM ContractDocumentVersion
    WHERE ContractId = '800Hu000006wxDhIAI'
)
ORDER BY ContentDocument.CreatedDate DESC
```

### 4) Get Signature Status From `DocumentEnvelope`
```sql
SELECT Id, Status, Vendor, FinalStatusDateTime, CreatedDate, ContractDocumentVersionId
FROM DocumentEnvelope
WHERE ContractDocumentVersionId IN (
    SELECT Id
    FROM ContractDocumentVersion
    WHERE ContractId = '800Hu000006wxDhIAI'
)
ORDER BY CreatedDate DESC
```

## Known Caveats For Viewer/Compare
- Duplicate links can appear when the same file is linked to both `Contract` and `ContractDocumentVersion`.
- Placeholder artifacts can appear (`SVG`/`TEXT`) while signed or generated PDFs also exist.
- `ContractDocumentVersion.VersionNumber` and `ContentVersion.VersionNumber` are independent and should not be assumed to match.
- External M365/SharePoint indicators (`Origin = 'E'`, `ExternalDocumentInfo*`, `ContentUrl`) are not currently populated in this org snapshot.

## General CLM Context (Not Guaranteed In This Org)
These are common ecosystem patterns and should be treated as contextual only:
- Some orgs use managed package objects (for example `dsfs__*`, `DSFS__*`, Conga namespaces) as the primary signature/version source.
- Some orgs use external file stores (SharePoint/Box/etc.) with `ContentVersion.Origin = 'E'` and external document info fields populated.
- Some CLM implementations include additional objects (for example `ContractDocument`) as first-class nodes in the chain.

## Roadmap Note (Non-binding)
Future option only: add AI-assisted text redline comparison between two selected version files (clause-level + exact textual delta), while keeping current version viewer behavior unchanged until explicitly approved.

## Documentation QA Checklist
- [x] Facts marked “Verified In This Org” are backed by live org query/describe checks.
- [x] Contextual items are labeled as non-guaranteed patterns.
- [x] SOQL cookbook snippets were validated in `cm-prod-demo` for syntax.
- [x] This document remains reference-first (no implicit implementation directives).
