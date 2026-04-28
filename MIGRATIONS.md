# Migrations

When a Fabrika update requires consumer projects to do more than a straight file overwrite, the migration steps are documented here.

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
