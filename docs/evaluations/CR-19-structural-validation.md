---
type: verification-report
change-request: planning/CR-19-adhoc-workflow.md
plan: docs/plans/CR-19-plan.md
status: complete
created: 2026-05-03
---

# CR-19 Structural Validation Report

**Verdict: PASS**

All structural checks pass. No files are missing, no references are
broken, versions match, catalogs are current, and no new files were
created outside the plan.

---

## 1. All files referenced in the CHANGELOG entry actually exist

The 0.30.0 CHANGELOG entry lists six changed files. Each verified:

| File | Exists |
|------|--------|
| `Domain-Language.md` | PASS — repo root |
| `core/workflows/types/task-workflow.md` | PASS |
| `core/workflows/types/development-workflow.md` | PASS |
| `integrations/claude-code/CLAUDE.md` | PASS |
| `integrations/copilot/copilot-instructions.md` | PASS |
| `core/Document-Catalog.md` | PASS |

**Result: PASS**

---

## 2. VERSION file matches the version in the latest CHANGELOG entry

- `VERSION` content: `0.30.0`
- CHANGELOG latest entry header: `## 0.30.0 — Universal backlog types and ceremony graduation`

**Result: PASS**

---

## 3. No new files were created (CR-19 specific)

The plan explicitly states "No new files. The CR explicitly prohibits
new workflow files, agent prompts, and templates." Git diff between
HEAD~1 and HEAD confirms only modifications to existing files plus the
plan file itself (`docs/plans/CR-19-plan.md`, which is the plan
artifact, not a canonical structural file):

```
M  CHANGELOG.md
M  Domain-Language.md
M  VERSION
M  core/Document-Catalog.md
M  core/workflows/types/development-workflow.md
M  core/workflows/types/task-workflow.md
A  docs/plans/CR-19-plan.md
M  integrations/claude-code/CLAUDE.md
M  integrations/copilot/copilot-instructions.md
```

No new workflow files, agent prompts, or templates were created.

**Result: PASS**

---

## 4. Domain-Language defines all four backlog types

Checked `Domain-Language.md` for the four required terms:

| Term | Present | Location |
|------|---------|----------|
| **Backlog type** | Yes | Lines 385-393 — defines the category concept and lists all four types |
| **Bug** | Yes | Lines 395-400 — "A backlog type for defect correction. A task with reproduction context..." |
| **Epic** | Yes | Lines 402-409 — "A backlog type representing a coordination envelope..." |
| **Simple mode** | Yes | Lines 411-419 — "An orchestrator behavior within the task workflow..." |
| **Work type routing** | Yes | Lines 421-429 — "The orchestrator's type-first assessment question..." |
| **Ad-hoc** (retired) | Yes | Lines 431-435 — "Historical term. The concept... resolves into simple mode... retired from active use as of 0.30.0" |

Additionally verified that **Universal complexity spectrum** (lines
369-383) was redefined from linear scale to type-based model, and
**Complexity tier** (lines 331-341) was reframed as "internal to
story-type work."

**Result: PASS**

---

## 5. Task workflow has Simple Mode section

`core/workflows/types/task-workflow.md` contains:

- **Simple Mode section** at lines 56-102 — covers what it is,
  scope assessment threshold, what it skips, what it keeps, reviewer
  behavior, and promotion to standard mode.
- **Bug Tasks section** at lines 105-124 — covers reproduction
  context fields and reviewer verification behavior.
- **Introductory paragraph** (lines 1-9) mentions simple mode:
  "For trivially scoped work, simple mode lets the orchestrator plan
  inline and skip the task folder."

**Result: PASS**

---

## 6. Development workflow has clarifying paragraph

`core/workflows/types/development-workflow.md` line 33-37, at the top
of the "Tier-Conditional Workflow Branching" section:

> "Patch, Story, and Deep Story are ceremony tiers internal to
> story-type work. They are unchanged from 0.29.0. These tiers do
> not apply to tasks, bugs, or epics..."

This is a clarifying paragraph only. No behavioral changes to the
tier paths below it.

**Result: PASS**

---

## 7. Integration templates have Work Type Routing section

### CLAUDE.md integration template

Lines 31-65 contain the "### Work Type Routing" subsection within
the "## Workflow Composition" section. It defines all four backlog
types (task, bug, story, epic), includes routing signals, within-type
ceremony assessment, and notes that sprint-planned work already has
its type.

Lines 364-374 in the "## Development Workflow" section include
updated "Complexity Tiers (story-internal)" language noting tiers
"do not apply to tasks, bugs, or epics (see Work Type Routing above)."

Lines 546-560 in the task-workspace agent table include simple mode
references: "Skipped in simple mode" for planner and validator,
"In simple mode, reviews against the orchestrator's inline plan" for
reviewer.

### copilot-instructions.md

Lines 31-65 contain identical "### Work Type Routing" content.

Lines 273-283 in the "## Development Workflow" section contain
matching "Complexity Tiers (story-internal)" language.

Lines 366-377 in the task-workspace agent table contain matching
simple mode references.

**Result: PASS**

---

## 8. Document-Catalog has backlog type applicability notes

