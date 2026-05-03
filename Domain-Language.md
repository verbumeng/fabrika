# Fabrika Domain Language

Fabrika's framework vocabulary. These terms are used consistently
across agent prompts, workflow files, integration templates, and
documentation. Consumer projects should understand these terms when
reading Fabrika source files or integration templates.

This is Fabrika's own glossary. Consumer projects create their own
Domain Language using `core/templates/Domain-Language-Template.md`
for their project-specific vocabulary.

---

## Agent Model

**Archetype** — A base behavioral template that defines the shared
dispatch contract, output contract, and tool profile for a category
of agents. Seven archetypes exist: Planner, Reviewer, Validator,
Coordinator, Designer, Implementer, and Architect. Specialized agents
(e.g., code-reviewer, software-engineer) inherit from an archetype
and add domain-specific expertise.

**Agent** — An AI sub-agent dispatched by the **orchestrator** to
perform a scoped task. Each agent implements one **archetype** and
carries domain-specific evaluation criteria, procedures, and
**calibration examples**. Agents do not call each other — all
coordination flows through the orchestrator.

**Orchestrator** — The top-level AI session that drives the
development workflow. The orchestrator reads project state, dispatches
**agents**, mediates between them, presents results to the **owner**,
and manages the **retry protocol**. The orchestrator never writes
production code — that is the **implementer**'s job. Sometimes called
the "pure orchestrator" to emphasize this constraint. [Formalized in
0.12.0.]

**Pure orchestrator** — The principle that the orchestrator dispatches
work to specialist agents rather than implementing directly. The
orchestrator may perform orientation (reading STATUS.md, sprint
contracts), present briefings, and manage the evaluation feedback
loop, but all production file changes go through an **implementer**
agent. [Introduced in 0.12.0.]

**Roster** — The set of agents installed for a given **project type**.
Each project type maps to a specific combination of agent roles
(planner, reviewer, validator, etc.) defined in the **Agent Catalog**.
Multi-type projects install the union of all applicable rosters.

**Agent Catalog** — The reference document
(`core/agents/AGENT-CATALOG.md`) that maps each **project type** to
its **roster** of agents. Also lists all agent files, their roles,
archetypes, and which project types use them.

**Dispatch** — The act of the **orchestrator** invoking a sub-agent
with a structured payload. The payload contents depend on the
**dispatch tier**. Dispatch always goes through the orchestrator —
agents never dispatch to other agents.

**Dispatch tier** — The level of context provided to an agent when
dispatched. Two tiers exist: **strict dispatch** and **contextual
dispatch**. A third variant, **lightweight dispatch**, reduces
ceremony for trivial changes but is still a dispatch to an
implementer.

**Strict dispatch** — A dispatch payload containing only the approved
plan, file paths, and rubric pointer. No opinions, no hints, no
pre-digested summaries. Used for **reviewers**, **validators**,
**designers**, and **architects** (in review mode) to preserve
independent judgment.

**Contextual dispatch** — A dispatch payload containing broader
project context: conversation history, owner preferences, prior
decisions, architecture pointers. Used for **planners**,
**coordinators**, **implementers**, and **architects** (in design
mode) because they are creating, not judging.

**Lightweight dispatch** — A reduced-ceremony variant of
**contextual dispatch** for trivial **implementer** changes. All
three conditions must be true: the change touches exactly one file,
the spec fully specifies the edit, and the change is not a new
feature, refactor, or architectural change. The orchestrator still
dispatches to the implementer — lightweight dispatch reduces the
payload ceremony, not the dispatch itself. [Introduced in 0.12.0.]

**Dispatch contract** — The specification of what the orchestrator
must provide to an agent at each invocation point. Defined per agent
in `core/workflows/protocols/dispatch-protocol.md`. Includes required fields,
conditional fields, and fields that must NOT be included (to preserve
independence).

**Output contract** — The specification of what an agent must produce
after completing its task. Defines the artifact type (spec, review
report, changed files, assessment), file path conventions, and
required sections.

**Calibration example** — A worked example embedded in an agent
prompt showing what PASS, FAIL, SOUND, CONCERNS, or UNSOUND looks
like for that agent's evaluation criteria. Calibration examples
anchor the agent's judgment to concrete standards rather than leaving
quality thresholds abstract. [Added to agentic-workflow agents in
0.12.0; to architect agents in 0.13.0.]

**Agent maturity** — The level of detail and sophistication in an
agent's prompt. A mature agent has detailed evaluation criteria,
step-by-step procedures, calibration examples, and context window
hygiene guidance. Immature agents have stub prompts with basic role
descriptions. [All canonical agents reached maturity by 0.13.0.]

**Specialist** — An agent that implements an archetype with
domain-specific expertise. Five specialist **implementers**
(software-engineer, data-engineer, data-analyst, ml-engineer,
ai-engineer) and three specialist **architects** (software-architect,
data-architect, context-architect) exist. Specialists carry domain
principles — how to think about the domain — independent of any
specific project's tech stack. [Implementers introduced in 0.12.0;
architects in 0.13.0.]

---

## Agent Roles

