---
type: reference
status: active
created: 2026-03-21
updated: 2026-03-21
tags: [project, documentation, catalog, reference]
---

# Project Document Catalog

> **Audience: the AI agent.** This catalog lists every document that might exist in a project vault. During bootstrapping, use the project type and priority tiers to determine which documents to create. Each entry describes what the document is, why it matters, who it's for, and which project types need it.

---

## How to Use This Catalog

### Project Types
Every document is tagged with the project types that need it:

| Tag | Description | Examples |
|-----|-------------|---------|
| `data-app` | Interactive tools replacing Excel — dashboards, forms, data entry apps, reporting tools | Streamlit dashboard, internal reporting tool, data entry webapp |
| `data-platform` | Data infrastructure — pipelines, transformations (dbt), local analytics layers (DuckDB), warehouse foundations, analytics engineering | DuckDB + dbt layer, Alteryx → SQL migration, ETL pipelines |
| `ml-project` | Machine learning — model development, training data, feature engineering, evaluation | Predictive models, classification, forecasting |
| `web-app` | Full-stack web applications — personal tools, SaaS products, consumer apps, APIs | Personal SaaS, consumer SaaS, internal web tools |
| `automation` | Scripts, CLIs, bots, workflow automation, scheduled jobs | Data scrapers, cron jobs, CLI tools, Slack bots |

A project can be **multi-type**. A data app with scrapers feeding a dashboard is `data-app` + `automation`. A SaaS product with ML features is `web-app` + `ml-project`. The agent should union all applicable document sets.

### Priority Tiers
| Tier | When to Create | During Bootstrapping? |
|------|---------------|----------------------|
| **Tier 1** | Must exist before Sprint 1. Create during bootstrapping. | Yes — agent creates these |
| **Tier 2** | Should exist before first user/stakeholder sees the product | Only if the user provides enough context in the brain dump |
| **Tier 3** | Create as needed during development | No — create when the need arises |
| **Tier 4** | Nice to have, create if time allows | No |

### Audience Markers
| Marker | Meaning |
|--------|---------|
| **human** | Written for the project owner's strategic thinking. The agent writes it, but the owner is the primary reader. |
| **agent** | Written for the AI agent to reference during implementation. The agent both writes and reads it. |
| **both** | Serves both the owner's understanding and the agent's implementation context. |

---

## 00-Index/

### Home.md
- **Purpose:** Central navigation hub. Links to all major sections, shows project status at a glance.
- **Types:** all | **Tier:** 1 | **Audience:** both
- **Structure:** Project name, one-line description, quick links to key docs, current phase, what to read first.
- **Notes:** This is the first thing anyone opens. Keep it short — links, not content.

### Glossary.md
- **Purpose:** Defines domain-specific terms used across the project. Prevents ambiguity when the agent encounters unfamiliar terminology.
- **Types:** all | **Tier:** 4 | **Audience:** both
- **Structure:** Alphabetical term list with definitions. Add terms as they come up.
- **Notes:** Most useful for domain-heavy projects (healthcare, finance, regulatory). Skip for simple tools.

---

## 01-Product/

### Phase Definitions.md
- **Purpose:** Defines what each project phase delivers and what's explicitly excluded. Prevents scope creep by making the boundaries of "now" vs. "later" unambiguous.
- **Types:** all | **Tier:** 1 | **Audience:** both
- **Structure:** Phase 1 (MVP): goal, what ships, what doesn't. Phase 2+: brief description, explicitly marked "do not build yet."
- **Notes:** The agent references this to refuse out-of-scope work. Critical for discipline.

### Vision & Positioning.md
- **Purpose:** Why this product exists, who it's for, what makes it different. Brand promise and competitive angle.
- **Types:** web-app | **Tier:** 1 (consumer SaaS), 2 (personal SaaS) | **Audience:** human
- **Structure:** Mission statement, target user, problem being solved, competitive positioning, success metrics.
- **Notes:** For work projects (data-app, data-platform), this becomes a simpler "Project Justification" — why are we building this instead of using Excel/Alteryx.

