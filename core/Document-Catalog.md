---
type: reference
status: active
created: 2026-03-21
updated: 2026-04-25
tags: [project, documentation, catalog, reference]
---

# Project Document Catalog

> **Audience: the AI agent.** This catalog lists every document that might exist in a project vault. During bootstrapping, use the project type and priority tiers to determine which documents to create. Each entry describes what the document is, why it matters, who it's for, and which project types need it.

---

## How to Use This Catalog

### Project Types
Every document is tagged with the project types that need it:

### Workflow Types

All project types are workflow types — reusable multi-agent patterns
that projects can compose. A project is not locked to a single type.

| Tag | Workflow | Description | Examples |
|-----|---------|-------------|---------|
| `web-app` | Software Development | Full-stack web applications — personal tools, SaaS products, consumer apps, APIs | Personal SaaS, consumer SaaS, internal web tools |
| `data-app` | Data App | Interactive tools replacing Excel — dashboards, forms, data entry apps, reporting tools | Streamlit dashboard, internal reporting tool, data entry webapp |
| `analytics-engineering` | Analytics Engineering | Modeled data layers — dbt transformations, DuckDB analytics, warehouse modeling | DuckDB + dbt layer, Alteryx migration, star schema builds |
| `data-engineering` | Data Engineering | Full pipeline infrastructure — ingestion, storage, orchestration, serving | Airflow DAGs, CDC pipelines, warehouse ETL, streaming ingestion |
| `ml-engineering` | ML Engineering | Machine learning — model development, training data, feature engineering, evaluation | Predictive models, classification, forecasting |
| `ai-engineering` | AI Engineering | LLM-powered applications — RAG systems, agent frameworks, prompt engineering | RAG chatbot, AI-powered search, agent workflow |
| `automation` | Software Development | Scripts, CLIs, bots, workflow automation, scheduled jobs | Data scrapers, cron jobs, CLI tools, Slack bots |
| `library` | Library | Reusable packages, SDKs, shared modules published for other developers to import | npm packages, PyPI libraries, internal SDKs |
| `analytics workflow` | Analytics | Ad hoc analysis, investigations, data requests. Task lifecycle, no sprints. | Revenue variance investigation, ad hoc SQL, data quality audit |
| `task-workspace` | Task (base) | Bounded tasks — domain-agnostic work with base agents. The base workflow type. | Catch-all for work not fitting other types |
| `agentic-workflow` | Agentic | Systems where the methodology itself is the product. 7-step structural update lifecycle. | Agentic workflow frameworks |

A project can be **multi-type**. A data app with scrapers is `data-app` + `automation`. An AI chatbot with a web frontend is `ai-engineering` + `web-app`. The agent should union all applicable document sets. Any workflow types can be composed — the orchestrator routes work to the appropriate workflow.

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

### Freshness Metadata

Tier 1 documents that the orchestrator loads into dispatch context at
story/task start carry a `last-validated` frontmatter field — the date
when a human or agent last confirmed that the document accurately
reflects the current codebase. This field is not auto-updated on every
edit; it is explicitly set during validation.

Documents that carry it: Architecture Overview, Data Model, Canonical
Patterns, Testing Strategy, Phase Definitions, Domain Language, Project
Charter, PRD, and domain-specific Tier 1 docs for the project type.
For Tier 1 documents created during bootstrap that do not have a
canonical template (Architecture Overview, Data Model, Canonical
Patterns, Testing Strategy, etc.), add `last-validated: [bootstrap
date]` to the frontmatter during creation.

The orchestrator uses this field during story/task start to determine
whether a document is fresh or stale — see
`core/workflows/protocols/story-execution.md` (Freshness-Aware Context
Loading) for the behavioral protocol and
`core/workflows/protocols/sprint-coordination.md` for the periodic
freshness sweep.

---

## Decomposition Hierarchy

Fabrika's documents follow a decomposition hierarchy that also serves
as the alignment hierarchy — the documents at each level capture
shared understanding between orchestrator and owner about what work
needs to be done.

| Level | Document | When used |
|-------|----------|-----------|
| Project inception | **Charter** | Created once at project start or major pivot |
| Execution sequence | **Roadmap** | Organizes PRDs/phases into execution order with dependencies |
| Phase or feature | **PRD** | Features or phases complex enough for module-level planning |
| Grouping envelope | **Epic** | Groups related stories and tasks toward a larger goal |
| Sprint-scoped work | **Story** | Sprint-based work with acceptance criteria, points, tier |
| Bounded work | **Task** | Individual work items in task and analytics workflows |
| Defect | **Bug** | Task with reproduction context (observed/expected, steps) |

These are layers, not alternatives. A complex project might have a
charter, then a roadmap, then PRDs, then epics, then stories. A
simple task just has a task document. The orchestrator's complexity
assessment determines how much alignment ceremony is needed — the
same assessment that determines execution ceremony.

---

## 00-Index/

### Home.md
- **Purpose:** Central navigation hub. Links to all major sections, shows project status at a glance.
- **Types:** all domain workflow types | **Tier:** 1 | **Audience:** both
- **Structure:** Project name, one-line description, quick links to key docs, current phase, what to read first.
- **Notes:** This is the first thing anyone opens. Keep it short — links, not content. For `analytics workflow`, the equivalent is `sources/README.md` (the source registry index).

### Domain-Language.md
- **Purpose:** Shared vocabulary of domain concepts — a living reference that evolves with the project. Each term has a plain-language definition, a mandatory code-level name (populated at implementation), relationships to other terms, and anti-terms (what this term is NOT). Organized by domain area, not alphabetically. Created during Design Alignment, updated during implementation and maintenance. Feeds into briefings (jargon glossary source), implementer dispatch (code naming), and code review (terminology consistency criterion).
- **Types:** all | **Tier:** 1 | **Audience:** both
- **Template:** `core/templates/Domain-Language-Template.md`
- **Structure:** One section per domain area. Within each area, one block per term: definition, code-level name, relationships, anti-terms. Cross-domain terms section for terms spanning multiple areas.
- **Notes:** Created via the Design Alignment protocol (`core/workflows/protocols/design-alignment.md`). Updated during implementation (implementers populate code-level names and flag new concepts), PRD creation (new terms added), and maintenance (terminology drift check). For multi-type projects, use domain area sections to disambiguate terms that mean different things in different contexts. For `analytics workflow`, Domain Language covers business domain vocabulary; the source registry (`sources/README.md`) covers data infrastructure vocabulary — they are complementary, not overlapping.

---

## 01-Product/

### Phase Definitions.md
- **Purpose:** Defines what each project phase delivers and what's explicitly excluded. Scope breakdown across phases, referenced by PRDs. Prevents scope creep by making the boundaries of "now" vs. "later" unambiguous.
- **Types:** all | **Tier:** 1 | **Audience:** both
- **Structure:** Phase 1 (MVP): goal, what ships, what doesn't. Phase 2+: brief description, explicitly marked "do not build yet."
- **Notes:** The agent references this to refuse out-of-scope work. Critical for discipline.