**Planner** — An agent that takes a vague ask and produces a
structured spec or plan. Operates in two modes: planning mode
(creates the spec) and validation mode (verifies the implementation
against the spec). Examples: product-manager, experiment-planner,
api-designer, analysis-planner, workflow-planner.

**Reviewer** — An agent that evaluates implementation quality through
independent, skeptical review. Does not implement fixes — identifies
problems, grades severity, and writes fix instructions. Examples:
code-reviewer, logic-reviewer, prompt-reviewer, security-reviewer,
performance-reviewer, methodology-reviewer.

**Supplemental reviewer** — A reviewer that provides a specialized
review pass alongside the primary reviewer. Depth over breadth.
Examples: security-reviewer and performance-reviewer running
alongside code-reviewer.

**Validator** — An agent that proves correctness by execution —
writes and runs tests, evals, data checks, or model metrics.
Examples: test-writer, data-quality-engineer, model-evaluator,
eval-engineer, data-validator, structural-validator.

**Coordinator** — An agent that manages work sequencing, sprint
planning, and process facilitation. Does not implement features or
review code. Currently only the scrum-master fills this role.

**Designer** — An agent that proposes and evaluates designs (visual,
structural, interactive). Currently only the visualization-designer
fills this role.

**Implementer** — An agent that writes production changes against an
approved plan. Does not design — executes what was planned. Each
implementer is scoped to a domain. The orchestrator dispatches to the
appropriate **specialist** based on the work's domain.

**Architect** — An agent that evaluates structural design —
decomposition, references, context budgets, interface design. Does
not review content quality (reviewer's job), verify correctness
(validator's job), or implement changes (implementer's job). Operates
in three modes: design mode (proposes structure), review mode
(evaluates implemented changes), and ad hoc mode (assesses existing
codebase).

---

## Workflow

**Structural mode** — The required mode for **agentic-workflow**
projects where changes follow the 7-step **structural update
lifecycle**. All changes to the system's infrastructure (agent
prompts, workflow definitions, instruction files, templates, catalogs)
go through this protocol. Feature branch and PR are required.

**Operational mode** — An optional mode for **agentic-workflow**
projects that have day-to-day operational work beyond structural
changes (e.g., daily reviews, weekly planning). Operational sessions
are human-initiated and interactive — no agent orchestration. Does
not change the structural update protocol or add agents.

**Structural update lifecycle** — The 7-step protocol governing
changes to agentic-workflow systems: (1) Plan (planner writes plan
file to `docs/plans/`), (2) Align (owner reviews, planner revises
on pushback), (3) Execute, (4) Verify (agents receive plan file
path), (5) Incorporate Feedback, (6) Present, (7) Ship (plan status
set to executed). Steps 4-5 can loop (maximum 3 retry cycles).
Defined in `core/workflows/types/agentic-workflow.md`.

**Change request (CR)** — The input to the planning process for
agentic-workflow projects. A document describing what needs to change
and why. Lives in the project's change request directory (e.g.,
`planning/` for Fabrika itself). The planner expands a change request
into a **system update plan**. Previously called "PRD" in Fabrika's
own repo — new change requests use "CR" naming; existing PRD files
are not renamed. [Introduced in 0.21.0.]

**System update plan** — A persistent file at
`docs/plans/[identifier]-plan.md` produced by the **workflow-planner**
in Step 1 of the **structural update lifecycle**. Contains file
change inventory, integration point analysis, risk identification,
mitigations, version bump determination, and an **alignment history**
section. Status lifecycle: draft -> approved -> executed. The
implementation contract that the **agentic-engineer** (formerly
context-engineer, renamed in 0.25.0) implements against and the
verification agents evaluate against. [Persisted as file in 0.21.0;
previously conversation-only.]

**Alignment history** — A section in a **system update plan** file
that captures what changed from the initial plan and why during Step
2 (Align). Short entries, not transcripts. When the owner pushes
back, the planner is re-invoked and appends to this section.
Persists the design rationale that would otherwise evaporate in
conversation. [Introduced in 0.21.0.]

**Sprint lifecycle** — The multi-chat cycle governing sprint-based
projects: Design Alignment (when triggered) -> Sprint Planning ->
Story chats (one per story) -> Sprint Close-Out -> Maintenance ->
Sprint Retro -> next Sprint Planning. Each phase boundary is a hard
new-chat handoff to keep context windows clean. Defined in
`core/workflows/protocols/sprint-coordination.md`.

**Task lifecycle** — The tiered workflow governing
**analytics-workspace** projects. Two tiers: Tier 1 (local data:
plan -> promotion check -> write -> logic review -> [revise ->
re-review]* -> execute -> validate + brief check -> deliver) and
Tier 2 (production data: adds metadata queries, execution manifest,
performance review, and cost approval gate before main execution).
Each task is independent — no sprint structure. Defined in
`core/workflows/types/analytics-workspace.md`. [Tiered workflow introduced
in 0.20.0.]

**Session lifecycle** — The per-chat workflow within a single story
or task: orient (read STATUS.md, sprint contract), plan, implement,
evaluate, close out. Defined in the integration template (CLAUDE.md
or copilot-instructions.md).

