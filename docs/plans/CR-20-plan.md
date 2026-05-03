---
title: CR-20 Context Compaction Principle
status: executed
version_target: 0.28.0
bump_type: minor
cr: planning/CR-20-context-compaction-principle.md
---

# System Update Plan: CR-20 — Context Compaction as Design Principle

Codifies context compaction as a named design principle governing how
all workflows hand off between phases. Each phase transition produces
a compressed artifact that is self-contained for the next phase — the
receiving agent should not need to re-read the sending agent's inputs,
only its outputs.

Compaction is about what agents PRODUCE during workflow runs, not
about making Fabrika's own instruction files shorter. The principle
ensures agents return compressed signal rather than raw dumps, keeping
the next agent in the productive zone of its context window.

## Scope Boundary

CR-20 codifies the compaction principle and adds output format
constraints to the dispatch protocol. It does NOT:

- Add cross-cutting pointer sections to workflow files (owner
  determined these are unnecessary — existing references between
  workflow files and design-principles.md are sufficient)
- Modify agent prompt files (agents do not need to know about
  compaction by name — the dispatch protocol and output format specs
  enforce it)
- Change sprint lifecycle or sprint coordination
- Change topologies
- Modify templates (they already embody compaction implicitly)
- Impose hard token limits (guideline-based, not rule-based)
- Add runtime verification of compaction (principle for prompt
  authors, not a structural-validator check in v1)
- Rename analytics-workspace.md to analytics-workflow.md (deferred
  to CR-22 where the three project type categories dissolve)

## Version Bump Determination

**0.28.0 (minor bump).** Per CLAUDE.md versioning rules, `core/**`
changes trigger a minor bump. This CR extends `core/design-principles.md`
with a new principle and adds output format constraints to the dispatch
protocol — both are core contract changes that consumers need to know
about.

## File Change Inventory

### New files

None. This CR extends existing files only.

### Modified files

| # | File | Change summary |
|---|------|---------------|
| 1 | `core/design-principles.md` | Add Compaction principle section |
| 2 | `core/workflows/protocols/dispatch-protocol.md` | Add Output Format Constraints section |
| 3 | `Domain-Language.md` | Define compaction |
| 4 | `integrations/claude-code/CLAUDE.md` | Add compaction mention in Key Constraints |
| 5 | `integrations/copilot/copilot-instructions.md` | Add compaction mention in Key Constraints |
| 6 | `VERSION` | Bump to 0.28.0 |
| 7 | `CHANGELOG.md` | Add 0.28.0 entry |

### Deleted files

None.

---

## Detailed Change Specifications

### 1. `core/design-principles.md`

**What changes:**

Add a third principle section after the existing
Implementer-Validator Pairing section. The Compaction principle
covers:

- **Definition** — each phase transition produces a compressed,
  self-contained artifact for the next phase. Preserves signal,
  discards noise. The core equation: better tokens in, better tokens
  out.
- **Phase boundary table** — concise table showing what gets
  compressed and what gets discarded at each transition (Research →
  Plan, Plan → Implement, Implement → Review, Review → Revise,
  Revise → Re-review). One line per transition.