### Project Charter.md
- **Purpose:** Internal design document capturing shared understanding between the owner and agents. Defines the problem space, target user, core capabilities, constraints, success criteria, and design principles. Created once at project inception or during a major pivot.
- **Types:** all domain workflow types, agentic-workflow | **Tier:** 1 | **Audience:** both
- **Template:** `core/templates/Project-Charter-Template.md`
- **Notes:** Created via the Design Alignment protocol (`core/workflows/protocols/design-alignment.md`). The Charter captures what the product IS; Vision & Positioning captures why it matters externally; Phase Definitions breaks the Charter's capabilities into buildable phases. All three must be tightly aligned.

### PRD.md (Product Requirements Document)
- **Purpose:** Detailed requirements for a specific phase or major feature. User stories, module changes, implementation decisions, testing approach, and scope boundaries. Created per phase or major feature.
- **Types:** all domain workflow types, agentic-workflow | **Tier:** 1 | **Audience:** both
- **Template:** `core/templates/PRD-Template.md`
- **Notes:** Created via the Design Alignment protocol. The architect reviews the Module Changes section before owner approval. After approval, the scrum master decomposes the PRD into sprint stories.

### Vision & Positioning.md
- **Purpose:** External-facing "why" — why this product exists, who it's for, what makes it different. Brand promise and competitive angle. See Project Charter for the internal design document.
- **Types:** web-app | **Tier:** 1 (consumer SaaS), 2 (personal SaaS) | **Audience:** human
- **Structure:** Mission statement, target user, problem being solved, competitive positioning, success metrics.
- **Notes:** For work projects (data-app, analytics-engineering), this becomes a simpler "Project Justification" — why are we building this instead of using Excel/Alteryx.

### User Stories.md
- **Purpose:** Plain-language descriptions of what users need to accomplish. Bridges product thinking and engineering.
- **Types:** web-app, data-app, ai-engineering | **Tier:** 2 | **Audience:** both
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
- **Types:** web-app, data-app, ai-engineering | **Tier:** 3 (create as needed) | **Audience:** both
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
- **Types:** all sprint-based except automation (if stateless) and library (if stateless) | **Tier:** 1 | **Audience:** agent
- **Structure:** Table/collection definitions with column types, relationships, indexes, example queries, migration/evolution notes.
- **Notes:** For DuckDB/dbt projects, this documents the target schema. For web-apps, includes auth tables, RLS policies, etc. For `data-engineering`, documents schemas at each lifecycle stage (source, staging, transformed, served). For `ai-engineering`, documents embedding schemas, vector stores, and any persistent state.

### Data Pipeline Design.md
- **Purpose:** How data moves through the system. Sources, extraction, transformation, loading, scheduling.
- **Types:** data-app, analytics-engineering, data-engineering, automation | **Tier:** 1 | **Audience:** agent
- **Structure:** Source inventory, extraction method per source, transformation steps, load targets, scheduling/orchestration approach, error handling, retry logic.
- **Notes:** For dbt projects, this documents the DAG structure and transformation philosophy. For scrapers, documents the scraping pattern and per-source research template. For `data-engineering`, this is the central design document — covers the full Reis lifecycle from ingestion through serving.

### Data Dictionary.md
- **Purpose:** Defines every field/column across the data layer. Business meaning, data type, source, transformations applied.
- **Types:** data-app, analytics-engineering, data-engineering | **Tier:** 2 | **Audience:** both
- **Structure:** Table per source/model. Columns: field name, type, description, source, business rules, example values.
- **Notes:** Critical for analytics engineering — this is what stakeholders reference to understand reports.

### Data Quality Rules.md
- **Purpose:** Validation rules, expected ranges, anomaly detection criteria. What makes data "suspicious."
- **Types:** data-app, analytics-engineering, data-engineering | **Tier:** 2 | **Audience:** agent
- **Structure:** Per-table or per-field rules: not-null constraints, range checks, freshness requirements, referential integrity, custom business rules.
- **Notes:** For dbt projects, these translate directly to dbt tests. For `data-engineering`, rules span all lifecycle stages.

### Transformation Logic.md
- **Purpose:** Documents the business logic behind data transformations. Why certain calculations exist, what business rules drive them.
- **Types:** analytics-engineering, data-engineering | **Tier:** 1 | **Audience:** both
- **Structure:** Per-transformation: input sources, business rule, calculation/logic, output, edge cases, owner/stakeholder who defined it.
- **Notes:** This is the "translation layer" between the Excel formulas you're replacing and the SQL/dbt models you're building. Critical for validation.

### Migration Plan.md
- **Purpose:** Documents how to migrate from the current state (Excel, Alteryx, etc.) to the target state. What moves when, validation steps, rollback plan.
- **Types:** analytics-engineering, data-engineering, data-app | **Tier:** 2 | **Audience:** both
- **Structure:** Current state, target state, migration phases, per-phase: what moves, validation criteria, rollback, stakeholder sign-off.
- **Notes:** Especially important for Alteryx → SQL migrations where you need to prove output parity.

### Model Design.md
- **Purpose:** Documents the ML model architecture, algorithm choice, feature set, and training approach.
- **Types:** ml-engineering | **Tier:** 1 | **Audience:** both
- **Structure:** Problem statement, algorithm/approach, feature list with rationale, training data requirements, hyperparameters, baseline metrics.

### Training Data Spec.md
- **Purpose:** What data the model trains on. Sources, labels, preprocessing, splits, known biases.
- **Types:** ml-engineering | **Tier:** 1 | **Audience:** agent
- **Structure:** Data sources, labeling methodology, preprocessing pipeline, train/val/test split ratios, data volume, known issues/biases, refresh cadence.

### Model Evaluation Criteria.md
- **Purpose:** How to judge if the model is good enough. Metrics, thresholds, comparison baselines.
- **Types:** ml-engineering | **Tier:** 1 | **Audience:** both
- **Structure:** Primary metrics (accuracy, F1, RMSE, etc.), threshold for production-readiness, baseline comparison (current process vs. model), evaluation dataset, re-evaluation cadence.

### Source System Contracts.md
- **Purpose:** Documents each source system's reliability characteristics: SLAs, schema ownership, change notification process, known instabilities.
- **Types:** data-engineering | **Tier:** 1 | **Audience:** agent
- **Structure:** Per-source: system name, owner/team, SLA (uptime, latency), schema change notification process, known issues, historical incidents, data freshness guarantees.
- **Notes:** Goes deeper than Data Source Research — this is about operational reliability, not just access. Critical for pipeline engineering where source instability is the most common failure mode.

