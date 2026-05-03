# CR-28 Architecture Assessment

**Evaluator:** context-architect
**Plan:** `docs/plans/CR-28-plan.md`
**Verdict:** CONCERNS

---

## 1. Instruction Decomposition Appropriateness

**Assessment: SOUND**

The types/ vs. protocols/ split is a clean decomposition that makes
an existing conceptual distinction visible in the file system. The
classification rule is clear and consistently applied:

- **types/** contains files that define complete multi-agent
  lifecycles an orchestrator can run end-to-end. All four files
  placed here (agentic-workflow, development-workflow, task-workflow,
  analytics-workspace) meet this criterion — each specifies lifecycle
  phases, agent rosters, dispatch contracts, and verification
  criteria.

- **protocols/** contains files that are referenced by workflow types
  but never run independently. All eleven files placed here meet this
  criterion — dispatch-protocol, design-alignment, sprint-
  coordination, doc-triggers, hooks-reference, knowledge-pipeline,
  knowledge-synthesis, progress-files, task-promotion, token-
  estimation, and analytics-onboarding are all invoked or consulted
  from workflow type definitions.

No file is misclassified. The boundary is a clean "runnable
lifecycle" vs. "reusable process" distinction that will scale as
new workflow types (CR-18, CR-19) and new protocols are added.

The README.md at `core/workflows/README.md` documents this
distinction in 30 lines. It provides orientation (what goes where,
when to add a new type vs. a new protocol) without overreach. The
README is a legitimate always-loaded context addition for anyone
navigating the workflows directory for the first time.

---

## 2. Pointer Pattern Cleanliness

**Assessment: SOUND**

Cross-references use consistent path formats throughout all modified
files. I verified every canonical file in the dispatch payload —
93+ references were updated.

**Path format conventions preserved:**

- Workflow files referencing each other use `core/workflows/types/`
  and `core/workflows/protocols/` consistently (never relative
  paths within the types/ or protocols/ directories)
- Agent prompts use the same `core/workflows/protocols/` absolute
  path format for dispatch-protocol references
- Integration templates use `[FABRIKA_PATH]/core/workflows/types/`
  and `[FABRIKA_PATH]/core/workflows/protocols/` with the
  placeholder prefix, matching the pre-existing convention
- Root-level documents (BOOTSTRAP.md, ADOPT.md, Domain-Language.md)
  use the same path patterns
- Wiki articles use the full path without placeholder prefix,
  matching the existing convention for wiki source references

**No old flat paths remain in canonical files.** I verified every
old path pattern (`core/workflows/design-alignment.md`,
`core/workflows/dispatch-protocol.md`, `core/workflows/sprint-
lifecycle.md`, `core/workflows/agentic-workflow-lifecycle.md`,
`core/workflows/development-workflow.md`,
`core/workflows/task-workflow.md`,
`core/workflows/analytics-workspace.md`,
`core/workflows/knowledge-pipeline.md`,
`core/workflows/knowledge-synthesis.md`,
`core/workflows/doc-triggers.md`,
`core/workflows/hooks-reference.md`,
`core/workflows/progress-files.md`,
`core/workflows/task-promotion.md`,
`core/workflows/token-estimation.md`,
`core/workflows/analytics-onboarding.md`).
All remaining hits are confined to historical files
(CHANGELOG.md, MIGRATIONS.md, planning/, docs/plans/,
docs/evaluations/) which correctly were not updated.

---

## 3. Context Budget Balance

**Assessment: SOUND**

The README.md is 30 lines — well within the context decomposition
principle threshold. It serves a clear purpose: when an agent or
contributor lands in `core/workflows/` and sees two subdirectories,
the README explains the classification criterion and tells them
where to put new files. It references ADD-WORKFLOW.md for the full
process without duplicating content.

The reorganization itself improves context budget in a subtle way:
the directory listing now communicates intent. `types/agentic-
workflow.md` tells you the file's category without reading it.
Previously, all 15 files sat at the same level and the reader had
to open each to determine whether it was a workflow type or a
supporting protocol.

No bloat was introduced. The README does not repeat the directory
listing (which is self-evident from `ls`) or describe each file
(which would become stale). It states the classification rule and
stops.

---

## 4. Pattern Consistency

**Assessment: CONCERNS**

Two findings:

### 4a. Internal titles not updated after renames (CONCERN)

The file `core/workflows/protocols/sprint-coordination.md` was
renamed from `sprint-lifecycle.md`, but its H1 title still reads
`# Sprint Lifecycle`. The file `core/workflows/types/agentic-
workflow.md` was renamed from `agentic-workflow-lifecycle.md`, but
its H1 title still reads `# Agentic-Workflow Lifecycle`.

The plan explicitly states this is a structural cleanup with no
behavioral changes, and updating titles could be considered a
content change. However, a file whose H1 title does not match its
filename creates a navigation mismatch: an agent following a
pointer to `sprint-coordination.md` opens the file and reads
"Sprint Lifecycle" at the top, creating momentary confusion about
whether it opened the right file.

This is a minor concern, not a blocker. The content is correct and
the pointers resolve. But the mismatch is a loose end that should
be tracked — either update the titles in this CR (since the
renames were in scope) or defer explicitly.

**Note on the Domain-Language term:** The Domain-Language entry
uses "Sprint lifecycle" as the concept name and correctly points to
`core/workflows/protocols/sprint-coordination.md`. This is
acceptable — the concept name describes what the lifecycle IS, while
the filename describes what the file DOES (coordinate sprint
phases). There is no need to rename the Domain-Language term.

### 4b. development-workflow.md non-rename is appropriately deferred

The plan documents why `development-workflow.md` keeps its name:
CR-22 will split it into domain-specific workflows, so renaming now
would be premature. The Alignment History section records the
owner's rationale. This is not an inconsistency — it is a
deliberate design decision to avoid papering over a known tension.
No concern here.

---

## 5. Integration Surface Completeness

**Assessment: SOUND**

### Integration templates

Both integration templates (`integrations/claude-code/CLAUDE.md` and
`integrations/copilot/copilot-instructions.md`) have all workflow
path references updated. I verified every reference — 13 in the
Claude Code template, 13 in the Copilot template. The references
span all workflow types and protocols that consumers interact with.

### Consumer update instructions

The CHANGELOG 0.27.0 entry lists every moved/renamed file with old
and new paths, every modified file, and provides a 6-step consumer
update instruction set. The MIGRATIONS.md 0.27.0 entry includes the
complete path mapping table and step-by-step migration instructions.

The consumer instructions are comprehensive:
1. Reorganize local workflow files (directory creation + moves)
2. Apply renames (two files)
3. Update cross-references in local copies
4. Update project instruction file from new integration template
5. Copy updated Fabrika source files (specific files listed)
6. Copy the new README.md

### Root-level documents

BOOTSTRAP.md, ADOPT.md, ADD-WORKFLOW.md, UPDATE.md, and
Domain-Language.md all have their references updated. I verified
each.

### Wiki

All three wiki articles (workflow-design.md, agent-model.md,
owner-preferences.md) have their Core files listings and inline
references updated to the new paths. The workflow-design.md article
— which has the most extensive workflow references — has all 9+
references updated correctly in both the Core files section and the
narrative prose.

---

## Summary of Findings

| # | Area | Finding | Severity |
|---|------|---------|----------|
| 1 | Decomposition | types/ vs. protocols/ split is clean and consistently applied | SOUND |
| 2 | Pointer patterns | All 93+ cross-references updated; no stale flat paths in canonical files | SOUND |
| 3 | Context budget | README.md is appropriately sized and does not duplicate existing content | SOUND |
| 4a | Pattern consistency | H1 titles in sprint-coordination.md and agentic-workflow.md do not match renamed filenames | Minor concern |
| 4b | Pattern consistency | development-workflow.md non-rename is a deliberate design decision, not an inconsistency | SOUND |
| 5 | Integration surface | Both integration templates, consumer instructions, root docs, and wiki are fully updated | SOUND |

---

## Verdict: CONCERNS

The structural reorganization is well-executed. The types/ vs.
protocols/ decomposition is clean, all cross-references are properly
updated with no stale paths in canonical files, the README adds
appropriate orientation without bloat, and the integration surface is
complete.

The single concern is that two renamed files retain their old H1
titles (sprint-coordination.md still titled "Sprint Lifecycle",
agentic-workflow.md still titled "Agentic-Workflow Lifecycle"). This
is a navigation clarity issue, not a correctness issue — all
pointers resolve and the content is accurate. The concern is minor
enough that it could be addressed in this CR or deferred
deliberately, at the owner's discretion.
