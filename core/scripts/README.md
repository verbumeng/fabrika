# core/scripts/

Deterministic helper scripts invokable by the orchestrator during
workflow execution. These are NOT agents — they are computational
utilities that cost zero LLM tokens to run.

## Admission Criteria

Scripts in this directory must be:

- **Deterministic** — same inputs always produce same outputs
- **Stateless** — read inputs, emit JSON to stdout, optionally update
  a single state file (calibration data)
- **uv-runnable** — require only `uv run` with inline script metadata
  for dependencies (no separate venv, no requirements.txt)
- **Self-documenting** — include `--help` via argparse

## Runtime

All scripts use inline script metadata (PEP 723):

```python
# /// script
# requires-python = ">=3.11"
# dependencies = ["pyyaml"]
# ///
```

Invoke via: `uv run core/scripts/<script-name>.py [args]`

## Current Scripts

| Script | Purpose |
|--------|---------|
| `estimate-tokens.py` | Token cost estimation from agent list + calibration + priors + pricing |
