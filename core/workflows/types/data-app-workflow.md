# Data App Workflow

Domain workflow for **data-app** projects (dashboards, reporting
tools, data entry apps — replacing Excel). This file defines the
domain-specific agents, review criteria, and testing approach that
compose with the shared story execution mechanics in
`core/workflows/protocols/story-execution.md`.

The shared story execution mechanics are defined in the story-execution
protocol — this file adds the data-app-specific layer.

---

## Agent Roster

| Role | Agent | Notes |
|------|-------|-------|
| Planner | [product-manager](../../agents/product-manager.md) | Expands stories into specs; validates acceptance criteria |
| Reviewer | [code-reviewer](../../agents/code-reviewer.md) | Reviews app code against spec and rubric |
| Supplemental Reviewer | [performance-reviewer](../../agents/performance-reviewer.md) | Query performance, dashboard load times |
| Validator | [test-writer](../../agents/test-writer.md) | Behavioral tests, model assertion tests |
| Designer | [visualization-designer](../../agents/visualization-designer.md) | Dashboard layout, visualization design |
| Coordinator | [scrum-master](../../agents/scrum-master.md) | Sprint coordination (complexity-triggered) |
| Implementer | [data-analyst](../../agents/data-analyst.md) | Writes app code (Streamlit, Dash, etc.) |
| Architect | [data-architect](../../agents/data-architect.md) | Evaluates data model, query architecture |

---

## Domain-Specific Gates

### Dashboard Spec Validation

Stories that create or modify dashboards must verify:
- Layout matches the Dashboard Spec document
- Data sources are correctly connected
- Filters and interactions work as specified
- Refresh frequency meets requirements

### Visualization Review

The visualization-designer reviews dashboard outputs for:
- Audience appropriateness
- Chart type selection
- Data-ink ratio
- Accessibility

---

## Testing Approach

- **TDD** — new data models, new dashboard components, new query
  patterns
- **Test-informed** — modifications to existing dashboards, filter
  logic changes
- **Test-after** — styling changes, label updates, configuration

**Verification method:** Playwright MCP for browser automation +
model assertion tests + test runner.

---

## Story Execution

For all story execution mechanics, follow
`core/workflows/protocols/story-execution.md`.
