# Change Summary Briefing Format

Use this format when presenting completed structural changes to the
owner at Step 6 (Present) of the agentic-workflow lifecycle, before
shipping.

The changes are on the feature branch — the owner needs to understand
what was done, why it matters, and whether it aligns with their
intent before approving the commit and PR.

## Structure

### 1. What changed in the system
Two to four sentences: what the system can do now that it couldn't
before. Frame as capability gained, gap filled, or problem solved —
not files edited.

### 2. File-by-file summary
For each created or modified file:
- What changed (specific content, not vague descriptions)
- Why it matters for the system
- How it connects to other files (integration points that were kept
  in sync)

Group by category (new files, modified files). Lead with the most
important changes. Versioning file updates (VERSION, CHANGELOG,
MIGRATIONS) can be summarized in one line.

### 3. Deviations from the plan
If execution deviated from the approved plan — additional files
changed, scope adjusted, open items resolved differently than
recommended — explain each deviation: what changed, why, and whether
it needs the owner's explicit approval.

If there were no deviations, say so: "Execution followed the
approved plan — no deviations."

### 4. Verification results
Summarize what the three verification agents found:
- **Methodology reviewer:** what it checked and the verdict
- **Structural validator:** what it checked and the verdict
- **Context architect:** what it assessed and the verdict

Translate findings into plain language. Do not say "see the report"
— explain what was found and whether anything was fixed during the
incorporate-feedback step.

### 5. Implications for consumer projects
What do consumer projects need to do when updating to this version?
Summarize the MIGRATIONS entry in plain language: new files to copy,
files to update, behavioral changes to be aware of.

### 6. Token efficiency
Include a cost summary for the structural update. Use the token cost
format from briefing-principles.md:

```
Token usage: [X] tokens
Approximate cost: ~$[high] at high-end / ~$[mid] at mid-tier / ~$[low] at economy tier
```

Include a per-agent-role breakdown:

```
Breakdown: Planner ~$[X] | Engineer ~$[X] | Reviewer ~$[X] | Validator ~$[X] | Architect ~$[X]
```

If token data is not available from the tool, note that and skip.

### 7. Follow-up items
Anything identified during execution that should be addressed in a
future update — gaps noticed, potential improvements deferred, open
questions that didn't need resolution for this change but should be
tracked.

If nothing, say so: "No follow-up items — this change is
self-contained."

## What NOT to include

- Raw verification agent reports (translate findings into section 4)
- Internal file cross-reference details (the owner needs to know
  what changed and why, not which files reference which)
- Implementation commentary or agent dispatch logs

## Closing

End with: *"Ready to commit and create the PR, or do you want to
adjust anything first?"*
