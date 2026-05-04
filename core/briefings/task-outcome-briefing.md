# Task Outcome Briefing Format

Use this format when presenting analysis results to the owner after
task delivery in an analytics workflow project.

The outcome artifact lives at `tasks/[date-name]/outcome.md` and
contains the full methodology, data quality notes, and output
locations. This briefing is the human-facing translation — it exists
so the owner can understand what was found, why it matters, and what
to do with it.

## Structure

### 1. What we found
Lead with the headline answer to the business question. Two to four
sentences in plain language. If the answer is nuanced ("it depends"),
state the key finding first, then the conditions that affect it.

### 2. Why it matters
Connect the finding to the business decision it informs. What should
the owner do with this information? Who else needs to see it? If the
finding confirms or contradicts a prior assumption, say so.

### 3. How confident are we
Translate data quality notes into plain language:
- How fresh is the data? (e.g., "data is current through yesterday"
  vs. "the most recent data is two weeks old")
- Any known gaps or limitations? (e.g., "mobile app data is missing
  for the first week of March")
- How robust is the methodology? (e.g., "this is a simple count" vs.
  "this is a statistical estimate with a margin of error")

Do not say "data quality is good" — say what specifically makes it
trustworthy or what caveats to keep in mind.

### 4. What to look at
Point the owner to specific outputs worth reviewing:
- Output files, dashboards, or visualizations with brief descriptions
  of what each shows
- Specific numbers or patterns worth verifying
- Anything surprising that the owner might want to dig into

If there's nothing that needs the owner's attention beyond this
summary, say so: "The output is ready to share — nothing unusual
needs your review."

### 5. Token efficiency
Include a cost summary for the task. Use the token cost format from
briefing-principles.md:

```
Token usage: [X] tokens
Approximate cost: ~$[high] at high-end / ~$[mid] at mid-tier / ~$[low] at economy tier
```

Include a per-agent-role breakdown:

```
Breakdown: Planner ~$[X] | Implementer ~$[X] | Reviewer ~$[X] | Validator ~$[X]
```

If token data is not available from the tool, note that and skip.

### 6. Follow-up recommendations
What analysis could go deeper? Should this become a recurring
analysis? If the analysis planner detected a promotion opportunity
(see task promotion workflow), mention it here with a plain-language
explanation of what promotion would mean.

If no follow-up is needed, say so: "This is a one-off analysis — no
follow-up needed unless the finding changes the owner's priorities."

## What NOT to include

- Raw SQL, code snippets, or query output (the owner reads the
  headline finding, not the implementation)
- Data quality details beyond what affects the conclusion (keep
  caveats in section 3 focused on what matters for the decision)
- File paths to validation reports or plan files (the owner doesn't
  need to read those — translate the results)

## Closing

End with: *"The full outcome is at `tasks/[date-name]/outcome.md`.
Let me know if you want to dig deeper into any of these findings."*
