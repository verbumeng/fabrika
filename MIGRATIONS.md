# Migrations

When a Fabrika update requires consumer projects to do more than a straight file overwrite, the migration steps are documented here.

---

## 0.32.0 — Category dissolution, workflow decomposition, file renames

### File renames

**analytics-workspace.md renamed to analytics-workflow.md:**
- Old path: `core/workflows/types/analytics-workspace.md`
- New path: `core/workflows/types/analytics-workflow.md`
- Action: Rename the file in your project. Update
  `.fabrika/manifest.yml` to reflect the new path. Update any
  project-level references to the old path.

**analytics-onboarding.md renamed to analytics-workflow-onboarding.md:**
- Old path: `core/workflows/protocols/analytics-onboarding.md`
- New path: `core/workflows/protocols/analytics-workflow-onboarding.md`
- Action: Rename the file in your project. Update
  `.fabrika/manifest.yml` to reflect the new path.

### development-workflow.md deleted

The file `core/workflows/types/development-workflow.md` has been
deleted. Its content has been split:
- **Shared story execution mechanics** (story-start orientation,
  dispatch protocol reference, tier-conditional branching,
  freshness-aware context loading, testing approach branching,
  evaluation cycle, multi-domain story completion) are now in
  `core/workflows/protocols/story-execution.md` (new file — copy it)
- **Domain-specific content** (agent rosters, domain-specific gates,
  testing approach details) lives in 7 new domain workflow files in
  `core/workflows/types/` (copy the one(s) for your project type)

Action: Remove `development-workflow.md` from your project. Copy
`story-execution.md` and your domain workflow file(s). Update any
project-level references that pointed to `development-workflow.md`.

### New files

- `core/workflows/protocols/story-execution.md` — shared story
  execution protocol
- 7 domain workflow files in `core/workflows/types/`:
  `software-development-workflow.md`, `data-engineering-workflow.md`,
  `analytics-engineering-workflow.md`, `data-app-workflow.md`,
  `ml-engineering-workflow.md`, `ai-engineering-workflow.md`,
  `library-workflow.md`
- `core/workflows/protocols/dispatch/` directory with 7 per-archetype
  contract files

### Dispatch protocol decomposition

The monolithic `dispatch-protocol.md` (1,097 lines) has been
decomposed into a hub file (~250 lines) and 7 per-archetype contract
files in `core/workflows/protocols/dispatch/`. Copy the entire
`dispatch/` directory and update your local copy of
`dispatch-protocol.md` from Fabrika source.

### Category dissolution

The three project type categories (Sprint-Based Types, Task-Based
Types, Methodology-Based Types) have been dissolved. All types are
now workflow types. If your project's CLAUDE.md or
copilot-instructions.md uses category headers in the Subagents
section, update from the Fabrika integration template.

---

## 0.27.0 — Workflow folder reorganization

**Affects:** All consumer projects with copied workflow files or
cross-references to `core/workflows/` paths.

**What changed:** The flat `core/workflows/` directory is now
organized into `types/` (workflow type definitions) and `protocols/`
(supporting processes). Two files were also renamed:
`agentic-workflow-lifecycle.md` -> `agentic-workflow.md`,
`sprint-lifecycle.md` -> `sprint-coordination.md`.

**Complete path mapping:**

| Old path | New path |
|----------|----------|
| `core/workflows/agentic-workflow-lifecycle.md` | `core/workflows/types/agentic-workflow.md` |
| `core/workflows/development-workflow.md` | `core/workflows/types/development-workflow.md` |
| `core/workflows/task-workflow.md` | `core/workflows/types/task-workflow.md` |
| `core/workflows/analytics-workspace.md` | `core/workflows/types/analytics-workspace.md` |
| `core/workflows/dispatch-protocol.md` | `core/workflows/protocols/dispatch-protocol.md` |
| `core/workflows/design-alignment.md` | `core/workflows/protocols/design-alignment.md` |
| `core/workflows/sprint-lifecycle.md` | `core/workflows/protocols/sprint-coordination.md` |
| `core/workflows/doc-triggers.md` | `core/workflows/protocols/doc-triggers.md` |
| `core/workflows/hooks-reference.md` | `core/workflows/protocols/hooks-reference.md` |
| `core/workflows/knowledge-pipeline.md` | `core/workflows/protocols/knowledge-pipeline.md` |
| `core/workflows/knowledge-synthesis.md` | `core/workflows/protocols/knowledge-synthesis.md` |
| `core/workflows/progress-files.md` | `core/workflows/protocols/progress-files.md` |
| `core/workflows/task-promotion.md` | `core/workflows/protocols/task-promotion.md` |
| `core/workflows/token-estimation.md` | `core/workflows/protocols/token-estimation.md` |
| `core/workflows/analytics-onboarding.md` | `core/workflows/protocols/analytics-onboarding.md` |

**Migration steps:**

1. **Reorganize your local workflow files.** Create `types/` and
   `protocols/` subdirectories under your local workflows directory
   (`.fabrika/workflows/` or wherever you store Fabrika workflow
   copies). Move each file according to the path mapping above.

2. **Apply renames.** Rename `agentic-workflow-lifecycle.md` to
   `agentic-workflow.md` and `sprint-lifecycle.md` to
   `sprint-coordination.md`.

