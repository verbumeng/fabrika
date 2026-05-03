---
type: system-update-plan
change-request: planning/PRD-15-token-cost-estimation.md
status: aligned
created: 2026-05-02
---

# System Update Plan: Token Cost Estimation (PRD-15)

## File Change Inventory

### New files

| # | File | Purpose |
|---|------|---------|
| 1 | `core/workflows/token-estimation.md` | Centralized estimation protocol document. Defines: script invocation contract (CLI surface, JSON input/output schema), readout format (token band + calibration metadata + optional dollar costs), calibration update protocol (post-workflow hook invocation), cadence rules (when estimation surfaces), and worked examples. Referenced by development-workflow, analytics-workspace, and agentic-workflow-lifecycle with one-line pointers. |
| 2 | `core/scripts/estimate-tokens.py` | Deterministic Python estimator. Receives agent list (as JSON) from the orchestrator, reads calibration data, priors, and pricing. Applies iteration multiplier per agent role. Emits structured JSON. Invoked via `uv run`. |
| 3 | `core/scripts/README.md` | Convention document for `core/scripts/`. States: scripts here are deterministic helpers invokable by the orchestrator, ship to consumers verbatim, require only `uv` (no per-script environments), and are not agents. |
| 4 | `core/calibration/priors.yml` | Bundled tier-level priors (the table from Decision 5) plus the model-to-tier lookup table covering all current Claude and GPT models. |
| 5 | `core/templates/Calibration-Template.yml` | Template for consumer-project calibration file (`.fabrika/calibration.yml`). Empty structure with comments explaining each section. Scaffolded at bootstrap time. |
| 6 | `core/agents/agent-frontmatter-spec.md` | Defines the YAML frontmatter schema for agent prompts: `model` (concrete model ID, optional), `model_tier` (low/mid/high, optional, default mid), future extensibility notes. Documents the override cascade: per-agent frontmatter -> per-project config -> conversational override. Documents relationship between archetypes (declare required fields) and concrete agents (provide values). Referenced from AGENT-CATALOG.md. |
| 7 | `core/calibration/pricing.yml` | Per-model $/1M-token pricing (input and output rates). Separated from priors.yml for easier patch-level updates when providers change pricing. Referenced by `estimate-tokens.py` via `--pricing` argument. |

### Modified files

