# Agent Catalog

> **Audience: the AI agent.** This catalog maps project types to the agents that should be installed during bootstrapping. Each project gets a set of agents copied to its `.claude/agents/` (or `.github/agents/`) directory.

## Agent Roles

Every project has up to four agent roles:

| Role | Purpose |
|------|---------|
| **Planner** | Takes a vague ask and produces a structured spec or plan. Invoked at the start of a story or task. |
| **Reviewer** | Validates the work product for correctness. The skeptic in the workflow. |
| **Supplemental Reviewer** | Provides a specialized review pass alongside the primary reviewer. Depth over breadth. |
| **Validator** | Proves the output is right — through tests, evals, data checks, or model metrics. |
| **Designer** | Shapes the presentation or interface layer. Invoked when output needs visual design. |
| **Coordinator** | Manages workflow cadence, sprint planning, and retros. Sprint-based types only. |

## Agent Mapping by Project Type

### Sprint-Based Types

| Type | Planner | Reviewer | Supplemental Reviewers | Validator | Designer | Coordinator |
|------|---------|----------|----------------------|-----------|----------|-------------|
| `web-app` | product-manager | code-reviewer | security-reviewer, performance-reviewer | test-writer | — | scrum-master |
| `data-app` | product-manager | code-reviewer | performance-reviewer | test-writer | visualization-designer | scrum-master |
| `analytics-engineering` | product-manager | code-reviewer | performance-reviewer | test-writer | visualization-designer | scrum-master |
| `data-engineering` | product-manager | code-reviewer | security-reviewer, performance-reviewer | data-quality-engineer | — | scrum-master |
| `ml-engineering` | experiment-planner | code-reviewer | performance-reviewer | model-evaluator | — | scrum-master |
| `ai-engineering` | product-manager | code-reviewer, prompt-reviewer | security-reviewer, performance-reviewer | eval-engineer | — | scrum-master |
| `automation` | product-manager | code-reviewer | performance-reviewer | test-writer | — | scrum-master |
| `library` | api-designer | code-reviewer | performance-reviewer | test-writer | — | scrum-master |

### Task-Based Types

| Type | Planner | Reviewer | Supplemental Reviewers | Validator | Designer | Coordinator |
|------|---------|----------|----------------------|-----------|----------|-------------|
| `analytics-workspace` | analysis-planner | logic-reviewer | performance-reviewer | data-validator | visualization-designer | *(none)* |

## Multi-Type Projects

When a project has multiple types (e.g., `web-app` + `ai-engineering`), install the union of all agents. If two types specify different agents for the same role, install both — they serve complementary purposes. For example, `ai-engineering` installs both `code-reviewer` and `prompt-reviewer` as reviewers.

## Agent Files

| File | Role | Used by |
|------|------|---------|
| `product-manager.md` | Planner | web-app, data-app, analytics-engineering, data-engineering, ai-engineering, automation |
| `experiment-planner.md` | Planner | ml-engineering |
| `api-designer.md` | Planner | library |
| `analysis-planner.md` | Planner | analytics-workspace |
| `code-reviewer.md` | Reviewer | all sprint-based types |
| `logic-reviewer.md` | Reviewer | analytics-workspace |
| `prompt-reviewer.md` | Supplemental Reviewer | ai-engineering |
| `security-reviewer.md` | Supplemental Reviewer | web-app, data-engineering, ai-engineering |
| `performance-reviewer.md` | Supplemental Reviewer | all types |
| `test-writer.md` | Validator | web-app, data-app, analytics-engineering, automation, library |
| `data-quality-engineer.md` | Validator | data-engineering |
| `model-evaluator.md` | Validator | ml-engineering |
| `eval-engineer.md` | Validator | ai-engineering |
| `data-validator.md` | Validator | analytics-workspace |
| `visualization-designer.md` | Designer | analytics-workspace, data-app, analytics-engineering |
| `scrum-master.md` | Coordinator | all sprint-based types |