### User Stories.md
- **Purpose:** Plain-language descriptions of what users need to accomplish. Bridges product thinking and engineering.
- **Types:** web-app, data-app | **Tier:** 2 | **Audience:** both
- **Structure:** Grouped by persona or feature area. Format: "As a [user], I want to [action] so that [outcome]."
- **Notes:** For data-apps, "users" might be internal stakeholders. Stories can be simple.

### Competitive Analysis.md
- **Purpose:** Teardown of competing products. What they do well, where they fall short, where you differentiate.
- **Types:** web-app (consumer) | **Tier:** 2 | **Audience:** human
- **Structure:** Per-competitor sections: what they offer, pricing, strengths, weaknesses, your angle.

### Revenue Model.md
- **Purpose:** How the product makes money. Pricing tiers, conversion assumptions, unit economics.
- **Types:** web-app (consumer/marketed) | **Tier:** 3 | **Audience:** human
- **Structure:** Pricing tiers, free vs. paid features, projected conversion rates, revenue targets.

### Feature Specs/
- **Purpose:** Detailed specification for complex features that deserve their own document (beyond what a story captures).
- **Types:** web-app, data-app | **Tier:** 3 (create as needed) | **Audience:** both
- **Structure:** One file per feature. Problem, proposed solution, user flow, edge cases, acceptance criteria.
- **Notes:** Not every feature needs a spec. Use for features with complex domain logic (e.g., scoring algorithms, notification strategies, complex calculations).

### Domain-Specific Docs
- **Purpose:** Documents unique to the project's domain that don't fit other categories.
- **Types:** any | **Tier:** varies | **Audience:** both
- **Examples:**
  - Scoring algorithms (e.g., health scores, risk ratings)
  - Notification/alerting strategies
  - Regulatory compliance requirements
  - Industry-specific business rules
  - Calculation methodologies (replacing Excel formulas)
- **Notes:** The agent should ask during brain dump: "Are there domain-specific concepts that need their own documentation?"

---

## 02-Engineering/

### Architecture Overview.md
- **Purpose:** How the system is built. Components, data flow, key technologies, deployment topology.
- **Types:** all | **Tier:** 1 | **Audience:** agent
- **Structure:** System diagram (ASCII or description), component inventory, data flow (step-by-step), key files/folders, technology choices with brief rationale.
- **Notes:** The agent reads this before every implementation session. Keep it current.

### Data Model.md
- **Purpose:** What data the system stores. Schemas, relationships, key fields, evolution plan.
- **Types:** all except automation (if stateless) | **Tier:** 1 | **Audience:** agent
- **Structure:** Table/collection definitions with column types, relationships, indexes, example queries, migration/evolution notes.
- **Notes:** For DuckDB/dbt projects, this documents the target schema. For web-apps, includes auth tables, RLS policies, etc.

### Data Pipeline Design.md
- **Purpose:** How data moves through the system. Sources, extraction, transformation, loading, scheduling.
- **Types:** data-app, data-platform, automation | **Tier:** 1 | **Audience:** agent
- **Structure:** Source inventory, extraction method per source, transformation steps, load targets, scheduling/orchestration approach, error handling, retry logic.
- **Notes:** For dbt projects, this documents the DAG structure and transformation philosophy. For scrapers, documents the scraping pattern and per-source research template.

### Data Dictionary.md
- **Purpose:** Defines every field/column across the data layer. Business meaning, data type, source, transformations applied.
- **Types:** data-app, data-platform | **Tier:** 2 | **Audience:** both
- **Structure:** Table per source/model. Columns: field name, type, description, source, business rules, example values.
- **Notes:** Critical for analytics engineering — this is what stakeholders reference to understand reports.

### Data Quality Rules.md
- **Purpose:** Validation rules, expected ranges, anomaly detection criteria. What makes data "suspicious."
- **Types:** data-app, data-platform | **Tier:** 2 | **Audience:** agent
- **Structure:** Per-table or per-field rules: not-null constraints, range checks, freshness requirements, referential integrity, custom business rules.
- **Notes:** For dbt projects, these translate directly to dbt tests.