### Ingestion Design.md
- **Purpose:** How data gets from source systems into your infrastructure. Batch vs. streaming, CDC, idempotency, error handling.
- **Types:** data-engineering | **Tier:** 1 | **Audience:** agent
- **Structure:** Per-source ingestion pattern: method (batch/streaming/CDC/full-refresh), frequency, idempotency strategy, error handling, backfill procedure, schema evolution handling, data validation at ingestion.
- **Notes:** Separated from Data Pipeline Design because ingestion has its own set of concerns (exactly-once semantics, late-arriving data, schema drift) distinct from transformation.

### Storage Architecture.md
- **Purpose:** Why data lives where it does. Storage tier decisions, lifecycle policies, cost considerations.
- **Types:** data-engineering | **Tier:** 1 | **Audience:** both
- **Structure:** Storage layers (raw/staging/transformed/served), technology per layer, data format choices, partitioning strategy, retention policies, cost model, backup/disaster recovery.
- **Notes:** Storage is a cross-cutting concern in Reis's lifecycle — data passes through multiple storage layers. This doc captures the architectural decisions about where and why.

### Serving Contracts.md
- **Purpose:** What downstream consumers expect from the data you serve. SLAs, freshness requirements, format guarantees.
- **Types:** data-engineering | **Tier:** 1 | **Audience:** both
- **Structure:** Per-consumer: who they are, what they consume, freshness SLA, format, access method, what happens when data is late or wrong.
- **Notes:** The counterpart to Source System Contracts — one documents what comes in, this documents what goes out.

### Orchestration Design.md
- **Purpose:** How pipeline tasks are coordinated. DAG structure, dependency management, alerting, retry policies.
- **Types:** data-engineering | **Tier:** 1 | **Audience:** agent
- **Structure:** Orchestrator choice (Airflow, Dagster, Prefect, cron), DAG topology, dependency graph, retry/backoff strategy, alerting channels, SLA monitoring, manual intervention procedures.

### DataOps Runbook.md
- **Purpose:** Operational reference for monitoring, incident response, and CI/CD for data pipelines.
- **Types:** data-engineering | **Tier:** 2 | **Audience:** both
- **Structure:** Monitoring dashboards, alerting rules, incident response playbook (common failure modes and fixes), CI/CD pipeline for data code, testing strategy for pipelines, deployment procedure.

### Prompt Library.md
- **Purpose:** Versioned prompt templates with test cases. The core artifact of an AI-powered application.
- **Types:** ai-engineering | **Tier:** 1 | **Audience:** agent
- **Structure:** Per-prompt: name, version, purpose, template text, input variables, expected output characteristics, test cases (input → expected output), known failure modes.
- **Notes:** Prompts are code in AI applications. Version them, test them, review them. The prompt-reviewer agent grades against this document.

### Model Configuration.md
- **Purpose:** Which LLMs are used, with what parameters, and why. Routing strategy if multiple models are in play.
- **Types:** ai-engineering | **Tier:** 1 | **Audience:** agent
- **Structure:** Per-model: provider, model ID, temperature, token limits, use case, fallback model, cost per call estimate. Model routing logic if applicable.

### RAG Architecture.md
- **Purpose:** Retrieval-augmented generation pipeline design: embedding strategy, chunking, retrieval, reranking.
- **Types:** ai-engineering | **Tier:** 1 (if RAG is used) | **Audience:** agent
- **Structure:** Embedding model, chunk size/overlap strategy, vector store, retrieval method (similarity, hybrid, reranking), context window management, freshness/re-indexing cadence.
- **Notes:** Only applicable if the project uses RAG. Skip if the AI application is generation-only.

### Evaluation Strategy.md
- **Purpose:** How AI output quality is measured. Eval datasets, metrics, automated checks, human review criteria.
- **Types:** ai-engineering | **Tier:** 1 | **Audience:** both
- **Structure:** Eval dimensions (relevance, groundedness, safety, helpfulness), per-dimension: metric, automated check, threshold, eval dataset with known-good answers. Human review sampling strategy if applicable.
- **Notes:** Distinct from Testing Strategy — this is about evaluating LLM behavior, not testing code. Think of it as the acceptance criteria for AI quality.

### Cost Model.md
- **Purpose:** Projected operational costs for compute, storage, API usage, and infrastructure. For `ai-engineering`, focuses on token usage and model routing. For `data-engineering` and `analytics-engineering`, covers warehouse compute, storage multiplication, and egress.
- **Types:** ai-engineering, data-engineering, analytics-engineering, ml-engineering | **Tier:** 2 | **Audience:** both
- **Structure:**
  - **ai-engineering:** Per-feature: estimated calls/day, tokens/call, model used, monthly cost projection. Caching strategy, prompt optimization notes, model routing (cheap model for simple tasks, expensive for complex).
  - **data-engineering:** Per-pipeline: compute cost per run, storage cost across lifecycle stages (raw/staged/modeled/served), egress costs, orchestrator costs, idle infrastructure baseline. Monthly projection at current and projected data volume.
  - **analytics-engineering:** Per-model: warehouse compute cost for full refresh vs. incremental, storage footprint, downstream query cost impact. Monthly projection.
  - **ml-engineering:** Training compute (GPU hours per experiment), inference cost at projected volume, experiment tracking storage, model registry costs.
- **Notes:** The performance-reviewer agent checks actual costs against this model during reviews. Track actual vs. projected over time to improve estimation accuracy.

### Guardrails Spec.md
- **Purpose:** Input/output filtering, safety boundaries, fallback behavior when AI output is unacceptable.
- **Types:** ai-engineering | **Tier:** 2 | **Audience:** agent
- **Structure:** Input validation (prompt injection detection, content filtering), output validation (factuality checks, format enforcement, PII filtering), fallback behavior (what happens when guardrails trigger), logging/alerting for guardrail events.

### API Design Guide.md
- **Purpose:** Public API surface area design: naming conventions, versioning strategy, backward compatibility guarantees.
- **Types:** library | **Tier:** 1 | **Audience:** both
- **Structure:** Public exports inventory, naming conventions, versioning strategy (semver, calver), deprecation policy, breaking change process, type signature design principles.
- **Notes:** This is the library equivalent of UX — the interface your consumers interact with. Design it deliberately.

### Migration Guide Template.md
- **Purpose:** Template for documenting how consumers upgrade between library versions. Per-version breaking changes and migration steps.
- **Types:** library | **Tier:** 2 | **Audience:** both
- **Structure:** Per-version: breaking changes list, migration steps (before/after code examples), automated migration scripts if applicable.

### Publishing Checklist.md
- **Purpose:** Checklist for publishing a new library version: registry, docs, changelog, semver, testing.
- **Types:** library | **Tier:** 2 | **Audience:** both
- **Structure:** Pre-publish checks (tests pass, lint clean, changelog updated, version bumped), publish steps (build, publish to registry, tag release), post-publish (verify install, update docs site, announce).

### API Conventions.md
- **Purpose:** Standards for API design: naming, versioning, error format, auth patterns.
- **Types:** web-app, library | **Tier:** 2 | **Audience:** agent
- **Structure:** URL patterns, HTTP methods, request/response format, error codes, pagination, auth headers, rate limiting.

