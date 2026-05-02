# PRD-14 Architecture Assessment

**Agent:** context-architect
**Plan:** `docs/plans/PRD-14-plan.md`
**Verdict:** SOUND

---

## 1. Instruction Decomposition

**Finding: Appropriate. No extraction needed.**

The new onboarding content (Phase 2W.1a) adds roughly 75 lines to
BOOTSTRAP.md. The plan explicitly considered and dropped the idea of
a separate Onboarding-Questionnaire-Reference.md file, and the
rationale is correct: BOOTSTRAP.md is read once per project lifetime,
in a session whose entire purpose is bootstrapping. There is no
context budget pressure because the orchestrator is already reading
the full BOOTSTRAP.md during that session. Extracting the
questionnaire into its own file would create a sync obligation (the
questionnaire references templates, templates reference the
questionnaire's output paths) with no corresponding benefit.

The Phase 2W section as a whole is now substantial (~170 lines from
2W.1 through 2W.6), but each subsection is a discrete procedural
step with its own heading. The section reads as a sequential protocol,
not a tangled multi-concern block. It does not yet hit the
decomposition threshold described in CLAUDE.md's "Context
decomposition principle" (~30-50 lines of instructional content doing
double duty). If a future change adds significant content to Phase 2W,
the subsections could be extracted into a standalone onboarding
workflow file, but that is not warranted today.

## 2. Pointer Patterns

**Finding: Clean. No circular or redundant references.**

Cross-reference chain for the new content:

- BOOTSTRAP.md Phase 2W.1a -> `[FABRIKA_PATH]/core/templates/Platform-Connection-Template.md` (template source)
- BOOTSTRAP.md Phase 2W.1a -> `sources/connections/[platform]/README.md` (output path)
- BOOTSTRAP.md Phase 2W.2 -> `sources/connections/` (reads what onboarding scaffolded)
- analytics-workspace.md Plan phase -> `sources/connections/[platform]/README.md` (reads cost model)
- analytics-workspace.md default cost note -> BOOTSTRAP.md Phase 2W.1a (references onboarding as capture point)
- Document-Catalog -> `core/templates/Platform-Connection-Template.md` (template listing)
- Document-Catalog -> `sources/connections/[platform]/README.md` (document entry)
- Integration templates -> `core/workflows/analytics-workspace.md` (existing pointer, unchanged)

All references are directional and non-circular. The
BOOTSTRAP.md -> analytics-workspace.md reference is indirect (they
share the path convention `sources/connections/[platform]/README.md`
rather than pointing at each other), which is the correct pattern --
the bootstrap creates the file, the workflow reads it, and neither
needs to know the other's implementation details.

The `[FABRIKA_PATH]` placeholder pattern is used consistently in
BOOTSTRAP.md for template references, matching existing usage
throughout the file.

## 3. Context Budget

**Finding: No impact on always-loaded context. Appropriate balance.**

The changes affect context loading as follows:

**Always-loaded (CLAUDE.md / copilot-instructions.md):** One sentence
added to the Analytics Workspace Workflow summary in each integration
template. This is the right granularity -- the summary tells the
orchestrator that onboarding pre-populates platform config, which is
enough to orient it. The detail stays in the workflow file, loaded
on demand.

**On-demand (BOOTSTRAP.md):** ~75 lines added. Only loaded during
bootstrap sessions, which are single-purpose and infrequent. No
budget concern.

**On-demand (analytics-workspace.md):** ~10 lines of changes spread
across the Plan phase descriptions and the default cost note. This
file is loaded per-task for analytics workspaces, so line count
matters. The additions are minimal and descriptive (pointing to where
platform config lives), not procedural. No bloat.

**On-demand (Document-Catalog.md):** ~25 lines of changes (new entry,
clarification of existing entry, Quick Reference update, template
listing). The catalog is loaded during bootstrap and when checking
which documents to create. The additions are structurally necessary
-- without them, the catalog would be incomplete.

**Template (Platform-Connection-Template.md):** New file, ~55 lines.
Only loaded when creating a platform connection README. Appropriate
size for a template -- comparable to Source-Connection-Template.md
(~40 lines) and Source-Tool-Template.md (~42 lines).

No concern about context budget. The always-loaded surface gains
one sentence; everything else is on-demand and loaded only when
relevant.

