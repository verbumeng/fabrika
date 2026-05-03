# Agent Prompt Frontmatter Specification

Agent prompt files in `core/agents/` carry YAML frontmatter declaring
model metadata for token cost estimation. This is metadata for the
estimation system — it does not change agent behavior. An agent
functions identically with or without frontmatter.

## Schema

```yaml
---
model: <concrete-model-id>     # Optional. API model identifier.
model_tier: <low|mid|high>     # Optional. Fallback when model not declared.
---
```

**Resolution order:** The estimator reads `model` first. If absent,
falls back to `model_tier`. If both absent, defaults to `mid`.

When `model` is set, the estimator derives the tier via the
model-to-tier lookup table in `core/calibration/priors.yml`. Dollar
cost estimates are available only when `model` is set (pricing data
requires a concrete model identifier).

## Override Cascade

Three levels, with precedence (highest to lowest):

1. **Per-run conversational override** — owner states "estimate for
   Opus instead" after plan is drafted; orchestrator passes the
   override to the script
2. **Per-project config** — consumer projects override in
   `.fabrika/calibration.yml` under `model_overrides` or
   `model_tier_overrides`
3. **Per-agent frontmatter** — the default declared in the agent
   prompt file itself

This cascade means the values in agent frontmatter are DEFAULTS, not
mandates. Projects with usage constraints (e.g., Sonnet for planning,
Haiku for execution) override at the project level without modifying
agent source files.

## Format Requirements

- Frontmatter MUST be the first thing in the file (before any
  headings or content)
- Use standard YAML frontmatter delimiters (`---`)
- The `model` field uses API model identifiers (e.g.,
  `claude-opus-4-6`, `gpt-4o`)
- The `model_tier` field accepts: `low`, `mid`, `high`
- Both fields are optional — omitting both defaults to `mid` tier

## Archetype Relationship

Each archetype file in `core/agents/archetypes/` declares a "Required
Frontmatter" section specifying what frontmatter fields its concrete
agents should provide. This is guidance, not enforcement — the
estimation system handles missing fields gracefully via defaults.

## Integration Formats

Different integrations use different model name formats:

- **Claude Code / API:** API model IDs — `claude-opus-4-6`,
  `claude-sonnet-4-6`
- **GitHub Copilot (VS Code):** Display names — `Claude Opus 4.5`,
  `GPT-4o`. Supports preference arrays:
  `model: ['Claude Opus 4.5', 'GPT-5.2']`

Fabrika's canonical agent files use API model IDs. When copying agents
to `.github/agents/` for Copilot, convert to display names. The
estimation script reads API IDs only (from the canonical source).

## Future Extensibility

Additional frontmatter fields may be added in future versions (e.g.,
`context_budget`, `tools`). Tooling should ignore unknown fields
rather than failing.
