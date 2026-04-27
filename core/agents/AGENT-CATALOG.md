# Agent Catalog

> **Audience: the AI agent.** This catalog maps project types to the agents that should be installed during bootstrapping. Each project gets a set of agents copied to its `.claude/agents/` (or `.github/agents/`) directory.

## Agent Roles

Every project has a subset of these agent roles:

| Role | Purpose |
|------|---------|
| **Planner** | Takes a vague ask and produces a structured spec or plan. Invoked at the start of a story or task. |
| **Reviewer** | Validates the work product for correctness. The skeptic in the workflow. |
| **Supplemental Reviewer** | Provides a specialized review pass alongside the primary reviewer. Depth over breadth. |
| **Validator** | Proves the output is right — through tests, evals, data checks, or model metrics. |
| **Designer** | Shapes the presentation or interface layer. Invoked when output needs visual design. |
| **Coordinator** | Manages workflow cadence, sprint planning, and retros. Sprint-based types and agentic-workflow (structural mode, for change backlog sequencing). |
| **Implementer** | Writes production changes against an approved plan. Does not design — executes what was planned. |
| **Architect** | Evaluates structural design — how components decompose, reference each other, and manage complexity. Does not review content quality or verify correctness. |

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

### Methodology-Based Types

Methodology-based types use the agentic-workflow lifecycle (`core/workflows/agentic-workflow-lifecycle.md`) instead of the sprint lifecycle or task lifecycle. The agent roster includes implementer and architect roles not present in other types.

| Type | Planner | Reviewer | Validator | Implementer | Architect | Coordinator |
|------|---------|----------|-----------|-------------|-----------|-------------|
| `agentic-workflow` (structural) | product-manager | methodology-reviewer | structural-validator | *(archetype)* | *(archetype)* | scrum-master *(for change backlog sequencing)* |

**Note on agent maturity (0.10.0):** The implementer and architect columns reference archetype templates, not concrete agent files. The methodology-reviewer and structural-validator are stub agents. PRD-03 will create full concrete agents across all project types, including agentic-workflow specializations.

**Operational mode:** Agentic-workflow projects may optionally have an operational mode for day-to-day system operation. Operational sessions are human-initiated and interactive — no additional agents are added. See the workflow file for details.

## Multi-Type Projects

When a project has multiple types (e.g., `web-app` + `ai-engineering`), install the union of all agents. If two types specify different agents for the same role, install both — they serve complementary purposes. For example, `ai-engineering` installs both `code-reviewer` and `prompt-reviewer` as reviewers.

## Agent Archetypes

Each agent implements one of seven archetypes that define base tool profiles, dispatch contracts, and output contracts. Archetype templates live in `core/agents/archetypes/` and serve as starting points for new agents — existing agents may diverge where their specialization demands it.

| Archetype | Base behavior | Dispatch tier |
|-----------|--------------|---------------|
| [Planner](archetypes/planner.md) | Synthesize context into specs; validate against acceptance criteria | Contextual (planning) / Strict (validation) |
| [Reviewer](archetypes/reviewer.md) | Independent skeptical evaluation of work product | Strict |
| [Validator](archetypes/validator.md) | Write and run verification code; prove correctness by execution | Strict |
| [Coordinator](archetypes/coordinator.md) | Manage work sequencing, sprint planning, topology assessment | Contextual |
| [Designer](archetypes/designer.md) | Propose and evaluate designs (visual, structural, interactive) | Strict |
| [Implementer](archetypes/implementer.md) | Write production changes against an approved plan | Contextual |
| [Architect](archetypes/architect.md) | Evaluate structural design — decomposition, references, context budgets | Strict |

For dispatch contracts (what the orchestrator provides each agent at each invocation point), see `core/workflows/dispatch-protocol.md`.

## Agent Files

| File | Role | Archetype | Used by |
|------|------|-----------|---------|
| `product-manager.md` | Planner | Planner | web-app, data-app, analytics-engineering, data-engineering, ai-engineering, automation |
| `experiment-planner.md` | Planner | Planner | ml-engineering |
| `api-designer.md` | Planner | Planner | library |
| `analysis-planner.md` | Planner | Planner | analytics-workspace |
| `code-reviewer.md` | Reviewer | Reviewer | all sprint-based types |
| `logic-reviewer.md` | Reviewer | Reviewer | analytics-workspace |
| `prompt-reviewer.md` | Supplemental Reviewer | Reviewer | ai-engineering |
| `security-reviewer.md` | Supplemental Reviewer | Reviewer | web-app, data-engineering, ai-engineering |
| `performance-reviewer.md` | Supplemental Reviewer | Reviewer | all types |
| `test-writer.md` | Validator | Validator | web-app, data-app, analytics-engineering, automation, library |
| `data-quality-engineer.md` | Validator | Validator | data-engineering |
| `model-evaluator.md` | Validator | Validator | ml-engineering |
| `eval-engineer.md` | Validator | Validator | ai-engineering |
| `data-validator.md` | Validator | Validator | analytics-workspace |
| `visualization-designer.md` | Designer | Designer | analytics-workspace, data-app, analytics-engineering |
| `scrum-master.md` | Coordinator | Coordinator | all sprint-based types, agentic-workflow (structural — change backlog sequencing) |
| `methodology-reviewer.md` | Reviewer | Reviewer | agentic-workflow |
| `structural-validator.md` | Validator | Validator | agentic-workflow |
