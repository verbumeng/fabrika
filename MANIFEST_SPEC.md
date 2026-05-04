# Manifest Specification

Every consumer project that has Fabrika installed carries a `.fabrika/manifest.yml` at the project root. This file is the single source of truth for what was installed, when, and what's been customized. It is committed to the consumer project's repository — it is not local-only state.

## Format

```yaml
# .fabrika/manifest.yml
fabrika_version: "0.1.0"                # version of Fabrika installed
project_type: analytics-engineering      # which project type was selected during bootstrap
integrations:                           # which tool integrations were installed
  - claude-code
  - copilot
installed_at: "2026-04-16"             # date Fabrika was first installed
updated_at: "2026-04-16"               # date of most recent Fabrika update
installed_files:                        # every file Fabrika placed in this project
  - path: .claude/agents/scrum-master.md
    source: core/agents/scrum-master.md
    source_version: "0.1.0"            # Fabrika version when this file was last installed/synced
    hash: "sha256:abc123..."           # sha256 hash of file contents at install time
    customized: false                  # set true if local hash drifts from install hash
  - path: .claude/agents/product-manager.md
    source: core/agents/product-manager.md
    source_version: "0.1.0"
    hash: "sha256:def456..."
    customized: false
  - path: CLAUDE.md
    source: integrations/claude-code/CLAUDE.md
    source_version: "0.1.0"
    hash: "sha256:789abc..."
    customized: true                   # user filled in project-specific sections
```

## Field Reference

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `fabrika_version` | string | yes | Semver string matching the Fabrika VERSION file at install/update time |
| `project_type` | string | yes | The project's workflow type: `web-app`, `data-app`, `analytics-engineering`, `data-engineering`, `ml-engineering`, `ai-engineering`, `automation`, `library`, `analytics-workflow`, `task-workspace`, `agentic-workflow`. Multi-type projects use the primary type. |
| `integrations` | list | yes | Tool integrations installed: `claude-code`, `copilot`, or both |
| `installed_at` | string | yes | ISO date of initial Fabrika installation |
| `updated_at` | string | yes | ISO date of most recent Fabrika update |
| `installed_files` | list | yes | Every file Fabrika placed in the project |
| `installed_files[].path` | string | yes | Path relative to project root where the file was placed |
| `installed_files[].source` | string | yes | Path relative to Fabrika repo root where the file originated |
| `installed_files[].source_version` | string | yes | Fabrika version when this specific file was last installed or synced |
| `installed_files[].hash` | string | yes | `sha256:` prefixed hex digest of file contents at install/sync time |
| `installed_files[].customized` | boolean | yes | `true` if the file's current hash differs from the install-time hash |

## Hash Algorithm

All hashes use SHA-256. The hash is computed over the raw file contents (bytes), not a normalized form. The format is `sha256:` followed by the lowercase hex digest.

## Project Config Fields

Optional configuration fields that modify framework behavior when set.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `token_budget_warn` | integer (tokens) | not set | When set, the orchestrator displays a soft warning if a token cost estimate exceeds this threshold. Advisory only — never blocks execution. The warning surfaces during plan alignment alongside the estimate readout. |

Project config fields are set in `.fabrika/manifest.yml` at the top level (alongside `fabrika_version`, `project_type`, etc.).

## Location

The manifest lives at `.fabrika/` in the consumer project root. The `.fabrika/` directory is committed to the consumer project's git repository. It contains:

- `.fabrika/manifest.yml` — The manifest itself (this spec)
- `.fabrika/calibration.yml` — Per-project calibration data for token cost estimation (scaffolded from `core/templates/Calibration-Template.yml` at bootstrap, updated automatically after workflow runs)
- `.fabrika/evals/sprint-NN.md` — Per-sprint evaluation artifacts (see HARVEST.md)
- `.fabrika/FABRIKA.md` — Framework relationship guide (read on demand by agents)

## When the Manifest is Written

- **BOOTSTRAP.md** generates the initial manifest after all files are copied
- **ADOPT.md** generates the manifest after tiered installation
- **UPDATE.md** updates the manifest after syncing files to a newer Fabrika version
- The `customized` field is updated whenever an update check detects hash drift

## Consumer Project Responsibility

The consumer project should commit `.fabrika/manifest.yml` and keep it in version control. It is the key that makes cheap updates possible — without it, updating requires full-repo diffing.
