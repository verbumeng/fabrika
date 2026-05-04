# Agent Catalog

> **Audience: the AI agent.** This catalog maps workflow types to the agents that should be installed during bootstrapping. Each project gets a set of agents copied to its `.claude/agents/` (or `.github/agents/`) directory.

## Skills Model

Fabrika's agent model is organized around skills — the atomic unit of
agent capability exercised in one invocation. An agent HAS a skill;
the agent is not "a skill." Agents are dispatched entities with
identity, state, and dispatch contracts. Skills are what they do.

**Base agents** carry unparameterized skills with zero domain
assumptions. The four base agents (planner, implementer, reviewer,
validator) are the foundation that all specialized agents extend.

**Specialized agents** carry parameterized skills — a base skill
extended with domain knowledge. The domain knowledge adds:
domain-specific evaluation criteria, domain-specific dispatch contract
fields, and domain principles. The parameterization relationship is
documented in the Agent Files table below.

**Workflow types** invoke agents with their skills in sequence. Each
workflow type defines its roster — which agents (with their skills)
are needed for the domain's work lifecycle.

## Agent Roles

Every project has a subset of these agent roles:

| Role | Purpose |
|------|---------|
| **Planner** | Takes a vague ask and produces a structured spec or plan. Invoked at the start of a story or task. |
| **Reviewer** | Validates the work product for correctness. The skeptic in the workflow. |
| **Supplemental Reviewer** | Provides a specialized review pass alongside the primary reviewer. Depth over breadth. |
| **Validator** | Proves the output is right — through tests, evals, data checks, or model metrics. |
| **Designer** | Shapes the presentation or interface layer. Invoked when output needs visual design. |
| **Coordinator** | Manages workflow cadence, sprint planning, and retros. Activates when a project's work includes story/epic-level backlog items. |
| **Implementer** | Writes production changes against an approved plan. Does not design — executes what was planned. |
| **Architect** | Evaluates structural design — how components decompose, reference each other, and manage complexity. Does not review content quality or verify correctness. |

## Agent Mapping by Workflow Type

### Domain Workflows

| Workflow Type | Project Types | Planner | Reviewer | Supplemental Reviewers | Validator | Designer | Implementer | Architect |
|---------------|--------------|---------|----------|----------------------|-----------|----------|-------------|-----------|
| Software Development | `web-app`, `automation` | product-manager | code-reviewer | security-reviewer (web-app), performance-reviewer | test-writer | — | software-engineer | software-architect |
| Data Engineering | `data-engineering` | product-manager | code-reviewer | security-reviewer, performance-reviewer | data-quality-engineer | — | data-engineer | data-architect |
| Analytics Engineering | `analytics-engineering` | product-manager | code-reviewer | performance-reviewer | test-writer | visualization-designer | data-engineer | data-architect |
| Data App | `data-app` | product-manager | code-reviewer | performance-reviewer | test-writer | visualization-designer | data-analyst | data-architect |
| ML Engineering | `ml-engineering` | experiment-planner | code-reviewer | performance-reviewer | model-evaluator | — | ml-engineer | data-architect |
| AI Engineering | `ai-engineering` | product-manager | code-reviewer, prompt-reviewer | security-reviewer, performance-reviewer | eval-engineer | — | ai-engineer | software-architect |
| Library | `library` | api-designer | code-reviewer | performance-reviewer | test-writer | — | software-engineer | software-architect |

**Sprint coordination** (scrum-master) is a complexity-triggered
procedure — it activates when a project's work includes story-type or
epic-type backlog items, regardless of which domain workflow is
installed. The orchestrator assesses this at bootstrap, at
adopt/add-workflow, and mid-project.

### Analytics Workflow

| Workflow Type | Planner | Reviewer | Supplemental Reviewers | Validator | Designer | Implementer | Architect |
|---------------|---------|----------|----------------------|-----------|----------|-------------|-----------|
| Analytics | analysis-planner | logic-reviewer | performance-reviewer | data-validator | visualization-designer | data-analyst | *(none)* |

### Task Workflow (Base)

| Workflow Type | Planner | Reviewer | Validator | Implementer |
|---------------|---------|----------|-----------|-------------|
| Task | planner | reviewer | validator | implementer |

### Agentic Workflow

| Workflow Type | Planner | Reviewer | Validator | Implementer | Architect | Coordinator |
|---------------|---------|----------|-----------|-------------|-----------|-------------|
| Agentic (structural) | workflow-planner | methodology-reviewer | structural-validator | agentic-engineer | context-architect | scrum-master *(for change backlog sequencing)* |

