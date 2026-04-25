---
type: outcome-report
task: [YYYY-MM-DD-short-name]
status: complete
completed: YYYY-MM-DD
---

# Outcome Report: [Short descriptive title]

## Summary
[Lead with the answer. 2-4 sentences that directly address the question from the brief. If the stakeholder reads nothing else, this should give them what they need.]

## Findings
[Detailed results. Use tables, numbers, and specific examples. Organize by whatever structure makes the answer clearest — by region, by time period, by category, by variance driver, etc.]

### [Finding 1 — e.g., "Revenue Variance Breakdown"]
[Details, tables, specific numbers]

### [Finding 2 — e.g., "Root Cause: Manual Adjustments"]
[Details, evidence, specific examples]

## Methodology
[Enough detail for someone to reproduce the analysis. Not a tutorial — just the key decisions.]

- **Sources used:** [List with dates/timestamps of data pulled]
- **Key logic:** [Brief description of joins, filters, calculations — reference the plan for full detail]
- **Tools used:** [SQL against warehouse X, Python for analysis, DuckDB for local joins, etc.]
- **Time period:** [What date range was analyzed]
- **Filters/exclusions:** [What was included/excluded and why]

## Data Quality Notes
[Anything the reader should know about the reliability of these results.]
- [e.g., "3% of transactions are missing region codes — these were excluded from the regional breakdown"]
- [e.g., "Finance's manual adjustments account for $180K of the $2.3M variance"]
- [e.g., "Data is current as of 2026-04-24; any transactions after that date are not included"]

## Output Location
[Where the deliverable lives, so someone can find it later.]
- [e.g., "CSV exported to `data/output/q1-revenue-variance.csv`"]
- [e.g., "Email sent to [stakeholder] on [date]"]
- [e.g., "Tableau workbook updated: [URL or path]"]
- [e.g., "SQL saved to `tasks/2026-04-24-revenue-variance/work/analysis.sql` for future re-use"]

## Follow-Up Recommendations
[Optional. If the analysis revealed something that warrants further investigation or action.]
- [e.g., "The manual adjustment process should be documented — it's a recurring source of confusion"]
- [e.g., "Consider adding a reconciliation check to the monthly close process"]
- [e.g., "The West Coast data lag may affect other reports — worth investigating"]