### Transformation Logic.md
- **Purpose:** Documents the business logic behind data transformations. Why certain calculations exist, what business rules drive them.
- **Types:** data-platform | **Tier:** 1 | **Audience:** both
- **Structure:** Per-transformation: input sources, business rule, calculation/logic, output, edge cases, owner/stakeholder who defined it.
- **Notes:** This is the "translation layer" between the Excel formulas you're replacing and the SQL/dbt models you're building. Critical for validation.

### Migration Plan.md
- **Purpose:** Documents how to migrate from the current state (Excel, Alteryx, etc.) to the target state. What moves when, validation steps, rollback plan.
- **Types:** data-platform, data-app | **Tier:** 2 | **Audience:** both
- **Structure:** Current state, target state, migration phases, per-phase: what moves, validation criteria, rollback, stakeholder sign-off.
- **Notes:** Especially important for Alteryx → SQL migrations where you need to prove output parity.

### Model Design.md
- **Purpose:** Documents the ML model architecture, algorithm choice, feature set, and training approach.
- **Types:** ml-project | **Tier:** 1 | **Audience:** both
- **Structure:** Problem statement, algorithm/approach, feature list with rationale, training data requirements, hyperparameters, baseline metrics.

### Training Data Spec.md
- **Purpose:** What data the model trains on. Sources, labels, preprocessing, splits, known biases.
- **Types:** ml-project | **Tier:** 1 | **Audience:** agent
- **Structure:** Data sources, labeling methodology, preprocessing pipeline, train/val/test split ratios, data volume, known issues/biases, refresh cadence.

### Model Evaluation Criteria.md
- **Purpose:** How to judge if the model is good enough. Metrics, thresholds, comparison baselines.
- **Types:** ml-project | **Tier:** 1 | **Audience:** both
- **Structure:** Primary metrics (accuracy, F1, RMSE, etc.), threshold for production-readiness, baseline comparison (current process vs. model), evaluation dataset, re-evaluation cadence.

### API Conventions.md
- **Purpose:** Standards for API design: naming, versioning, error format, auth patterns.
- **Types:** web-app | **Tier:** 2 | **Audience:** agent
- **Structure:** URL patterns, HTTP methods, request/response format, error codes, pagination, auth headers, rate limiting.

### Testing Strategy.md
- **Purpose:** How the project is tested. What types of tests, coverage targets, fixture conventions, CI pipeline, verification method.
- **Types:** all | **Tier:** 1 | **Audience:** agent
- **Structure:** Test types (unit, integration, fixture-based, e2e), coverage targets, fixture conventions, CI pipeline description, what to mock vs. not mock, verification method (browser automation, output diffing, etc.), fast vs. full test commands.
- **Notes:** For data projects, testing often means output validation (do SQL results match Excel?). For ML, testing means evaluation metrics. The verification method determines how the test-writer agent runs E2E checks.

### rubrics/code-review-rubric.md
- **Purpose:** Weighted grading criteria for the code-reviewer agent. Defines what PASS/FAIL means for each criterion with skepticism calibration.
- **Types:** all | **Tier:** 1 (created during bootstrap) | **Audience:** agent
- **Notes:** Loaded on demand by the code-reviewer agent at the start of each review. Not included in base CLAUDE.md context.

### rubrics/test-rubric.md
- **Purpose:** Weighted grading criteria for the test-writer agent. Defines coverage standards, edge case requirements, E2E verification expectations.
- **Types:** all | **Tier:** 1 (created during bootstrap) | **Audience:** agent

### maintenance-checklist.md
- **Purpose:** Full checklist for maintenance sessions: documentation sync, code quality, test health, progress reconciliation, dependency health, context efficiency, evaluation health, hook health.
- **Types:** all | **Tier:** 1 (created during bootstrap) | **Audience:** agent
- **Notes:** Run between sprints or weekly. The scrum-master checks the `maintenance-latest` git tag during sprint planning.

### Security & Privacy.md
- **Purpose:** Security architecture, data handling, authentication, encryption, compliance requirements.
- **Types:** web-app | **Tier:** 2 | **Audience:** agent
- **Structure:** Auth method, data encryption (at rest, in transit), PII handling, GDPR/CCPA considerations, credential management.