3. **Update cross-references in your local copies.** Search all
   copied Fabrika files for `core/workflows/` references and update
   to the new paths (`core/workflows/types/` or
   `core/workflows/protocols/` as appropriate). This includes
   workflow files that reference each other, agent prompts, and any
   project-specific instruction files.

4. **Update your project instruction file.** Regenerate your
   CLAUDE.md or copilot-instructions.md from the new integration
   template — all workflow path references have changed.

5. **Copy updated Fabrika source files.** The following files have
   updated cross-references and should be re-copied from Fabrika:
   - `core/agents/AGENT-CATALOG.md`
   - `core/agents/analysis-planner.md`
   - `core/agents/data-architect.md`
   - `core/agents/software-architect.md`
   - `core/agents/archetypes/architect.md`
   - `core/Document-Catalog.md`
   - `core/maintenance-checklist.md`
   - `core/templates/Batch-Index-Schema.md`
   - `core/topologies/Sprint-Contract-Pipeline.md`
   - All workflow files (now under `types/` and `protocols/`)

6. **Copy the new README.** Copy `core/workflows/README.md` to your
   workflows directory — it documents the types vs. protocols
   distinction.

---

## 0.26.0 — Base workflow type, base agents, and workflow composition

**Affects:** All consumer projects.

**What changed:** Fabrika introduces the task workflow type — the
domain-agnostic base workflow — and four base agents (planner,
implementer, reviewer, validator). This is the first step in Fabrika's
shift from taxonomic project types to composable workflow types.
Projects are no longer locked to their declared project type — they
can add workflow types on demand.

**Key concept:** "Workflow type" is now the primary term for what was
previously called "project type." A project can compose multiple
workflow types as needed. The task workflow is the base; analytics,
sprint-based, and agentic workflows are specialized versions.

**Migration steps:**

1. **Copy new agent files** to your agent directory
   (`.claude/agents/` or `.github/agents/`):
   - `planner.md`, `implementer.md`, `reviewer.md`, `validator.md`

2. **Copy new templates** to your templates location:
   - `Brief-Template.md`, `Plan-Template.md`, `Outcome-Template.md`

3. **Copy ADD-WORKFLOW.md** to your project root — this documents how
   to add workflow types on demand.

3b. **Copy `core/workflows/task-workflow.md`** to
    `.fabrika/workflows/task-workflow.md` as a reference copy of the
    workflow definition.

4. **Update canonical files from Fabrika source:**
   - `core/agents/AGENT-CATALOG.md`
   - `core/Document-Catalog.md`
   - `core/workflows/dispatch-protocol.md`
   - `core/workflows/doc-triggers.md`
   - `Domain-Language.md`
   - `BOOTSTRAP.md`
   - `ADOPT.md`
   - `MANIFEST_SPEC.md`

5. **Update your project instruction file** from the integration
   template (`integrations/claude-code/CLAUDE.md` or
   `integrations/copilot/copilot-instructions.md`). The key addition:
   projects can compose workflow types on demand — the orchestrator
   should know this.

6. **No structural changes required.** Existing workflows,
   agents, and project structures are unaffected. The new workflow
   type is additive.

---

## 0.25.0 — Rename context engineer to agentic engineer

**Affects:** Consumer projects with `agentic-workflow` project type.

**What changed:** The agentic-workflow implementer agent was renamed
from "context engineer" / `context-engineer.md` to "agentic engineer"
/ `agentic-engineer.md`. All cross-references across core files,
integration templates, and bootstrap instructions were updated.

**Migration steps:**

1. **Rename the agent file.** Rename (or delete and re-copy)
   `context-engineer.md` to `agentic-engineer.md` in your agent
   directory (`.claude/agents/` or `.github/agents/`). For Copilot,
   rename `context-engineer.agent.md` to `agentic-engineer.agent.md`.

2. **Update canonical files from Fabrika source.** Copy the updated
   versions of these files:
   - `core/agents/AGENT-CATALOG.md`
   - `core/agents/workflow-planner.md`
   - `core/agents/methodology-reviewer.md`
   - `core/agents/context-architect.md`
   - `core/workflows/dispatch-protocol.md`
   - `core/workflows/agentic-workflow-lifecycle.md`
   - `core/design-principles.md`
   - `core/workflows/token-estimation.md`
   - `Domain-Language.md`
   - `BOOTSTRAP.md`
   - `wiki/topics/agent-model.md`

3. **Update your project instruction file.** Copy the updated
   integration template (`integrations/claude-code/CLAUDE.md` or
   `integrations/copilot/copilot-instructions.md`) and re-apply your
   project-specific customizations.

4. **Search for remaining references in your project.**
   ```
   rg "context.engineer" -i --type md
   ```
   Update any matches in your own project files — custom workflows,
   documentation, dispatch overrides, etc. Ignore matches that refer
   to "context architect" (different agent, not renamed).

---

## 0.24.0 — Token Cost Estimation

**Affects:** All consumer projects.

**What changed:** Token cost estimation surfaces during plan alignment
across all workflow types. Agent prompt files gain YAML frontmatter
declaring model preferences. A deterministic Python script estimates
token costs from plan + agent metadata + per-project calibration. Per-
project calibration data accumulates in `.fabrika/calibration.yml` and
improves estimates over time via EWMA blending.

