# Spring '26 Adoption Backlog (Contracts Management)

## Baseline
As of March 31, 2026, the active baseline for this project is **Spring '26 GA**.

## Prioritization Model
- **Now**: low-risk, high-value updates and release updates with hard deadlines.
- **Next**: moderate effort enhancements improving contract cycle time or reliability.
- **Later**: strategic improvements needing broader architecture changes.

## Candidate Backlog
| Priority | Candidate | Why It Matters for Contracts | Prerequisite | Owner | Target Wave |
|---|---|---|---|---|---|
| Now | Secure redirection for HTTP callouts (release update) | Protects external integration callout behavior for document/signature services | Validate current callout endpoints | Platform Admin | Wave 1 |
| Now | Auto-layout migration check for legacy Flow behavior | Prevents flow regressions in contract orchestration | Inventory existing screen flows | Salesforce Admin | Wave 1 |
| Next | Flow performance/reliability improvements from Spring '26 notes | Stabilizes contract approval/signing automations | Baseline flow error logs | Automation Owner | Wave 2 |
| Next | LWC and Apex modernization opportunities | Improves maintainability of contract UX/extensions | Inventory usage + test coverage | Dev Lead | Wave 2 |
| Later | Expanded analytics on contract lifecycle bottlenecks | Improves business visibility and optimization | Reporting model alignment | RevOps | Wave 3 |

## Adoption Execution Steps
1. Validate each candidate against actual org assets in `analysis/contracts-scope.json`.
2. Add impact estimates and implementation owners.
3. Convert accepted items into sprint-ready stories.
