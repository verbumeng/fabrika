# CR-28 Architecture Assessment (v2)

**Evaluator:** context-architect
**Plan:** `docs/plans/CR-28-plan.md`
**Verdict:** SOUND

---

## 1. Instruction Decomposition Appropriateness

The types/ vs. protocols/ split is the right decomposition axis. It
maps directly to how agents consume these files:

- **Types** are read when the orchestrator needs to know "what
  lifecycle am I running?" Each type file is a complete, self-
  contained workflow definition with phases, agent roster, and
  dispatch points. An agent reads exactly one type file per session.

- **Protocols** are read on demand when a specific procedure is
  needed. They are referenced by pointer from type files and
  integration templates. Multiple protocols may be consulted in a
  single session, but none is loaded unconditionally.

This matches the existing progressive context disclosure pattern in
Fabrika: integration templates carry compact summaries with pointers,
and workflow files are loaded when needed. The new subdirectory
structure makes the same distinction visible in the filesystem.

The 4/11 split (4 types, 11 protocols) reflects the actual ratio of
lifecycle definitions to supporting processes. No protocol is
misclassified as a type or vice versa. The classification criteria
are clear: if it defines a complete lifecycle with phases and an
agent roster, it is a type; if it is invoked by or consulted from
a type, it is a protocol.

## 2. Pointer Pattern Cleanliness

All 93+ cross-references across 29 files have been updated to the
new paths. Verification was performed by grepping the entire repo
for every old flat-path pattern. Results:

**Clean (zero stale references):** All canonical files — agent
prompts, integration templates, root-level documents,
Document-Catalog, maintenance-checklist, Batch-Index-Schema,
Sprint-Contract-Pipeline, Domain-Language, BOOTSTRAP, ADOPT,
ADD-WORKFLOW, UPDATE, and all wiki topic articles.

**Correctly untouched (historical):** CHANGELOG.md, MIGRATIONS.md
(historical entries), planning/, docs/plans/, docs/evaluations/ —
all reference old paths as accurate records of past state.

**CLAUDE.md (project-level, gitignored):** Contains 3 stale
references to `core/workflows/agentic-workflow-lifecycle.md` (lines
45, 74) and `core/workflows/dispatch-protocol.md` (line 57). This
file is gitignored and was correctly excluded from the canonical
change scope. However, it actively guides orchestrator behavior
when working on Fabrika. The owner should update it separately. This
is not a CR-28 defect — the plan correctly identified CLAUDE.md as
out of scope — but is noted as a follow-up action.

Internal cross-references between workflow files (types referencing
protocols, protocols referencing each other) all use the new
subdirectory paths. Verified: knowledge-pipeline <-> knowledge-
synthesis, sprint-coordination -> design-alignment, doc-triggers ->
design-alignment and knowledge-synthesis, design-alignment ->
token-estimation.

## 3. Context Budget Balance

**README.md** is 30 lines — well within the "fit comfortably as
a subsection" threshold. It answers three questions (what goes in
types, what goes in protocols, what to do when adding new files) and
nothing else. No bloat.

The README is not always-loaded. It sits at the directory level and
would be read only when an agent navigates to `core/workflows/` and
needs orientation. This is appropriate — it is a wayfinding document,
not an instruction document.

The types/ vs. protocols/ split does not change the context budget
for any session. Integration templates still carry compact summaries
with pointers. The pointers now go to `types/` or `protocols/`
instead of the flat directory, adding one path component but no
additional token cost.

## 4. Pattern Consistency

**Naming:** Filenames are consistent within each subdirectory.
Types use the pattern `[domain]-workflow.md` or `[domain]-
workspace.md` (matching the project type vocabulary). Protocols use
descriptive names that match their function.

**H1 titles:** Generally consistent but with minor variations:

| File | H1 Title | Notes |
|------|----------|-------|
| `agentic-workflow.md` | Agentic Workflow | Clean match |
| `analytics-workspace.md` | Analytics Workspace Workflow | Adds "Workflow" |
| `development-workflow.md` | Development Workflow | Clean match |
| `task-workflow.md` | Task Workflow | Clean match |
| `sprint-coordination.md` | Sprint Coordination | Clean match |
| `dispatch-protocol.md` | Dispatch Protocol | Clean match |
| `doc-triggers.md` | Document Creation Triggers | Expands "doc" |
| `knowledge-synthesis.md` | Knowledge Synthesis Workflow | Adds "Workflow" |
| `task-promotion.md` | Task Promotion Workflow | Adds "Workflow" |
| `token-estimation.md` | Token Cost Estimation Protocol | Adds "Cost" and "Protocol" |
| `analytics-onboarding.md` | Analytics Workspace Onboarding | Adds "Workspace" |

These are pre-existing variations, not introduced by CR-28. CR-28's
scope was to move and rename files, not to standardize existing H1
titles. The variations are minor and do not cause confusion. Not a
finding.

**AGENT-CATALOG.md** correctly references the new paths at lines 44
and 98.

## 5. Integration Surface Completeness

Both integration templates (`integrations/claude-code/CLAUDE.md` and
`integrations/copilot/copilot-instructions.md`) have all workflow
path references updated. Verified 13 references in the Claude Code
template and 13 in the Copilot template — every one points to the
correct `types/` or `protocols/` subdirectory.

The integration templates do not mention the README.md or the
directory structure itself. This is correct — the README is an
internal orientation document for Fabrika maintainers, not something
consumer integration templates need to reference.

Consumer update instructions in the CHANGELOG 0.27.0 entry and
MIGRATIONS.md 0.27.0 entry both include the complete path mapping
table (all 15 moved files). The migration instructions tell consumers
to create `types/` and `protocols/` subdirectories, move their local
copies, apply renames, and update cross-references. This is complete.

## Follow-Up Items (Not Defects)

1. **Project-level CLAUDE.md** has 3 stale references. Not a CR-28
   defect (file is gitignored and out of canonical scope), but the
   owner should update it to avoid confusing future orchestrator
   sessions.

2. **dispatch-protocol.md line 5** says "in the development
   workflow" but the dispatch protocol applies to all workflows. This
   is pre-existing prose, not introduced by CR-28. Noted for future
   cleanup.

---

**Verdict: SOUND.** The types/protocols decomposition is clean and
well-motivated. All canonical cross-references are updated. The
README is appropriately lean. Pattern consistency is maintained.
Integration surface is complete.
