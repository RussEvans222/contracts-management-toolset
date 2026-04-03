# Developer Change Log

## 2026-04-02

### Agentforce Flow-Driven Prompt Action
- Added `SDO_ContractPromptTemplateInvocable` to invoke Prompt Template `Contracts_Summary` from Flow.
- Added `SDO_ContractPromptTemplateInvocableTest` coverage for valid and validation-path execution.
- Updated `Contract_Obligations_Summary_For_Agentforce` to call `Generate Contract Summary` after obligations summary construction.
- Added new Flow output variable `agentResponse` for Agentforce action consumption.
- Preserved existing obligation retrieval, loop formatting, overdue flagging, and truncation behavior.

### Prompt Template Metadata
- Retrieved and tracked `Contracts_Summary.genAiPromptTemplate` metadata so prompt inputs remain versioned with the project.
- Confirmed template contract input (`Input:Contracts`) and text input (`Input:obligationsSummary`) alignment with flow mapping.
