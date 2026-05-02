# PRD-14 Architecture Assessment (v2)

**Agent:** context-architect
**Plan:** `docs/plans/PRD-14-plan.md`
**Scope:** Re-assessment after owner-requested extraction of onboarding
questions from BOOTSTRAP.md into `core/workflows/analytics-onboarding.md`.
**Verdict:** SOUND

---

## Context: What Changed Between v1 and v2

The v1 assessment evaluated onboarding content inline in BOOTSTRAP.md
(~75 lines added to Phase 2W.1a). The verdict was SOUND, with the
note that extraction was "not warranted today" but could become
warranted if Phase 2W grew further.

The owner then requested extraction. The onboarding questions now
live in `core/workflows/analytics-onboarding.md` as a self-contained
protocol. BOOTSTRAP.md Phase 2W.1a became a short pointer (~8 lines)
that says "run the analytics onboarding protocol at [path]." ADOPT.md
gains its own pointer to the same file for retroactive onboarding.

This assessment evaluates whether the extraction was done well and
whether the resulting architecture is sound.

---

## 1. Instruction Decomposition

**Finding: Well-executed extraction. The standalone file is properly
self-contained.**

The extracted file (`core/workflows/analytics-onboarding.md`) is 98
lines. It contains:

- A clear purpose statement and context (lines 1-7)
- Prerequisites (what must exist before running)
- Four question groups, each with: the question to ask, what to do
  with the answer, what files to create, and skip/fallback behavior
- No back-references to BOOTSTRAP.md's internal section numbering

The file reads as a standalone protocol. An agent encountering it
from ADOPT.md (with no BOOTSTRAP.md context) can execute it without
confusion. This was the primary motivation for extraction, and it
succeeds.

BOOTSTRAP.md Phase 2W.1a is now a clean pointer:

```
### 2W.1a Platform onboarding (optional)

Run the analytics onboarding protocol at
`[FABRIKA_PATH]/core/workflows/analytics-onboarding.md`. This asks
the user about platforms, cost models, source connections, and data
governance tooling. All questions are skippable. Answers produce
pre-populated platform connection stubs in the source registry.
```

This is the right decomposition pattern: the pointer tells the
orchestrator WHAT it does and WHERE to find it, but does not
duplicate the procedural content. The pointer is ~8 lines; the
extracted file is ~98 lines. That is a meaningful context reduction
for BOOTSTRAP.md sessions where the user skips onboarding (the
"(optional)" marker means skipping is expected for some users).