## 4. Pattern Consistency

**Finding: Platform-Connection-Template follows established patterns
with one structural difference that is appropriate.**

Comparison with existing templates:

| Aspect | Source-Connection | Source-Tool | Platform-Connection |
|--------|------------------|-------------|---------------------|
| YAML frontmatter | Yes (type, name, connection_type, status, last_verified) | Yes (type, name, tool_type, status, last_verified) | No |
| Top heading | Source name | Tool name | Platform name |
| Sections | Connection Details, What Lives Here, Access Notes, Known Gotchas, Reliability | Access Details, Key Assets, Data Sources Used, What the Agent Can Help With, Known Quirks | Platform Type, Cost Model, EXPLAIN Mechanism, General Notes, Projects/Instances |
| Placeholder format | `[bracketed descriptions]` | `[bracketed descriptions]` | `[bracketed descriptions]` |
| Length | ~40 lines | ~42 lines | ~55 lines |

The Platform-Connection-Template does NOT have YAML frontmatter,
while the other two source templates do. This is a deliberate and
defensible choice: the platform README is a directory-level overview
file (it lives at `sources/connections/[platform]/README.md` as the
index for everything beneath that platform), not an individually
addressable source document. The Source-Connection and Source-Tool
templates each describe a specific source that gets queried or
tracked; the platform template describes the platform that hosts
multiple sources. YAML frontmatter would imply it is a queryable
catalog item in the same way connections and tools are, which it
is not.

However, I note this as a minor inconsistency worth being aware of
rather than a defect to fix. If the project later introduces
Dataview-style queries over source registry documents, the lack
of frontmatter on platform READMEs could be a gap. For now, no
action needed.

The Cost Model section structure matches what
analytics-workspace.md expects to read: pricing model, cost basis,
rate, cost model source. The default pricing reference table matches
the Platform-Specific EXPLAIN Mechanisms table in
analytics-workspace.md (BigQuery $6.25/TB, Snowflake $2-4/credit-hour,
Databricks $0.07-0.22/DBU, SQL Server N/A). The EXPLAIN Mechanism
section mirrors the EXPLAIN column in that same table. These are the
critical structural agreements that prevent template-workflow
mismatch (Risk 1 in the plan).

The Projects/Instances table at the bottom is a good structural
choice -- it creates a navigable link between the platform level
and the Level 1 connections beneath it, which is the relationship
that the four-level hierarchy in the analytics-workspace workflow
describes.

## 5. Integration Surface Completeness

**Finding: Sufficient. Not too much, not too little.**

Both integration templates (CLAUDE.md and copilot-instructions.md)
received identical one-sentence additions to their Analytics Workspace
Workflow summary sections:

> "Platform configuration and cost model info are pre-populated
> during workspace onboarding (BOOTSTRAP.md Phase 2W.1a) at
> `sources/connections/[platform]/README.md`."

This is the right level of detail for always-loaded context:

- It tells the orchestrator WHERE platform config comes from (so it
  does not re-ask the user during tasks)
- It tells the orchestrator WHEN it was created (onboarding, not
  per-task)
- It tells the orchestrator WHERE the file lives (path convention)
- It does NOT explain the questionnaire structure, the template, or
  the fallback behavior -- that detail lives in BOOTSTRAP.md and
  analytics-workspace.md, loaded on demand

The existing pointer to `[FABRIKA_PATH]/core/workflows/analytics-workspace.md`
in both integration templates already covers the full workflow detail.
No additional pointer is needed.

I verified that no other sections of the integration templates
required updates. The project structure trees already include
`sources/connections/` in the analytics-workspace layout. The
Subagents tables are unchanged (correct -- no new agents were
added). The Document Creation Triggers pointer is unchanged
(correct -- onboarding is a bootstrap activity, not a
development trigger).

---

## Summary

All five evaluation criteria are satisfied. The change is
structurally sound:

1. Onboarding content stays inline in BOOTSTRAP.md where it belongs
2. Cross-references are clean and directional
3. Context budget impact is minimal (one always-loaded sentence)
4. The new template follows established patterns with a justified
   structural difference (no YAML frontmatter on directory-level
   overview files)
5. Integration surface changes are the right size

No structural concerns. No action items.