**Operational mode:** Agentic-workflow projects may optionally have an operational mode for day-to-day system operation. Operational sessions are human-initiated and interactive — no additional agents are added. See the workflow file for details.

## Multi-Type Projects

When a project has multiple workflow types (e.g., `web-app` + `ai-engineering`), install the union of all agents. If two types specify different agents for the same role, install both — they serve complementary purposes. For example, `ai-engineering` installs both `code-reviewer` and `prompt-reviewer` as reviewers.

## Agent Frontmatter

Agent prompt files carry YAML frontmatter declaring model metadata
used for token cost estimation. Frontmatter is metadata for the
estimation system — it does not change agent behavior. An agent
functions identically with or without frontmatter.

For the full frontmatter schema, override cascade, and format
requirements, see `core/agents/agent-frontmatter-spec.md`.

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

For dispatch contracts (what the orchestrator provides each agent at each invocation point), see `core/workflows/protocols/dispatch-protocol.md`.

## Agent Files

| File | Role | Archetype | Skill | Used by |
|------|------|-----------|-------|---------|
| `product-manager.md` | Planner | Planner | planner + product domain | web-app, data-app, analytics-engineering, data-engineering, ai-engineering, automation |
| `experiment-planner.md` | Planner | Planner | planner + experiment design | ml-engineering |
| `api-designer.md` | Planner | Planner | planner + API design | library |
| `analysis-planner.md` | Planner | Planner | planner + analytics domain | analytics workflow |
| `code-reviewer.md` | Reviewer | Reviewer | reviewer + software review | all domain workflows |
| `logic-reviewer.md` | Reviewer | Reviewer | reviewer + data logic review | analytics workflow |
| `prompt-reviewer.md` | Supplemental Reviewer | Reviewer | reviewer + prompt quality | ai-engineering |
| `security-reviewer.md` | Supplemental Reviewer | Reviewer | reviewer + security assessment | web-app, data-engineering, ai-engineering |
| `performance-reviewer.md` | Supplemental Reviewer | Reviewer | reviewer + performance assessment | all workflow types |
| `test-writer.md` | Validator | Validator | validator + test execution | web-app, data-app, analytics-engineering, automation, library |
| `data-quality-engineer.md` | Validator | Validator | validator + data quality | data-engineering |
| `model-evaluator.md` | Validator | Validator | validator + model evaluation | ml-engineering |
| `eval-engineer.md` | Validator | Validator | validator + LLM evaluation | ai-engineering |
| `data-validator.md` | Validator | Validator | validator + data validation | analytics workflow |
| `visualization-designer.md` | Designer | Designer | designer + visualization | analytics workflow, data-app, analytics-engineering |
| `scrum-master.md` | Coordinator | Coordinator | coordinator + sprint ceremony | complexity-triggered (story/epic work), agentic-workflow (change backlog) |
| `methodology-reviewer.md` | Reviewer | Reviewer | reviewer + methodology assessment | agentic-workflow |
| `structural-validator.md` | Validator | Validator | validator + structural verification | agentic-workflow |
| `workflow-planner.md` | Planner | Planner | planner + methodology planning | agentic-workflow |
| `agentic-engineer.md` | Implementer | Implementer | implementer + methodology | agentic-workflow |
| `context-architect.md` | Architect | Architect | architect + instruction architecture | agentic-workflow |
| `software-architect.md` | Architect | Architect | architect + software architecture | web-app, automation, library, ai-engineering |
| `data-architect.md` | Architect | Architect | architect + data architecture | data-engineering, analytics-engineering, data-app, ml-engineering |
| `software-engineer.md` | Implementer | Implementer | implementer + software domain | web-app, automation, library |
| `data-engineer.md` | Implementer | Implementer | implementer + data engineering | data-engineering, analytics-engineering |
| `data-analyst.md` | Implementer | Implementer | implementer + analytics domain | analytics workflow, data-app |
| `ml-engineer.md` | Implementer | Implementer | implementer + ML domain | ml-engineering |
| `ai-engineer.md` | Implementer | Implementer | implementer + AI domain | ai-engineering |
| `planner.md` | Planner | Planner | planner (base skill) | task-workspace (base agent) |
| `implementer.md` | Implementer | Implementer | implementer (base skill) | task-workspace (base agent) |
| `reviewer.md` | Reviewer | Reviewer | reviewer (base skill) | task-workspace (base agent) |
| `validator.md` | Validator | Validator | validator (base skill) | task-workspace (base agent) |
