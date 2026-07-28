# Model Workspace Protocol (MWP)
## Simple Guide for Non-Technical Teams

**Author:** Miguel Tillis Jr.  
**Adapted for non-technical users:** July 2026  
**Based on:** ModelWorkspaceProtocol.md (v2.0)

---

## What MWP Is

MWP is a simple way to organize AI work.

You use folders and text files to tell the AI what to do.

Instead of building a complex system using code, you:
- break work into numbered stages,
- write clear instructions for each stage,
- save results in the right folder,
- and keep each run in its own folder.

Think of MWP like a school binder:
- each section has one job,
- each page has directions,
- and all work is easy to find.

---

## Simple Definitions

### What is a workflow?

A workflow is work done step by step, from start to finish.

It answers:
- What happens first?
- What happens next?
- What happens last?

Example:
1. Get the request.
2. Make a draft.
3. Review the draft.
4. Send the final version.

### What is a markdown file?

A markdown file is a plain text file used for notes and instructions.

It usually ends in `.md`, like `CONTEXT.md`.

Markdown is easy to read and write:
- `#` makes a title
- `-` makes bullet points
- blank lines separate ideas

### What is context?

Context is the information the AI reads before it does a task.

Context helps the AI understand:
- what the goal is,
- what files to read,
- what rules to follow.

In MWP, context usually comes from files like `AGENTS.md`, `CONTEXT.md`, and stage outputs.

---

## Why Teams Use MWP

MWP helps teams work faster with less confusion.

- You can change behavior by editing text files.
- You can see every output in normal folders.
- You avoid many code changes and redeploys.
- Non-technical and technical people can work together.
- It is easier to review what happened.

---

## The 4 Big Ideas

1. **Numbered stages**  
   Work moves in order: 01, 02, 03.

2. **Stage instruction file**  
   Each stage has a `CONTEXT.md` file with:
   - Inputs (what it needs)
   - Process (what to do)
   - Output (what to create)
   - Rules (what not to do)

3. **Output folders**  
   Each run saves results in its own folder inside `output/`.

4. **Clear file names**  
   Use clear run folder names so people can quickly find the right files.

---

## AI Quick Start Section (Copy This)

Use this section when you want an AI to create a simple workflow fast.

### Required Folder Structure

Use this exact layout:

```text
workflow/
├── README.md
├── .opencode/
│   └── agents/
│       └── agent_name.md
├── workspace_build/01_stage
│   ├── CONTEXT.md
│   ├── output/
│   │   └── output_file_name.md
│   └── references/
│       └── reference_file_name.md
└── workspace_build/shared/
   ├── rules/
   └── references/
```

### AI Prompt Block

Copy this block into your AI tool and fill in the blanks.


```markdown

# Information Gathering Step

Create a basic workflow

Before generating files, have the AI do a short use-case analysis.

Use this process:
1. Ask clarifying questions first.
2. Use the answers to break work into ordered stages.
3. Name each stage with a numeric prefix (01_, 02_, 03_).
4. Generate folders and files from those stage names.

Ask these clarifying questions:
- What final result should this workflow produce?
- Who will use the final result?
- What input is available at the start?
- What checks or approvals are required?
- What should happen if a step fails?

Turn answers into stages like this:
- Stage 01: Intake and validate inputs
- Stage 02: Create or transform content
- Stage 03: Review and finalize output

Stage naming rules:
- Use lowercase letters, numbers, and underscores only
- Keep names short and action-based (for example: intake, draft, review)
- Order by real execution sequence, not by team ownership


VARIABLES:
- {{ AGENT_NAME }}: The short name of the AI agent for this workflow.
   - Used in: `{{ AGENT_NAME }}_workflow/` and `.opencode/agents/{{ AGENT_NAME }}.md`
   - Format: lowercase letters, numbers, and underscores only
   - Example: `content_writer`

- {{ STAGE_NAME }}: The short name of one stage (without the number).
   - Used in: `{{ PROJECT_DIR }}/01_{{ STAGE_NAME }}/`, `output/{{ STAGE_NAME }}.md`, and `references/{{ STAGE_NAME }}.md`
   - Format: lowercase letters, numbers, and underscores only
   - Examples by stage: `intake`, `draft`, `review`



WORKFLOW_NAME: <name>
GOAL: <what this workflow should produce>
AUDIENCE: <who will use the output>


# Stage createion Step:

Come up with respective stages from analysis step

FOR EACH STAGE, GENERATE:
- Folder name using numbered format (example: workspace_build/01_stage)
- CONTEXT.md with Inputs, Process, Output, Rules
- One sample output file name
- references file name

CONSTRAINTS:
- Keep language simple and clear
- No advanced tools needed
- Use plain markdown files
- Each stage must write output into its own run folder
- Use this base structure exactly (markdown tree):

  {{ AGENT_NAME }}_workflow/
  ├── README.md
  ├── .opencode/
  │   └── agents/
  │       └── {{ AGENT_NAME }}.md
  ├── 01_{{ STAGE_NAME }}/
  │   ├── CONTEXT.md
  │   ├── output/
  │   │   └── {{ STAGE_NAME }}.md
  │   └── references/
  │       └── {{ STAGE_NAME }}.md
  └── workspace_build/shared/
   ├── rules/GLOBAL_RULES.md
   └── references/GLOBAL_REFERENCES.md

DELIVERABLES:
1) Folder tree
2) CONTEXT.md content for each stage
3) One short test run example (input -> output)
```