**Migration steps:**

1. **Copy new files.** Copy the following from Fabrika source:
   - `core/workflows/token-estimation.md`
   - `core/scripts/estimate-tokens.py`
   - `core/scripts/README.md`
   - `core/calibration/priors.yml`
   - `core/calibration/pricing.yml`
   - `core/templates/Calibration-Template.yml`
   - `core/agents/agent-frontmatter-spec.md`

2. **Scaffold calibration file.** Copy
   `core/templates/Calibration-Template.yml` to
   `.fabrika/calibration.yml`. One-liner:
   `cp [FABRIKA_PATH]/core/templates/Calibration-Template.yml .fabrika/calibration.yml`

3. **Update agent prompts (non-breaking).** Either copy the updated
   agent files from Fabrika source (which now include frontmatter), or
   manually prepend frontmatter to your existing copies per the schema
   in `core/agents/agent-frontmatter-spec.md`. Agents that omit
   frontmatter default to `model_tier: mid` — estimation still works
   but at reduced accuracy. Agents that benefit most from `model:`
   declarations: reviewers and planners (they dominate cost).

4. **Update workflow files.** Copy updated versions of:
   - `core/workflows/development-workflow.md`
   - `core/workflows/analytics-workspace.md`
   - `core/workflows/agentic-workflow-lifecycle.md`
   - `core/workflows/design-alignment.md`

5. **Update remaining core files.** Copy updated versions of:
   - `core/agents/AGENT-CATALOG.md`
   - `core/agents/archetypes/*.md` (all 7)
   - `core/Document-Catalog.md`
   - `core/FABRIKA.md`

6. **Update root-level files.** Copy updated versions of:
   - `Domain-Language.md`
   - `MANIFEST_SPEC.md`
   - `BOOTSTRAP.md`

7. **Update integration template.** Copy the updated CLAUDE.md or
   copilot-instructions.md from the integrations/ directory.

8. **(Optional) Set budget warning.** Add `token_budget_warn: 50000`
   (or your preferred threshold) to project config if you want soft
   warnings when estimates exceed a token budget.

**Behavioral changes after migration:**
- Plan presentations (spec briefings, analysis plan briefings,
  structural plan briefings) now include a token cost readout.
- Session close-out now records actual token usage to
  `.fabrika/calibration.yml` when token data is available.
- Budget warnings (if configured) trigger during plan alignment when
  estimates exceed the threshold. Advisory only — never blocks.
- Agent prompts are behaviorally identical — frontmatter is metadata
  for the estimator, not instructions for the agent.

---

## 0.22.0 — Review-Revise Loop Redesign

**Affects:** All consumer projects (sprint-based, analytics-workspace, and agentic-workflow).

**What changed:** All three project types now use the same review-revise loop pattern. The implementer reads review reports directly during revision (the orchestrator routes file paths, it does not synthesize or interpret findings). All evaluators re-review after every revision, not just the ones that failed. The cycle cap is 3 failed cycles with orchestrator diagnosis after cap. This replaces the previous split where sprint-based and agentic-workflow used orchestrator-as-translator (max 2 cycles) while analytics-workspace used direct-read (max 3 cycles). Implementer-reviewer pairing and implementer-validator pairing are codified as explicit framework design principles in a new file.

**Migration steps:**

1. **Copy new file.** Copy `core/design-principles.md` to your Fabrika path.

2. **Update changed core files.** Update the following from the Fabrika source: `core/workflows/dispatch-protocol.md`, `core/workflows/development-workflow.md`, `core/workflows/agentic-workflow-lifecycle.md`, `core/workflows/analytics-workspace.md`, `core/agents/archetypes/implementer.md`, `core/agents/context-engineer.md`, `core/topologies/Sprint-Contract-Pipeline.md`, `core/topologies/Sprint-Contract-Mesh.md`, `core/topologies/Sprint-Contract-Hierarchical.md`.

3. **Update changed integration file.** Update your integration template (CLAUDE.md or copilot-instructions.md).

4. **Update Domain Language (optional).** Update `Domain-Language.md` with revised "Evaluation cycle" and "Retry protocol" definitions and three new terms.

5. **Behavioral changes.** After migration:
   - When evaluators FAIL an implementation, the orchestrator dispatches the implementer for revision with a `Review report paths` field containing the paths to all evaluation reports. The implementer reads these directly alongside the original plan.
   - After revision, ALL evaluators re-check — not just the ones that failed. A fix can introduce new issues in areas that previously passed.
   - The cycle cap is 3 (previously 2 for sprint-based and agentic-workflow). After 3 failed cycles, the orchestrator diagnoses the failure pattern and presents it to the user. The user decides the path forward.
   - Existing sprint contracts in active sprints are unaffected. New sprint contracts will pick up the updated topology templates.

**Why this matters:** The orchestrator-as-translator pattern added a translation layer between evaluator findings and the implementer. This round trip lost nuance — the implementer is the domain expert who wrote the output and is better positioned to interpret review findings in context. The analytics-workspace workflow proved this in v0.20.0: direct reading produced better revision quality with less orchestrator overhead. Converging all project types on one pattern eliminates the cognitive overhead of maintaining two different retry protocols and ensures consistent behavior across the framework.