| # | File | What changes |
|---|------|-------------|
| 8 | `core/workflows/development-workflow.md` | One-line reference to `token-estimation.md` inserted after the planner returns a spec and before the owner approval step (line ~35 area, within "Starting a Story" step 5). Text: "After the spec is drafted, invoke `core/workflows/token-estimation.md` to present the token cost estimate alongside the spec briefing." |
| 9 | `core/workflows/analytics-workspace.md` | One-line reference at each plan-presentation seam. In the Tier 1 Plan phase and Tier 2 Plan phase, after the plan is written: "After the plan is written, present the token cost estimate per `[FABRIKA_PATH]/core/workflows/token-estimation.md`." |
| 10 | `core/workflows/agentic-workflow-lifecycle.md` | One-line reference inside Step 2 (Align), at the seam where the workflow-planner's output is presented to the owner. Insert after "Present the plan using the Structural Plan Briefing format" paragraph: "Include the token cost estimate per `core/workflows/token-estimation.md` in the plan presentation." |
| 11 | `core/workflows/design-alignment.md` | Soft note added to the "Walk the Design Tree" section under Constraints. One sentence: "The orchestrator may informally mention expected token cost when a scope decision would significantly change it — this is conversational awareness, not a structured estimate (see `core/workflows/token-estimation.md` for when structured estimates surface)." |
| 12 | `core/agents/product-manager.md` | Add YAML frontmatter: `---\nmodel: claude-opus-4-6\nmodel_tier: high\n---` |
| 13 | `core/agents/experiment-planner.md` | Add YAML frontmatter: `---\nmodel: claude-opus-4-6\nmodel_tier: high\n---` |
| 14 | `core/agents/api-designer.md` | Add YAML frontmatter: `---\nmodel: claude-opus-4-6\nmodel_tier: high\n---` |
| 15 | `core/agents/analysis-planner.md` | Add YAML frontmatter: `---\nmodel: claude-opus-4-6\nmodel_tier: high\n---` |
| 16 | `core/agents/code-reviewer.md` | Add YAML frontmatter: `---\nmodel: claude-opus-4-6\nmodel_tier: high\n---` |
| 17 | `core/agents/logic-reviewer.md` | Add YAML frontmatter: `---\nmodel: claude-opus-4-6\nmodel_tier: high\n---` |
| 18 | `core/agents/prompt-reviewer.md` | Add YAML frontmatter: `---\nmodel: claude-opus-4-6\nmodel_tier: high\n---` |
| 19 | `core/agents/security-reviewer.md` | Add YAML frontmatter: `---\nmodel: claude-opus-4-6\nmodel_tier: high\n---` |
| 20 | `core/agents/performance-reviewer.md` | Add YAML frontmatter: `---\nmodel: claude-sonnet-4-6\nmodel_tier: mid\n---` |
| 21 | `core/agents/test-writer.md` | Add YAML frontmatter: `---\nmodel: claude-sonnet-4-6\nmodel_tier: mid\n---` (strategy phase uses Opus per Model Routing table, but the validator archetype execution phase dominates token usage — use mid as the representative tier) |
| 22 | `core/agents/data-quality-engineer.md` | Add YAML frontmatter: `---\nmodel: claude-sonnet-4-6\nmodel_tier: mid\n---` |
| 23 | `core/agents/model-evaluator.md` | Add YAML frontmatter: `---\nmodel: claude-sonnet-4-6\nmodel_tier: mid\n---` |
| 24 | `core/agents/eval-engineer.md` | Add YAML frontmatter: `---\nmodel: claude-sonnet-4-6\nmodel_tier: mid\n---` |
| 25 | `core/agents/data-validator.md` | Add YAML frontmatter: `---\nmodel: claude-sonnet-4-6\nmodel_tier: mid\n---` |
| 26 | `core/agents/visualization-designer.md` | Add YAML frontmatter: `---\nmodel: claude-sonnet-4-6\nmodel_tier: mid\n---` |
| 27 | `core/agents/scrum-master.md` | Add YAML frontmatter: `---\nmodel: claude-opus-4-6\nmodel_tier: high\n---` |
| 28 | `core/agents/methodology-reviewer.md` | Add YAML frontmatter: `---\nmodel: claude-opus-4-6\nmodel_tier: high\n---` |
| 29 | `core/agents/structural-validator.md` | Add YAML frontmatter: `---\nmodel: claude-opus-4-6\nmodel_tier: high\n---` |
| 30 | `core/agents/workflow-planner.md` | Add YAML frontmatter: `---\nmodel: claude-opus-4-6\nmodel_tier: high\n---` |
| 31 | `core/agents/context-engineer.md` | Add YAML frontmatter: `---\nmodel: claude-opus-4-6\nmodel_tier: high\n---` |
| 32 | `core/agents/context-architect.md` | Add YAML frontmatter: `---\nmodel: claude-opus-4-6\nmodel_tier: high\n---` |
| 33 | `core/agents/software-architect.md` | Add YAML frontmatter: `---\nmodel: claude-opus-4-6\nmodel_tier: high\n---` |
| 34 | `core/agents/data-architect.md` | Add YAML frontmatter: `---\nmodel: claude-opus-4-6\nmodel_tier: high\n---` |
| 35 | `core/agents/software-engineer.md` | Add YAML frontmatter: `---\nmodel: claude-sonnet-4-6\nmodel_tier: mid\n---` |
| 36 | `core/agents/data-engineer.md` | Add YAML frontmatter: `---\nmodel: claude-sonnet-4-6\nmodel_tier: mid\n---` |
| 37 | `core/agents/data-analyst.md` | Add YAML frontmatter: `---\nmodel: claude-sonnet-4-6\nmodel_tier: mid\n---` |
| 38 | `core/agents/ml-engineer.md` | Add YAML frontmatter: `---\nmodel: claude-sonnet-4-6\nmodel_tier: mid\n---` |
| 39 | `core/agents/ai-engineer.md` | Add YAML frontmatter: `---\nmodel: claude-sonnet-4-6\nmodel_tier: mid\n---` |
| 40 | `core/agents/archetypes/planner.md` | Add a "Required Frontmatter" section declaring that concrete planner agents must provide `model` or `model_tier`. Reference `core/agents/agent-frontmatter-spec.md` for schema. |
| 41 | `core/agents/archetypes/reviewer.md` | Same pattern — "Required Frontmatter" section. |
| 42 | `core/agents/archetypes/validator.md` | Same pattern ��� "Required Frontmatter" section. |
| 43 | `core/agents/archetypes/coordinator.md` | Same pattern — "Required Frontmatter" section. |
| 44 | `core/agents/archetypes/designer.md` | Same pattern — "Required Frontmatter" section. |
| 45 | `core/agents/archetypes/implementer.md` | Same pattern — "Required Frontmatter" section. |
| 46 | `core/agents/archetypes/architect.md` | Same pattern — "Required Frontmatter" section. |
| 47 | `core/agents/AGENT-CATALOG.md` | Add a new section "Agent Frontmatter" between the current "Agent Archetypes" section and the "Agent Files" table. Content: one paragraph explaining that agent prompt files carry YAML frontmatter with model metadata, plus a cross-reference to `agent-frontmatter-spec.md` for the full schema. Do NOT embed the schema in the catalog. |
| 48 | `core/Document-Catalog.md` | Four additions: (1) Under "agentic-workflow Documents" section, add entry for `core/calibration/priors.yml` (bundled framework artifact, framework-level). (2) Add entry for `core/calibration/pricing.yml` (per-model pricing data, framework-level). (3) Under Templates "Included based on project type" list, add `Calibration-Template.yml` for all types. (4) Under agentic-workflow documents, add `.fabrika/calibration.yml` as a consumer-project artifact (per-project calibration data, scaffolded at bootstrap). |
| 49 | `core/FABRIKA.md` | Add a paragraph in the "What `.fabrika/` contains" section documenting `calibration.yml` (per-project calibration data for token estimation — updated automatically after workflow runs). Add a new section "Framework Scripts" noting that `core/scripts/` contains deterministic helpers invokable by the orchestrator (if not already captured in `core/scripts/README.md` — keep FABRIKA.md as the surface-level pointer, README.md as the detail). |
| 50 | `Domain-Language.md` | Add entries under a new "Token Estimation" domain area: **calibration** (per-project data that improves estimation over time), **tier-level prior** (bundled baseline estimate per model tier), **EWMA blend** (exponentially weighted moving average formula combining priors with local data), **iteration multiplier** (scaling factor applied to agents that participate in review-revise cycles), **soft invalidation** (calibration data becomes stale when model identifier changes — falls back to priors rather than migrating old data), **calibration key** (the unique identifier for a calibration entry: workflow + agent + model). |
| 51 | `integrations/claude-code/CLAUDE.md` | Two changes: (1) In the "Development Workflow" summary section (line ~311), add a note: "Token cost estimates are presented alongside plan/spec briefings — see `[FABRIKA_PATH]/core/workflows/token-estimation.md`." (2) In the existing "Model Routing" table (lines 64-73), add a footnote: "Agent model preferences are declared in frontmatter on each agent prompt file. The `model` field drives token cost estimation; consumers can override per-project via `.fabrika/calibration.yml`." |
| 52 | `integrations/copilot/copilot-instructions.md` | Parallel change. Add note about token estimation availability. Copilot custom agents (`.github/agents/*.agent.md`) support `model:` in frontmatter using display names (e.g., "Claude Opus 4.5") — VS Code Copilot Chat respects this field. Add integration guidance showing display-name format for Copilot vs. API-ID format for Claude Code. Add a "Copilot CLI Limitation" note: the Copilot CLI does NOT yet respect `model:` frontmatter (feature parity on GitHub roadmap). Token estimation still functions in CLI contexts (reads frontmatter for cost calculation). For VS Code users (the primary path), model routing works end-to-end. |
| 53 | `MANIFEST_SPEC.md` | Two additions: (1) Add `token_budget_warn` to a new "Project Config Fields" section — optional integer (tokens), default: not set. When set, the orchestrator displays a soft warning if an estimate exceeds this threshold. (2) In the "Location" section, expand the `.fabrika/` directory contents to explicitly enumerate all possible contents: `manifest.yml`, `calibration.yml` (new), `evals/sprint-NN.md`, `FABRIKA.md`. |
| 54 | `BOOTSTRAP.md` | Add a step after agent installation (in both sprint-based Phase 2 and analytics-workspace Phase 2W) to scaffold `.fabrika/calibration.yml` from `core/templates/Calibration-Template.yml`. One line: "Copy `core/templates/Calibration-Template.yml` to `.fabrika/calibration.yml`." Also add `core/scripts/estimate-tokens.py`, `core/calibration/priors.yml`, and `core/calibration/pricing.yml` to the "files copied from Fabrika" inventory. |
| 55 | `UPDATE.md` | Add guidance for existing consumers picking up 0.24.0: scaffold the calibration file, copy new core/scripts/ and core/calibration/ files, note that agent frontmatter additions are non-breaking (agents work without frontmatter — default tier is mid). |
| 56 | `MIGRATIONS.md` | New entry for 0.24.0 (see CHANGELOG Draft below for content). |
| 57 | `README.md` | Add "Token cost estimation" to the feature list bullet points ("What's in the box" section). Add brief description: "Cost-informed planning with deterministic token estimation, calibration, and advisory budget warnings." |
| 58 | `VERSION` | `0.23.0` -> `0.24.0` |
| 59 | `CHANGELOG.md` | New entry under 0.24.0 (see CHANGELOG Draft section below). |

