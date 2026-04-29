# Document Creation Triggers

During ongoing development, create new documents when these situations arise. Reference the **Document Catalog** for document structure and purpose.

| Trigger | Action |
|---------|--------|
| New project starting | Orchestrator enters Design Alignment mode (`core/workflows/design-alignment.md`), produces Project Charter + first PRD in `01-Product/` |
| New phase or major feature | Orchestrator enters Design Alignment mode, produces PRD in `01-Product/` |
| Orchestrator detects ambiguity (can't describe what user wants in 2-3 sentences) | Orchestrator enters Design Alignment mode |
| Owner explicitly requests alignment | Orchestrator enters Design Alignment mode |
| Major pivot in project direction | Update or replace Project Charter in `01-Product/` via Design Alignment |
| Technical decision made (stack, library, pattern) | Create ADR in `02-Engineering/ADRs/` |
| New data source discussed | Create Data Source Research note in `05-Research/Data Source Research/` |
| Feature is getting complex (many edge cases, domain logic) | Create Feature Spec in `01-Product/Feature Specs/` |
| Implementation diverges from Architecture Overview | Update `02-Engineering/Architecture Overview.md` |
| Schema changes | Update `02-Engineering/Data Model.md` |
| New transformation logic | Update `02-Engineering/Transformation Logic.md` (if `analytics-engineering` or `data-engineering`) |
| Dashboard/report design discussed | Create or update spec in `03-Design/` |
| User wants to demo or present the project | Create Stakeholder Presentation or Demo Script in `06-Visibility/` |
| Deployment or infrastructure changes | Update `07-Operations/` docs |
| Agent prompt modified | Log change + failure context to `docs/evals/agent-changelog.md` |
| Owner reports a bug | Create bug file in `04-Backlog/Bugs/`, run Bug Reporting & Fix Workflow |
| Idea for future work surfaces | Add to `09-Personal-Tasks/Someday-Maybe.md` |
| New public-facing endpoint or user input surface added | Create or update `02-Engineering/Threat Model.md` (`web-app`, `ai-engineering`) |
| Expensive compute, warehouse queries, or LLM calls introduced | Create or update `02-Engineering/Cost Model.md` |
| Recurring analysis detected (2+ similar tasks) | Initiate task promotion conversation (see `task-promotion.md`) |
| Dashboard or visual output designed or changed | Invoke visualization-designer agent for review |