---

## 0.21.0 — Plan Persistence Alignment

**Affects:** Consumer projects using the `agentic-workflow` project type.

**What changed:** The agentic-workflow lifecycle now persists plans as files instead of keeping them in conversation. The workflow-planner writes plans to `docs/plans/[identifier]-plan.md` using a new template. Owner pushback re-invokes the planner to revise the file (the orchestrator never edits plans directly). Verification agents receive the plan file path in their strict dispatch. Plan files include an Alignment History section that captures what changed and why during alignment.

**Migration steps:**

1. **Copy new template.** Copy `core/templates/System-Update-Plan-Template.md` to your Fabrika path.

2. **Create plan directory.** Create `docs/plans/` in your project if it does not already exist. Sprint-based projects already have this directory for spec files. Agentic-workflow projects that did not previously have `docs/` will need to create both `docs/` and `docs/plans/`.

3. **Update changed core files.** Update the following from the Fabrika source: `core/agents/workflow-planner.md`, `core/workflows/agentic-workflow-lifecycle.md`, `core/workflows/dispatch-protocol.md`, `core/agents/context-engineer.md`, `core/agents/methodology-reviewer.md`, `core/agents/structural-validator.md`, `core/agents/context-architect.md`, `core/Document-Catalog.md`, `core/briefings/structural-plan-briefing.md`.

4. **Update changed integration file.** Update your integration template (CLAUDE.md or copilot-instructions.md).

5. **Behavioral changes.** After migration:
   - The workflow-planner writes plans to `docs/plans/[identifier]-plan.md` instead of the conversation. The plan file is a persistent artifact with YAML frontmatter tracking status (draft/approved/executed).
   - When the owner pushes back on a plan, the orchestrator re-invokes the planner with feedback. The planner revises the plan file and appends to the Alignment History section. The orchestrator updates the status from draft to approved after owner approval.
   - The context-engineer, methodology-reviewer, structural-validator, and context-architect all receive the plan file path in their dispatch contracts instead of a conversation reference.
   - During Step 7 (Ship), the orchestrator updates the plan status to executed before committing.
   - Plan files persist after execution as validation artifacts and historical records.

**Why this matters:** The plan is the implementation contract — the thing the implementer builds against and the validators assess against. Keeping it in conversation meant it degraded as context compressed, validators could not independently read the complete plan, and alignment feedback (the most valuable design rationale) evaporated. Persisting it as a file makes the contract durable, the verification independent, and the rationale permanent.

---

## 0.18.0 — Wiki Knowledge Layer

**Affects:** All consumer projects. Sprint-based and analytics-workspace projects have additional workflow file changes.

**What changed:** A wiki knowledge layer is now available for consumer projects. It automatically consolidates scattered project artifacts (ADRs, retros, evaluation reports, research docs) into organized topic articles during maintenance sessions. The system uses a 5-phase pipeline (Extract, Index, Synthesize, Link, Glossary) with batch JSON indexes as stable intermediates, a comprehensive salience model (S1/S2/S3) mapping all Document Catalog artifact types, and cadence mappings for sprint-based and analytics-workspace projects. Topic articles are created via a notice-and-proceed model (the agent creates and notifies the owner, proceeding unless the owner objects). The wiki serves dual audiences: humans get a progressive narrative overview; agents get structured topic references. Bootstrap and adoption flows now offer the wiki (default recommended). A backfill mechanism populates the wiki from existing artifacts during adoption or update.

**Migration steps:**

1. **Copy new files.** Copy `core/workflows/knowledge-pipeline.md`, `core/workflows/knowledge-synthesis.md`, `core/templates/Wiki-Topic-Template.md`, and `core/templates/Batch-Index-Schema.md` to your Fabrika path.

2. **Update changed core files.** Update the following from the Fabrika source: `core/maintenance-checklist.md`, `core/Document-Catalog.md`, `core/workflows/doc-triggers.md`.

3. **Update changed workflow files (sprint-based projects).** Update `core/workflows/sprint-lifecycle.md`.

4. **Update changed workflow files (analytics-workspace projects).** Update `core/workflows/analytics-workspace.md`.

5. **Update changed integration file.** Update your integration template (CLAUDE.md or copilot-instructions.md).

6. **Update bootstrap/adopt files (if applicable).** Update `BOOTSTRAP.md` and `ADOPT.md`.

7. **Set up the wiki (recommended).** Create `wiki/` directory at the project root with three items:
   - `wiki/index.md` — stub file with project name and a note that the wiki will be populated during maintenance
   - `wiki/topics/` — empty directory (add `.gitkeep`)
   - `wiki/meta/` — empty directory (add `.gitkeep`)

8. **Run backfill (for projects with existing artifacts).** If your project has existing ADRs, evaluation reports, retros, session logs, or other project artifacts, run the backfill procedure from `core/workflows/knowledge-synthesis.md` (Phase 0: Backfill). This is a one-time operation that populates the wiki from existing content. Under ~30 artifacts: run in the current chat. 30+ artifacts: run in a dedicated chat to keep context clean.