**Comparison with plan:** The original plan decided to keep
onboarding inline ("BOOTSTRAP.md is read once in a session whose
purpose is bootstrapping -- no context budget concern"). The owner
overruled this, and the override is architecturally justified by a
consideration the plan did not weigh: ADOPT.md and UPDATE.md need
to reference the same onboarding protocol without pulling in all
of BOOTSTRAP.md. Extraction eliminates a cross-file duplication
risk (the alternative was to duplicate or paraphrase the
questionnaire in ADOPT.md).

**One concern resolved:** My v1 assessment noted that "extracting the
questionnaire into its own file would create a sync obligation (the
questionnaire references templates, templates reference the
questionnaire's output paths)." Looking at the implementation, this
sync obligation is real but minimal. The extracted file references
two templates (`Platform-Connection-Template.md` and
`Source-Connection-Template.md`) and the output path convention
(`sources/connections/[platform]/README.md`). These are the same
references BOOTSTRAP.md's Phase 2W.2 and the analytics-workspace
workflow already use. The sync surface is shared, not new -- if these
paths change, three files need updating regardless of whether
onboarding is inline or extracted.

## 2. Pointer Patterns

**Finding: Clean. The extraction improves pointer structure by giving
both BOOTSTRAP.md and ADOPT.md a shared target.**

Updated cross-reference chain:

- BOOTSTRAP.md Phase 2W.1a -> `[FABRIKA_PATH]/core/workflows/analytics-onboarding.md` (protocol)
- ADOPT.md "Analytics Workspace Onboarding" section -> `[FABRIKA_PATH]/core/workflows/analytics-onboarding.md` (same protocol)
- analytics-onboarding.md -> `Platform-Connection-Template.md` (template source)
- analytics-onboarding.md -> `Source-Connection-Template.md` (template source)
- analytics-onboarding.md -> `sources/connections/[platform]/README.md` (output path)
- analytics-onboarding.md -> `STATUS.md` (records file formats)
- analytics-onboarding.md -> BOOTSTRAP.md Phase 2W.2 (cross-reference for BI/ETL tools)
- BOOTSTRAP.md Phase 2W.2 -> `sources/connections/` (reads what onboarding scaffolded)
- analytics-workspace.md Plan phase -> `sources/connections/[platform]/README.md` (reads cost model)
- analytics-workspace.md default cost note -> BOOTSTRAP.md Phase 2W.1a (references onboarding)
- Document-Catalog -> `core/templates/Platform-Connection-Template.md` (template listing)
- Document-Catalog -> `sources/connections/[platform]/README.md` (document entry)
- Integration templates -> `core/workflows/analytics-workspace.md` (existing pointer)

All references remain directional and non-circular. The key
improvement over v1: BOOTSTRAP.md and ADOPT.md now converge on the
same file rather than maintaining parallel descriptions of the same
protocol.

**One directional note:** analytics-onboarding.md line 37-38
references "the source inventory conversation (BOOTSTRAP.md Phase
2W.2)." This is the only back-reference from the extracted file to
BOOTSTRAP.md. It is appropriate because it clarifies a handoff
boundary (BI/ETL tools are documented in 2W.2, not onboarding).
However, when the file is invoked from ADOPT.md for retroactive
onboarding, there is no Phase 2W.2 -- the user's source registry
already exists or will be populated ad hoc. This reference is not
harmful (it is descriptive context, not a procedural dependency), but
it does assume a bootstrap context that ADOPT.md callers may not
have. A minor imperfection, not a defect.

**UPDATE.md gap:** UPDATE.md does not reference analytics-onboarding.md
or mention onboarding. This is correct behavior -- UPDATE.md is
about file-level updates via the manifest, not about re-running
protocols. The CHANGELOG's consumer update instructions (item 7)
handle the "retroactive onboarding" path, and ADOPT.md has its
own section. No UPDATE.md change is needed.

## 3. Context Budget

**Finding: The extraction reduces BOOTSTRAP.md context load by ~70
lines for sessions where onboarding is skipped. Improves overall
budget allocation.**

Context loading comparison (v1 inline vs. v2 extracted):

| File | v1 (inline) | v2 (extracted) | Delta |
|------|-------------|----------------|-------|
| BOOTSTRAP.md (always loaded during bootstrap) | +75 lines | +8 lines pointer | -67 lines |
| analytics-onboarding.md (loaded only if running onboarding) | N/A | +98 lines | +98 lines (conditional) |
| ADOPT.md (loaded during adoption) | +6 lines (description only) | +12 lines (pointer + description) | +6 lines |
| analytics-workspace.md | same | same | 0 |
| Integration templates | same | same | 0 |

Net effect: sessions that skip onboarding save ~67 lines of context.
Sessions that run onboarding load ~31 more lines total (98 in the
standalone file vs. 75 that would have been inline, minus the 8-line
pointer). This is the right trade-off: the file that is loaded more
often (BOOTSTRAP.md for all workspace bootstraps) gets lighter, and
the file that is loaded less often (onboarding protocol, only when
the user opts in) absorbs the content.

The ADOPT.md path gains the most: instead of needing to inline or
paraphrase the onboarding questionnaire, it points to the same
standalone file. The ADOPT.md section is 12 lines -- clean and
self-sufficient.

**Always-loaded surface (CLAUDE.md / copilot-instructions.md):**
Unchanged from v1. Still one sentence. Still correct.

## 4. Pattern Consistency

**Finding: The extracted file follows core/workflows/ patterns
appropriately.**

Comparison with other workflow files in `core/workflows/`:

| Aspect | analytics-onboarding.md | task-promotion.md | knowledge-synthesis.md | analytics-workspace.md |
|--------|------------------------|-------------------|----------------------|----------------------|
| Title format | `# Analytics Workspace Onboarding` | `# Task Promotion Workflow` | `# Knowledge Synthesis Workflow` | `# Analytics Workspace Workflow` |
| Opening sentence | Purpose + scope | Purpose + scope | Purpose + scope | Purpose + scope |
| Prerequisites | Yes (explicit section) | No (implicit) | Yes (explicit section) | No (implicit via pre-workflow) |
| Horizontal rules | Between sections | Between sections | Between sections | Between sections |
| Instruction style | Imperative ("Ask:", "Create:", "Record in") | Imperative | Imperative | Imperative |
| Length | 98 lines | ~110 lines | ~90 lines (first 30 read) | ~536 lines |

The file fits the established workflow file pattern: title, purpose
statement, optional prerequisites, procedural sections with
horizontal rules, imperative instruction style. No stylistic
divergence.

The prerequisites section is a good addition -- it makes explicit
what must exist before the protocol runs (the `sources/connections/`
directory and the two templates). This makes the file usable from
ADOPT.md where the directory structure may or may not already exist.

**The naming follows convention:** `analytics-onboarding.md` sits
alongside `analytics-workspace.md` in `core/workflows/`. The prefix
makes the relationship clear. The name describes what the file IS (an
onboarding protocol), not where it is called from (bootstrap or
adopt).

**YAML frontmatter:** The file does not have YAML frontmatter. This
is consistent with all other files in `core/workflows/` (none of them
have frontmatter). The Document-Catalog entries and templates have
frontmatter; workflow files do not. Correct pattern.

## 5. Integration Surface Completeness

**Finding: All entry points are properly covered. The three-path
architecture (bootstrap, adopt, upgrade) is coherent.**

### Bootstrap path (new workspaces)
BOOTSTRAP.md Phase 2W.1a -> analytics-onboarding.md -> creates
platform stubs. Phase 2W.2 checks what onboarding already scaffolded
before asking. The readiness checklist (line 803-804) includes
platform connection stub verification. Complete.

### Adopt path (existing workspaces adopting Fabrika)
ADOPT.md's "Analytics Workspace Onboarding" section -> same
analytics-onboarding.md. The section explicitly notes that existing
source registry files are not affected -- onboarding adds
platform-level READMEs alongside them. Complete.

### Upgrade path (existing Fabrika consumers upgrading to 0.23.0+)
CHANGELOG consumer update instructions item 7: "run
`core/workflows/analytics-onboarding.md` retroactively to add
platform configuration, or create
`sources/connections/[platform]/README.md` manually." This gives
existing consumers two paths: automated (run the protocol) or manual
(use the template directly). Complete.

### Runtime path (analytics-workspace workflow during tasks)
analytics-workspace.md Plan phase references
`sources/connections/[platform]/README.md` as the source of platform
config and cost model. The workflow does not reference
analytics-onboarding.md directly -- it references the OUTPUT of
onboarding (the platform README files). This is correct: the
workflow cares about the data, not how it got there. Whether the
platform README was created during onboarding, retroactively via
ADOPT, or manually by the user, the workflow reads the same file.
Complete.

### Document-Catalog coverage
The Document-Catalog has the Platform Connection entry (line 577-582)
with the correct template reference and the note "populated during
onboarding." The Quick Reference (line 825) lists Platform Connection
under the Onboarding line. The Templates section (line 763) lists
`Platform-Connection-Template.md` for `analytics-workspace`. Complete.

### AGENT-CATALOG coverage
The AGENT-CATALOG does not reference analytics-onboarding.md. This is
correct -- the onboarding protocol is orchestrator-driven, not
agent-driven. No agent is dispatched to run onboarding; the
orchestrator runs it directly. No catalog update needed.

---

## Comparison with v1 Assessment

The v1 assessment found the inline approach SOUND. This v2
assessment finds the extracted approach also SOUND, with the
following net improvements:

1. **ADOPT.md independence.** The strongest architectural
   justification for extraction. ADOPT.md can now reference the
   onboarding protocol without depending on BOOTSTRAP.md context
   or duplicating content.
2. **Context budget.** BOOTSTRAP.md sessions where onboarding is
   skipped save ~67 lines. This matters because "skip" is a valid
   and expected path.
3. **Single source of truth.** One file describes the onboarding
   protocol; two files point to it. If the questionnaire changes,
   one file changes. The sync obligation exists only for shared path
   conventions (`sources/connections/[platform]/README.md`), which is
   the same sync obligation that existed in v1.

And one trade-off:

1. **Sync surface.** The extracted file references "BOOTSTRAP.md
   Phase 2W.2" in a descriptive context line. This creates a weak
   coupling that would not exist if the content were inline. It is
   descriptive, not procedural, so it will not break anything if
   the BOOTSTRAP.md section is renumbered -- but it will become
   misleading. If Phase 2W.2 is ever renumbered, this reference
   should be updated. Low-priority concern.

---

## Summary

The extraction is architecturally sound. It improves on the v1
inline approach in all five evaluation dimensions:

1. **Instruction decomposition:** Clean extraction with a properly
   self-contained standalone file and a minimal pointer in
   BOOTSTRAP.md
2. **Pointer patterns:** Both BOOTSTRAP.md and ADOPT.md converge on
   a single shared target; all references directional and
   non-circular
3. **Context budget:** Reduces BOOTSTRAP.md by ~67 lines for
   skip-onboarding sessions; adds conditional load only when
   onboarding runs
4. **Pattern consistency:** Follows core/workflows/ conventions
   (naming, structure, style, no frontmatter)
5. **Integration surface:** All four paths (bootstrap, adopt,
   upgrade, runtime) properly covered

No structural concerns. No action items.