---

## Open Items Resolution

The PRD listed six open items for the planner to resolve. Here are concrete recommendations:

### 1. CLI surface for `estimate-tokens.py`

**Resolved (owner decision: orchestrator passes agent list):**

```
uv run core/scripts/estimate-tokens.py \
  --agents '<json-list>' \
  --calibration <path-to-calibration-file> \
  --priors <path-to-priors-file> \
  --pricing <path-to-pricing-file> \
  [--override-model <model-id>] \
  [--override-tier <low|mid|high>] \
  [--record-actuals --actual-input <int> --actual-output <int> --workflow <id> --agent <id> --model <id>]
```

**`--agents` JSON format (passed by the orchestrator):**

```json
[
  {
    "agent": "code-reviewer",
    "model": "claude-opus-4-6",
    "tier": "high",
    "iteration_multiplier": 2
  },
  {
    "agent": "software-engineer",
    "model": "claude-sonnet-4-6",
    "tier": "mid",
    "iteration_multiplier": 1
  }
]
```

The orchestrator constructs this list from the plan context (it already knows which agents are being dispatched). The script is purely computational — it takes the agent list + calibration + priors + pricing and emits the estimate. No plan-parsing logic needed in the script.

**Output JSON schema (estimation mode):**

```json
{
  "estimate": {
    "total_input_tokens": { "low": 45000, "high": 82000 },
    "total_output_tokens": { "low": 12000, "high": 28000 },
    "dollar_cost": { "low": 0.42, "high": 0.78, "available": true },
    "per_agent": [
      {
        "agent": "code-reviewer",
        "model": "claude-opus-4-6",
        "tier": "high",
        "input_tokens": { "low": 15000, "high": 30000 },
        "output_tokens": { "low": 5000, "high": 8000 },
        "iteration_multiplier": 2
      }
    ]
  },
  "calibration": {
    "run_count": 7,
    "typical_error_pct": 25,
    "state": "calibrated"
  },
  "warnings": []
}
```