### Testing Strategy.md
- **Purpose:** How the project is tested. What types of tests, coverage targets, fixture conventions, CI pipeline, verification method.
- **Types:** all | **Tier:** 1 | **Audience:** agent
- **Structure:** Test types (unit, integration, fixture-based, e2e), coverage targets, fixture conventions, CI pipeline description, what to mock vs. not mock, verification method (browser automation, output diffing, etc.), fast vs. full test commands.
- **Notes:** For data projects, testing often means output validation (do SQL results match Excel?). For ML, testing means evaluation metrics. For AI, testing means eval suites against model behavior. For libraries, testing includes backward compatibility and public API contract tests. The verification method determines how the validator agent runs E2E checks. Not applicable to `analytics workflow` (validation is per-task, handled by the data-validator agent).

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

### Threat Model.md
- **Purpose:** Enumerates attack surfaces, threat actors, and mitigations. Maps each surface to a concrete mitigation or an accepted risk.
- **Types:** web-app, ai-engineering | **Tier:** 2 | **Audience:** both
- **Structure:** Per attack surface: entry point, threat actor (unauthenticated user, authenticated user, supply chain, insider), attack vector, impact (data breach, privilege escalation, denial of service), mitigation, status (mitigated, accepted risk, TODO). For `ai-engineering`: include prompt injection, data poisoning, model extraction, and PII leakage through model responses.
- **Notes:** The security-reviewer agent references this during reviews. Start with the obvious surfaces (auth, user input, external APIs) and expand as the application grows. Not a one-time document — update when new attack surfaces are introduced.

### Deployment Guide.md
- **Purpose:** How to deploy the project. Steps, environments, infrastructure, monitoring.
- **Types:** all (that deploy) | **Tier:** 2 | **Audience:** agent
- **Structure:** Environment list, deployment steps, infrastructure (hosting, CI/CD), monitoring/alerting, rollback procedure.

### Seed Data Spec.md
- **Purpose:** Initial data the system needs to function. Default values, reference tables, sample data for development.
- **Types:** web-app, data-app | **Tier:** 2 | **Audience:** agent
- **Structure:** Per-table: what seed data exists, source, format, load method. For web-apps: default categories, system settings, demo data.

### Canonical Patterns.md
- **Purpose:** The single reference for how common concerns are implemented in this project. One pattern per concern (error handling, API calls, state management, logging, test structure, etc.), each with a concrete code example. Agents use this as a lookup table: "when you need to do X, do it exactly like this." This makes agent output predictable and consistent regardless of where in the codebase it operates.
- **Types:** all | **Tier:** 1 | **Audience:** agent
- **Structure:** One section per concern. Each section: pattern name, when to use it, canonical code example, anti-patterns to avoid.
- **Notes:** Start with 3-5 patterns during bootstrapping based on the tech stack. Expand during maintenance when session logs reveal new patterns used 2+ times. The code-reviewer grades against this document (see "Pattern Conformance" criterion in the code-review rubric).

### Custom Lint Rules/
- **Purpose:** Project-specific lint rules with prompt-style error messages. Each rule targets a recurring agent (or human) mistake that was observed 3+ times. Error messages are written as remediation instructions, not just violation descriptions — they tell the agent what to do instead and why.
- **Types:** all | **Tier:** 3 (built during maintenance from observed patterns) | **Audience:** agent
- **Structure:** One file per lint rule or group. Contains: the rule definition (ESLint, Ruff, semgrep custom rule, or structural test), the prompt-style error message, and the failure context that motivated it.
- **Notes:** Created during maintenance sessions when the same code-reviewer feedback appears 3+ times across sprints. The error message IS a prompt — write it as remediation instructions the agent can follow, not just "X is not allowed."

### Structural Constraints.md
- **Purpose:** Declares codebase structure rules that are enforced mechanically via tests or lint, not just by agent judgment. Examples: max file length, banned import patterns, dependency edge rules, schema deduplication requirements. These are agent-efficiency constraints — they keep the codebase in a shape where agents can work effectively within limited context windows.
- **Types:** all | **Tier:** 2 | **Audience:** agent
- **Structure:** One section per constraint. Each section: constraint name, rationale (why this helps agents), enforcement mechanism (test, lint, hook), threshold or rule definition.
- **Notes:** Start simple (file length limits, no circular imports). Expand based on observed agent struggles during maintenance. The test-writer agent generates structural tests from this document. The pre-push hook runs structural tests alongside behavioral tests.

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
- **Types:** analytics-engineering, data-engineering, automation, data-app | **Tier:** 2 | **Audience:** both
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
- **Types:** data-app, analytics-engineering, data-engineering, automation | **Tier:** 1 (for known sources) | **Audience:** agent
- **Structure:** One file per data source. See Data-Source-Research-Template.md. Overview, access method, authentication, data format, known issues, refresh cadence.
- **Notes:** Critical for any project that pulls data from external sources. One file per source keeps research organized and agent-accessible. For `analytics workflow`, source documentation lives in `sources/` (see analytics workflow folder structure) rather than here.

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
- **Types:** data-app, analytics-engineering | **Tier:** 3 | **Audience:** human
- **Structure:** Problem statement, what was built, before/after comparison, impact metrics, demo talking points, next steps.

### Demo Script.md
- **Purpose:** Step-by-step walkthrough for demoing the project. What to show, what to say, anticipated questions.
- **Types:** data-app, web-app | **Tier:** 3 | **Audience:** human
- **Structure:** Setup steps, demo flow (click-by-click), talking points per screen, FAQ/anticipated questions.

### ROI / Impact Analysis.md
- **Purpose:** Quantified impact of the project. Time saved, errors reduced, revenue impact, cost avoidance.
- **Types:** data-app, analytics-engineering | **Tier:** 3 | **Audience:** human
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

## Base Documents (All Workflow Types)

> These documents are available to any workflow type. They are the
> domain-agnostic lifecycle documents that the task workflow uses
> directly and that specialized workflows extend with domain-specific
> versions. The analytics workflow has domain-specific versions
> (Analysis-Plan, Analysis-Outcome) that add data source sections,
> SQL logic, and cost estimation. Sprint-based workflows use stories
> and specs instead. But the base task document, plan, outcome, and
> validation report pattern applies universally.
>
> **Backlog type applicability:** Task documents apply to tasks and
> bugs (bugs include reproduction context fields: observed/expected
> behavior, reproduction steps). Plans apply to standard-mode tasks
> and bugs (simple-mode tasks skip the plan — the commit message is
> the documentation artifact). Story specs apply to story-type work
> (see `plans/` section). Epics have no execution documents — they
> are a coordination envelope; epic-level coordination artifacts are
> CR-24 scope.

