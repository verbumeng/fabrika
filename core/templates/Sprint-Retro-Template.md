---
type: sprint-retro
sprint: Sprint-XX
topology: [pipeline | mesh | hierarchical]
created: YYYY-MM-DD
sprint-dates: YYYY-MM-DD to YYYY-MM-DD
---

# Sprint XX Retro

> Written by the scrum-master agent in the **Retro chat** (Sprint Lifecycle phase 4 of 4 between sprints). Inputs: this sprint's progress file, the latest maintenance outputs, the previous sprint's retro, and this sprint's contract. Output is read by the next sprint's planning chat.

## Inputs Read
- [ ] `Sprint-XX-progress.md` (especially the "Agent quality observations" bullets)
- [ ] `Sprint-XX-contract.md`
- [ ] Maintenance outputs from `docs/maintenance/*-YYYY-MM-DD.md` (most recent set)
- [ ] `docs/maintenance/agent-improvements-YYYY-MM-DD.md` (most recent — drives Agent Quality Findings section below)
- [ ] Previous retro: `Sprint-[XX-1]-retro.md` (or N/A if first sprint)

---

## Shipped vs. Slipped

| Story | Committed Points | Status at Sprint End | Notes |
|-------|------------------|----------------------|-------|
| [TICKET-1] | [X] | [Done / In Review / Carried over / Cancelled] | [1-line if non-obvious] |
| [TICKET-2] | [X] | [...] | |
| [TICKET-3] | [X] | [...] | |

- **Committed:** [X] points
- **Shipped:** [Y] points
- **Carried over:** [Z] points → assigned to backlog or next sprint candidate

## Lessons / Insights

Synthesize from the per-session "Lessons / Insights" bullets in `Sprint-XX-progress.md`. Group related observations; do not just copy-paste. Aim for 3–7 substantive items.

- [Lesson 1 — what surprised us, what we learned, why it matters]
- [Lesson 2]
- [Lesson 3]

## Maintenance Findings to Absorb

Pulled from the maintenance chat that ran between this sprint and now. The retro decides which findings need explicit follow-up vs. which can stay in the backlog as ambient debt.

### Code / Test / Dependency Findings

| Finding | Source File | Action |
|---------|-------------|--------|
| [e.g., "Regression in checkout flow tests"] | `docs/maintenance/full-test-YYYY-MM-DD.md` | [Story for next sprint / Backlog / Already fixed in maintenance] |
| [e.g., "5 outdated dependencies, 1 with security advisory"] | `docs/maintenance/deps-YYYY-MM-DD.md` | [...] |
| [e.g., "Duplicate score calculation in 3 files"] | `docs/maintenance/dedup-YYYY-MM-DD.md` | [...] |

### Agent Quality Findings

The retro is the approval gate for agent prompt changes — the maintenance chat drafts proposals but does NOT apply them. Read `docs/maintenance/agent-improvements-YYYY-MM-DD.md` (most recent) and record decisions below.

**Eval accuracy this maintenance cycle:**

| Agent | Last Cycle | This Cycle | Delta | Notes |
|-------|------------|-----------|-------|-------|
| code-reviewer | [X/Y] | [X/Y] | [+/-N or new] | [regression / improvement / stable / no evals yet] |
| test-writer | [...] | [...] | [...] | [...] |
| product-manager | [...] | [...] | [...] | [...] |
| scrum-master | [...] | [...] | [...] | [...] |

**Proposed eval cases (drafted in maintenance from observed failure patterns, awaiting approval here):**

| Source pattern | Agent | Decision |
|----------------|-------|----------|
| [e.g., "code-reviewer missed null deref pattern 3 times this sprint"] | code-reviewer | [Approve → save to `docs/evals/code-reviewer/eval-NNN.md` / Reject / Defer to next maintenance] |

**Proposed prompt changes (drafted in maintenance with eval-suite-validated deltas, awaiting approval here):**

| Proposal | Agent | Eval delta | Decision | Applied in this chat? |
|----------|-------|-----------|----------|----------------------|
| [e.g., "Add 'check for unused destructured fields' to code-reviewer"] | code-reviewer | [6/10 → 8/10] | [Approve / Reject / Defer to backlog story] | [Yes — committed in retro chat / No — scoped as S-XXX] |

When applying approved prompt changes in this chat, log each change to `docs/evals/agent-changelog.md` per the existing changelog format.

## Process Changes for Next Sprint

This is the section the next sprint's planning chat **must** read. Be concrete — vague resolutions don't survive the next sprint.

- [ ] [e.g., "Estimate +30% on stories that touch the data layer — every single one this sprint underran by ~40%"]
- [ ] [e.g., "Write the test plan in the spec before implementation, not after — caught two missing edge cases in retro that would have been caught earlier"]
- [ ] [e.g., "Stop bundling 'and also refactor the X helper' into stories — refactors deserve their own ticket and isolation"]

## Topology Assessment for Next Sprint

- **This sprint's topology:** [pipeline / mesh / hierarchical]
- **Did it work?** [Yes / Partially / No — with one-line reason]
- **Recommended topology for next sprint:** [pipeline / mesh / hierarchical / depends-on-scope] — [reason]

## Followups from Previous Retro

Did the "Process changes" from `Sprint-[XX-1]-retro.md` actually get applied this sprint?

- [ ] [Item from previous retro] — [Applied / Partially / Not applied — why]

(If first sprint: write "N/A — first sprint.")

## Fabrika Eval Artifact

Write `.fabrika/evals/sprint-XX.md` using the eval artifact template (see `.fabrika/manifest.yml` for the Fabrika version; the template is at `[FABRIKA_PATH]/core/evals/eval-artifact-template.md`). For each agent invoked this sprint, record: outcome, what happened, root cause (if friction/failure), local fix applied, and the `Generalizable?` assessment. Draw from the "Agent quality observations" bullets in the progress file and the "Agent Quality Findings" section above.

- [ ] `.fabrika/evals/sprint-XX.md` written

## One-Line Sprint Summary

[A single sentence that captures the sprint. Used in the next planning chat's orientation as the high-signal recap.]
