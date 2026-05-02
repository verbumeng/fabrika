---
type: system-update-plan
change-request: [path to CR/PRD that initiated this plan]
status: draft
created: [YYYY-MM-DD]
---

# System Update Plan: [Short descriptive title]

## File Change Inventory

[Every file that will be created, modified, or deleted. Explicit
paths, not "update related files."]

### New files

| File | Purpose |
|------|---------|
| `[path]` | [what this file is and why it is needed] |

### Modified files

| File | Change |
|------|--------|
| `[path]` | [specific nature of the change] |

## Integration Point Analysis

[For each changed file, what other files reference it, depend on it,
or need to stay in sync. Trace the cross-reference chains.]

| Changed file | References from | Sync required |
|-------------|----------------|---------------|
| `[path]` | `[referencing file]` | [what must stay in sync] |

## Risk Identification

[For each integration point, what breaks if the change is
inconsistent. Concrete failure modes, not "things might break."]

| # | Risk | Affected files | Failure mode |
|---|------|---------------|-------------|
| 1 | [risk name] | `[files]` | [specific inconsistency and its consequence] |

## Mitigations

[For each risk, the specific action to prevent it. Actionable by
someone who follows instructions literally.]

| Risk # | Mitigation |
|--------|-----------|
| 1 | [specific action with file paths] |

## Version Bump Determination

**Bump type:** [major / minor / patch]
**New version:** [X.Y.Z]
**Reasoning:** [which bump rule applies and why]

## CHANGELOG Draft

[One-line description per changed file, grouped by category. Include
consumer update instructions.]

## Owner Decision Points

[Any items requiring the owner's judgment. Separate from mechanical
changes that need no input. If all decisions were resolved during
alignment, state that.]

## Alignment History

[Captures what changed from the initial plan and why. Short entries,
not transcripts. Updated by the planner on each re-invocation.]

- **v1:** Initial plan. [Date or "no revisions yet"]