- **Anti-patterns** — four named anti-patterns:
  1. "Here's everything I found" (full file dumps instead of excerpts)
  2. "Let me re-read the research" (re-reading files the prior phase
     already summarized)
  3. "The orchestrator will explain" (orchestrator synthesizing
     reviewer findings instead of passing reports — already addressed
     by implementer-reviewer pairing)
  4. "I'll include this just in case" (including "might be relevant"
     context that isn't directly needed)
- **How it applies** — universal across all workflow types, not
  specified per-project-type. The dispatch protocol's output format
  constraints are the enforcement mechanism.
- **Not verifiable in v1** — principle for prompt authors and dispatch
  contract designers, not a runtime check.

Keep the section at roughly the same weight as the two existing
principles (implementer-reviewer pairing is ~20 lines,
implementer-validator pairing is ~15 lines). The phase boundary table
should be concise. Output format constraint details live in
dispatch-protocol.md (loaded on demand), not here.

**Integration points:**
- Referenced by dispatch-protocol.md (new Output Format Constraints
  section references this for the principle)
- Already referenced by all four workflow type files for
  implementer-reviewer pairing — compaction adds another reason to
  read this file but requires no changes in workflow files
- Referenced by integration templates (existing reference; compaction
  bullet added)
- Referenced by Domain-Language.md definitions

---

### 2. `core/workflows/protocols/dispatch-protocol.md`

**What changes:**

Add an "Output Format Constraints" section after the existing Retry
Protocol section (end of file). This section is the enforcement
mechanism for the compaction principle — it specifies what compressed
output looks like for each agent role category.

The section references `core/design-principles.md` for the principle
and then specifies concrete constraints organized by output type:

- **Research and exploration outputs** (sub-agent research, file
  lookups, exploratory reads): include file paths with line numbers,
  code snippets not full files, behavior summaries, constraints and
  gotchas. Exclude full file contents, raw tool call outputs,
  exploration dead-ends.
- **Plan and spec outputs** (all planner agents): must be
  self-contained without reading the research, include actual code
  snippets showing what changes, include mechanically verifiable
  acceptance criteria, include test/validation approach.
- **Evaluation report outputs** (all reviewers and validators): lead
  with verdict, include specific file paths and line numbers, suggest
  fix approach not just "this is wrong", exclude general praise and
  restated code.
- **Sub-agent returns** (any sub-agent dispatched by another agent):
  dispatch contract should specify signal vs. noise, return compressed
  results so the parent agent doesn't need to re-read inputs.

Organized by role category, NOT per-agent, to avoid duplicating the
existing per-agent dispatch contract structure. The existing dispatch
contracts specify inputs (what the orchestrator sends); this new
section specifies outputs (what agents return).

**Integration points:**
- References `core/design-principles.md` (principle source)
- Already referenced by all workflow files for dispatch contracts
- Already referenced by integration templates

---

### 3. `Domain-Language.md`

**What changes:**

Add one new term to the Workflow section, after the
"Implementer-validator pairing" entry:

**Compaction** — definition covering: the principle that each phase
transition produces a compressed artifact self-contained for the next
phase, preserves signal and discards noise, governs all workflows
universally, dispatch protocol output format constraints are the
enforcement mechanism, anti-patterns (dumping full file contents,
re-reading summarized files, orchestrator synthesizing reviewer
findings). Points to `core/design-principles.md`. Tagged as codified
in 0.28.0.

**Integration points:**
- Defines terms used in `core/design-principles.md` and
  dispatch-protocol.md
- Read by agents during orientation when Domain Language exists

---

### 4. `integrations/claude-code/CLAUDE.md`

**What changes:**

Add a compaction bullet to the Key Constraints section, placed
immediately after the existing "Context window hygiene" bullet. The
placement creates a natural read/write pair: context window hygiene
is about what agents READ (load on demand, not up front), compaction
is about what agents PRODUCE (compressed output at phase boundaries).

Content: one bullet explaining that each phase handoff produces a
compressed artifact self-contained for the next agent, with a pointer
to `[FABRIKA_PATH]/core/design-principles.md`.

**Integration points:**
- References `core/design-principles.md`
- Consumer projects copy this template — compaction awareness reaches
  all Claude Code consumer projects through this channel

---

### 5. `integrations/copilot/copilot-instructions.md`

**What changes:**

Same as the CLAUDE.md change — add a compaction bullet to Key
Constraints after the "Context window hygiene" bullet, same content.

**Integration points:**
- References `core/design-principles.md`
- Consumer projects copy this template for Copilot

---

### 6. `VERSION`

`0.27.0` -> `0.28.0`

---

### 7. `CHANGELOG.md`

Add a new entry at the top (after the header, before the 0.27.0
entry). Entry covers:

- Summary: codifies context compaction as a named design principle
  and adds output format constraints to the dispatch protocol
- Changed files list with nature of each change
- Consumer update instructions:
  1. Update `core/design-principles.md` from Fabrika source (new
     Compaction principle section)
  2. Update `core/workflows/protocols/dispatch-protocol.md` from
     Fabrika source (new Output Format Constraints section)
  3. Update `Domain-Language.md` with new term definition (if your
     project maintains a Domain Language file)
  4. Update your project instruction file (CLAUDE.md or
     copilot-instructions.md) from integration template (new
     compaction constraint bullet)

---

## Integration Point Analysis

### Chain 1: Design principles -> Dispatch protocol

**Current state:** Dispatch protocol references design-principles.md
once in the Retry Protocol section (for implementer-reviewer pairing
rationale).

**After CR-20:** Dispatch protocol gains an Output Format Constraints
section that explicitly references the compaction principle in
design-principles.md. The principle (WHY) lives in
design-principles.md; the enforcement mechanism (HOW — what each
output type should look like) lives in dispatch-protocol.md. Clean
separation.

### Chain 2: Design principles -> Integration templates

**Current state:** Integration templates reference
design-principles.md in Key Constraints for implementer-reviewer
pairing and context window hygiene.

**After CR-20:** Integration templates gain a compaction bullet that
also points to design-principles.md. Consistent with existing
pattern.

### Chain 3: Domain Language -> Design principles

**Current state:** Domain Language defines implementer-reviewer
pairing and implementer-validator pairing, pointing to
design-principles.md.

**After CR-20:** Domain Language adds compaction definition, pointing
to design-principles.md. Consistent chain.

---

## What Could Go Wrong

### Risk 1: Compaction principle section is too long

**Problem:** If the compaction section in design-principles.md is
overly detailed (extensive examples, long tables), it violates
context decomposition — agents loading design-principles.md for
implementer-reviewer pairing would be forced to also load compaction
content they may not need.

**Mitigation:** Keep the principle section at roughly the same weight
as the existing two principles. The phase boundary table is concise
(one line per transition). Anti-patterns are a brief enumerated list.
Detailed output format constraints live in dispatch-protocol.md
(loaded on demand), not in design-principles.md.

### Risk 2: Output format constraints in dispatch-protocol conflict with existing contracts

**Problem:** The dispatch protocol already specifies per-agent
dispatch contracts (input). Adding output format constraints could
create confusion between "what the orchestrator sends" and "what the
agent returns."

**Mitigation:** Keep the Output Format Constraints as a clearly
separated section at the end of dispatch-protocol.md, after all
per-agent dispatch contracts. Use role categories (research, plan,
evaluation) rather than per-agent tables. The section header and
introductory paragraph make the input/output distinction explicit.

### Risk 3: Integration template compaction bullet overlaps with context window hygiene

**Problem:** The templates already have a "Context window hygiene"
bullet. A "Compaction" bullet could seem redundant.

**Mitigation:** These are complementary: hygiene = what agents READ
(load on demand), compaction = what agents PRODUCE (compressed
output). Place the compaction bullet immediately after the hygiene
bullet so the read/write pair is visible.

---

## Verification Checklist (for Step 4 agents)

- [ ] `core/design-principles.md` contains a Compaction principle
  section with definition, phase boundary table, anti-patterns, and
  application guidance
- [ ] Compaction section is roughly the same weight as existing
  principles (not over-expanded)
- [ ] `core/workflows/protocols/dispatch-protocol.md` contains an
  Output Format Constraints section that references
  design-principles.md and specifies constraints for research outputs,
  plan outputs, evaluation outputs, and sub-agent returns
- [ ] Output Format Constraints section is clearly separated from
  existing per-agent dispatch contracts
- [ ] `Domain-Language.md` defines "Compaction" in the Workflow
  section
- [ ] Both integration templates have a compaction bullet in Key
  Constraints, placed after "Context window hygiene"
- [ ] No hard token limits imposed anywhere
- [ ] No workflow type files were modified (pointer sections were
  dropped from scope)
- [ ] No agent prompt files were modified
- [ ] VERSION is 0.28.0
- [ ] CHANGELOG 0.28.0 entry exists and lists all changed files
- [ ] CHANGELOG consumer update instructions are complete
- [ ] No smell test violations (no personal references, no downstream
  product names, makes sense to a stranger)
- [ ] Cross-references are consistent: dispatch-protocol.md references
  design-principles.md for the principle, integration templates
  reference design-principles.md

---

## Alignment History

**Round 1 (2026-05-03):** Owner pushed back on three aspects:

1. **Cross-cutting pointer sections dropped.** The original plan
   added a Cross-Cutting Principles pointer section to all four
   workflow files. Owner identified this as unnecessary context bloat —
   existing references between workflow files and design-principles.md
   are sufficient. Scope reduced from 11 files to 7. The
   Cross-Cutting Principles enumeration section in design-principles.md
   was also dropped; the compaction principle itself notes it is
   cross-cutting.

2. **Analytics-workspace naming.** Owner expected analytics-workspace
   to be renamed to analytics-workflow as part of the Phase 2
   compositional model shift. Confirmed this rename is deferred to
   CR-22 where the three project type categories dissolve.

3. **Clearer explanation of what compaction is.** Owner was concerned
   CR-20 would degrade instruction file quality by making them more
   terse. Clarified: compaction governs what agents PRODUCE during
   workflow runs (compressed handoff artifacts), not the quality or
   length of Fabrika's own canonical files.

Design decisions confirmed as aligned: no hard token limits, own
principle (not folded into another), not structurally verifiable in
v1, wiki mentioned as example only.