### Filled Example (Generic Workflow)

You can use this exact example to get started:

```text
Create a basic workflow using MWP.

WORKFLOW_NAME: blog_post_workflow
GOAL: Turn a short topic idea into a clean blog post draft.
AUDIENCE: Small business owner

STAGES:
1) intake
2) draft
3) review

FOR EACH STAGE, GENERATE:
- Folder name using numbered format
- CONTEXT.md with Inputs, Process, Output, Rules
- One sample output file name

CONSTRAINTS:
- Keep language simple and clear
- No advanced tools needed
- Use plain markdown files
- Each stage must write output into its own run folder

DELIVERABLES:
1) Folder tree
2) CONTEXT.md content for each stage
3) One short test run example
```

If the AI output is weak, ask it to improve only one stage at a time.

---

## How To Use MWP

### Step 1: List your stages

Write the main steps in your process.

Example:
- 01 Intake
- 02 Draft
- 03 Review and Export

### Step 2: Make stage folders

Use this base structure first:

```text
workflow/
README.md
.opencode/agents/agent_name.md
workspace_build/shared/rules/
workspace_build/shared/references/
```

Then create one folder for each stage inside `workflow/`:
- `workflow/01_intake/`
- `workflow/02_draft/`
- `workflow/03_export/`

Inside each stage, add:
- `CONTEXT.md`
- `references/`
- `output/`

### Step 3: Write clear stage instructions

Use this simple template:

```markdown
# Stage: <name>

## Inputs
- What files to read
- What user info is needed

## Process
1. First action
2. Next action
3. Last action

## Output
- Exact file name and format
- What “good” looks like

## Rules
- What this stage cannot do
- When to stop and ask a person
```

### Step 4: Choose a clear run folder name

Give each run a folder name that is easy to understand.

Examples:
- `summer_launch_week1`
- `new_customer_email_draft`
- `product_update_july`

Use the same run folder name when saving files for that run.

### Step 5: Add system directions

Use `AGENTS.md` at the top of the project to explain:
- what the system does,
- where stages are,
- global rules.

### Step 6: Run one real test

Run one request through all stages.

Check after each stage:
- Is the output in the right folder?
- Is the output usable?
- Did it follow the rules?

### Step 7: Improve the text first

If results are wrong, edit `CONTEXT.md` first.

Most fixes come from better instructions:
- clearer inputs,
- stricter output format,
- clear stop rules.

---

## Daily Use (Simple)

1. Receive request.
2. Create a clear run folder name.
3. Start Stage 01.
4. Move stage by stage.
5. Review files in that run folder inside `output/`.
6. Approve or ask for fixes.
7. Deliver final result.
8. Keep the log.

---

## What To Edit When You Need a Change

Use this order:

1. Stage `CONTEXT.md`
2. Shared rules in `workspace_build/shared/wizard_rules/`
3. Flow steps in `workspace_build/shared/wizard_steps/`
4. Code (only if text changes are not enough)

This lowers risk and speeds up updates.

---

## Quick Quality Checklist

Before going live:

- [ ] Every stage has a clear `CONTEXT.md`
- [ ] Every stage writes to a run folder inside `output/`
- [ ] `references/` is read-only
- [ ] Logs are saved each run
- [ ] There is a retry limit (for example, stop after 3 failures)
- [ ] A person can trace one full run end to end

---

## Common Problems and Fixes

### Problem: Instructions are too vague
Fix: Make steps specific and measurable.

### Problem: Files overwrite each other
Fix: Give each run its own folder inside `output/`.

### Problem: The agent keeps repeating errors
Fix: Add retry limits and escalation rules.

### Problem: Team keeps changing code for small behavior changes
Fix: Update `CONTEXT.md` first.

### Problem: Hard to explain what happened
Fix: Keep structured logs for every run.

---

## 30-Day Starter Plan

### Week 1
- Map the workflow.
- Create folders and stage files.

### Week 2
- Run internal tests.
- Fix unclear instructions.

### Week 3
- Run with a small real user group.
- Track quality and errors.

### Week 4
- Lock stable instructions.
- Train team on text-first updates.

---

## When MWP Fits Best

Use MWP when you need:
- clear, auditable AI workflows,
- step-by-step processes,
- fast updates without heavy redeploys,
- teamwork across technical and non-technical roles.

---

## Final Message

MWP gives teams a clear way to run AI work using folders, instructions, outputs, and logs.

If your team can edit clear text files, your team can run and improve AI workflows with much less complexity.