**Design Alignment** — An orchestrator protocol for structured
requirements gathering. The orchestrator runs this directly (not a
sub-agent dispatch) because the iterative back-and-forth with the
owner requires conversational context. Produces a **Project Charter**
(first time) and a **PRD** (per phase or feature). Triggers: new
project, new phase, owner request, or detected ambiguity. For
**analytics-workspace**, produces an enhanced Analysis Brief instead
of a Charter/PRD. [Formalized in 0.14.0.]

**Sprint contract** — A per-sprint agreement defining the stories in
scope, their acceptance criteria, token budget estimates, testing
approach per story, and the sprint **topology**. Three topology
templates exist: Pipeline, Mesh, and Hierarchical. The coordinator
produces this during sprint planning; the owner approves it.

**Sprint progress** — A running log of work completed during a
sprint. Updated after each story chat. Includes story status, token
usage, agent quality observations, and evaluation outcomes.

**Cycle phase** — A field in STATUS.md that tells any new chat where
it is in the **sprint lifecycle**. Values: `alignment`, `planning`,
`story-in-progress`, `sprint-close`, `maintenance`, `retro`.

**Topology** — The task coupling pattern of a sprint. Three options:
**Pipeline** (sequential stages with entry/exit conditions — the
default), **Mesh** (independent tasks with no shared state), or
**Hierarchical** (coupled tasks with dependency chains and shared
interfaces). The coordinator assesses topology during sprint planning.

**Evaluation cycle** — The review-validate-fix loop after
implementation. The orchestrator dispatches reviewer(s), validator(s),
and planner (in validation mode). If evaluators find issues, the
implementer reads the review reports directly (the orchestrator routes
file paths, it does not synthesize findings) and revises. All
evaluators re-check after every revision. Maximum 3 retry cycles.

**Retry protocol** — The procedure for handling a FAIL verdict from
an evaluator. The orchestrator dispatches the implementer for revision
with the original plan and the review report paths. The implementer
reads the reports directly, revises, and the orchestrator re-invokes
all evaluators (not just failing ones) with fresh dispatch. Maximum 3
retry cycles. After 3 failed cycles, the orchestrator diagnoses the
failure pattern and presents it to the user for intervention. Defined
in `core/workflows/protocols/dispatch-protocol.md`.

**Implementer-reviewer pairing** — The principle that every
implementer output gets an independent review before it is considered
complete or acted upon downstream. The implementer produces, the
reviewer independently assesses, the implementer revises based on
findings, and the reviewer re-checks. The orchestrator routes but
does not interpret or synthesize. Applies across all project types.
Defined in `core/design-principles.md`. [Identified in 0.20.0,
codified in 0.22.0.]

**Implementer-validator pairing** — The corollary to
**implementer-reviewer pairing**: every implementer output that
produces observable results gets validated against expected outcomes.
The nature of validation differs by project type: data output for
analytics-workspace, test passage for sprint-based, structural
correctness for agentic-workflow. Defined in
`core/design-principles.md`. [Identified in 0.20.0, codified in
0.22.0.]

**Compaction** — The principle that each phase transition produces a
compressed artifact self-contained for the next phase. The receiving
agent reads outputs, not inputs — preserving signal and discarding
noise. Governs all workflows universally. The dispatch protocol's
output format constraints
(`core/workflows/protocols/dispatch-protocol.md`) are the enforcement
mechanism. Anti-patterns: dumping full file contents instead of
excerpts, re-reading files a prior phase already summarized,
orchestrator synthesizing reviewer findings instead of routing report
paths, including "might be relevant" context that burns context
window. Defined in `core/design-principles.md`. [Codified in 0.28.0.]

**Orchestrator diagnosis** — The protocol after 3 failed **retry
protocol** cycles. The orchestrator reads all evaluation reports
across all cycles, identifies the failure pattern (same issue
recurring, different issues each time, narrowing but not resolving),
and presents the diagnosis to the user in plain language. The user
decides the path forward; the review cycle still runs after
intervention. [Introduced in 0.22.0.]

**Verification gate** — A step in the **structural update lifecycle**
(Step 4) where three independent agents — methodology-reviewer,
structural-validator, and context-architect — evaluate the changes in
parallel with **strict dispatch**. Each must form its own judgment
without seeing the others' findings.

**Graduated testing** — A framework for matching testing approach to
story complexity. Three levels: **spec-first** (TDD), **test-informed**,
and **test-after**. The coordinator assigns the approach per story
during sprint planning. [Introduced in 0.16.0.]

**Complexity tier** — A classification of work item complexity that
determines which workflow gates apply. Three tiers for sprint-based
work: **Patch** (reduced ceremony), **Story** (full ceremony), and
**Deep Story** (enhanced ceremony). Part of the **universal complexity
spectrum**. Assigned by the **coordinator** during sprint planning
based on story points, scope indicators, and owner override. Recorded
in the story file frontmatter (`tier: patch | story | deep-story`)
and in the **sprint contract**. The **orchestrator** reads the tier
and routes to the appropriate execution path. [Introduced in 0.29.0.]