**Output JSON schema (record-actuals mode):**

```json
{
  "recorded": true,
  "key": "agentic-workflow-lifecycle.methodology-reviewer.claude-opus-4-6",
  "new_run_count": 8
}
```

### 2. Initial smoothing constant k

**Recommendation: k = 5.**

Rationale: With k=5, after 5 local runs the weight is 50/50 between local data and priors. After 10 runs, local data dominates at 67%. After 20, at 80%. This is conservative enough that one wildly expensive run doesn't immediately skew the estimate, but responsive enough that 5+ consistent observations shift it meaningfully. The constant is declared in `core/calibration/priors.yml` so consumers can override it in their project calibration file if needed.

### 3. Model-to-tier lookup table contents

**Recommendation (lives in `core/calibration/priors.yml`):**

```yaml
model_tier_lookup:
  # Claude models
  claude-opus-4-6: high
  claude-opus-4-5: high
  claude-sonnet-4-6: mid
  claude-sonnet-4-5: mid
  claude-haiku-4-5: low
  claude-haiku-3-5: low
  # GPT models
  gpt-4o: high
  gpt-4o-mini: low
  gpt-4-turbo: high
  gpt-4: high
  gpt-3.5-turbo: low
  o1: high
  o1-mini: mid
  o3: high
  o3-mini: mid
  o4-mini: mid
  # Gemini models
  gemini-2.5-pro: high
  gemini-2.5-flash: mid
  gemini-2.0-flash: low
```

The lookup table is extensible — consumers can add entries in their project calibration file for models not in the bundled list. Unknown models default to `mid`.

### 4. Token-estimation.md structure

**Recommendation — document outline:**

```markdown
# Token Cost Estimation Protocol

## When Estimation Surfaces
- Table: moment -> behavior (from PRD Decision 9)

## Invoking the Estimator
- CLI invocation example
- JSON input/output schema reference
- How the orchestrator reads the output and formats the readout

## Readout Format
- With concrete model (tokens + dollars + calibration metadata)
- With tier only (tokens only + hint to declare model)
- Subscription caveat language

## Calibration
### How calibration works
- EWMA blend formula
- Smoothing constant k
- Calibration key structure
### When calibration updates
- Post-workflow hook: `--record-actuals` invocation
- Trigger: session close-out when token data is available
### Soft invalidation
- Model change behavior

## Budget Warning (Advisory)
- `token_budget_warn` field
- Orchestrator behavior when exceeded

## Worked Examples
### Example 1: Sprint story with 3 agents, calibrated
### Example 2: Agentic-workflow change, uncalibrated (first run)
### Example 3: Analytics task with tier-only declarations
```

