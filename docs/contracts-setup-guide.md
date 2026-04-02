# Contracts Management Setup Guide

## Objective
Set up and validate a read-only discovery baseline for Contracts Management in the production demo org.

## 1) Project and Org Access
1. Open this workspace.
2. Set Salesforce CLI environment variables for this workspace:
   - `export SF_USE_GENERIC_UNIX_KEYCHAIN=true`
   - `export SF_HOME_DIR="/Users/russellevans/Downloads/Salesforce Builds/Contracts/.sfhome-generic"`
3. Authenticate to production org alias:
   - `./scripts/auth-org.sh --alias cm-prod-demo --login-url https://login.salesforce.com`
4. Confirm `analysis/org-identity.json` shows `isSandbox: false`.

## 2) Metadata Discovery Baseline
1. Run metadata inventory:
   - `./scripts/inventory-metadata.sh --alias cm-prod-demo`
2. Review:
   - `analysis/metadata-types.json`
   - `analysis/component-inventory.json`

## 3) Contract Scope Retrieval
1. Build scope and retrieve metadata:
   - `./scripts/retrieve-contract-scope.sh --alias cm-prod-demo --wait 60`
2. Review scope:
   - `analysis/contracts-scope.json`
   - `manifest/contract-scope.package.xml`

## 4) OmniStudio Decision Point
1. Check `analysis/contracts-scope.json` field `omni.fallbackRequired`.
2. If `true`, run:
   - `./scripts/export-omnistudio-fallback.sh --alias cm-prod-demo`

## 5) Post-Processing
1. Generate inventory documentation:
   - `./scripts/analyze-contract-scope.sh`
2. Review:
   - `docs/contracts-inventory.md`
   - `analysis/contracts-scope-summary.json`

## 6) Completion Criteria
- Core contract metadata is retrieved locally.
- M365 and DocuSign related metadata artifacts are present in scope outputs.
- Inventory documentation is generated and shareable.