### Deployment Guide.md
- **Purpose:** How to deploy the project. Steps, environments, infrastructure, monitoring.
- **Types:** all (that deploy) | **Tier:** 2 | **Audience:** agent
- **Structure:** Environment list, deployment steps, infrastructure (hosting, CI/CD), monitoring/alerting, rollback procedure.

### Seed Data Spec.md
- **Purpose:** Initial data the system needs to function. Default values, reference tables, sample data for development.
- **Types:** web-app, data-app | **Tier:** 2 | **Audience:** agent
- **Structure:** Per-table: what seed data exists, source, format, load method. For web-apps: default categories, system settings, demo data.

### ADRs/ (Architecture Decision Records)
- **Purpose:** Documents significant technical decisions with context, alternatives considered, and consequences.
- **Types:** all | **Tier:** 1 (at least one for major tech choices) | **Audience:** agent
- **Structure:** Status, Context, Decision, Consequences, Alternatives Considered.
- **Notes:** Create one during bootstrapping for the primary tech stack choice. Add more as decisions arise during development.

---

## 03-Design/

### Dashboard Spec.md
- **Purpose:** What the dashboard/UI looks like. Layout, components, data displayed, interactions, filters.
- **Types:** data-app | **Tier:** 1 | **Audience:** both
- **Structure:** Page layout (ASCII wireframe or description), data sources per component, filter/interaction behavior, refresh frequency, user permissions.
- **Notes:** This is the primary design doc for data apps. Can include ASCII wireframes or describe the layout in detail.

### Output Specifications.md
- **Purpose:** What reports, exports, or outputs the system produces. Format, content, delivery method, schedule.
- **Types:** data-platform, automation, data-app | **Tier:** 2 | **Audience:** both
- **Structure:** Per-output: name, format (CSV, PDF, email, dashboard), content/columns, delivery (email, file drop, API), schedule, recipients.
- **Notes:** For Alteryx replacement projects, this documents the outputs that must match the current Alteryx workflow outputs.

### Wireframes.md
- **Purpose:** Visual layout of key screens. Low-fidelity sketches that establish information hierarchy and flow.
- **Types:** web-app, data-app | **Tier:** 2 | **Audience:** both
- **Structure:** ASCII wireframes or descriptions of key screens. Label components, show navigation flow.

### UX Specification.md
- **Purpose:** Detailed interaction design. User flows, states (empty, loading, error, offline), micro-interactions, responsive behavior.
- **Types:** web-app | **Tier:** 1 (consumer), 2 (personal) | **Audience:** both
- **Structure:** Core user flows (step-by-step), state definitions per screen, responsive breakpoints, animation/transition notes, accessibility requirements.

### Brand Guidelines.md
- **Purpose:** Visual identity — colors, typography, tone, logo usage.
- **Types:** web-app (consumer/marketed) | **Tier:** 2 | **Audience:** human
- **Structure:** Color palette, typography, tone of voice, logo usage rules, inspiration references.

### Design Tokens.md
- **Purpose:** Design system variables exported as code (Tailwind config, CSS variables).
- **Types:** web-app (consumer) | **Tier:** 2 | **Audience:** agent
- **Structure:** Color tokens, spacing scale, typography scale, border radius, shadows — in code-ready format.

### Accessibility.md
- **Purpose:** Accessibility requirements and compliance target (WCAG level).
- **Types:** web-app (consumer) | **Tier:** 3 | **Audience:** both
- **Structure:** Target WCAG level, key requirements (keyboard nav, screen reader, color contrast), testing approach.

---

## 04-Backlog/

### Epics/
- **Purpose:** High-level capability groupings. Each epic represents a major feature area.
- **Types:** all | **Tier:** 1 | **Audience:** agent
- **Structure:** See Epic-Template.md. YAML frontmatter + overview + Dataview story query.

### Stories/
- **Purpose:** Individual units of work with acceptance criteria. The primary unit of sprint planning.
- **Types:** all | **Tier:** 1 | **Audience:** agent
- **Structure:** See Story-Template.md. YAML frontmatter + description + acceptance criteria + technical notes.

### Sprints/
- **Purpose:** Time-boxed work periods with a goal and assigned stories.
- **Types:** all | **Tier:** 1 (created during sprint planning) | **Audience:** agent
- **Structure:** See Sprint-Template.md. YAML frontmatter + Dataview query + sprint notes + retrospective.

