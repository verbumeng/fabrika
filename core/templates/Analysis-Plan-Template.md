---
type: analysis-plan
task: [YYYY-MM-DD-short-name]
status: draft
---

# Analysis Plan: [Short descriptive title]

## Data Sources
[List each source needed for this analysis. Link to the source detail file in `sources/`.]

| Source | Type | What we need from it | Detail file |
|--------|------|---------------------|-------------|
| [e.g., Warehouse - sales schema] | Connection | Order-level revenue by region, Q1 2026 | `sources/connections/warehouse-prod.md` |
| [e.g., Finance Q1 report] | File | Their reported revenue totals | `sources/files/finance-quarterly.md` |

## Approach
[Step-by-step technical plan. Be specific about joins, filters, and aggregation logic.]

1. **Pull source data:** [What query/queries to run, against which connections]
2. **Transform/join:** [How to combine sources — join keys, join type, filters]
3. **Calculate:** [What metrics or calculations to perform]
4. **Compare/analyze:** [How to arrive at the answer — variance analysis, trend analysis, etc.]
5. **Format output:** [How to shape the final deliverable]

## Key Logic
[The core SQL, Python, or calculation logic. Write it out — don't just describe it.]

```sql
-- Example: core query or calculation
SELECT ...
FROM ...
JOIN ...
WHERE ...
GROUP BY ...
```

## Assumptions
[What are we assuming about the data or business rules?]
- [e.g., "Revenue is recognized at order date, not ship date"]
- [e.g., "Fiscal Q1 = Jan 1 - Mar 31 (calendar year)"]
- [e.g., "Refunds are excluded from revenue totals"]

## Known Gotchas
[Data quality issues, timezone traps, or source system quirks from the source detail files.]
- [e.g., "The warehouse has a known 24-hour lag on West Coast transactions"]
- [e.g., "Finance manually adjusts for currency conversion — we'll need to account for that"]

## Tool Chain
[What tools will be used to execute this analysis?]
- **Agent will:** [e.g., Write SQL queries, run Python analysis, generate output file]
- **Human will:** [e.g., Execute inside Tableau, paste results into report, forward email]

## Validation Approach
[How will we know the answer is right?]
- [e.g., "Cross-reference total against published quarterly report"]
- [e.g., "Spot-check 5 individual transactions end-to-end"]
- [e.g., "Compare row counts against source system record counts"]
