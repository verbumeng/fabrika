# Task Plan Briefing Format

Use this format when presenting an analysis task plan to the owner
for approval, after the analysis planner creates a plan in an
analytics-workspace project.

The plan artifact lives at `tasks/[date-name]/plan.md` and defines
the technical approach. This briefing is the human-facing translation
— it exists so the owner can evaluate whether the right approach is
being taken before work begins.

## Structure

### 1. What question are we answering and for whom
One or two sentences: the business question in plain language, who
asked it, and what decision it informs. If the brief has a deadline,
state it here.

### 2. Analysis approach in plain language
Walk through the approach from the owner's perspective: what data
sources we're pulling from, what method we're using (joins, rollups,
trend analysis, cohort comparison, etc.), and why this method fits
this question. Define any analytical terms in the jargon glossary
below.

### 3. Cost estimate in plain terms
Translate the technical cost estimate from the plan into owner-facing
language:
- Compute cost (query volume, processing time)
- API/LLM cost if applicable
- Approximate time to complete

If this is a recurring analysis, note the per-run cost and projected
recurring cost.

### 4. Assumptions and risks
What could make the results wrong or misleading? Data freshness
issues, known gaps in source data, methodological limitations. Frame
each as: what the assumption is, why it matters, and what we're doing
to mitigate it.

### 5. Jargon glossary
Define every analytical term, data source name, metric name, or
methodology concept that appears in the briefing and wouldn't be
obvious to someone who hasn't worked with this data recently.

When a Domain Language document exists for the project, draw
definitions from it. If a term isn't in the Domain Language, define
it here and flag it for addition.

Format: `**Term** — plain-language definition`.

## Closing

End with: *"The plan is at `tasks/[date-name]/plan.md`. Let me know
if the approach, scope, or cost estimate should change before I start
working."*

## Success Criterion

If the owner has to read the raw plan file to understand what
analysis is being done and why, the briefing failed. The goal is to
make the owner comfortable asking "why not approach Y instead?" or
"what if we also looked at Z?"