**Patch** — The lightest complexity tier for sprint-based work.
Single-concern changes (1-2 points) where the story file IS the spec.
Skips spec creation and planner validation. Evaluation is reduced to
code-reviewer only (max 2 retry cycles). If a Patch exceeds 2 review
cycles or the code-reviewer flags scope creep, the orchestrator
promotes it to **Story**. Conventional commit format is the primary
documentation artifact. [Introduced in 0.29.0.]

**Story** — The standard complexity tier for sprint-based work.
Multi-file changes (3-5 points) with bounded scope. The current full
**development workflow** applies with no modifications: spec creation,
all evaluation gates, 3 retry cycles. This is the default tier when
none is specified. [Named in 0.29.0; behavior predates Fabrika.]

**Deep Story** — The highest complexity tier for sprint-based work.
Cross-cutting, novel, or high-risk changes (8-13 points). Adds a
mandatory research phase (producing
`docs/plans/[TICKET]-research.md`) before spec creation, mandatory
**architect** review of the spec before implementation, and mandatory
architect structural review after implementation. Research findings
are compressed before being passed to the planner (**compaction**
applies). [Introduced in 0.29.0.]

**Universal complexity spectrum** — The graduated scale of ceremony
levels that applies across all workflow types, not just sprint-based
work. The full spectrum: ad-hoc (near-zero ceremony) -> task (base
workflow) -> patch (reduced sprint ceremony) -> story (full sprint
ceremony) -> deep story (enhanced sprint ceremony) -> epic (multi-story
coordination). The **orchestrator** dynamically assesses where a piece
of work falls on this spectrum based on scope, risk, and coordination
needs — not by checking the project type. The three old project type
categories (sprint-based, task-based, methodology-based) are dissolving
into composable **workflow types** with the spectrum as the connecting
thread. [Conceptualized in 0.29.0; CR-18 implements the sprint-based
portion (patch, story, deep story). CR-19 covers ad-hoc. CR-17
covers task. CR-24 addresses epic-level orchestration.]

**Tier promotion** — The one-way escalation of a story's
**complexity tier** during execution. Patch can promote to Story;
Story can promote to Deep Story. Triggers: code-reviewer flags scope
creep, implementer discovers unexpected complexity, orchestrator
detects >3 files touched (Patch), or automatic promotion after
exceeding the tier's retry cap. The orchestrator presents the
promotion to the owner before continuing. Demotion (Deep Story to
Story) is owner-initiated only. [Introduced in 0.29.0.]

**Spec-first** — The TDD testing approach. The validator writes tests
from the approved spec before any code exists. The implementer then
writes the minimum code to make those tests pass. Used for new
modules, complex logic, new public interfaces, and high-risk
behaviors. Also called "TDD stories."

**Test-informed** — A testing approach where the implementer is aware
of testing expectations during implementation but tests are written
after code. The validator writes tests against the finished
implementation but the spec's acceptance criteria guide what to test.
Used for modifications to existing code, medium-complexity changes.
The default when in doubt.

**Test-after** — A testing approach where tests are written entirely
after implementation. Used for low-complexity changes, configuration
updates, and documentation-heavy stories. Also the default for
**lightweight dispatch**.

**Briefing** — A structured presentation of agent-produced artifacts
translated into plain language for the **owner**. Briefings bridge
the gap between machine-optimized artifacts and human decision-making.
Defined formats exist for specs, sprint plans, task plans, task
outcomes, structural plans, change summaries, and retros. Principles
in `core/briefings/briefing-principles.md`. [Formalized in 0.17.0.]

**Tier (analytics workspace)** — A data environment classification
that determines the workflow process for an analytics-workspace task.
Tier 1 (local data) skips execution manifest and performance review.
Tier 2 (production data) adds metadata queries, execution manifest,
performance review, and cost approval (cloud only). Mixed sources use
the highest tier. Separate from **stakes** — tier determines process,
stakes determine intensity. [Introduced in 0.20.0.]

**Stakes** — A review intensity classification for analytics-workspace
tasks. Low (exploratory, throwaway), medium (stakeholder ad hoc, team
consumption), or high (executive audience, financial reporting,
compliance). Determines how thoroughly reviewers and validators check
within a given **tier**. Separate from tier — a low-stakes cloud query
still needs cost protection (tier), while a high-stakes local analysis
needs thorough validation (stakes) but not cost approval. [Introduced
in 0.20.0.]

**Execution manifest** — A metadata query results document at
`tasks/[date-name]/work/execution-manifest.md` produced during Tier 2
analytics-workspace tasks. Contains INFORMATION_SCHEMA lookups, EXPLAIN
plan output, estimated costs per query, and data source classification.
The primary input for the performance reviewer's pre-execution
assessment. [Introduced in 0.20.0.]

**Brief check** — Analysis planner validation mode output at
`docs/evaluations/[task-name]-brief-check.md`. Verifies that the
analysis output answers the business question from the brief in the
format the stakeholder needs. Requirements validation (does the output
answer the right question?), not data validation (are the numbers
correct?). Verdict: MEETS BRIEF / PARTIALLY MEETS BRIEF / DOES NOT
MEET BRIEF. [Introduced in 0.20.0.]