### tasks/[date-name]/task.md (Task Document)
- **Purpose:** Documents what needs to be done — the goal, audience, deadline, desired output, and constraints. The base alignment artifact between orchestrator and owner.
- **Types:** task-workspace, analytics workflow | **Tier:** 1 (created per task) | **Audience:** both
- **Template:** `core/templates/Task-Template.md`
- **Notes:** The analytics workflow uses the same template as the base task workflow. The task document is domain-agnostic — it works for any task type. For analytics tasks, "The Goal" typically states the business question.

### tasks/[date-name]/plan.md (Plan)
- **Purpose:** How the work will be done — deliverables, acceptance criteria, sequencing, constraints, validation approach. The contract the implementer executes against and the reviewer evaluates against.
- **Types:** task-workspace, analytics workflow (as Analysis Plan) | **Tier:** 1 (created per task) | **Audience:** both
- **Template:** `core/templates/Plan-Template.md` (base), `core/templates/Analysis-Plan-Template.md` (analytics-specific)
- **Notes:** The analytics workflow extends the base plan with data source tables, SQL logic sections, and cost estimates. The base plan derives its structure from the task document, not from a domain model.

### tasks/[date-name]/outcome.md (Outcome)
- **Purpose:** Results, methodology, deliverable summary, and follow-up recommendations. The "what we found/produced" of a task.
- **Types:** task-workspace, analytics workflow (as Outcome Report) | **Tier:** 1 (created per task at delivery) | **Audience:** both
- **Template:** `core/templates/Outcome-Template.md` (base), `core/templates/Analysis-Outcome-Template.md` (analytics-specific)
- **Notes:** The analytics workflow extends the base outcome with data quality notes, output locations (SQL files, CSVs), and source-specific methodology. The base outcome works for any deliverable type.

### tasks/[date-name]/validation-report.md (Validation Report)
- **Purpose:** Human-facing evidence chain tracing key claims in the outcome back to the plan and task document. Lets the audience understand why they can trust the output.
- **Types:** task-workspace, analytics workflow | **Tier:** 1 (created per task at delivery) | **Audience:** both
- **Notes:** Written by the validator as a second output alongside its internal evaluation report. Lives at the task root (not in `docs/evaluations/`) because it is a stakeholder-facing deliverable. The analytics workflow version traces claims back through SQL and data; the base version traces claims back through whatever the deliverables are.

### docs/evaluations/[task-name]-review.md (Review Report)
- **Purpose:** Reviewer findings for a task — verdict, per-criterion assessment against the plan's acceptance criteria, quality signal assessment, fix instructions.
- **Types:** task-workspace | **Tier:** 1 (created per task during review) | **Audience:** agent
- **Notes:** The base reviewer derives its checklist from the plan's acceptance criteria and four general quality signals (completeness, consistency, clarity, correctness). Domain-specific reviewers (logic-reviewer, code-reviewer) use domain rubrics instead.

### docs/evaluations/[task-name]-validation.md (Validation Report — Internal)
- **Purpose:** Validator internal evaluation — verdict, task document satisfaction assessment, deliverable completeness, acceptance criteria coverage, internal consistency findings.
- **Types:** task-workspace | **Tier:** 1 (created per task during validation) | **Audience:** agent
- **Notes:** Internal report for the review loop. Distinct from the human-facing validation report at `tasks/[date-name]/validation-report.md`.

### docs/evaluations/[task-name]-plan-check.md (Plan Check)
- **Purpose:** Planner validation mode report. Verifies that the output answers the task document's goal in the right format for the audience.
- **Types:** task-workspace, analytics workflow | **Tier:** 1 (created per task at delivery) | **Audience:** agent
- **Notes:** The planner validates independently — it does not receive reviewer or validator findings.

---

## agentic-workflow Documents

> These documents support the agentic-workflow structural update lifecycle. The structural mode uses a 7-step protocol; documents track plans, verification, and version history. Operational mode documents (if enabled) are project-specific and human-maintained.

### System Update Plan
- **Purpose:** The structured plan produced in Step 1 of the structural update lifecycle. Documents what is changing, how it integrates, what could go wrong, and mitigations. Persists alignment decisions and design rationale.
- **Types:** agentic-workflow | **Audience:** both
- **Template:** `core/templates/System-Update-Plan-Template.md`
- **Structure:** YAML frontmatter (status: draft/approved/executed, created date, change-request pointer), file change inventory, integration point analysis, risk identification, mitigations, version bump determination, CHANGELOG draft, owner decision points, alignment history.
- **Notes:** Written by the workflow-planner to `docs/plans/[identifier]-plan.md` during Step 1. Revised in place when the owner pushes back (planner re-invoked, not orchestrator). The Alignment History section captures what changed from the initial plan and why. Status transitions: draft (planner creates) -> approved (owner approves in Step 2) -> executed (shipped in Step 7).

### Change Verification Report
- **Purpose:** Independent evaluation reports produced in Step 4 (Verify). Each verifying agent (methodology-reviewer, structural-validator, architect) writes its own report.
- **Types:** agentic-workflow | **Audience:** agent
- **Structure:** Verdict (PASS/FAIL or SOUND/CONCERNS/UNSOUND), per-criterion findings, specific issues with file paths and fix instructions.
- **Notes:** Written to `docs/evaluations/` (or equivalent). The orchestrator reads these in Step 5 to decide what to fix.

### core/calibration/priors.yml
- **Purpose:** Bundled tier-level priors and model-to-tier lookup table for token cost estimation. Framework-level reference data used by `core/scripts/estimate-tokens.py`. Contains per-tier token ranges (low/mid/high), the model-to-tier mapping for current Claude, GPT, and Gemini models, and the EWMA smoothing constant.
- **Types:** all | **Audience:** agent
- **Notes:** Framework-level artifact — copied to consumer projects during bootstrap. Updated when new models release or estimation priors are recalibrated. Patch-level bump when changed.

### core/calibration/pricing.yml
- **Purpose:** Per-model pricing data ($/1M tokens, input and output rates) used by `core/scripts/estimate-tokens.py` for dollar cost estimates. Separated from priors.yml for easier patch-level updates when providers change pricing.
- **Types:** all | **Audience:** agent
- **Notes:** Framework-level artifact — copied to consumer projects during bootstrap. Updated when model pricing changes. Patch-level bump when changed.

### .fabrika/calibration.yml
- **Purpose:** Per-project calibration data for token cost estimation. Records actual token usage after workflow runs and improves estimate accuracy over time via EWMA blending against bundled priors. Scaffolded from `core/templates/Calibration-Template.yml` at bootstrap time.
- **Types:** all | **Audience:** agent
- **Notes:** Consumer-project artifact. Updated automatically during session close-out (sprint-based and analytics workflow) or Step 7 Ship (agentic-workflow) when token data is available. Not manually edited — the estimation script manages it via `--record-actuals`.

