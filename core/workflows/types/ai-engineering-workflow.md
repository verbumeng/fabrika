# AI Engineering Workflow

Domain workflow for **ai-engineering** projects (LLM-powered
applications — RAG systems, agent frameworks, prompt engineering,
eval harnesses). This file defines the domain-specific agents, review
criteria, and testing approach that compose with the shared story
execution mechanics in
`core/workflows/protocols/story-execution.md`.

The shared story execution mechanics are defined in the story-execution
protocol — this file adds the ai-engineering-specific layer.

---

## Agent Roster

| Role | Agent | Notes |
|------|-------|-------|
| Planner | [product-manager](../../agents/product-manager.md) | Expands stories into specs; validates acceptance criteria |
| Reviewer | [code-reviewer](../../agents/code-reviewer.md) | Reviews application code against spec and rubric |
| Reviewer | [prompt-reviewer](../../agents/prompt-reviewer.md) | Supplemental: reviews prompt quality, safety, cost |
| Supplemental Reviewer | [security-reviewer](../../agents/security-reviewer.md) | Prompt injection, data poisoning, PII leakage |
| Supplemental Reviewer | [performance-reviewer](../../agents/performance-reviewer.md) | Token usage, model routing efficiency |
| Validator | [eval-engineer](../../agents/eval-engineer.md) | Runs LLM eval suites, guardrail tests |
| Coordinator | [scrum-master](../../agents/scrum-master.md) | Sprint coordination (complexity-triggered) |
| Implementer | [ai-engineer](../../agents/ai-engineer.md) | Writes AI application code, prompts, eval harnesses |
| Architect | [software-architect](../../agents/software-architect.md) | Evaluates RAG architecture, model routing design |

---

## Domain-Specific Gates

### Prompt Review

The prompt-reviewer is a supplemental reviewer that runs alongside
the code-reviewer for stories that modify prompts. Checks:
- Prompt quality (clarity, specificity, safety)
- Consistency with Prompt Library versions
- Cost implications of prompt changes
- Guardrails compliance

### Eval Harness

Every story that modifies AI behavior must include evaluation:
- Eval dimensions: relevance, groundedness, safety, helpfulness
- Automated checks against eval datasets
- Regression testing: existing eval cases still pass
- New eval cases for new behaviors

### RAG Assessment

For stories touching the retrieval pipeline:
- Embedding strategy alignment
- Chunking and retrieval quality
- Context window management
- Freshness / re-indexing impact

### Security Assessment

AI engineering projects have additional security surfaces:
- Prompt injection defense
- Data poisoning risk
- Model extraction risk
- PII leakage through model responses

---

## Testing Approach

- **TDD** — new eval dimensions, new guardrail rules, new RAG
  components
- **Test-informed** — prompt modifications, model routing changes
- **Test-after** — configuration changes, model version bumps

**Verification method:** Eval harness (LLM output quality) +
guardrail tests + standard test runner.

---

## Story Execution

For all story execution mechanics, follow
`core/workflows/protocols/story-execution.md`.