**Validation report** — A human-facing evidence chain at
`tasks/[date-name]/validation-report.md` produced by the data
validator. Traces each key claim in the outcome report back to the
code and data that supports it. Always detailed regardless of
**stakes**. Distinct from the internal evaluation report (which is for
the review loop). [Introduced in 0.20.0.]

**Pre-execution review** — The review phase between code writing and
code execution in the analytics-workspace tiered workflow. The logic
reviewer and (for Tier 2) performance reviewer assess code before any
query hits a database. Prevents expensive, incorrect, or destructive
queries from executing. [Introduced in 0.20.0.]

**Context window hygiene** — The practice of managing what an agent
reads to stay within effective context limits. Read targeted files,
not entire directories. Load docs on demand, not up front. Return
concise output summaries. Referenced in every archetype and agent
prompt.

---

## Framework Structure

**Canonical** — The authoritative source version of a Fabrika file,
living in the Fabrika repository itself. Consumer projects receive
copies of canonical files during **bootstrap** or **adoption**.
Changes to canonical files require a **version bump** and
**CHANGELOG entry**.

**Consumer** — A project that has installed Fabrika via
**BOOTSTRAP.md** or **ADOPT.md**. Consumer projects carry copies of
Fabrika files (agents, templates, rubrics) tracked by the
**manifest**. Consumer projects may customize their copies — the
**harvest** workflow captures generalizable improvements back to
canonical.

**Integration template** — A project-level instruction file
(CLAUDE.md for Claude Code, copilot-instructions.md for GitHub
Copilot) that configures the AI coding tool for the project. Contains
the session lifecycle, sprint lifecycle awareness, evaluation system
rules, sub-agent dispatch tables, and testing rules. Produced from
Fabrika templates in `integrations/`.

**Manifest** — The file `.fabrika/manifest.yml` in a consumer
project that records every Fabrika-originated file installed, its
source path, version, content hash, and whether it has been
customized. The manifest makes updates cheap (diff against changelog,
not the whole repo) and enables the **harvest** workflow. Specified
in `MANIFEST_SPEC.md`.

**Bootstrap** — The process of creating a new project from scratch
using Fabrika. Produces a complete project scaffold, documentation
vault, agent installation, sprint planning, and readiness check.
Defined in `BOOTSTRAP.md`.

**Adopt** — The process of integrating Fabrika into an existing
project. Three tiers: Tier 1 (agents only), Tier 2 (agents + sprint
framework), Tier 3 (full restructure). Never overwrites existing
project content — merges alongside what is already there. Defined in
`ADOPT.md`.

**Adoption tier** — One of three levels of Fabrika integration for
existing projects. Tier 1 installs agents and basic state files only.
Tier 2 adds sprint contracts, rubrics, hooks, evaluation scaffold,
and maintenance checklist. Tier 3 reorganizes the docs directory into
the full Fabrika convention.

**Update** — The process of syncing a consumer project to a newer
Fabrika version. The **manifest** and **CHANGELOG** make this cheap:
the agent reads the changelog to determine what changed, diffs only
affected files, and proposes updates. Always run **harvest** before
update. Defined in `UPDATE.md`.

**Harvest** — The workflow for capturing generalizable improvements
from consumer project forks back into canonical Fabrika. Two inputs:
eval artifacts (structured, per-sprint observations) and manifest
drift (file-level diffs of customized files). Human-triggered, not
automatic. Always run before **update**. Defined in `HARVEST.md`.

**Context decomposition** — The principle that instruction files
should stay lean. When a section grows beyond ~30-50 lines of
instructional content, extract it into its own file and leave a
pointer. Signs: file does double duty, reader scrolls past irrelevant
blocks, same info would need duplication without extraction.

**Smell test** — A set of mental checks run on every canonical file
before committing: Does this leak personal, product-specific, or
tool-specific assumptions? Does this name downstream projects? Would
this make sense to a stranger cloning the repo? If any check fails,
revise before committing.

**Bump rules** — The rules governing which changes require a
**version bump** and of what type. `core/**` changes require a minor
bump. `integrations/**`, `BOOTSTRAP.md`, `UPDATE.md`, `ADOPT.md`,
`HARVEST.md` changes require a patch bump. `MANIFEST_SPEC.md`
changes require a minor bump. `examples/**`, `README.md`, and meta
changes require no bump.

**Integration point map** — A reference of common cross-reference
chains in Fabrika. Used by the workflow-planner and agentic-engineer
to trace ripple effects of changes. Examples: agent prompts <->
Agent Catalog <-> workflow files <-> integration templates; Document
Catalog <-> doc-triggers <-> agent prompts.

**FABRIKA.md** — A framework relationship guide copied to
`.fabrika/FABRIKA.md` in consumer projects. Agents read this on
demand to understand the relationship between the consumer project
and canonical Fabrika (e.g., during retros or when asking about
upstream flow).

---

## Knowledge

**Wiki** — A project knowledge layer (`wiki/` directory) that
synthesizes scattered project artifacts (ADRs, retros, evaluation
reports, research docs) into organized, continuously updated
**topic articles**. Created during bootstrap or adoption when the
owner opts in. Maintained incrementally during maintenance sessions
and quarterly **reintegration** passes. [Introduced in 0.18.0.]