### VERSION
- **Purpose:** Single-line file containing the current semantic version. The version authority for the system.
- **Types:** agentic-workflow | **Audience:** agent
- **Notes:** Bumped as part of every structural change (Step 3). Must match the latest CHANGELOG entry.

### CHANGELOG
- **Purpose:** Running log of all structural changes, organized by version. Lists every file changed, the nature of the change, and consumer update instructions.
- **Types:** agentic-workflow | **Audience:** both
- **Notes:** Entry added as part of every structural change (Step 3). Consumer update instructions must be complete — every file a consumer needs to update or copy is listed.

---

## Analytics Workflow Documents

> These documents live outside the standard `docs/` vault structure. The analytics workflow type uses a flat, task-centric folder layout instead of the numbered docs hierarchy.

### sources/README.md (Source Registry Index)
- **Purpose:** Central index of all data sources, BI tools, and flat file sources available in this workspace. The equivalent of Home.md for analytics workspaces.
- **Types:** analytics workflow | **Tier:** 1 (populated during onboarding) | **Audience:** agent
- **Structure:** Three sections: Connections (queryable data sources), Tools (BI/ETL tools), Files (recurring flat file sources). Each entry: name, one-line description, link to detail file.

### sources/connections/[platform]/README.md (Platform Connection)
- **Purpose:** Platform-level overview documenting the database platform type, environment (cloud/on-prem/local), connection method, cost model, and EXPLAIN mechanism. One per platform. Level 1 project/instance connections live in subdirectories beneath this.
- **Types:** analytics workflow | **Tier:** 1 (populated during onboarding) | **Audience:** agent
- **Template:** `core/templates/Platform-Connection-Template.md`
- **Structure:** Platform type, environment, connection method, cost model (actual or default), default pricing reference table, EXPLAIN mechanism, list of Level 1 connections beneath this platform.
- **Notes:** Created during workspace onboarding (BOOTSTRAP.md Phase 2W.1a). If the user does not know their cost model, the file uses published default pricing and flags this. The analytics workflow workflow reads the cost model from this file during plan and performance review phases.

### sources/connections/[platform]/[instance]/*.md
- **Purpose:** Per-connection documentation for Level 1 project/instance data sources beneath a platform: specific databases, projects, or servers the agent can query programmatically.
- **Types:** analytics workflow | **Tier:** 1 (one per known connection) | **Audience:** agent
- **Template:** `core/templates/Source-Connection-Template.md`
- **Structure:** Connection type, connection string/path, authentication method, key schemas/tables, known gotchas, SLA/reliability notes, who owns it.

### sources/tools/*.md
- **Purpose:** Per-tool documentation for BI and ETL tools the agent can reason about but cannot touch directly: Tableau Server, Power BI Service, Alteryx Server/Designer.
- **Types:** analytics workflow | **Tier:** 1 (one per known tool) | **Audience:** agent
- **Structure:** Tool name, URL/location, key workbooks/workflows/reports, data sources used, refresh schedule, who maintains it. Advisory mode note: what the agent can do (write SQL, review logic, draft DAX) vs. what the human executes in the tool.

### sources/files/*.md
- **Purpose:** Per-source documentation for recurring flat files: CSVs, Excel files, YXDBs. Documents metadata about the file, not the file itself (files go in `data/input/`).
- **Types:** analytics workflow | **Tier:** 2 (as encountered) | **Audience:** agent
- **Structure:** File name/pattern, who sends it, delivery frequency, format, known quality issues, expected columns/schema, where it lands in `data/input/`.

### tasks/[date-name]/task.md (Task Document)
- **Purpose:** Documents the business question, who asked, deadline, desired output format. The "why" of a task.
- **Types:** analytics workflow | **Tier:** 1 (created per task) | **Audience:** both
- **Structure:** See Task-Template.md.

### tasks/[date-name]/plan.md (Analysis Plan)
- **Purpose:** Technical approach: what data sources to pull, joins/transforms, logic, assumptions, validation approach. The "how" of a task.
- **Types:** analytics workflow | **Tier:** 1 (created per task) | **Audience:** both
- **Structure:** See Analysis-Plan-Template.md.

### tasks/[date-name]/outcome.md (Outcome Report)
- **Purpose:** Results, methodology summary, data quality notes, output location, follow-up recommendations. The "what we found" of a task.
- **Types:** analytics workflow | **Tier:** 1 (created per task at delivery) | **Audience:** both
- **Structure:** See Analysis-Outcome-Template.md.

### tasks/[date-name]/work/execution-manifest.md (Execution Manifest)
- **Purpose:** Metadata query results for Tier 2 tasks: INFORMATION_SCHEMA lookups, EXPLAIN plan output, estimated costs per query. Produced by running metadata queries before main query execution. The primary input for the performance reviewer.
- **Types:** analytics workflow | **Tier:** 1 (created per Tier 2 task) | **Audience:** agent
- **Structure:** Tables touched (four-level path), schema info per table, EXPLAIN plan output per query, estimated cost per query and total, data source classification.
- **Notes:** Only created for Tier 2 tasks (production data). Lives in `work/` because it is a work product (output of running metadata queries).

### tasks/[date-name]/validation-report.md (Validation Report)
- **Purpose:** Human-facing evidence chain tracing each key claim in the outcome report back to the code and data that supports it. Lets a stakeholder understand WHY they can trust each number without re-reading the SQL.
- **Types:** analytics workflow | **Tier:** 1 (created per task at delivery) | **Audience:** both
- **Structure:** Per claim: which code produced it, what filters/logic were applied, what validation checks confirmed. Always detailed regardless of stakes.
- **Notes:** Written by the data validator as a second output alongside the internal evaluation report. Lives at the task root (not in `docs/evaluations/`) because it is a stakeholder-facing deliverable.

### docs/evaluations/[task-name]-plan-check.md (Plan Check)
- **Purpose:** Analysis planner validation mode report. Verifies that the analysis output answers the business question from the task document in the right format for the stakeholder. Requirements validation, not data validation.
- **Types:** analytics workflow | **Tier:** 1 (created per task at delivery) | **Audience:** agent
- **Structure:** Verdict (MEETS REQUIREMENTS / PARTIALLY MEETS REQUIREMENTS / DOES NOT MEET REQUIREMENTS), per-check findings, gaps identified, recommendations.
- **Notes:** The analysis planner validates independently — it does not receive data validation results or logic review findings.

---

## evaluations/

> **Tier note:** Patch-tier stories produce only a code review report
> (`[TICKET]-code-review.md`). Test review, product review, and
> architect review are produced for Story and Deep Story tiers only.
> Deep Story tier additionally produces an architect review report
> (`[TICKET]-architecture-review.md`) as a mandatory (not optional)
> evaluation artifact.

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
- **Notes:** The main session presents this to the owner for approval before implementation begins. **Tier note:** Patch-tier stories do not produce spec documents — the story file IS the spec. Spec creation applies to Story and Deep Story tiers only.

