# Session Summary Briefing Format

Use this format when presenting the end-of-session summary to the owner (Session Close-Out step 23, and story completion step 16). This is the owner's primary touchpoint for understanding what happened during the session.

Do not tell the owner to go read evaluation reports, spec files, or sprint contracts. Translate the results into a plain-language summary that explains what changed in their product and why it matters.

## Structure

### 1. What changed in the product
2-3 sentences: what can the product do now that it couldn't before this session? Or: what was broken that is now fixed? Frame this as end-user impact, not code changes.

### 2. Key decisions made and why
List any non-trivial choices made during implementation. For each: what was decided, what the alternative was, and why this direction was picked. If no significant decisions were made, skip this section.

### 3. Evaluation results (plain language)
Summarize what the evaluator agents found. Do not say "see `docs/evaluations/TICKET-code-review.md`" — instead say what the evaluators checked and whether anything noteworthy came up. Examples:

- "Code review passed clean — no issues found."
- "Code review passed with one note: the date parsing could be more defensive, but it's non-blocking."
- "Test coverage is at 85% for the new feature. The test writer flagged one edge case we should watch — empty datasets."

If an evaluator failed and was retried, explain what went wrong and how it was fixed.

### 4. What to look at (if anything)
If there are specific things the owner should review — a UI that's worth clicking through, a behavior that's worth verifying, a design choice that could go either way — call them out here with a brief explanation of what to look for and why.

If there's nothing that needs the owner's attention beyond this summary, say so: "Nothing needs your review right now."

### 5. What's next
One sentence: what should the next session pick up? This should match the deterministic handoff prompt.

## What NOT to include

- File paths to evaluation reports, spec files, or sprint contracts (the owner doesn't need to read those)
- Raw test output or linter results
- Token counts or context window metrics (those go in the progress file, not the owner summary)
- Implementation details unless they're relevant to a decision the owner needs to make