9. **Behavioral changes.** After migration:
   - Maintenance sessions include a Knowledge Synthesis step (after Architecture Review) that runs when `wiki/` exists. It extracts and indexes new artifacts every maintenance, and triggers topic synthesis when 3+ batch indexes accumulate without a synthesis pass.
   - Topic articles are created automatically with inline notification (notice-and-proceed). The owner can object, but the default is proceed.
   - Quarterly reintegration runs when 3+ months have elapsed since the last pass, re-scoring salience and rebuilding the wiki narrative.
   - The Glossary pipeline phase checks for concepts not yet in Domain Language and flags them for addition — the wiki does not define its own vocabulary.
   - Agents are instructed to check `wiki/index.md` and `wiki/topics/` before searching raw artifacts, and to draw on wiki knowledge during brainstorming and alignment conversations.
   - For analytics-workspace projects: Extract+Index runs automatically after each task delivery as part of the Deliver step.

**Why this matters:** Projects generate knowledge continuously but store it as disconnected artifacts. The wiki consolidates this into a queryable, topic-organized knowledge base that helps both humans understand the project holistically and agents surface relevant history during planning and alignment. The progressive narrative in wiki/index.md lets someone go from zero understanding to full context without reading dozens of individual files.

---

## 0.17.0 — Briefing System Improvements

**Affects:** All consumer projects (briefing files are used by all project types). Analytics-workspace and agentic-workflow projects have additional workflow file changes.

**What changed:** The briefing system is expanded and refined across all three project type categories. Sprint-based briefings gain concrete translation examples (topology choices, evaluation findings), token cost visibility in session summaries (previously restricted), and a restructured retro token efficiency section with sprint totals prominent and per-agent drill-down detail. Spec briefings gain explicit guidance on framing design alternatives in user-impact terms. Analytics-workspace gains two new briefing formats (task plan, task outcome). Agentic-workflow gains two new briefing formats (structural plan, change summary). A canonical token cost format is established in briefing-principles.md using approximate model-tier ranges with per-agent-role breakdowns.

**Migration steps:**

1. **Copy new files.** Copy `core/briefings/task-plan-briefing.md`, `core/briefings/task-outcome-briefing.md`, `core/briefings/structural-plan-briefing.md`, and `core/briefings/change-summary-briefing.md` to your Fabrika path.

2. **Update changed briefing files.** Update the following from the Fabrika source: `core/briefings/sprint-plan-briefing.md`, `core/briefings/session-summary-briefing.md`, `core/briefings/retro-briefing.md`, `core/briefings/spec-briefing.md`, `core/briefings/briefing-principles.md`.

3. **Update changed workflow files (analytics-workspace projects).** Update `core/workflows/analytics-workspace.md`.

4. **Update changed workflow files (agentic-workflow projects).** Update `core/workflows/agentic-workflow-lifecycle.md`.

5. **Update changed integration file.** Update your integration template (CLAUDE.md or copilot-instructions.md).

6. **Behavioral changes.** After migration:
   - Session summaries include a token efficiency section with per-agent-role cost breakdown. The old "no token counts in owner summary" restriction is removed — the owner sees costs.
   - Sprint retro token efficiency is restructured: sprint total prominent at top, per-story costs in the main table, per-agent breakdown as drill-down detail underneath.
   - Token costs use approximate model-tier ranges (high-end / mid-tier / economy) instead of naming specific models. The canonical format is defined in briefing-principles.md.
   - Spec briefings frame design alternatives in user-impact terms. Technical terminology used in briefings is defined in the jargon glossary and flagged for Domain Language.
   - Sprint plan briefings have topology translation examples for reference.
   - Analytics-workspace: task plans are presented using the Task Plan Briefing format; task outcomes are presented using the Task Outcome Briefing format.
   - Agentic-workflow: Step 2 (Align) uses the Structural Plan Briefing format; Step 6 (Present) uses the Change Summary Briefing format.

**Why this matters:** The briefing system now covers all three project type categories consistently. Token cost visibility gives the owner financial context for every piece of work. Translation examples provide concrete models for plain-language communication, reducing the gap between what the agent writes internally and what the owner reads. The canonical token cost format using model tiers instead of model names means the briefing system doesn't need updating every time pricing or model names change.

---

## 0.16.0 — TDD Integration

**Affects:** All sprint-based consumer projects. Analytics-workspace and agentic-workflow projects are not affected (TDD is a sprint-based workflow concept).

**What changed:** The development workflow now supports three testing approaches per story: TDD (spec-first tests before code, implementation in vertical slices), test-informed (implementer codes with awareness of test boundaries, then test-writer verifies), and test-after (existing behavior — implement, then test during evaluation cycle). The scrum master assigns the approach during sprint planning based on story complexity and risk. Sprint contracts carry the testing approach per story. The test-writer has two modes: spec-first (TDD — writes behavioral tests from the spec without seeing code) and coverage (test-informed/test-after — existing behavior). The test rubric gains a spec-first quality criterion for TDD stories. All five implementer dispatch contracts gain a conditional "Tests to pass" field for TDD stories.

**Migration steps:**

1. **Copy new file.** Copy `core/evals/baseline/validator/eval-004-spec-first-no-code.md` to your Fabrika path.