---

## 05-Research/

### Technology Evaluations
- **Purpose:** Research notes on technologies being considered. Pros, cons, fit for this project.
- **Types:** all | **Tier:** 3 | **Audience:** both
- **Structure:** One file per technology. What it is, why we're considering it, pros, cons, alternatives, recommendation.

### Data Source Research/
- **Purpose:** Per-source documentation for data pipeline projects. Login flows, APIs, file formats, access methods, quirks.
- **Types:** data-app, data-platform, automation | **Tier:** 1 (for known sources) | **Audience:** agent
- **Structure:** One file per data source. See Data-Source-Research-Template.md. Overview, access method, authentication, data format, known issues, refresh cadence.
- **Notes:** Critical for any project that pulls data from external sources. One file per source keeps research organized and agent-accessible.

### Market Analysis.md
- **Purpose:** Market size, trends, opportunity assessment.
- **Types:** web-app (consumer/marketed) | **Tier:** 2 | **Audience:** human
- **Structure:** TAM/SAM/SOM, market trends, customer segments, pricing benchmarks.

### User Research/
- **Purpose:** User interview notes, survey results, feedback synthesis.
- **Types:** web-app | **Tier:** 3 | **Audience:** human
- **Structure:** One file per interview or research session. Key findings, quotes, implications for product.

---

## 06-Visibility/

> This folder covers how you make the project visible — to stakeholders at work, or to the market for consumer products. At work, this is where demo materials, impact analyses, and stakeholder presentations live. For marketed products, this is traditional marketing.

### Stakeholder Presentation.md
- **Purpose:** Slide-ready content for presenting the project to leadership, peers, or cross-functional teams.
- **Types:** data-app, data-platform | **Tier:** 3 | **Audience:** human
- **Structure:** Problem statement, what was built, before/after comparison, impact metrics, demo talking points, next steps.

### Demo Script.md
- **Purpose:** Step-by-step walkthrough for demoing the project. What to show, what to say, anticipated questions.
- **Types:** data-app, web-app | **Tier:** 3 | **Audience:** human
- **Structure:** Setup steps, demo flow (click-by-click), talking points per screen, FAQ/anticipated questions.

### ROI / Impact Analysis.md
- **Purpose:** Quantified impact of the project. Time saved, errors reduced, revenue impact, cost avoidance.
- **Types:** data-app, data-platform | **Tier:** 3 | **Audience:** human
- **Structure:** Before state (manual effort, error rate), after state (automated, accurate), quantified impact (hours saved/week, error reduction %).
- **Notes:** This is how you justify the project's existence and advocate for more resources or recognition.

### GTM Strategy.md
- **Purpose:** Go-to-market plan. Launch strategy, channels, early adopter acquisition.
- **Types:** web-app (consumer/marketed) | **Tier:** 2 | **Audience:** human
- **Structure:** Launch timeline, channels (Product Hunt, Reddit, SEO, partnerships), early adopter strategy, success metrics.

### Launch Plan.md
- **Purpose:** Tactical launch checklist. What needs to be ready, in what order, by when.
- **Types:** web-app (consumer/marketed) | **Tier:** 2 | **Audience:** human
- **Structure:** Pre-launch checklist, launch day plan, post-launch monitoring, success criteria.

### Content Calendar.md
- **Purpose:** Planned content for marketing channels. Blog posts, social media, email campaigns.
- **Types:** web-app (consumer/marketed) | **Tier:** 3 | **Audience:** human
- **Structure:** Week-by-week content plan. Channel, topic, format, publish date, status.

---

## 07-Operations/

### Environment Configuration.md
- **Purpose:** Documents all environments (dev, staging, prod) and their configuration differences.
- **Types:** all (that deploy) | **Tier:** 2 | **Audience:** agent
- **Structure:** Per-environment: URL, hosting, env vars, database, external service connections.

### Business Setup.md
- **Purpose:** Business entity, accounts, services needed to operate. LLC, domains, email, payment processing.
- **Types:** web-app (consumer/marketed) | **Tier:** 2 | **Audience:** human
- **Structure:** Checklist: entity registration, domain, email, hosting accounts, payment processor, analytics.

