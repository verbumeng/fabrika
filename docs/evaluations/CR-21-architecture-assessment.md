# CR-21 Architecture Assessment

**Verdict: SOUND**

The freshness protocol is well-decomposed, follows established
patterns, and fits cleanly into the existing structural architecture.
No blocking concerns. Two minor observations worth noting but not
worth fixing.

---

## 1. Instruction Decomposition

**Finding: Correctly decomposed. No double duty.**

The freshness protocol is defined once in
`core/workflows/types/development-workflow.md` (the "Freshness-Aware
Context Loading" section, lines 154-203). This is the single source of
truth for behavioral logic — what the orchestrator does with the
freshness signal, what Strategy A and B mean, when triage happens.

Every other file that references freshness uses a pointer pattern
rather than restating the protocol:

- `core/Document-Catalog.md` (lines 65-87) — defines the metadata
  field itself and which documents carry it; defers to
  development-workflow.md for behavioral logic
- `core/workflows/types/task-workflow.md` (lines 134-140) — brief
  cross-reference pointing to development-workflow.md for the full
  protocol
- `core/workflows/protocols/sprint-coordination.md` (lines 76-78) —
  defines the maintenance sweep procedure (its own concern, not a
  restatement of development-workflow); references Document-Catalog
  for which docs carry the field
- Integration templates (CLAUDE.md lines 299, 681;
  copilot-instructions.md lines 212-213, 598-599) — concise summary
  bullets pointing to development-workflow.md

Each file owns its own concern: Document-Catalog owns "what is the
field and where does it live," development-workflow owns "what the
orchestrator does with it at story/task start," sprint-coordination
owns "how and when the periodic sweep runs," and integration templates
own "orient the consumer orchestrator." No file is doing double duty.

The placement of the Freshness-Aware Context Loading section in
development-workflow.md — after Tier-Conditional Workflow Branching and
before Starting a Story — is structurally sound. The orchestrator
reads it before entering any story path, which matches the execution
order.

---

## 2. Pointer Pattern Cleanliness

**Finding: Clean. Bidirectional where needed. No dangling references.**

Cross-reference chain:

| From | To | Direction | Clean? |
|------|----|-----------|--------|
| Document-Catalog.md | development-workflow.md | Forward | Yes — names the section |
| Document-Catalog.md | sprint-coordination.md | Forward | Yes — names the sweep |
| development-workflow.md | Document-Catalog.md | Backward | Yes — "See the Freshness Metadata section in Document-Catalog.md" |
| development-workflow.md | sprint-coordination.md | Forward | Yes — "See sprint-coordination.md for the sprint maintenance sweep" |
| task-workflow.md | development-workflow.md | Forward | Yes — names the section |
| sprint-coordination.md | Document-Catalog.md | Forward | Yes — "See the Freshness Metadata section in Document-Catalog.md" |
| Integration templates | development-workflow.md | Forward | Yes — uses `[FABRIKA_PATH]` placeholder |
| Domain-Language.md | Document-Catalog.md | Forward | Yes — "See core/Document-Catalog.md for which documents carry the field" |

All forward references resolve. Backward references exist where needed
(development-workflow.md points back to Document-Catalog for field
definition, and to sprint-coordination for the sweep — both are
upstream relationships that the reader needs to navigate). No orphaned
pointers.

---

## 3. Context Budget

**Finding: Acceptable. Freshness content is concise enough for
always-loaded context.**

The freshness additions to integration templates (always-loaded
context) are:

- **CLAUDE.md Session Lifecycle:** ~5 lines of inline text after step
  2, explaining the passive freshness check with a pointer to
  development-workflow.md. This is appropriately concise — it tells
  the orchestrator what to do during orientation without restating the
  full protocol.

- **CLAUDE.md Key Constraints:** 1 bullet (~3 lines) after the
  Compaction bullet. Consistent length with adjacent constraint
  bullets.

- **copilot-instructions.md:** Identical additions in matching
  positions.

The total freshness content added to always-loaded context is roughly
8 lines per integration template. Given that compaction already added
~3 lines in Key Constraints at 0.28.0, the two context-quality
principles together consume ~11 lines of always-loaded context. This
is well within acceptable bounds — context window hygiene remains
intact.

The behavioral detail (Strategy A vs B, triage options, threshold
configuration) correctly lives in development-workflow.md (loaded on
demand at story/task start), not in the always-loaded integration
template.

---

## 4. Pattern Consistency

**Finding: Follows established patterns precisely.**

Freshness follows the same structural pattern as compaction:

| Aspect | Compaction (CR-20) | Freshness (CR-21) |
|--------|-------------------|-------------------|
| Principle definition | `core/design-principles.md` | `core/workflows/types/development-workflow.md` |
| Domain Language terms | In Workflow section | In Workflow section, immediately after Compaction |
| Integration template treatment | Key Constraints bullet with pointer | Key Constraints bullet with pointer, placed after Compaction |
| Cross-cutting applicability | Universal across all workflow types | Universal across all workflow types |
| Version tag | `[Codified in 0.28.0.]` | `[Introduced in 0.31.0.]` |

One structural difference: compaction is defined in
`core/design-principles.md` while freshness is defined in
`core/workflows/types/development-workflow.md`. This is a defensible
choice, not an inconsistency — compaction governs agent output (a
design principle about how agents interact), while freshness governs
orchestrator input loading (a workflow-level behavior about what
happens before agents are dispatched). The principle lives where it is
mechanically implemented.

If freshness were added to design-principles.md, it would be the only
principle there that is not about agent-to-agent interaction patterns.
The current placement avoids that category mismatch.

Template frontmatter additions are consistent across all three
templates: `last-validated: YYYY-MM-DD` placed immediately after the
`updated:` field in each.

---

## 5. Integration Surface Completeness

**Finding: Complete. All files that should reference freshness do.**

Checking every file that loads Tier 1 context or governs orchestrator
behavior at story/task start:

| File | Should reference freshness? | Does it? |
|------|---------------------------|----------|
| `core/workflows/types/development-workflow.md` | Yes (primary definition) | Yes |
| `core/workflows/types/task-workflow.md` | Yes (task-start context loading) | Yes |
| `core/workflows/protocols/sprint-coordination.md` | Yes (maintenance sweep, retro) | Yes |
| `core/Document-Catalog.md` | Yes (field definition, which docs carry it) | Yes |
| `integrations/claude-code/CLAUDE.md` | Yes (session lifecycle orientation) | Yes |
| `integrations/copilot/copilot-instructions.md` | Yes (session lifecycle orientation) | Yes |
| `Domain-Language.md` | Yes (term definitions) | Yes |
| Templates (Domain-Language, Project-Charter, PRD) | Yes (frontmatter field) | Yes |
| `core/design-principles.md` | No (freshness is workflow behavior, not agent interaction principle) | Correct — not referenced |
| `core/workflows/protocols/dispatch-protocol.md` | No (freshness is pre-dispatch; dispatch protocol governs payload contents) | Correct — not referenced |
| Agent prompt files | No (freshness is orchestrator concern; agents receive whatever context is dispatched) | Correct — not modified |
| `core/workflows/types/analytics-workspace.md` | No (uses "freshness" for data source freshness, a different concept) | Correct — not modified |
| `core/workflows/types/agentic-workflow.md` | No (wiki articles have their own lifecycle; structural changes do not load Tier 1 project docs at start) | Correct — not modified |

No missing references. No files that should have been modified but
were not.

---

## Minor Observations (not blocking)

**1. analytics-workspace terminological collision.** The
analytics-workspace workflow uses "freshness" to describe data source
recency (e.g., "source freshness assessment" at line 378 of
analytics-workspace.md). CR-21 introduces "freshness signal" and
"freshness validation" for document staleness. These are different
concepts with the same root word. The collision is low-risk because
the two usages occur in different files and contexts — a reader of
analytics-workspace.md is thinking about data, not documents. But
if a future change touches both concepts in the same file, the
terminology could become confusing. No action needed now — just a
seam to be aware of.

**2. `freshness-threshold` not present in integration template
scaffolds.** The consumer update instructions (CHANGELOG step 8) tell
consumers to add `freshness-threshold: 2-sprints` to their project
instruction file. But the integration template scaffolds (CLAUDE.md
and copilot-instructions.md) do not include this field themselves as
a placeholder or commented-out default. A consumer bootstrapping a
new project from these templates would not have the threshold set
until they read the consumer update instructions. The default
(2 sprints) handles this gracefully since development-workflow.md
explicitly states "If no threshold is configured, use the default."
This is not a structural problem — the fallback works — but including
a commented-out placeholder in the template would make the
configuration more discoverable for new projects.

---

## Summary

The freshness protocol is structurally sound. It follows the
define-once-point-elsewhere decomposition pattern. The single source
of truth (development-workflow.md) is placed at the right level of
abstraction. Cross-references are clean and bidirectional where needed.
Always-loaded context additions are appropriately concise. The pattern
is consistent with how compaction was introduced. Integration surface
coverage is complete.
