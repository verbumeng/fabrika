# CR-29: Unified Document Hierarchy

**Version target:** TBD
**Dependencies:** CR-17 (establishes the brief as base artifact),
CR-18 (universal complexity spectrum — complexity level determines
which alignment artifact), CR-22 (dissolves project type categories
that currently determine document types)
**Execution method:** Agentic-workflow structural update protocol

## Problem Statement

Fabrika currently has multiple document types that serve the same
fundamental purpose — capturing the orchestrator's alignment with the
owner about what work needs to be done — but are treated as separate,
category-specific artifacts:

- **Brief** (analytics-workspace): What question to answer, who
  asked, deadline, output format
- **Story** (sprint-based): User story with acceptance criteria,
  scoped to a sprint
- **PRD** (sprint-based/agentic-workflow): Product requirements for a
  phase or feature
- **Project Charter** (sprint-based/agentic-workflow): High-level
  problem space, capabilities, constraints, design principles
- **Roadmap** (informal, not templated): Meta-layer organizing
  PRDs/CRs into execution phases

These are all the same thing at different levels of complexity. They
all follow the same pattern: the orchestrator gathers context from the
user, structures it, passes it to a planner agent, and the planner
produces a formal plan. The only difference is how much ceremony and
detail the alignment requires.

With the Phase 2 shift to composable workflow types and the universal
complexity spectrum (CR-18), having separate document types per project
category creates confusion. Fabrika itself has experienced this:
Phase 1 used PRDs, Phase 2 uses CRs, analytics-workspace uses
briefs — but they're all orchestrator-to-planner handoff artifacts.

## Solution Direction

Unify around the **brief** as the base alignment artifact, with
graduated ceremony levels:

- **Brief** — the base. What needs to be done, for whom, by when,
  desired output. Used for tasks and patches.
- **Story brief** — a brief with acceptance criteria, story points,
  and sprint assignment. Used for stories.
- **Enhanced brief** (via Design Alignment) — a brief with deeper
  coverage of scope, terminology, and success criteria. Triggered by
  complexity signals.
- **PRD** — an enhanced brief with module changes, implementation
  decisions, testing approach. Used for features or phases complex
  enough to warrant them. May decompose into multiple story briefs.
- **Project Charter** — the highest-level alignment: problem space,
  target user, core capabilities, constraints, success criteria,
  design principles. Created once at project inception.
- **Roadmap** — a meta-layer organizing PRDs/CRs into execution
  phases. May have multiple iterations as the project evolves.

The key insight: these are layers, not alternatives. A complex project
might have a charter, then a roadmap, then PRDs, then story briefs. A
simple task just has a brief. The orchestrator assesses complexity and
determines how much alignment ceremony is needed — the same way the
universal complexity spectrum (CR-18) determines how much execution
ceremony is needed.

The Design Alignment workflow (core/workflows/design-alignment.md)
already handles the graduated alignment — it produces charters for new
projects, PRDs for features, and enhanced briefs for complex analyses.
This CR formalizes that the output forms a hierarchy, not a menu of
unrelated documents.

## Scope

This is primarily a conceptual unification with document and template
changes. Detailed scope to be determined during planning, but likely
includes:

### Modified files

- **Document-Catalog.md** — reorganize documents by complexity level,
  not project type
- **design-alignment.md** — formalize graduated output as an explicit
  hierarchy
- **Domain-Language.md** — define the relationship between brief,
  story, PRD, charter, roadmap
- **Integration templates** (CLAUDE.md, copilot-instructions.md) —
  teach the orchestrator the alignment spectrum
- **Templates** — possibly consolidate Brief/Story/PRD templates or
  add explicit hierarchy markers showing they are points on a spectrum

### New files

To be determined during planning. A unified brief template or a
hierarchy reference document may emerge.

### What does NOT change

- The Design Alignment protocol's mechanics (it already handles
  graduated output)
- Existing document content in consumer projects
- The agentic-workflow lifecycle steps

## Design Decisions to Align

1. **Should story files remain separate from briefs, or become a brief
   subtype?** Leaning toward: briefs and stories converge — a story IS
   a brief with sprint-specific metadata (points, sprint assignment,
   tier).