### 5. Copilot integration — model field format differences

**Resolved (owner research incorporated):**

Copilot custom agents (`.github/agents/*.agent.md`) use `model:` in YAML frontmatter — structurally identical to Fabrika's agent frontmatter. Key differences:

- **VS Code Copilot Chat** respects `model:` in frontmatter — this is the owner's primary usage path, and it works end-to-end
- **Copilot CLI** does NOT yet respect `model:` frontmatter (feature parity on GitHub roadmap)
- **Value format differs:** Copilot uses display names ("Claude Opus 4.5"), Claude Code uses API IDs ("claude-opus-4-6")

The `copilot-instructions.md` integration template documents:

- That `model:` is the same concept across both platforms with different value formats
- Integration-appropriate examples: display names for Copilot agents, API IDs for Claude Code agents
- The CLI-only limitation: for users who work in VS Code (the primary path), model routing works. CLI users must manually select the matching model
- Token estimation works regardless — it reads the frontmatter for cost calculation in both contexts

This is NOT a namespace collision (the same field, same semantics, just different string formats). No code workaround needed.

### 6. Calibration update trigger

**Recommendation:** Calibration updates happen during session close-out, not as a separate workflow hook. The trigger is:

1. During session close-out (step 15 in the CLAUDE.md session lifecycle, where "tokens consumed" is already logged), the orchestrator checks whether token data is available from the tool.
2. If available, the orchestrator invokes `estimate-tokens.py --record-actuals` with the actual input/output tokens, the workflow type, each agent invoked, and the model used.
3. The script updates `.fabrika/calibration.yml` in place.
4. This is a zero-cost addition to close-out — the data is already collected; the script call is one Bash invocation.

For agentic-workflow projects, the trigger is during Step 7 (Ship), after the commit but before the PR — the orchestrator records actuals for each agent that was invoked during the structural update.

The `token-estimation.md` document will specify this cadence.

---

## Integration Point Analysis

### Cross-reference chains affected

| Chain | Impact |
|-------|--------|
| Agent prompts -> AGENT-CATALOG -> dispatch-protocol | AGENT-CATALOG gets a new "Agent Frontmatter" section pointing to the spec. Dispatch-protocol itself is NOT modified — dispatch contracts don't change; estimation is an orchestrator-level concern, not a dispatch contract. |
| Agent prompts -> archetypes | Each archetype gains a "Required Frontmatter" section. Each concrete agent gains actual frontmatter. The archetype declares the requirement; the concrete agent fulfills it. |
| Workflow files -> integration templates | development-workflow, analytics-workspace, and agentic-workflow-lifecycle each gain a one-line pointer. Integration templates (CLAUDE.md, copilot-instructions.md) gain summary notes about estimation availability. |
| Document-Catalog -> templates -> BOOTSTRAP | New template (Calibration-Template.yml) added to Document-Catalog, copied during bootstrap. New document types (calibration.yml, priors.yml) documented in the catalog. |
| MANIFEST_SPEC -> BOOTSTRAP -> UPDATE | MANIFEST_SPEC documents the new `.fabrika/calibration.yml` contents and the `token_budget_warn` config field. BOOTSTRAP scaffolds the file. UPDATE guides existing consumers to add it. |
| VERSION -> CHANGELOG -> MIGRATIONS | Standard versioning chain. |
| README -> feature list | One bullet point addition. |

### What does NOT need to change (explicitly confirmed)

- `core/workflows/dispatch-protocol.md` — token estimation is orchestrator-level, not a dispatch contract addition
- `core/briefings/` — the briefing principles already say "include token efficiency data when available"; estimation just makes that data available earlier (at plan time vs. only at session close). No briefing format changes needed.
- `core/hooks/` — no hook changes; calibration update is embedded in session close-out logic
- `core/topologies/` — sprint contracts unchanged
- `core/evals/` — no eval changes
- `core/rubrics/` — no rubric changes
- `core/maintenance-checklist.md` — no change needed; calibration data is not a maintenance concern (it self-maintains via EWMA)

---

## Risk Identification

| # | Risk | Severity | Likelihood |
|---|------|----------|------------|
| R1 | Frontmatter addition breaks existing agent file parsing in consumer projects that use regex-based tools to read agent prompts | Medium | Low — most consumers load agents as full-text prompt injection; YAML frontmatter delimiters (`---`) are inert text to an LLM |
| R2 | The estimation script becomes a maintenance burden — model pricing changes, new models release | Low | High — pricing changes quarterly |
| R3 | Consumers treat advisory estimates as commitments and complain about accuracy | Medium | Medium |
| R4 | The `core/scripts/` precedent leads to script proliferation without discipline | Low | Low (captured in README.md) |
| R5 | Copilot and Claude Code use different value formats for the `model:` field (display names vs. API IDs) — consumers managing agents for both platforms need clear guidance on which format to use where | Low | Medium |

