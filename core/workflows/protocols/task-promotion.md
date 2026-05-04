# Task Promotion Workflow

**Procedure classification:** Workflow-bundled (analytics). Installed
with the analytics workflow via `ADD-WORKFLOW.md`.

For analytics workflow projects. Identifies recurring or high-value
analyses and helps the owner decide whether and how to reduce friction
for future runs.

## When to Trigger

The analysis planner should flag a promotion conversation when any of these are true:

- **Repetition detected:** The current task is structurally similar to a previous task (same data sources, same join logic, same aggregation pattern, different date range or parameters). Two repetitions is enough to flag.
- **Owner mentions recurrence:** "I'll need this again next month," "this is a quarterly report," "stakeholders keep asking for this."
- **High execution cost:** The task required significant compute, complex multi-step logic, or substantial manual effort that would benefit from automation.
- **Stakeholder dependency:** Other people or processes depend on this output on a schedule.

The analysis planner raises the flag at the start of the planning phase. It does not force a promotion — it opens a conversation with the owner.

---

## Promotion Levels

Not every recurring analysis needs to become a product. The levels below are ordered from least overhead to most. The right level depends on who consumes the output, how often it runs, and how much effort each run takes.

### Level 1: Templatize

**What changes:** Save the completed task as a reusable template. The task document, plan, and key SQL/scripts are preserved in a `templates/` folder within the workspace (not in the task-dated folder). Next time, the analysis planner instantiates from the template with updated parameters (date range, filters, etc.).

**When this is enough:**
- The analysis runs a few times a year
- The logic is stable — same approach each time, just different parameters
- The owner is the one running it (no external stakeholder waiting on a schedule)

**What the agent does:**
1. Extract the reusable parts of the task (task template, plan template, parameterized SQL/scripts)
2. Save to `templates/[analysis-name]/`
3. Document which parameters change between runs
4. Update `templates/README.md` (create if it doesn't exist) with a one-line entry

### Level 2: Scriptify

**What changes:** Extract the core logic into a reusable script, SQL file, or notebook that can be executed with minimal setup. Optionally wrap it in a `just` recipe or shell script for one-command execution.

**When this is enough:**
- The analysis runs monthly or more frequently
- The execution steps are mechanical — same queries, same transformations, same output format
- The owner or a teammate runs it manually but wants it to be a 1-minute task instead of a 30-minute task

**What the agent does:**
1. Refactor the task's work products into a clean, parameterized script in `src/scripts/` or `src/queries/`
2. Add a `just` recipe or shell script for one-command execution
3. Document the script's parameters, prerequisites, and expected output
4. If the script produces output files, document the output location and format

### Level 3: Visualize

**What changes:** The analysis output gets a persistent visual representation — a new tab on an existing dashboard, a section in an existing report, or a lightweight standalone view.

**When this is enough:**
- Stakeholders consume this output visually (charts, tables, KPIs)
- The same visualization is requested repeatedly with updated data
- The audience is non-technical and needs the output pre-formatted

**What the agent does:**
1. Invoke the visualization-designer agent to produce a viz spec
2. Assess existing dashboards (check `sources/tools/`) — does this belong as a new tab/section on something that already exists?
3. If integrating into an existing dashboard: write the SQL/DAX/calculated fields needed, document the layout addition, hand off to the human for implementation in the GUI tool
4. If creating a new lightweight view: implement in the project's existing stack (Streamlit page, HTML report, notebook with widgets)
5. Document the visualization in `sources/tools/` if it's a new persistent asset

**The visualization-designer agent is the key collaborator here.** It handles chart type selection, layout, and integration assessment. The analysis planner handles the data and logic side.

### Level 4: Automate

**What changes:** The analysis runs on a schedule without human initiation. A cron job, orchestrator task, or scheduled Claude Code trigger executes the script and delivers the output.

**When this is enough:**
- The output must be delivered on a fixed schedule (daily, weekly, monthly)
- Stakeholders expect it without having to ask
- The logic is stable and validated — manual review is no longer needed for each run

**What the agent does:**
1. Package the script from Level 2 for scheduled execution
2. Add scheduling configuration (cron, orchestrator DAG, or Claude Code `/schedule` trigger)
3. Add output delivery (email, file drop, dashboard refresh, Slack notification)
4. Add basic monitoring: alert if the job fails, if output is empty, or if results are outside expected ranges
5. Document the schedule, delivery mechanism, and monitoring in a `recurring/[analysis-name]/README.md`
6. Add a cost estimate for the recurring run (compute cost per execution times frequency)

### Level 5: Spin Out

**What changes:** The analysis has grown beyond what fits in the current workspace. It needs its own project — a standalone data app, a new pipeline in the data engineering stack, or a dedicated analytics-engineering model.

**When this is enough (all of these, not just one):**
- The output has its own stakeholders, SLAs, and lifecycle
- Multiple other analyses or systems depend on its output
- The complexity justifies its own testing strategy, deployment, and maintenance cycle
- The overhead of a new project (CLAUDE.md, bootstrap, sprint lifecycle) is worth it relative to the ongoing maintenance burden

**What the agent does:**
1. Recommend the appropriate project type for the spin-out (`data-app`, `analytics-engineering`, `data-engineering`, `automation`)
2. Draft a brief for the new project: what it does, who it serves, what data it consumes and produces
3. Hand off to the owner to bootstrap the new project via Fabrika's BOOTSTRAP.md
4. In the current workspace, replace the recurring task/script with a pointer to the new project: "This analysis is now maintained in [project-name]"

---

## The Promotion Conversation

When the analysis planner detects a promotion trigger, it presents the owner with a structured recommendation:

1. **Pattern observed:** "This is the third month you've run a spending-by-category analysis with the same logic and different date ranges."
2. **Current friction:** "Each run takes ~20 minutes of setup and ~$0.50 in compute. The output goes to [stakeholder] via email."
3. **Recommended level:** "Level 2 (Scriptify) — extract the SQL into a parameterized script with a `just` recipe. Future runs become a one-command, 2-minute task."
4. **Why not higher:** "Level 3 (Visualize) would make sense if the stakeholder wants a persistent dashboard, but right now they're happy with a monthly email. Level 4 (Automate) would remove you from the loop entirely, but the stakeholder sometimes changes the parameters."
5. **Why not lower:** "Level 1 (Templatize) would save some planning time but you'd still be re-running the same SQL manually."
6. **Estimated effort:** "~30 minutes to extract and parameterize the script."

The owner decides. The agent executes the promotion at the chosen level.

---

## Tracking Promoted Tasks

When a task is promoted beyond Level 1:
- Add an entry to `recurring/README.md` (create if it doesn't exist) with: name, level, schedule (if any), location of the script/dashboard/automation, date promoted, original task reference
- The analysis planner checks `recurring/README.md` at orientation to understand what already runs on a schedule, so it doesn't re-plan something that's already automated

---

## Relationship to Other Agents

| Agent | Role in Promotion |
|---|---|
| **Analysis planner** | Detects the pattern, initiates the conversation, executes Levels 1-2 |
| **Visualization designer** | Collaborates on Level 3 — chart type, layout, integration into existing dashboards |
| **Performance reviewer** | Reviews cost estimates for Level 4 recurring automation |
| **Logic reviewer** | Validates the parameterized script (Level 2+) to ensure it generalizes correctly |
| **Data validator** | Validates the first automated run (Level 4) against a manually verified baseline |
