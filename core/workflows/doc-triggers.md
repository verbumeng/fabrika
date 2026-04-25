# Document Creation Triggers

During ongoing development, create new documents when these situations arise. Reference the **Document Catalog** for document structure and purpose.

| Trigger | Action |
|---------|--------|
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