### [TICKET]-research.md
- **Purpose:** Compressed subsystem research findings produced during the Deep Story research phase, before spec creation. Documents affected subsystems, current state, constraints discovered, risks identified, and open questions. Passed to the planner as context for spec expansion (compaction applies).
- **Types:** all sprint-based | **Tier:** 1 (created automatically for Deep Story tier stories only) | **Audience:** both
- **Notes:** Produced by the orchestrator (not a sub-agent) during the Deep Story research phase. Lives alongside specs in `docs/plans/`. Only created for Deep Story tier — Patch and Story tiers do not produce this artifact.

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

### knowledge-synthesis-YYYY-MM-DD.md
- **Purpose:** Knowledge synthesis report from maintenance session. Records what was indexed, which topics were created or updated, and terms flagged for Domain Language.
- **Types:** all | **Tier:** 3 (created during maintenance sessions when wiki/ exists) | **Audience:** agent

---

## wiki/

> The wiki knowledge layer synthesizes scattered project artifacts (ADRs, retros, evaluation reports, research docs) into organized, continuously updated topic articles. Created during bootstrap or adoption when the owner opts in (default recommended). Maintained incrementally during maintenance sessions and quarterly reintegration passes.

### wiki/index.md
- **Purpose:** Progressive narrative overview of the project's knowledge. Reads from zero understanding to full context: project overview → knowledge domains → key decisions → current state → active questions → sources summary. The primary "explain this project" document for both humans and agents.
- **Types:** all | **Tier:** 2 (created when wiki is first populated, either during bootstrap backfill or first maintenance synthesis) | **Audience:** both
- **Structure:** Project overview, knowledge domains with one-paragraph summaries and topic links, key decisions (top 5-10 from S1 articles), current state, active questions, sources summary.
- **Notes:** This is a narrative, not a list of links. Updated every synthesis pass. Fully rewritten during quarterly reintegration.

### wiki/topics/[topic-name].md
- **Purpose:** Synthesized topic article consolidating knowledge from multiple source artifacts on a specific subject. Each article is self-contained with links to related topics and source artifacts.
- **Types:** all | **Tier:** 2 (created during maintenance when 2+ source artifacts converge on a theme) | **Audience:** both
- **Template:** `core/templates/Wiki-Topic-Template.md`
- **Structure:** Summary, Key Decisions, Current State, Open Questions, Related Topics, Sources.
- **Notes:** Requires the single-source synthesis threshold: content from at least 2 independent source artifacts. Created via the notice-and-proceed model (agent creates and notifies owner, proceeds unless owner objects). Uses Domain Language terms — does not define terms that belong in Domain Language.

### wiki/meta/batch-YYYY-MM-DD.json
- **Purpose:** Batch index file produced by the Extract+Index phases of the knowledge pipeline. Stable intermediate that decouples synthesis from source file lifecycle. Contains extracted content, salience scores, topic candidates, and deduplication keys.
- **Types:** all | **Tier:** 3 (created during each pipeline run) | **Audience:** agent
- **Schema:** `core/templates/Batch-Index-Schema.md`
- **Notes:** Agent-facing artifact — humans do not need to read batch indexes. Survives source file renames and deletions. Stale entries cleaned up during quarterly reintegration.

### wiki/meta/last-reintegration.md
- **Purpose:** Timestamp and summary of the most recent quarterly reintegration pass. Used by the maintenance checklist to determine when the next reintegration is due.
- **Types:** all | **Tier:** 3 | **Audience:** agent

---

## Templates/

Templates live in the `Templates/` folder (or `docs/Templates/` in sprint-based projects) and are used by the agent when creating new documents.

### Always included (domain workflow types):
- Project-Charter-Template.md
- PRD-Template.md
- Epic-Template.md
- Story-Template.md
- Sprint-Template.md
- ADR-Template.md
- Sprint-Contract-Pipeline.md
- Sprint-Contract-Mesh.md
- Sprint-Contract-Hierarchical.md
- Domain-Language-Template.md
- Wiki-Topic-Template.md
- Batch-Index-Schema.md

### Base templates (all task-based workflow types):
- Task-Template.md — `task-workspace`, `analytics workflow` (unified task document template)
- Plan-Template.md — `task-workspace` (base plan, extended by Analysis-Plan-Template for analytics)
- Outcome-Template.md — `task-workspace` (base outcome, extended by Analysis-Outcome-Template for analytics)
- Roadmap-Template.md — all project types (execution sequence with active/completed/deferred phases)

### Included based on project type:
- Calibration-Template.yml — all project types (scaffolded to `.fabrika/calibration.yml` at bootstrap)
- Data-Source-Research-Template.md — `data-app`, `analytics-engineering`, `data-engineering`, `automation`
- Feature-Spec-Template.md — `web-app`, `data-app`, `ai-engineering`
- Session-Log-Template.md — all domain workflow types
- Dashboard-Spec-Template.md — `data-app`
- Model-Design-Template.md — `ml-engineering`
- Platform-Connection-Template.md — `analytics workflow`
- Source-Connection-Template.md — `analytics workflow`, `data-engineering`
- Source-Tool-Template.md — `analytics workflow`
- Source-File-Template.md — `analytics workflow`
- Analysis-Plan-Template.md — `analytics workflow`
- Analysis-Outcome-Template.md — `analytics workflow`
- Task-Contract-Template.md — `analytics workflow`
- System-Update-Plan-Template.md — `agentic-workflow`

---

## Quick Reference: Documents by Project Type

### Domain Workflows

#### web-app (SaaS, personal tools, consumer apps)
**Tier 1:** Home, Domain Language, Project Charter, PRD, Phase Definitions, Architecture Overview, Data Model, Testing Strategy, Canonical Patterns, ADR, Epics, Stories, Someday-Maybe, Pre-Dev Checklist
**Tier 1 (consumer):** + Vision & Positioning, UX Specification
**Tier 2:** API Conventions, Security & Privacy, Threat Model, Deployment Guide, User Stories, Wireframes, Seed Data, Structural Constraints, wiki/index.md, wiki/topics/
**Tier 2 (consumer):** + Brand Guidelines, Design Tokens, GTM Strategy, Launch Plan, Business Setup, Legal
**Tier 3:** Feature Specs, Revenue Model, Content Calendar, Demo Script, Session Logs, wiki/meta/

#### data-app (Excel replacement, dashboards, reporting tools)
**Tier 1:** Home, Domain Language, Project Charter, PRD, Phase Definitions, Architecture Overview, Data Model, Data Pipeline Design, Dashboard Spec, Testing Strategy, Canonical Patterns, ADR (at least one), Epics, Stories, Someday-Maybe, Pre-Dev Checklist
**Tier 2:** Data Dictionary, Data Quality Rules, Migration Plan, Output Specs, Wireframes, Seed Data, User Stories, Deployment Guide, Structural Constraints, wiki/index.md, wiki/topics/
**Tier 3:** Stakeholder Presentation, Demo Script, ROI/Impact Analysis, Session Logs, wiki/meta/