`core/Document-Catalog.md` lines 539-558, in the "## Base Documents
(All Workflow Types)" section, contain the blockquote with backlog type
applicability:

> "**Backlog type applicability:** Briefs apply to tasks and bugs
> (bugs include reproduction context fields...). Plans apply to
> standard-mode tasks and bugs (simple-mode tasks skip the plan...).
> Story specs apply to story-type work... Epics have no execution
> documents..."

Lines 925-930 in the task-workspace Quick Reference section include
the simple mode note:

> "**Per-task (simple mode):** No task folder, no plan.md — the
> orchestrator plans inline and dispatches the implementer directly.
> The commit message is the documentation artifact."

**Result: PASS**

---

## 9. AGENT-CATALOG matches actual files in core/agents/

The AGENT-CATALOG Agent Files table lists 32 agent entries. There are
32 actual agent prompt files in `core/agents/` (excluding
`AGENT-CATALOG.md` and `agent-frontmatter-spec.md`). Every file listed
in the catalog exists, and every file in the directory appears in the
catalog.

No new agents were created in this CR (as expected — the plan
explicitly prohibits new agent prompts).

**Result: PASS**

---

## 10. Document-Catalog Quick Reference sections are current

No new document types were added. The only changes to
`Document-Catalog.md` were the backlog type applicability notes (check
8 above) and the simple mode note in the task-workspace Quick
Reference. The existing Quick Reference sections for all project types
remain current.

**Result: PASS**

---

## 11. Cross-references between files resolve

Checked cross-references in the modified files:

| Reference | Source file | Target | Resolves |
|-----------|-----------|--------|----------|
| `core/workflows/types/task-workflow.md` | development-workflow.md line 36 | task-workflow.md | PASS |
| `Domain-Language.md` | development-workflow.md line 37 | Domain-Language.md | PASS |
| `core/workflows/protocols/sprint-coordination.md` | development-workflow.md line 40 | sprint-coordination.md | PASS |
| `core/workflows/types/task-workflow.md` | CLAUDE.md line 38 | task-workflow.md | PASS |
| `core/workflows/types/development-workflow.md` | CLAUDE.md line 45 | development-workflow.md | PASS |
| `[FABRIKA_PATH]/core/workflows/types/task-workflow.md` | CLAUDE.md line 559 | task-workflow.md | PASS (template placeholder) |
| `core/workflows/types/task-workflow.md` | copilot-instructions.md line 38 | task-workflow.md | PASS |
| `core/workflows/types/development-workflow.md` | copilot-instructions.md line 45 | development-workflow.md | PASS |
| `core/workflows/protocols/design-alignment.md` | task-workflow.md line 38 | design-alignment.md | PASS |
| `core/templates/Brief-Template.md` | task-workflow.md line 138 | Brief-Template.md | PASS |

No broken references found.

**Result: PASS**

---

## 12. README.md accurately reflects current framework state

README.md states "32 specialized agents across 7 archetypes." The
agent count matches: 32 agent prompt files exist. This CR did not
change the agent count or add/remove any project type categories.
No README changes were needed, and none were made. The existing
README description remains accurate.

**Result: PASS**

---

## 13. No smell test violations

Checked the modified files for:
- Personal/product-specific leaks (Notnomo, Hearthen, MNEMOS, Opifex,
  edw labs, VerbumEng): None found in modified canonical files.
- Obsidian/Motion/PARA assumptions: None found.
- Downstream product name references: None in canonical content.

**Result: PASS**

---

## 14. Consumer update instructions completeness

The CHANGELOG 0.30.0 consumer update instructions list 6 steps
covering all 6 modified files. Cross-checked against the plan's
file inventory:

| Plan file | Consumer instruction | Covered |
|-----------|---------------------|---------|
| `Domain-Language.md` | Step 1: "Copy updated Domain-Language.md" | Yes |
| `core/workflows/types/task-workflow.md` | Step 2: "Copy updated..." | Yes |
| `core/workflows/types/development-workflow.md` | Step 3: "Copy updated..." | Yes |
| Integration templates | Step 4: "Update your project instruction file..." | Yes |
| `core/Document-Catalog.md` | Step 5: "Copy updated..." | Yes |
| Project Domain Language | Step 6: "Update your project's Domain Language..." | Yes |

VERSION and CHANGELOG are not consumer-copied files (consumers have
their own versioning).

**Result: PASS**

---

## Summary

| # | Check | Result |
|---|-------|--------|
| 1 | CHANGELOG files exist | PASS |
| 2 | VERSION matches CHANGELOG | PASS |
| 3 | No new files created | PASS |
| 4 | Domain-Language defines all four backlog types | PASS |
| 5 | Task workflow has Simple Mode section | PASS |
| 6 | Development workflow has clarifying paragraph | PASS |
| 7 | Integration templates have routing section | PASS |
| 8 | Document-Catalog has backlog type applicability | PASS |
| 9 | AGENT-CATALOG matches agent files | PASS |
| 10 | Quick Reference sections current | PASS |
| 11 | Cross-references resolve | PASS |
| 12 | README accurate | PASS |
| 13 | No smell test violations | PASS |
| 14 | Consumer update instructions complete | PASS |

**Overall verdict: PASS**