### Legal/
- **Purpose:** Privacy policy, terms of service, data handling agreements.
- **Types:** web-app (consumer) | **Tier:** 2 | **Audience:** human
- **Structure:** One file per document. Draft or final versions. Reference applicable regulations (GDPR, CCPA).

### Budget.md
- **Purpose:** Project costs — hosting, services, tools, marketing spend.
- **Types:** web-app (consumer/marketed) | **Tier:** 3 | **Audience:** human
- **Structure:** Monthly recurring costs, one-time costs, projected spend over 6-12 months.

---

## 08-Meeting-Notes/

### Session Logs
- **Purpose:** Document what was accomplished in a development session. Decisions made, problems solved, files changed.
- **Types:** all | **Tier:** 3 | **Audience:** both
- **Structure:** Date, duration, accomplishments, challenges/solutions, decisions made, files changed, next session plan.
- **Notes:** These accumulate naturally. The agent can create one at the end of each significant session.

### Decision Records
- **Purpose:** Lightweight log of decisions that don't warrant a full ADR. Quick reference for "why did we do it this way?"
- **Types:** all | **Tier:** 3 | **Audience:** both
- **Structure:** Date, decision, context, alternatives considered (brief).

---

## 09-Personal-Tasks/

### Someday-Maybe.md
- **Purpose:** Ideas not committed to the backlog. A parking lot for future possibilities.
- **Types:** all | **Tier:** 1 | **Audience:** human
- **Structure:** Bullet list of ideas, loosely categorized. No frontmatter needed.

### Pre-Dev Checklist.md
- **Purpose:** Tasks to complete before starting implementation. Environment setup, access, accounts, research.
- **Types:** all | **Tier:** 1 | **Audience:** both
- **Structure:** Categorized checklists: before each story, before each sprint, before first deploy.

---

## evaluations/

### [TICKET]-code-review.md
- **Purpose:** Code reviewer agent's evaluation report for a completed story. Verdict, per-criterion grades, specific findings, fix instructions.
- **Types:** all | **Tier:** 1 (created automatically during story completion) | **Audience:** agent
- **Notes:** Created by the code-reviewer agent during the evaluation cycle. Read by the main session for rollback protocol decisions.

### [TICKET]-test-review.md
- **Purpose:** Test writer agent's verification report. Coverage summary, missing tests, E2E results.
- **Types:** all | **Tier:** 1 (created automatically) | **Audience:** agent

### [TICKET]-product-review.md
- **Purpose:** Product manager's validation report. Acceptance criteria assessment, scope creep findings.
- **Types:** all | **Tier:** 1 (created automatically) | **Audience:** agent

---

## plans/

### [TICKET]-spec.md
- **Purpose:** Expanded implementation spec produced by the product-manager agent in planning mode. User stories, data model impact, design direction, acceptance criteria.
- **Types:** all | **Tier:** 1 (created automatically when starting a story) | **Audience:** both
- **Notes:** The main session presents this to the owner for approval before implementation begins.

---

## session-logs/

### YYYY-MM-DD-[topic].md
- **Purpose:** Brief session report: files read/written counts, tool call counts, context efficiency notes. Accumulated dataset for maintenance session analysis.
- **Types:** all | **Tier:** 3 (created automatically at session close-out) | **Audience:** agent
- **Notes:** Lightweight — not a detailed narrative. Used by maintenance sessions to identify context efficiency patterns.

---

## evals/

### README.md
- **Purpose:** Documents the evaluation harness format, lifecycle, and process. Reference for when to build evals.
- **Types:** all | **Tier:** 1 (scaffold created at bootstrap) | **Audience:** agent

### agent-changelog.md
- **Purpose:** Running log of agent prompt modifications with failure context. Raw data for building evaluation cases.
- **Types:** all | **Tier:** 1 (scaffold created at bootstrap) | **Audience:** agent

### [agent-name]/eval-NNN.md
- **Purpose:** Individual evaluation case with known correct answer. Built from real observed failures.
- **Types:** all | **Tier:** 3 (built after 2-3 sprints of real work) | **Audience:** agent

