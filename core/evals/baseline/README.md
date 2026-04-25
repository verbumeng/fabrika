# Baseline Evaluation Cases

These eval cases ship with every Fabrika project and test fundamental agent behaviors that should always be correct regardless of project type, tech stack, or domain. They are the starting point — project-specific evals built from real observed failures (see the main `docs/evals/README.md`) supplement these over time.

## Purpose

Baseline evals catch regressions in core agent behaviors when prompts are modified. They test the "floor" — if an agent fails a baseline eval, something is fundamentally wrong with the prompt.

## Organization

Evals are organized by role archetype, not by specific agent. A `planner` eval applies to any planner agent (product-manager, experiment-planner, api-designer, analysis-planner). A `reviewer` eval applies to any reviewer agent (code-reviewer, logic-reviewer, prompt-reviewer).

```
baseline/
├── planner/       # Evals for all planner-role agents
├── reviewer/      # Evals for all reviewer-role agents
├── validator/     # Evals for all validator-role agents
└── coordinator/   # Evals for the scrum-master
```

## How to Use

During maintenance sessions, run baseline evals alongside project-specific evals:

1. For each baseline eval in the relevant archetype directory, present the Input to the agent
2. Compare the agent's output against the Expected Output criteria
3. Log results in the eval's Result Log
4. If a baseline eval fails after a prompt change, the change likely introduced a regression — investigate before keeping it

## When to Skip

Baseline evals are designed to be universal, but some may not apply:
- `analytics-workspace` projects skip coordinator evals (no scrum master)
- Validator evals reference "tests" generically — adapt the specific check to the validator type (test-writer runs unit tests, data-validator runs sanity checks, model-evaluator runs metrics, etc.)

## Relationship to Project-Specific Evals

Baseline evals test universal behaviors. Project-specific evals (in `docs/evals/{agent-name}/`) test behaviors that failed in your specific project context. Both are valuable:

- Baseline evals: "Does the reviewer catch an obvious wrong join type?" (universal)
- Project-specific evals: "Does the reviewer catch that our fiscal year starts in July?" (context-dependent)

Over time, your project-specific eval suite will become more valuable than the baselines, because it encodes your specific failure history.