---

## Mitigations

| Risk | Mitigation |
|------|-----------|
| R1 | Document in MIGRATIONS.md that frontmatter is non-breaking (agents work without it; the `---` delimiters are ignored by LLMs reading the prompt as text). Add a note in agent-frontmatter-spec.md that frontmatter MUST come before any other content (first thing in the file) so tooling can reliably strip or parse it. |
| R2 | Pricing data lives in `core/calibration/pricing.yml` (separate file, easy to update independently of priors). The HARVEST flow already handles periodic framework updates. Add a note in token-estimation.md that pricing.yml should be refreshed when model pricing changes — this is a patch-level bump. |
| R3 | The readout format always includes the calibration state and typical error percentage. The subscription caveat is mandatory when dollar costs are shown. token-estimation.md explicitly states estimates are advisory. |
| R4 | `core/scripts/README.md` establishes admission criteria: scripts must be deterministic, stateless (read inputs, emit JSON), require only `uv`, and serve a clearly defined orchestrator need. |
| R5 | Document in agent-frontmatter-spec.md and copilot-instructions.md that the `model:` field uses different value formats per platform: API IDs for Claude Code (e.g., `claude-opus-4-6`), display names for Copilot (e.g., `Claude Opus 4.5`). Provide clear examples of both in the integration template. The estimator script reads whatever value is in `model:` and resolves it via the model-to-tier lookup in priors.yml (which should include both formats as keys). |

---

## Version Bump Determination

**Bump type: minor (0.23.0 -> 0.24.0)**

Rationale: Adds new files under `core/` (core/workflows/token-estimation.md, core/scripts/, core/calibration/, core/agents/agent-frontmatter-spec.md). Per bump rules, `core/**` changes trigger a minor bump. Integration and root-level doc changes (which would individually be patch) are subsumed by the minor bump.

---

## CHANGELOG Draft