**Topic article** — A synthesized document in `wiki/topics/`
consolidating knowledge from multiple source artifacts on a specific
subject. Each article is self-contained with sections: Summary, Key
Decisions, Current State, Open Questions, Related Topics, and
Sources. Requires the **single-source synthesis threshold**.

**Knowledge pipeline** — The five-phase pipeline that transforms raw
project artifacts into structured wiki knowledge: (1) Extract, (2)
Index, (3) Synthesize, (4) Link, (5) Glossary. Phases 1-2 run
frequently; Phases 3-5 run less frequently; all run during quarterly
**reintegration**. Defined in `core/workflows/protocols/knowledge-pipeline.md`.

**Extract** — Phase 1 of the **knowledge pipeline**. Reads source
artifacts created or modified since the last pipeline run and pulls
out title, summary, key concepts, decisions, open questions, and
related domains.

**Index** — Phase 2 of the **knowledge pipeline**. Assigns a
**salience** score, topic candidates, and a dedup key to each
extracted artifact, then writes a **batch index**.

**Synthesize** — Phase 3 of the **knowledge pipeline**. Clusters
artifacts by topic across **batch indexes**, applies the
**single-source synthesis threshold**, and creates or updates
**topic articles** in `wiki/topics/`. Uses the **notice-and-proceed
model** for new topics.

**Link** — Phase 4 of the **knowledge pipeline**. Updates Related
Topics cross-references across all **topic articles** and verifies
all cross-references resolve.

**Glossary** — Phase 5 of the **knowledge pipeline**. Compares key
concepts from wiki content against the project's **Domain Language**
document. Flags terms that appear in the wiki but are not defined in
Domain Language. The wiki consumes Domain Language — it does not
define terms independently.

**Salience** — A score (S1, S2, or S3) indicating how important a
piece of extracted content is for synthesis. S1 (high) is
owner-approved foundational documents. S2 (medium) is standard
workflow output that has been through review. S3 (foundational) is
unvalidated raw material. Salience determines synthesis priority and
weight in **topic articles**.

**Batch index** — A JSON file at `wiki/meta/batch-YYYY-MM-DD.json`
produced by the Extract+Index phases. Contains extracted content
entries with salience scores, topic candidates, dedup keys, and
source hashes. Batch indexes are stable intermediates — they survive
source file renames, moves, or deletions.

**Single-source synthesis threshold** — The rule that a **topic
article** requires content from at least 2 independent source
artifacts. Prevents restating individual notes as topic articles.
Topics that have only one source are skipped during synthesis.

**Synthesis trigger** — The condition that causes Phases 3-5 of the
**knowledge pipeline** to run: 3+ **batch indexes** exist since the
last synthesis pass, or the owner requests it, or quarterly
**reintegration** is due.

**Synthesis threshold** — See **single-source synthesis threshold**.
The minimum number of independent sources required before a topic is
synthesized into an article.

**Backfill** — A one-time retrospective sweep (Phase 0) for projects
adopting the wiki with existing artifacts. Runs all five pipeline
phases across the full artifact history to produce an initial set of
**topic articles** and the **wiki index**. For projects with 30+
artifacts, recommended in a dedicated chat session.

**Reintegration** — The quarterly (or on-demand) deep pass through
the entire **knowledge pipeline**. Re-scores **salience**, rewrites
stale articles, merges or retires topics, rebuilds the **wiki index**
narrative from scratch, and cleans up stale **batch index** entries.
Tracked in `wiki/meta/last-reintegration.md`.

**Wiki index** — The progressive narrative overview at
`wiki/index.md`. Serves dual audiences: a human reading from zero
understanding and an agent looking for a structured project overview.
Sections: project overview, knowledge domains, key decisions, current
state, active questions, sources summary. Updated each synthesis
pass, fully rewritten during **reintegration**.