#### analytics-engineering (dbt, DuckDB, warehouse modeling, Alteryx migration)
**Tier 1:** Home, Domain Language, Project Charter, PRD, Phase Definitions, Architecture Overview, Data Model, Data Pipeline Design, Transformation Logic, Testing Strategy, Canonical Patterns, ADR, Epics, Stories, Data Source Research, Someday-Maybe, Pre-Dev Checklist
**Tier 2:** Data Dictionary, Data Quality Rules, Migration Plan, Output Specs, Deployment Guide, Environment Config, Cost Model, Structural Constraints, wiki/index.md, wiki/topics/
**Tier 3:** Stakeholder Presentation, ROI/Impact Analysis, Session Logs, wiki/meta/

#### data-engineering (pipelines, ingestion, orchestration, full Reis lifecycle)
**Tier 1:** Home, Domain Language, Project Charter, PRD, Phase Definitions, Architecture Overview, Data Model, Data Pipeline Design, Source System Contracts, Ingestion Design, Storage Architecture, Serving Contracts, Orchestration Design, Transformation Logic, Testing Strategy, Canonical Patterns, ADR, Epics, Stories, Data Source Research, Someday-Maybe, Pre-Dev Checklist
**Tier 2:** Data Dictionary, Data Quality Rules, Migration Plan, Output Specs, DataOps Runbook, Deployment Guide, Environment Config, Cost Model, Structural Constraints, wiki/index.md, wiki/topics/
**Tier 3:** Stakeholder Presentation, ROI/Impact Analysis, Session Logs, wiki/meta/

#### ml-engineering (model development, training, evaluation)
**Tier 1:** Home, Domain Language, Project Charter, PRD, Phase Definitions, Architecture Overview, Data Model, Model Design, Training Data Spec, Model Evaluation Criteria, Testing Strategy, Canonical Patterns, ADR, Epics, Stories, Someday-Maybe, Pre-Dev Checklist
**Tier 2:** Data Pipeline Design, Data Dictionary, Deployment Guide, Cost Model, Structural Constraints, wiki/index.md, wiki/topics/
**Tier 3:** Session Logs, Feature Specs, wiki/meta/

#### ai-engineering (LLM apps, RAG, agents, prompt engineering)
**Tier 1:** Home, Domain Language, Project Charter, PRD, Phase Definitions, Architecture Overview, Data Model, Prompt Library, Model Configuration, Evaluation Strategy, Testing Strategy, Canonical Patterns, ADR, Epics, Stories, Someday-Maybe, Pre-Dev Checklist
**Tier 1 (if RAG):** + RAG Architecture
**Tier 2:** Guardrails Spec, Cost Model, Threat Model, User Stories, Deployment Guide, Security & Privacy, Structural Constraints, wiki/index.md, wiki/topics/
**Tier 3:** Feature Specs, Session Logs, wiki/meta/

#### automation (scripts, CLIs, bots, scheduled jobs)
**Tier 1:** Home, Domain Language, Project Charter, PRD, Phase Definitions, Architecture Overview, Testing Strategy, Canonical Patterns, ADR, Epics, Stories, Someday-Maybe, Pre-Dev Checklist
**Tier 2:** Data Pipeline Design (if data-moving), Output Specs, Deployment Guide, Structural Constraints, wiki/index.md, wiki/topics/
**Tier 3:** Session Logs, wiki/meta/

#### library (reusable packages, SDKs, shared modules)
**Tier 1:** Home, Domain Language, Project Charter, PRD, Phase Definitions, Architecture Overview, API Design Guide, Testing Strategy, Canonical Patterns, ADR, Epics, Stories, Someday-Maybe, Pre-Dev Checklist
**Tier 2:** API Conventions, Migration Guide Template, Publishing Checklist, Deployment Guide, Structural Constraints, wiki/index.md, wiki/topics/
**Tier 3:** Session Logs, wiki/meta/

### Analytics Workflow

#### analytics workflow (ad hoc analysis, investigations, data requests)
**Onboarding:** sources/README.md (Source Registry Index), sources/connections/[platform]/README.md (Platform Connection), sources/connections/[platform]/[instance]/*.md, sources/tools/*.md, Domain Language
**Per-task:** task.md, plan.md, outcome.md, validation-report.md (in each `tasks/[date-name]/` folder)
**Per-task (Tier 2 only):** execution-manifest.md (in `tasks/[date-name]/work/`)
**Evaluations:** [task-name]-logic-review.md, [task-name]-data-validation.md, [task-name]-plan-check.md, [task-name]-performance-review.md (Tier 2 only) (in `docs/evaluations/`)
**As needed:** sources/files/*.md, reusable queries in `src/queries/`, scripts in `src/scripts/`, wiki/index.md, wiki/topics/
**Note:** No sprint artifacts, no backlog. Work is organized as tasks with tiered review (Tier 1 for local data, Tier 2 for production data). Wiki is opt-in during workspace onboarding and populated via backfill and incremental synthesis after task deliveries.

#### task-workspace (bounded tasks, domain-agnostic work)
**Per-task (standard mode):** task.md, plan.md, outcome.md, validation-report.md (in each `tasks/[date-name]/` folder)
**Per-task (simple mode):** No task folder, no plan.md — the orchestrator plans inline and dispatches the implementer directly. The commit message is the documentation artifact. The reviewer receives the inline plan and the diff.
**Evaluations:** [task-name]-review.md, [task-name]-validation.md, [task-name]-plan-check.md (in `docs/evaluations/`) — standard mode only. Simple mode produces only the reviewer's assessment.
**As needed:** Domain Language, wiki/index.md, wiki/topics/
**Note:** No sprint artifacts, no data tiers, no domain-specific review. Work is organized as tasks with domain-agnostic agents. The reviewer derives its checklist from the plan's acceptance criteria (or inline plan in simple mode). Wiki is opt-in and populated via incremental synthesis after task deliveries.

### Agentic Workflow

#### agentic-workflow (agent methodology systems, personal operating systems)
**Core:** Domain Language, Project Charter, PRD, VERSION, CHANGELOG, MIGRATIONS (version history and consumer communication)
**Per-change:** System Update Plan (at `docs/plans/[identifier]-plan.md`), Change Verification Reports (in `docs/evaluations/`)
**Structural:** Agent prompts, workflow definitions, archetype templates, catalogs, integration templates, dispatch protocol, rubrics, hooks
**Knowledge layer:** wiki/index.md, wiki/topics/, wiki/meta/ (opt-in, cadence driven by the structural update lifecycle — wiki is updated during the Ship step of each system update, during alignment sessions, when harvest findings arrive, and on demand)
**Operational (if enabled):** Status file, operational logs, ritual definitions (project-specific, not templated)
**Note:** No sprint artifacts, no Tier system. Work is organized as structural changes following the 7-step lifecycle.