```markdown
## 0.24.0

Token Cost Estimation. Adds cost-informed planning via a deterministic
Python estimator that surfaces token and dollar cost estimates at plan
time across all workflow types. Introduces two structural precedents:
YAML frontmatter on agent prompts (model metadata), and executable
scripts in core/scripts/.

### New files

- `core/workflows/token-estimation.md` -- **NEW.** Centralized
  estimation protocol: script CLI contract, readout format, calibration
  update protocol, cadence rules, worked examples. Referenced by all
  three workflow files with one-line pointers.
- `core/scripts/estimate-tokens.py` -- **NEW.** Deterministic Python
  estimator. Receives agent list from orchestrator + calibration +
  priors + pricing, emits JSON. Requires `uv run`.
- `core/scripts/README.md` -- **NEW.** Convention document for
  core/scripts/ (admission criteria, runtime expectations).
- `core/calibration/priors.yml` -- **NEW.** Bundled tier-level priors
  and model-to-tier lookup table.
- `core/calibration/pricing.yml` -- **NEW.** Per-model $/1M-token
  pricing (input and output rates). Separate file for easy patch
  updates when providers change pricing.
- `core/templates/Calibration-Template.yml` -- **NEW.** Template for
  consumer `.fabrika/calibration.yml`.
- `core/agents/agent-frontmatter-spec.md` -- **NEW.** YAML frontmatter
  schema for agent prompts (model, model_tier, extensibility).

### Core (changed -- consumer projects should update)

- `core/workflows/development-workflow.md` -- **CHANGED.** One-line
  pointer to token-estimation.md at plan-presentation step.
- `core/workflows/analytics-workspace.md` -- **CHANGED.** One-line
  pointer at Tier 1 and Tier 2 plan phases.
- `core/workflows/agentic-workflow-lifecycle.md` -- **CHANGED.**
  One-line pointer in Step 2 (Align) at plan presentation.
- `core/workflows/design-alignment.md` -- **CHANGED.** Soft note
  about informal cost-awareness during Q&A walk.
- `core/agents/*.md` (28 concrete agents) -- **CHANGED.** YAML
  frontmatter added with model/model_tier declarations. Non-breaking
  -- agents function identically without frontmatter.
- `core/agents/archetypes/*.md` (7 archetypes) -- **CHANGED.**
  "Required Frontmatter" section added to each archetype.
- `core/agents/AGENT-CATALOG.md` -- **CHANGED.** New "Agent
  Frontmatter" section cross-referencing agent-frontmatter-spec.md.
- `core/Document-Catalog.md` -- **CHANGED.** New entries for
  calibration.yml (consumer artifact), priors.yml (framework artifact),
  pricing.yml (framework artifact), Calibration-Template.yml (template).
- `core/FABRIKA.md` -- **CHANGED.** Documents calibration.yml in
  .fabrika/ contents and surfaces core/scripts/ convention.

### Root (changed -- consumer projects should update)

- `Domain-Language.md` -- **CHANGED.** New "Token Estimation" domain
  area with 6 terms.
- `MANIFEST_SPEC.md` -- **CHANGED.** token_budget_warn config field,
  expanded .fabrika/ directory contents.
- `BOOTSTRAP.md` -- **CHANGED.** Scaffolds calibration.yml, copies
  estimator script and priors.
- `UPDATE.md` -- **CHANGED.** 0.24.0 update guidance.
- `MIGRATIONS.md` -- **CHANGED.** 0.24.0 migration entry.
- `README.md` -- **CHANGED.** Token estimation in feature list.

### Integrations (changed -- consumer projects should update)

- `integrations/claude-code/CLAUDE.md` -- **CHANGED.** Token
  estimation availability note, frontmatter footnote on Model Routing.
- `integrations/copilot/copilot-instructions.md` -- **CHANGED.**
  Token estimation availability note, Copilot CLI limitation
  documentation.

### Consumer update instructions

1. Copy new files:
   - `core/workflows/token-estimation.md`
   - `core/scripts/estimate-tokens.py`
   - `core/scripts/README.md`
   - `core/calibration/priors.yml`
   - `core/calibration/pricing.yml`
   - `core/templates/Calibration-Template.yml`
   - `core/agents/agent-frontmatter-spec.md`
2. Scaffold `.fabrika/calibration.yml` from
   `core/templates/Calibration-Template.yml`
3. Update workflow files (one-line pointer additions):
   - `core/workflows/development-workflow.md`
   - `core/workflows/analytics-workspace.md`
   - `core/workflows/agentic-workflow-lifecycle.md`
   - `core/workflows/design-alignment.md`
4. Update agent prompts with frontmatter (non-breaking -- agents work
   without it, but estimation accuracy improves with it). Copy updated
   versions from Fabrika source, or manually add frontmatter per
   `core/agents/agent-frontmatter-spec.md`.
5. Update archetype files (add Required Frontmatter sections)
6. Update AGENT-CATALOG.md (new section)
7. Update Document-Catalog.md (new entries)
8. Update FABRIKA.md (calibration.yml and scripts convention)
9. Update Domain-Language.md (new terms)
10. Update MANIFEST_SPEC.md (token_budget_warn, .fabrika/ contents)
11. Update BOOTSTRAP.md (calibration scaffolding step)
12. Update integration template (CLAUDE.md or copilot-instructions.md)
13. Optionally configure `token_budget_warn` in project config
```

---

## MIGRATIONS.md Draft Entry

```markdown
## 0.24.0 -- Token Cost Estimation

**Affects:** All consumer projects.

**What changed:** Token cost estimation surfaces during plan alignment
across all workflow types. Agent prompt files gain YAML frontmatter
declaring model preferences. A deterministic Python script estimates
token costs from plan + agent metadata + per-project calibration. Per-
project calibration data accumulates in `.fabrika/calibration.yml` and
improves estimates over time via EWMA blending.

**Migration steps:**

1. **Copy new files.** Copy the following from Fabrika source:
   - `core/workflows/token-estimation.md`
   - `core/scripts/estimate-tokens.py`
   - `core/scripts/README.md`
   - `core/calibration/priors.yml`
   - `core/calibration/pricing.yml`
   - `core/templates/Calibration-Template.yml`
   - `core/agents/agent-frontmatter-spec.md`

2. **Scaffold calibration file.** Copy
   `core/templates/Calibration-Template.yml` to
   `.fabrika/calibration.yml`. One-liner:
   `cp [FABRIKA_PATH]/core/templates/Calibration-Template.yml .fabrika/calibration.yml`

3. **Update agent prompts (non-breaking).** Either copy the updated
   agent files from Fabrika source (which now include frontmatter), or
   manually prepend frontmatter to your existing copies per the schema
   in `core/agents/agent-frontmatter-spec.md`. Agents that omit
   frontmatter default to `model_tier: mid` -- estimation still works
   but at reduced accuracy. Agents that benefit most from `model:`
   declarations: reviewers and planners (they dominate cost).

4. **Update workflow files.** Copy updated versions of:
   - `core/workflows/development-workflow.md`
   - `core/workflows/analytics-workspace.md`
   - `core/workflows/agentic-workflow-lifecycle.md`
   - `core/workflows/design-alignment.md`

5. **Update remaining core files.** Copy updated versions of:
   - `core/agents/AGENT-CATALOG.md`
   - `core/agents/archetypes/*.md` (all 7)
   - `core/Document-Catalog.md`
   - `core/FABRIKA.md`

6. **Update root-level files.** Copy updated versions of:
   - `Domain-Language.md`
   - `MANIFEST_SPEC.md`
   - `BOOTSTRAP.md`

7. **Update integration template.** Copy the updated CLAUDE.md or
   copilot-instructions.md from the integrations/ directory.

8. **(Optional) Set budget warning.** Add `token_budget_warn: 50000`
   (or your preferred threshold) to project config if you want soft
   warnings when estimates exceed a token budget.

**Behavioral changes after migration:**
- Plan presentations (spec briefings, analysis plan briefings,
  structural plan briefings) now include a token cost readout.
- Session close-out now records actual token usage to
  `.fabrika/calibration.yml` when token data is available.
- Budget warnings (if configured) trigger during plan alignment when
  estimates exceed the threshold. Advisory only -- never blocks.
- Agent prompts are behaviorally identical -- frontmatter is metadata
  for the estimator, not instructions for the agent.
```

---

## Owner Decision Points

All resolved during Step 2 alignment (2026-05-02):

1. **Model assignments for agents (files #12-39).** RESOLVED:
   Confirmed. Opus for planners, reviewers, architects, coordinators,
   and agentic-workflow agents; Sonnet for validators, designers, and
   implementers. Per-project override is first-class — prominently
   documented in `agent-frontmatter-spec.md` and `token-estimation.md`
   with the override cascade: per-agent frontmatter -> per-project
   config -> conversational override. Some consumer projects will need
   Sonnet-for-planning and Haiku-for-execution due to usage limits.

2. **Script parses plan files vs. orchestrator passes agent list.**
   RESOLVED: Orchestrator passes agent list. The script receives
   `--agents <json-list>` containing agent names, models, tiers, and
   iteration multipliers. No plan-parsing logic in the script — it is
   purely computational. This simplifies the script significantly.

3. **Calibration update trigger location.** RESOLVED: Confirmed.
   Session close-out (for sprint/analytics) and Step 7 Ship (for
   agentic-workflow). No change from recommendation.

4. **Smoothing constant k=5.** RESOLVED: Confirmed. k=5 accepted.

5. **Dollar pricing in priors.yml.** RESOLVED: Separate file.
   `core/calibration/pricing.yml` contains per-model $/1M-token
   pricing (input and output rates). Added as new file #7 in the
   inventory. CLI surface includes `--pricing <path>` argument.
   Easier patch-level updates when providers change pricing.

---

## Alignment History

### v2 — Step 2 alignment (2026-05-02)

Owner provided 6 decisions. All changes applied in place:

1. **Copilot integration reframed.** Research confirmed that Copilot
   custom agents DO support `model:` in VS Code (just not CLI). Updated
   file #52 description to reflect this. Reframed R5 from "namespace
   collision" to "different value formats" (Low severity). Updated Open
   Item #5 to document that VS Code is the primary path and it works.
   Added integration-appropriate examples (display names vs. API IDs).

2. **Model assignments confirmed with override emphasis.** No changes
   to agent assignments. Added override cascade documentation to file
   #6 (agent-frontmatter-spec.md) description. Marked Decision Point
   #1 as RESOLVED with note that per-project override is first-class.

3. **Orchestrator passes agent list (changed from script-parses-plan).**
   Updated file #2 description (estimate-tokens.py no longer reads plan
   files). Rewrote Open Item #1 CLI surface: removed `--plan`, added
   `--agents <json-list>` with JSON format spec. Removed the "decision
   point for owner" paragraph. Script is now purely computational.

4. **Calibration trigger confirmed.** No changes needed. Marked
   Decision Point #3 as RESOLVED.

5. **k=5 confirmed.** No changes needed. Marked Decision Point #4
   as RESOLVED.

6. **Separate pricing.yml confirmed.** Added `core/calibration/pricing.yml`
   as new file #7 in the inventory. Added `--pricing <path>` to the CLI
   surface in Open Item #1. Marked Decision Point #5 as RESOLVED.

**Files affected by this revision:** File Change Inventory (new file
#7, updated #2 and #6 and #52 descriptions, renumbered modified files
#8-59), Open Items #1 and #5, Risk R5, Mitigation R5, Mitigation R2,
Owner Decision Points (all marked RESOLVED), CHANGELOG Draft (added
pricing.yml, updated estimate-tokens.py description), MIGRATIONS Draft
(added pricing.yml to copy list), BOOTSTRAP entry (added pricing.yml).