---

## maintenance/

### dedup-YYYY-MM-DD.md
- **Purpose:** Duplicate code scan results from maintenance session.
- **Types:** all | **Tier:** 3 (created during maintenance sessions) | **Audience:** agent

### full-test-YYYY-MM-DD.md
- **Purpose:** Full test suite results from maintenance session.
- **Types:** all | **Tier:** 3 | **Audience:** agent

### deps-YYYY-MM-DD.md
- **Purpose:** Dependency health report: outdated packages, security advisories.
- **Types:** all | **Tier:** 3 | **Audience:** both

### context-review-YYYY-MM-DD.md
- **Purpose:** Context efficiency analysis from session logs. Identifies wasteful patterns and recommends tuning.
- **Types:** all | **Tier:** 3 | **Audience:** agent

---

## Templates/

Templates live in the `Templates/` folder and are used by the agent when creating new documents (or by a templating plugin if the docs vault supports one).

### Always included:
- Epic-Template.md
- Story-Template.md
- Sprint-Template.md
- ADR-Template.md
- Sprint-Contract-Pipeline.md
- Sprint-Contract-Mesh.md
- Sprint-Contract-Hierarchical.md

### Included based on project type:
- Data-Source-Research-Template.md — `data-app`, `data-platform`, `automation`
- Feature-Spec-Template.md — `web-app`, `data-app`
- Session-Log-Template.md — all types
- Dashboard-Spec-Template.md — `data-app`
- Model-Design-Template.md — `ml-project`

---

## Quick Reference: Documents by Project Type

### data-app (Excel replacement, dashboards, reporting tools)
**Tier 1:** Home, Phase Definitions, Architecture Overview, Data Model, Data Pipeline Design, Dashboard Spec, Testing Strategy, ADR (at least one), Epics, Stories, Someday-Maybe, Pre-Dev Checklist
**Tier 2:** Data Dictionary, Data Quality Rules, Migration Plan, Output Specs, Wireframes, Seed Data, User Stories, Deployment Guide
**Tier 3:** Stakeholder Presentation, Demo Script, ROI/Impact Analysis, Session Logs

### data-platform (DuckDB, dbt, pipelines, analytics engineering)
**Tier 1:** Home, Phase Definitions, Architecture Overview, Data Model, Data Pipeline Design, Transformation Logic, Testing Strategy, ADR, Epics, Stories, Data Source Research, Someday-Maybe, Pre-Dev Checklist
**Tier 2:** Data Dictionary, Data Quality Rules, Migration Plan, Output Specs, Deployment Guide, Environment Config
**Tier 3:** Stakeholder Presentation, ROI/Impact Analysis, Session Logs

### ml-project (model development, training, evaluation)
**Tier 1:** Home, Phase Definitions, Architecture Overview, Data Model, Model Design, Training Data Spec, Model Evaluation Criteria, Testing Strategy, ADR, Epics, Stories, Someday-Maybe, Pre-Dev Checklist
**Tier 2:** Data Pipeline Design, Data Dictionary, Deployment Guide
**Tier 3:** Session Logs, Feature Specs

### web-app (SaaS, personal tools, consumer apps)
**Tier 1:** Home, Phase Definitions, Architecture Overview, Data Model, Testing Strategy, ADR, Epics, Stories, Someday-Maybe, Pre-Dev Checklist
**Tier 1 (consumer):** + Vision & Positioning, UX Specification
**Tier 2:** API Conventions, Security & Privacy, Deployment Guide, User Stories, Wireframes, Seed Data
**Tier 2 (consumer):** + Brand Guidelines, Design Tokens, GTM Strategy, Launch Plan, Business Setup, Legal
**Tier 3:** Feature Specs, Revenue Model, Content Calendar, Demo Script, Session Logs

### automation (scripts, CLIs, bots, scheduled jobs)
**Tier 1:** Home, Phase Definitions, Architecture Overview, Testing Strategy, ADR, Epics, Stories, Someday-Maybe, Pre-Dev Checklist
**Tier 2:** Data Pipeline Design (if data-moving), Output Specs, Deployment Guide
**Tier 3:** Session Logs