2. **Should PRDs remain a distinct template or become an "enhanced
   brief" with optional sections?** Leaning toward: PRD stays as a
   template but is understood as the highest-ceremony brief, not a
   different kind of document.

3. **Should roadmaps be formalized with a template?** They've been
   informal so far (Fabrika has ROADMAP-v1.md and ROADMAP-v2.md but no
   template). Leaning toward: yes, a light template that captures the
   execution order, dependency graph, and through-line — enough
   structure to be useful without constraining the narrative.

4. **Where does "bug" fit in the hierarchy?** A bug report is a brief
   with a specific structure: observed behavior, expected behavior,
   reproduction steps. Leaning toward: bug is a brief subtype with its
   own template section for reproduction, not a separate document
   category.

5. **What triggers each level?** The universal complexity spectrum
   (CR-18) determines execution ceremony. Should the same spectrum
   also determine alignment ceremony (which document type to produce)?
   Leaning toward: yes — the orchestrator's complexity assessment
   determines both what alignment artifact to produce AND what
   execution workflow to use.

## Alignment Notes (CR-19 Rewrite Session, 2026-05-03)

1. **Design Decision #4 is resolved by CR-19.** "Where does bug fit?"
   — bug is a task with a different brief template (reproduction
   context: observed vs. expected behavior, reproduction steps, fix
   verification). CR-19 formalizes this as part of the universal
   backlog type model.

2. **Design Decision #5 is partially resolved by CR-19.** "What
   triggers each level?" — the orchestrator's complexity assessment
   determines both the backlog type (task, bug, story, epic) and the
   ceremony level within that type. CR-29 can focus on which
   *alignment artifact* each type/ceremony level produces, not on the
   routing logic itself.

3. **CR-29 scope is sharper.** With CR-19 defining the backlog type
   system, CR-29 can focus purely on unifying alignment artifacts:
   brief as the base, graduated through story brief, enhanced brief,
   PRD, charter, roadmap. The "what kinds of work exist" question is
   answered; CR-29 answers "what documents does each kind produce."

## Alignment Notes (v2 — Design Alignment Walk, 2026-05-04)

1. **The decomposition hierarchy IS the alignment hierarchy.** There
   is no separate "alignment artifact hierarchy." The documents at
   each decomposition level (charter, roadmap, PRD, epic, story,
   task, bug) are already the alignment artifacts. No new Domain
   Language terms ("alignment artifact," "alignment hierarchy") needed.

2. **Brief merges into Task.** Brief-Template.md and
   Analysis-Brief-Template.md merge into Task-Template.md. The file
   path `tasks/[date-name]/brief.md` becomes
   `tasks/[date-name]/task.md`. The "brief" was the task document
   all along.

3. **"Enhanced brief" is killed.** Removed from Design Alignment.
   Complexity is handled by CR-18/19 spectrum. Design Alignment
   produces Charter+PRD or PRD only.

4. **"Brief check" retired.** Replaced with "plan check" / "plan
   validation." Planner validates against the plan, not the task
   document.

5. **Stories are NOT briefs with sprint metadata.** Stories and tasks
   are parallel concepts at the same decomposition level, serving
   different workflow contexts. The v1 plan's framing was wrong.

6. **Analysis Plan and Outcome templates stay separate.** Genuine
   domain specializations. Outcome-Report-Template.md renamed to
   Analysis-Outcome-Template.md (naming convention: specialized =
   descriptor + base name).

7. **No hierarchy positioning notes on templates.** The v1 plan's
   approach of adding blockquote notes to every template was
   rejected. The decomposition hierarchy is documented in
   Document-Catalog.md and Domain-Language.md, not scattered across
   template files.

8. **Roadmap is a single living document.** Active phases, completed
   phases (collapsed to one-line), future phases (deferred). An
   index/sequence document pointing to PRDs/epics.

## Verification Criteria

- Document-Catalog reflects the unified hierarchy (brief as base,
  graduated levels)
- Domain-Language defines the relationship between brief, story, PRD,
  charter, roadmap
- Design Alignment workflow documentation references the graduated
  output hierarchy
- Integration templates teach the orchestrator that alignment
  artifacts form a spectrum
- No document type is presented as category-specific (e.g., "briefs
  are for analytics-workspace")
- The CR does not break existing consumer projects — documents already
  created under old naming continue to work
