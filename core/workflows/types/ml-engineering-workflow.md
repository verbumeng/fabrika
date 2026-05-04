# ML Engineering Workflow

Domain workflow for **ml-engineering** projects (model development,
training, evaluation). This file defines the domain-specific agents,
review criteria, and testing approach that compose with the shared
story execution mechanics in
`core/workflows/protocols/story-execution.md`.

The shared story execution mechanics are defined in the story-execution
protocol — this file adds the ml-engineering-specific layer.

---

## Agent Roster

| Role | Agent | Notes |
|------|-------|-------|
| Planner | [experiment-planner](../../agents/experiment-planner.md) | Designs experiments; validates results against hypotheses |
| Reviewer | [code-reviewer](../../agents/code-reviewer.md) | Reviews model code against spec and rubric |
| Supplemental Reviewer | [performance-reviewer](../../agents/performance-reviewer.md) | Training compute cost, inference efficiency |
| Validator | [model-evaluator](../../agents/model-evaluator.md) | Runs evaluation metrics, compares against baselines |
| Coordinator | [scrum-master](../../agents/scrum-master.md) | Sprint coordination (complexity-triggered) |
| Implementer | [ml-engineer](../../agents/ml-engineer.md) | Writes model code, training pipelines, evaluation scripts |
| Architect | [data-architect](../../agents/data-architect.md) | Evaluates feature store design, training pipeline architecture |

---

## Domain-Specific Gates

### Experiment Loops

ML stories often involve experiment iteration. The workflow supports:
- **Hypothesis-driven experiments:** The experiment-planner defines
  the hypothesis, metrics, and success criteria. The model-evaluator
  verifies results against these criteria.
- **Iteration cycles:** Failed experiments do not follow the standard
  retry protocol (which is for code quality issues). Instead, the
  experiment-planner revises the approach based on results, producing
  a new experiment spec. Each iteration is a new experiment, not a
  retry.

### Model Evaluation Criteria

Every model story must verify:
- Evaluation metrics meet the thresholds in Model Evaluation Criteria
- Comparison against the documented baseline is complete
- Training data provenance is documented
- Reproducibility: training can be re-run from documented state

### Compute Cost Assessment

The performance-reviewer assesses training compute (GPU hours per
experiment), inference cost at projected volume, and experiment
tracking overhead.

---

## Testing Approach

- **TDD** — new evaluation metrics, new feature engineering logic,
  new model serving endpoints
- **Test-informed** — hyperparameter changes, training data
  modifications
- **Test-after** — model configuration changes, logging adjustments

**Verification method:** Eval framework (model metrics) + training
reproducibility tests + test runner.

---

## Story Execution

For all story execution mechanics, follow
`core/workflows/protocols/story-execution.md`.
