# Software Development Workflow

Domain workflow for **web-app** and **automation** projects. This file
defines the domain-specific agents, review criteria, and testing
approach that compose with the shared story execution mechanics in
`core/workflows/protocols/story-execution.md`.

The shared story execution mechanics (story-start orientation,
dispatch protocol reference, tier-conditional branching, freshness-aware
context loading, testing approach branching, evaluation cycle,
multi-domain story completion, bug workflow reference, architecture
assessment, ideation/grooming, research) are defined in the
story-execution protocol — this file adds the software-development-
specific layer.

---

## Agent Roster

| Role | Agent | Notes |
|------|-------|-------|
| Planner | [product-manager](../../agents/product-manager.md) | Expands stories into specs; validates acceptance criteria |
| Reviewer | [code-reviewer](../../agents/code-reviewer.md) | Reviews implementation against spec, rubric, and security baseline |
| Supplemental Reviewer | [security-reviewer](../../agents/security-reviewer.md) | web-app only: supplemental security review |
| Supplemental Reviewer | [performance-reviewer](../../agents/performance-reviewer.md) | Performance assessment |
| Validator | [test-writer](../../agents/test-writer.md) | Spec-first (TDD), coverage, or test-after depending on testing approach |
| Coordinator | [scrum-master](../../agents/scrum-master.md) | Sprint planning, topology assessment, retros (complexity-triggered) |
| Implementer | [software-engineer](../../agents/software-engineer.md) | Writes production code against approved spec |
| Architect | [software-architect](../../agents/software-architect.md) | Evaluates module depth, interface design, component boundaries |

---

## Domain-Specific Gates

### Security Review (web-app only)

For web-app projects, the security-reviewer runs as a supplemental
review alongside the code-reviewer during the evaluation cycle. The
security reviewer assesses: authentication and authorization, input
validation, data handling, dependency security (via semgrep), and
threat model alignment.

For automation projects, security review is optional and
orchestrator-discretion based on the story's scope (e.g., stories
touching credential handling or external API integrations).

### Architecture Review Triggers

The software-architect is invoked when:
- The spec proposes new modules or significant restructuring
- The code-reviewer flags Module Depth / Interface Simplicity concerns
- Deep Story tier (mandatory)
- Owner requests assessment

---

## Testing Approach

The scrum-master assigns a testing approach per story during sprint
planning:

- **TDD** — new modules, complex logic, new public API endpoints,
  greenfield components
- **Test-informed** — modifications to existing modules, medium-
  complexity changes
- **Test-after** — config changes, minor fixes, documentation-heavy
  stories

**Verification methods by project type:**
- **web-app:** Playwright MCP for browser automation E2E; pytest/vitest
  for unit and integration
- **automation:** Standard test runner (pytest/vitest); integration
  tests against real or mock targets

---

## Story Execution

For all story execution mechanics (starting a story, evaluation cycle,
tier-conditional branching, multi-domain completion), follow
`core/workflows/protocols/story-execution.md`.