**Notice-and-proceed model** — The default behavior when the
**knowledge pipeline** creates a new **topic article**. The agent
creates the article and notifies the owner inline ("Creating topic
article: [name] from [N] sources"), then proceeds unless the owner
objects. Keeps the wiki hands-off. Full owner review occurs only
during **reintegration**.

**Domain Language** — A project's shared vocabulary of domain
concepts. Each term has a plain-language definition, code-level name,
relationships, and anti-terms. Created during **Design Alignment**,
updated during implementation and maintenance. Feeds into briefings,
implementer dispatch, and code review. Consumer projects use the
template at `core/templates/Domain-Language-Template.md`. This
document (the one you are reading) is Fabrika's own Domain Language.
[Template introduced in 0.15.0.]

**Terminology drift check** — A maintenance checklist step that scans
code, docs, and specs for inconsistencies with the **Domain Language**
document. Catches: code names diverging from definitions, implemented
concepts with "not yet implemented" in code-level name, terms that no
longer appear anywhere, new concepts not yet added. [Introduced in
0.15.0.]

---

## Versioning

**Version bump** — An increment to the `VERSION` file required
whenever canonical Fabrika files change. Minor bumps for `core/**`
and `MANIFEST_SPEC.md` changes. Patch bumps for `integrations/**`,
`BOOTSTRAP.md`, `UPDATE.md`, `ADOPT.md`, and `HARVEST.md` changes.
The most impactful change in a commit determines the bump type.

**CHANGELOG entry** — A versioned record in `CHANGELOG.md` listing
every file changed, the nature of the change, and **consumer update
instructions**. Required alongside every **version bump**. The
CHANGELOG is authoritative for what changed between versions — the
**update** protocol reads it instead of diffing the whole repo.

**Migration** — An entry in `MIGRATIONS.md` required when a change
demands that consumer projects do something beyond a straight file
overwrite (e.g., rename a file, restructure a directory, update a
config format). Migrations describe what consumers must do manually.

**Consumer update instructions** — The section of a **CHANGELOG
entry** that tells consumer projects exactly which files to update or
copy. Must be complete — every file a consumer needs to touch is
listed.

**Eval artifact** — A structured per-sprint report at
`.fabrika/evals/sprint-NN.md` in consumer projects. Contains agent
quality observations with a `Generalizable?` field (yes/no/maybe)
that serves as the primary **harvest** signal. Written during the
sprint retro phase.

---

## Project Types

**Sprint-based project** — A project that follows the **sprint
lifecycle**: plan -> build -> evaluate -> retro, organized into
time-boxed sprints with stories and epics. Eight types: web-app,
data-app, analytics-engineering, data-engineering, ml-engineering,
ai-engineering, automation, library. Can be multi-type (union of
rosters and documents).

**Analytics-workspace project** — A task-based project type for ad
hoc analysis, investigations, and data requests. Follows the **task
lifecycle** (brief -> plan -> execute -> validate -> deliver) with no
sprint structure. Work is organized as individual tasks in
`tasks/[date-name]/` directories.

**Agentic-workflow project** — A methodology-based project type where
the methodology itself is the product. Agent prompts, workflow
definitions, instruction files, and templates are the primary
artifacts. Two modes: **structural** (required, 7-step protocol) and
**operational** (optional, human-driven sessions). Fabrika itself is
an agentic-workflow project.

**Multi-type project** — A project combining two or more sprint-based
types (e.g., web-app + ai-engineering). Installs the union of all
applicable agent rosters and documents. Task-based and
methodology-based types cannot be combined with sprint-based types —
use a separate repo.

**Document tier** — The priority level governing when a project
document should be created. Tier 1: must exist before Sprint 1
(created during bootstrap). Tier 2: should exist before first
user/stakeholder sees the product. Tier 3: create as needed during
development. Tier 4: nice to have. Defined per document in the
**Document Catalog**.

**Document Catalog** — The reference document
(`core/Document-Catalog.md`) listing every document that might exist
in a project, with its purpose, applicable project types, document
tier, and audience marker.

**Doc-trigger** — A rule that causes a specific document to be
created or updated when certain conditions are met. Defined in
`core/workflows/protocols/doc-triggers.md`. Links document types to the
project events that should produce them.

**Audience marker** — A tag on each document in the **Document
Catalog** indicating its primary reader: **human** (for the owner's
strategic thinking), **agent** (for the AI to reference during
implementation), or **both**.

**Source registry** — The central index at `sources/README.md` in
**analytics-workspace** projects. Catalogs three categories: data
connections (warehouses, databases, APIs), BI/ETL tools (in advisory
mode), and recurring flat file sources.

**Advisory mode** — The operating mode for BI/ETL tools the agent
cannot directly access (Tableau, Power BI, Alteryx). The agent can
write SQL, draft DAX/M expressions, draft calculated fields, and
review described logic. The human executes inside the tool.

**Task promotion** — The workflow for recurring analyses in
**analytics-workspace** projects. Five levels from least to most
overhead: templatize, scriptify, visualize, automate, spin out. The
analysis planner initiates this when a task recurs.

**Task-workspace project** — A task-based project type for bounded
work that doesn't fit into software development, data analysis, or
methodology maintenance. Uses the **task workflow** — the base
multi-agent lifecycle (brief -> plan -> implement -> review -> validate
-> deliver) with domain-agnostic agents (planner, implementer,
reviewer, validator). The catch-all type: if a more specific type
fits, use it — domain-specific agents produce better results than
generic ones.

**Workflow type** — A reusable multi-agent pattern that projects can
compose. The evolved abstraction replacing the taxonomic "project
type" model. A project is not locked to a single workflow type — it
can add workflow types on demand via `ADD-WORKFLOW.md`. The task
workflow is the base; analytics, sprint-based, and agentic workflows
are domain-specific parameterizations. "Project type" remains as a
legacy/transition term in existing content.

**Base workflow** — The task workflow
(`core/workflows/types/task-workflow.md`): the domain-agnostic foundation
that all specialized workflows are parameterized versions of. Carries
no domain knowledge — its criteria come from the plan, not from a
domain model.

**Base agent** — An agent with no domain assumptions. The four base
agents (planner, implementer, reviewer, validator) are the
unparameterized versions that all domain-specific agents extend. The
analytics-workspace agents (analysis-planner, data-analyst,
logic-reviewer, data-validator) are the analytics-specific
parameterization; sprint-based agents (product-manager, code-reviewer,
software-engineer, etc.) are the software-specific parameterization.

**On-demand workflow addition** — The mechanism by which a project
adds a new workflow type after initial bootstrap, documented in
`ADD-WORKFLOW.md`. The orchestrator proposes this when it detects work
that doesn't fit installed workflow types. The workflow-level
equivalent of `ADOPT.md`'s tiered adoption.

---

## Maintenance

**Maintenance session** — A checklist-driven session run between
sprints (or weekly if no sprint boundary has occurred). Covers
documentation sync, code quality, test health, progress
reconciliation, dependency health, hook health, pattern curation,
terminology drift, architecture review (conditional), knowledge
synthesis (conditional), token usage review, context efficiency
review, and evaluation health. Defined in
`core/maintenance-checklist.md`.

**Maintenance tag** — Git tags (`maintenance-YYYY-MM-DD` and
`maintenance-latest`) applied at the end of each maintenance session.
The scrum-master checks `maintenance-latest` during sprint planning
to determine if maintenance is overdue.

**Hook discovery** — A maintenance sub-workflow triggered when the
same rule violation appears 3+ times across sessions. Proposes new
mechanical hooks (pre-commit, pre-push, or Claude Code hooks) to
prevent the recurring violation.

**Rubric** — A weighted grading criteria document that evaluators
(reviewers, validators) use to produce consistent verdicts. Defines
what PASS/FAIL means per criterion with skepticism calibration.
Loaded on demand at the start of each review.

**Verdict** — The outcome of an evaluation. Reviewers and validators
produce PASS / PASS WITH NOTES / FAIL. Architects produce SOUND /
CONCERNS / UNSOUND. The orchestrator reads verdicts to determine
whether to proceed, retry, or escalate to the owner.

**Spiral mitigation** — The practice of limiting improvement
proposals to prevent infinite optimization loops. For architecture
reviews: no more than 2 refactor stories per review. For agents:
done thresholds define when a module should not be re-evaluated until
significant new functionality lands.

---

## Structural Design Vocabulary

These terms are used by **architect** agents when evaluating
structural design. Drawn from Ousterhout's "A Philosophy of Software
Design."

**Module** — A unit of code that can be understood and changed
independently. The building block the architect evaluates. What
counts as a module depends on context: a class, a service, a pipeline
stage, a schema layer, an instruction file.

**Interface** — The visible surface of a **module** that other
modules interact with. Public methods, API endpoints, table schemas,
event contracts, file pointers. What consumers see and depend on.

**Depth** — The ratio of functionality to interface complexity. A
deep module does a lot behind a simple **interface**. A shallow
module has a complex interface relative to what it does. Deep is
good.

**Seam** — A boundary where two **modules** meet. The place where a
change in one module might force changes in another. Fewer and more
stable seams mean better architecture.

**Leverage** — How much useful work a **module** does per unit of
**interface** complexity. High leverage means the module is earning
its keep.

**Locality** — The principle that related logic should be close
together. Good locality means a typical change touches 1-2
**modules**. Poor locality means understanding a feature requires
reading files scattered across the codebase.

**Done threshold** — A statement in an **architect** finding or
proposal defining when a module is deep enough that it should not be
re-evaluated until significant new functionality lands. Prevents
**spiral mitigation** failures.

---

## Token Estimation

**Calibration** — Per-project data that records actual token usage
and improves estimation accuracy over time via **EWMA blend**ing
against bundled **tier-level priors**. Stored in
`.fabrika/calibration.yml`. Updated automatically during session
close-out or Step 7 (Ship). A project with no calibration data falls
back entirely to priors; as runs accumulate, local data increasingly
dominates.

**Tier-level prior** — A bundled baseline estimate per **model tier**
(low/mid/high) used when no local **calibration** data exists for a
given **calibration key**. Priors represent expected token ranges for
a single agent invocation at each tier. Defined in
`core/calibration/priors.yml`.

**EWMA blend** — Exponentially weighted moving average formula that
combines bundled **tier-level priors** with local **calibration**
data. The smoothing constant k controls how quickly local data
displaces priors: after k runs, the weight is 50/50; after 2k runs,
local data dominates at ~67%. Formula:
`blended = (k / (k + run_count)) * prior + (run_count / (k + run_count)) * local_mean`.

**Iteration multiplier** — A scaling factor (1x or 2x) applied to
agents that participate in review-revise cycles. Represents the range
from single-pass execution (low estimate, 1x) to a full revision
cycle (high estimate, 2x). The orchestrator sets this per-agent based
on whether the agent is expected to go through the **retry protocol**.

**Soft invalidation** — When a model identifier changes (e.g., the
project switches from `claude-opus-4-5` to `claude-opus-4-6`),
**calibration** data keyed to the old model becomes stale. The new
**calibration key** has no local data and falls back to **tier-level
priors** rather than migrating old data. Old keys are not deleted —
they become dormant.

**Calibration key** — The unique identifier for a calibration entry,
structured as `<workflow>.<agent>.<model>`. Example:
`agentic-workflow.methodology-reviewer.claude-opus-4-6`.
The key granularity ensures that changing models, agents, or
workflows each produce fresh calibration tracks rather than mixing
unrelated data.