2. **Update changed core files.** Update the following from the Fabrika source: `core/agents/archetypes/validator.md`, `core/agents/test-writer.md`, `core/agents/product-manager.md`, `core/agents/scrum-master.md`, `core/workflows/development-workflow.md`, `core/workflows/dispatch-protocol.md`, `core/rubrics/test-rubric.md`, `core/topologies/Sprint-Contract-Pipeline.md`, `core/topologies/Sprint-Contract-Mesh.md`, `core/topologies/Sprint-Contract-Hierarchical.md`.

3. **Update changed integration file.** Update your integration template (CLAUDE.md or copilot-instructions.md).

4. **No retroactive sprint contract updates needed.** Existing sprint contracts don't have the testing approach field — that's fine. The scrum master will add it during future sprint planning. Stories without a testing approach default to test-after (the previous behavior), so nothing breaks.

5. **Behavioral changes.** After migration:
   - The scrum master assigns TDD, test-informed, or test-after per story during sprint planning
   - The development workflow branches on this field at story start
   - TDD stories go through RED-GREEN-REFACTOR cycles: test-writer writes spec-first tests → implementer writes minimal code to pass → repeat → refactor
   - Test-informed stories: implementer codes with test boundary awareness → test-writer verifies
   - Test-after stories: no change from previous behavior
   - The test-writer activates spec-first mode automatically when dispatched without source paths
   - The test rubric's new Spec-First Quality criterion is N/A for non-TDD stories — no impact on existing grading

**Why this matters:** The previous workflow was "implement everything, then test." This produced tests shaped by the implementation (testing what the code does, not what it should do) and let agents outrun their headlights on complex stories. The graduated approach matches testing discipline to story risk: tight feedback loops for high-complexity work, light-touch verification for simple changes.

---

## 0.15.0 — Domain Language

**Affects:** All consumer projects. All project types now have Domain Language as Tier 1 (sprint-based types) or Onboarding/Core (analytics-workspace, agentic-workflow).

**What changed:** The old Glossary (Tier 4, alphabetical, static, optional) is replaced by Domain Language (Tier 1, organized by domain area, living, mandatory). Each term entry now carries four fields: plain-language definition, mandatory code-level name (populated at implementation), relationships to other terms, and anti-terms (what the term is NOT). Domain Language is created during Design Alignment, consumed by planners and implementers via dispatch contracts, checked during code review (new Terminology Consistency criterion), and audited during maintenance (new Terminology Drift Check). Briefings draw jargon glossary definitions from Domain Language rather than inventing them ad hoc.

**Migration steps:**

1. **Copy new template.** Copy `core/templates/Domain-Language-Template.md` to your Fabrika path.

2. **Update changed core files.** Update the following from the Fabrika source: `core/Document-Catalog.md`, `core/workflows/design-alignment.md`, `core/workflows/dispatch-protocol.md`, `core/rubrics/code-review-rubric.md`, `core/maintenance-checklist.md`, `core/workflows/doc-triggers.md`, `core/briefings/briefing-principles.md`.

3. **Update changed integration and root-level files.** Update your integration template (CLAUDE.md or copilot-instructions.md) and `BOOTSTRAP.md`.

4. **Migrate existing Glossary (if one exists).** If your project has a `docs/00-Index/Glossary.md`:
   - Rename it to `docs/00-Index/Domain-Language.md`
   - Restructure from alphabetical organization to domain-area organization using the template as a guide
   - For each existing term: keep the definition, add the code-level name field (populate it if the concept is already implemented in code, mark "not yet implemented" if not), add relationships to other terms, add anti-terms where disambiguation is needed
   - Add the YAML frontmatter from the template
   - Review for completeness — terms that were defined in the Glossary may need richer definitions now that they carry more fields

5. **Create Domain Language from scratch (if no Glossary exists).** Create `docs/00-Index/Domain-Language.md` from the template. Two paths:
   - During the next Design Alignment session, the terminology capture step will populate it naturally
   - Or run a dedicated terminology extraction session: scan your Project Charter, PRDs, Architecture Overview, and codebase for domain concepts, and consolidate them into the Domain Language document

6. **Populate code-level names for existing implementations.** For terms that are already implemented in code, fill in the code-level name field with the actual class names, table names, and variable names used in the codebase. This is a one-time catch-up — going forward, implementers populate this field as they build.

