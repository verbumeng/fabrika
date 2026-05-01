# PRD-16: Rename Context Engineer to Agentic Engineer

**Version target:** TBD (minor bump — core/ agent change)
**Dependencies:** None
**Execution method:** Agentic-workflow structural update protocol

## Problem Statement

"Context engineer" is an overloaded term. In the broader AI industry
it increasingly refers to the general practice of crafting prompts and
context — something every agent in Fabrika does to some degree. Within
Fabrika, the context engineer is specifically the implementer-archetype
agent that writes and modifies agentic-workflow artifacts (agent
prompts, workflow definitions, catalog entries, integration templates).

The name creates confusion in two directions:

1. **Internal ambiguity.** The context engineer and context architect
   share a "context-" prefix, implying they belong to the same family.
   They don't — one is an implementer, the other is a reviewer. The
   shared prefix obscures the archetype distinction that actually
   matters.

2. **External ambiguity.** New users encountering Fabrika's agent model
   read "context engineer" and assume it means generic prompt
   engineering, not the specific structural-implementation role it
   fills.

"Agentic engineer" resolves both: it signals the domain (agentic
systems) and the archetype (engineer/implementer), without collision
with the industry-generic "context engineering" concept.

## Scope

### Rename

- File: `core/agents/context-engineer.md` → `core/agents/agentic-engineer.md`
- All internal references updated: heading, self-references, role
  description

### Files that reference context engineer (16 total)

| File | Nature of change |
|---|---|
| `core/agents/AGENT-CATALOG.md` | Update agent name, filename, description |
| `core/agents/workflow-planner.md` | Update dispatch target name |
| `core/agents/methodology-reviewer.md` | Update cross-reference |
| `core/agents/context-architect.md` | Update cross-reference |
| `core/workflows/agentic-workflow-lifecycle.md` | Update agent name in step descriptions |
| `core/workflows/dispatch-protocol.md` | Update dispatch entries |
| `Domain-Language.md` | Update term definition |
| `integrations/claude-code/CLAUDE.md` | Update agent reference |
| `integrations/copilot/copilot-instructions.md` | Update agent reference |
| `BOOTSTRAP.md` | Update agent reference if present |
| `MIGRATIONS.md` | Add migration note for consumers |
| `CHANGELOG.md` | Entry under new version |
| `wiki/topics/agent-model.md` | Update agent name and description |
| `planning/EXECUTION-PROMPT.md` | Update reference |
| `planning/PRD-12-plan-persistence-alignment.md` | Update reference |
| `VERSION` | Bump |

### What does NOT change

- **Context architect** stays as-is. "Context" is accurate for that
  role — it evaluates how context is structured and allocated. The
  ambiguity problem is specific to the implementer agent.
- No behavioral changes to the agent prompt beyond the rename. Same
  orientation steps, same output contracts, same archetype.
- No workflow changes. The agentic engineer fills the same slot the
  context engineer did.

## Migration (Consumer Impact)

Consumers who reference `context-engineer` in their project instruction
files or custom workflows will need to update those references. The
MIGRATIONS.md entry should include:

- Old filename → new filename
- Old term → new term
- A grep pattern consumers can run to find references: `context.engineer`

## Open Questions

- Should the context architect also be renamed for consistency (e.g.,
  "agentic architect")? Current assessment: no — "context architect"
  accurately describes what it evaluates, and the rename would be churn
  without the same ambiguity problem. But worth a brief discussion.