7. **Behavioral changes.** After migration:
   - Briefings draw jargon glossary definitions from Domain Language when it exists
   - Code review checks terminology consistency (new criterion #12 — scored N/A if no Domain Language exists, so this is not a breaking change)
   - Maintenance checks terminology drift (new section — skipped if no Domain Language exists)
   - Implementers populate code-level names during implementation and flag new concepts for addition
   - Planners reference Domain Language terms in specs when the document exists

**Why this matters:** Domain Language creates a single source of truth for what domain concepts mean, how they are named in code, and how they relate to each other. This eliminates the translation layer between how the owner thinks about the domain and how the codebase represents it. The mandatory code-level name field ensures the vocabulary doesn't drift as the implementation evolves — it's populated at implementation and enforced from that point forward.

---

## 0.14.0 — Design Alignment + Project Charter + PRD

**Affects:** All sprint-based consumer projects and agentic-workflow projects. Analytics-workspace projects are affected only if they use Design Alignment for complex analyses.

**What changed:** The orchestrator now runs a Design Alignment protocol before sprint planning to produce durable requirements documents. Brain dumps no longer go directly to story creation — they flow through Design Alignment to produce a Project Charter (once per project) and PRDs (per phase/feature). The scrum master receives the approved PRD as primary input for story decomposition. Sprint retros check for PRD drift. The maintenance checklist gains Story-to-PRD Traceability. Analytics-workspace projects can optionally trigger Design Alignment for complex analyses, producing an enhanced Analysis Brief instead of Charter/PRD.

**Migration steps:**

1. **Copy new files.** Copy `core/workflows/design-alignment.md`, `core/templates/Project-Charter-Template.md`, and `core/templates/PRD-Template.md` to your Fabrika path.

2. **Update changed core files.** Update the following from the Fabrika source: `core/Document-Catalog.md`, `core/workflows/doc-triggers.md`, `core/workflows/sprint-lifecycle.md`, `core/workflows/development-workflow.md`, `core/workflows/dispatch-protocol.md`, `core/agents/scrum-master.md`, `core/maintenance-checklist.md`.

3. **Update changed integration and root-level files.** Update your integration template (CLAUDE.md or copilot-instructions.md) and `BOOTSTRAP.md`.

4. **Update analytics-workspace workflow** (analytics-workspace projects only). Update `core/workflows/analytics-workspace.md`.

5. **Create PRDs directory.** Create `docs/01-Product/PRDs/` in your project.

6. **Produce retroactive Charter and PRDs for existing projects.** This is the key adoption step. Run a Design Alignment session against your existing codebase and documentation:

   - **Retroactive Project Charter:** The orchestrator reads existing docs (Vision & Positioning, Phase Definitions, Architecture Overview, story history) and synthesizes them into a Project Charter at `docs/01-Product/Project-Charter.md`. This does not require the full Design Alignment question protocol — the information already exists in your docs, it just needs to be consolidated into Charter form.

   - **Retroactive PRDs for past phases:** For each completed phase, produce a lightweight PRD that documents what was built. These are retrospective — they record decisions already made, not planning documents. Place them in `docs/01-Product/PRDs/` with a naming convention like `PRD-001-[phase-name].md`.

   - **Active PRD for the current phase:** For the current active phase, produce a full PRD that functions as a planning document. This is the one the scrum master will reference for future sprint planning. If you're mid-sprint, this PRD should reflect the current state — what's been built, what remains, what the acceptance criteria are.

   The retroactive synthesis is a single-session exercise. The orchestrator does the reading and consolidation; the owner reviews and approves the result.

7. **Behavioral change.** After migration, the orchestrator no longer creates stories directly from brain dumps or ad hoc requests. New work flows through Design Alignment (when triggered) to produce or update a PRD, which the scrum master then decomposes into stories. Existing stories that are already in progress are unaffected — this applies to new work going forward.

**Why this matters:** Design Alignment catches requirements misalignment before it becomes implementation waste. The Charter provides a stable reference point that prevents scope creep across phases. PRDs create a traceable chain from requirements to stories to implementation, making retros and maintenance reviews more effective. The fresh-chat boundary between alignment and planning prevents context window bloat from carrying the full requirements conversation into sprint planning.

---

## 0.13.0 — Architect Archetype

**Affects:** All sprint-based consumer projects. Task-based projects (analytics-workspace) are not affected — no architect is assigned to that type.

**What changed:** Two architect agents (software-architect, data-architect) evaluate structural design across all sprint-based project types. The architect archetype stub from 0.10.0 is replaced with a full definition scoped to the shared behavioral contract (standardized vocabulary, dispatch tiers, output format, base rules). Domain-specific expertise lives in each specialist agent file. Architecture review is added to the maintenance checklist with conditional triggers and spiral mitigation (not every cycle, max 2 refactor stories). The code-review rubric gains a Module Depth criterion for lightweight structural assessment.

**Migration steps:**

1. **Copy the architect agent for your project type.** software-architect for web-app/automation/library/ai-engineering, data-architect for data-engineering/analytics-engineering/data-app/ml-engineering. Place in your agent directory (`.claude/agents/` or `.github/agents/`). Multi-type projects spanning both categories: copy both.

2. **Update architect archetype.** Replace `core/agents/archetypes/architect.md` — the stub is now a full definition. Note: the archetype no longer contains agentic-workflow-specific evaluation criteria (instruction decomposition, pointer patterns) — those live in context-architect.md's own file. If you have an agentic-workflow project, verify context-architect.md is self-contained (it should be if you updated to 0.12.0).

3. **Update AGENT-CATALOG.md.** New Architect column in Sprint-Based and Task-Based mapping tables. 2 new rows in Agent Files table.

4. **Update development-workflow.md.** Three new architect invocation points: optional design review after spec approval, optional structural evaluation during the evaluation cycle, and an ad hoc architecture assessment section.

5. **Update dispatch-protocol.md.** 6 new dispatch contracts for software-architect and data-architect (design mode, review mode, ad hoc — each with appropriate tier and field tables).

6. **Update code-review-rubric.md.** New criterion #11 Module Depth / Interface Simplicity (MEDIUM weight).

7. **Update maintenance-checklist.md.** New Architecture Review (Conditional) section with conditional triggers, assessment tracking, and spiral mitigation.

8. **Update your integration template** (CLAUDE.md or copilot-instructions.md). Architect in subagent tables, architect invocation points in workflow summary, architecture review in maintenance summary.

9. **Create architecture tracking log.** Create `docs/maintenance/architecture-tracking.md` (empty initially — populated during first architecture review maintenance session).

**Why this matters:** Structural design evaluation catches architectural drift — the slow accumulation of shallow modules and unstable interfaces — before it compounds into a codebase that's hard to change. The conditional trigger and spiral mitigation prevent the architect from generating infinite refactor work.

---

## 0.12.0 — Implementer Archetype + Pure Orchestrator

**Affects:** All consumer projects (sprint-based, task-based, and agentic-workflow).

**What changed:** The orchestrator is now a pure dispatcher — it never writes production code directly, even for trivial tasks. Five specialist implementer agents handle all implementation work, each carrying domain expertise for their project types. The development workflow's "Starting a Story" section dispatches to implementers instead of implementing directly. The evaluation feedback loop routes evaluator findings through the orchestrator (as translator) to the implementer rather than having the orchestrator fix issues directly. Lightweight dispatch provides a reduced-ceremony path for trivial changes while maintaining the implementer-always-implements principle. Multi-domain story support adds task decomposition with per-domain sessions and integration verification. All agentic-workflow agents (previously stubs) are fleshed out to full implementations. The product-manager and scrum-master gain domain scope assessment guidance.

**Migration steps:**

1. **Copy implementer agent(s) for your project type.** See the CHANGELOG consumer update instructions table for which agent(s) to copy. Place them in your agent directory (`.claude/agents/` or `.github/agents/`).

2. **Update development-workflow.md.** This is a behavioral change — the "Starting a Story" section and "Completing a Story" section are significantly rewritten. The orchestrator no longer implements directly. Review the new workflow and update your copy.

3. **Update dispatch-protocol.md.** The generic Implementer contract is replaced by 5 per-specialist contracts with domain-specific conditional fields. A new Lightweight Dispatch section defines the reduced-ceremony path. The Retry Protocol is rewritten with the orchestrator-as-translator pattern.

4. **Update AGENT-CATALOG.md.** New Implementer column added to Sprint-Based and Task-Based mapping tables. 5 new rows in Agent Files table.

5. **Update your integration template** (CLAUDE.md or copilot-instructions.md). Add Implementer to subagent tables and add the pure-orchestrator constraint to Key Constraints.

6. **For agentic-workflow projects:** Update all 5 agent stubs (workflow-planner, methodology-reviewer, structural-validator, context-engineer, context-architect) to the full implementations.

7. **For all sprint-based/task-based projects:** Update product-manager.md (domain scope assessment in planning mode) and scrum-master.md (domain scope assessment in sprint planning).

**Why this matters:** The pure orchestrator model prevents context window degradation during implementation — the orchestrator stays focused on routing and synthesis while implementers handle domain-specific work. This also enables future domain specialization without changing the orchestration layer.

---

## 0.11.0 — Agentic-Workflow Agent Roster Completion (No Migration Needed)

**Affects:** Consumer projects using the `agentic-workflow` project type.

**What changed:** Three new specialized agent stubs were added for the agentic-workflow type: workflow-planner (planner), context-engineer (implementer), context-architect (architect). These replace the generic product-manager and archetype placeholders in the agentic-workflow agent roster. The "Architect — Agentic-Workflow" dispatch contract was renamed to "Context Architect." Verification checklist references in methodology-reviewer and structural-validator dispatch contracts were updated to point to the project's instruction file generically.

**Migration steps:** None beyond the file updates listed in the CHANGELOG. The new agents are additive — they fill previously empty slots in the agentic-workflow roster. No existing configurations break. Copy the three new agent files and update the changed files per the CHANGELOG consumer update instructions.

---

## 0.10.0 — New Project Type (No Migration Needed)

**Affects:** No existing consumer projects.

**What changed:** A new project type `agentic-workflow` was added for systems where the methodology itself is the product. Two new agent archetypes (implementer, architect) and two agentic-workflow-specific agents (methodology-reviewer, structural-validator) were introduced.

**Migration steps:** None. This is a purely additive change. Existing projects of any type continue to work without modification. The new type is only relevant when bootstrapping new agentic-workflow projects.

---

## 0.6.0 — Type Taxonomy Rename

**Affects:** All consumer projects using `data-platform` or `ml-project` as their project type.

**What changed:** `data-platform` was renamed to `analytics-engineering`. `ml-project` was renamed to `ml-engineering`.

**Migration steps:**
1. Update `.fabrika/manifest.yml` — change the `project_type` field value
2. Search your project CLAUDE.md (or copilot-instructions.md) for the old type name and replace it
3. No document file renames are needed — the documents themselves (Data Pipeline Design, Transformation Logic, Model Design, etc.) keep the same names and paths

**Why:** The rename better describes the discipline each type covers. "Data platform" was vague and could mean many things. "Analytics engineering" precisely describes building modeled data layers with dbt/DuckDB. "ML engineering" aligns with the other engineering-discipline types.
