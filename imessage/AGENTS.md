# Agents

This project uses OpenCode agents orchestrated via shell scripts to generate, evaluate, revise, prepare sends, and send iMessage campaigns.

## Architecture

```
run.sh
├── imessage_prep agent (stages 1–4)        → builds campaign
├── imessage_eval agent (stage 5)           → grades against rubric
├── imessage_revise agent (stage 6)         → applies fixes
├── imessage_generate_messages agent (stage 7) → writes Number/Message send table
└── imessage_send agent (stage 8)           → sends from Stage 7 table via helper script
```

---

## Agent Definitions

All agent files live in `.opencode/agents/`.

### 1. `imessage_prep.md` — Campaign Builder

| Property | Value |
|----------|-------|
| Model | `amazon-bedrock/amazon.nova-pro-v1:0` |
| Temperature | 0.1 |
| Steps | 20 |
| Purpose | Build the iMessage campaign through stages 1–4 |

**Behavior:**
- Reads `imessage/shared/references/REQUIREMENTS.md`, `RUBRIC.md`, and `GLOBAL_CONTEXT.md` before starting.
- Walks through: audience → structure → content → final assembly.
- Each stage reads the previous stage's `output/` and writes its own deliverables to disk.
- Stops after stage 4 when run non-interactively via `run.sh`.

**Tools enabled:** read, write, edit, bash, grep, glob, todowrite, webfetch, websearch

---

### 2. `imessage_eval.md` — Campaign Evaluator

| Property | Value |
|----------|-------|
| Model | `amazon-bedrock/anthropic.claude-sonnet-4-5-20250929-v1:0` |
| Temperature | 0.0 |
| Steps | 10 |
| Purpose | Critically grade the campaign against the rubric |

**Behavior:**
- Reads the rubric and requirements, then the final message.
- Follows `imessage/05_evaluation/CONTEXT.md` for YES/NO verification per criterion.
- Assigns emoji ratings: ✅ Competent, ⚠️ Approaching Competence, ❌ Not Evident.
- Writes evaluation to `imessage/05_evaluation/output/evaluation.md`.

**Tools enabled:** read, write, bash, grep, glob

---

### 3. `imessage_revise.md` — Revision Agent

| Property | Value |
|----------|-------|
| Model | `amazon-bedrock/anthropic.claude-sonnet-4-5-20250929-v1:0` |
| Temperature | 0.2 |
| Steps | 15 |
| Purpose | Apply evaluation fixes to produce a passing campaign |

**Behavior:**
- Reads the evaluation output and identifies non-Competent criteria.
- Reads the current message from `imessage/04_final_assembly/output/final_message.md`.
- Applies fixes systematically.
- Writes the revised message to `imessage/06_revision_pass/output/revised_message.md`.

**Tools enabled:** read, write, edit, bash, grep, glob, webfetch, websearch

---

### 4. `imessage_generate_messages.md` — Generate Send Messages Agent

| Property | Value |
|----------|-------|
| Model | `amazon-bedrock/amazon.nova-pro-v1:0` |
| Temperature | 0.2 |
| Steps | 15 |
| Purpose | Build per-contact send-ready messages from revised content |

**Behavior:**
- Reads `imessage/07_generate_messages/CONTEXT.md` for procedure.
- Reads revised message content and contact list.
- Produces `imessage/07_generate_messages/output/send_messages.md` as a Markdown table with `Number` and `Message`.
- Encodes multiline content safely for table transport (`\n` and escaped pipes).

**Tools enabled:** read, write, edit, bash, grep, glob

---

### 5. `imessage_send.md` — Send Agent

| Property | Value |
|----------|-------|
| Model | `amazon-bedrock/amazon.nova-pro-v1:0` |
| Temperature | 0.1 |
| Steps | 20 |
| Purpose | Send prepared Stage 7 messages through the mandatory Stage 8 helper flow |

**Behavior:**
- Reads `imessage/08_send/CONTEXT.md` as source of truth.
- Runs Stage 8 send flow from `imessage/07_generate_messages/output/send_messages.md`.
- Uses `imessage/08_send/send_from_table.py` as the required execution path.
- Writes send results to `imessage/08_send/output/send_status.md` (or timestamped variant).

**Tools enabled:** read, write, edit, bash, grep, glob

---

### 6. `imessage_respond.md` — Respond Agent

| Property | Value |
|----------|-------|
| Purpose | Handle follow-up response workflows after send stages |

**Behavior:**
- Used for post-send message handling workflows.

**Tools enabled:** See `.opencode/agents/imessage_respond.md`

---

## Scripts

| Script | Purpose |
|--------|---------|
| `run.sh` | Pipeline orchestrator for stages 1–8 (many stages can be toggled on/off in script comments) |
| `imessage/05_evaluation/run_eval.sh [file]` | Standalone evaluation (optional file override) |
| `imessage/06_revision_pass/run_revise.sh` | Standalone revision pass |
| `imessage/08_send/send_from_table.py` | Mandatory Stage 8 sender: parses Stage 7 table, decodes content, sends safely via stdin invocation of `imessage.py`, writes send status |
| `clean.sh` | Remove all generated files from output directories |

---

## Stage I/O Contract

| Stage | Purpose | Output |
|-------|---------|--------|
| 1. Audience | Define who it's for, tone, word choice, technical level | `audience.md` |
| 2. Structure | Build logical message structure following SMS best practices | `structure.md` |
| 3. Content | Write focused message content with proper tone alignment | `content.md` |
| 4. Final Assembly | Produce a self-contained markdown file ready to send | `final_message.md` |
| 5. Evaluation | Grade against rubric with emoji scoring | `evaluation.md` |
| 6. Revision Pass | Fix non-Competent criteria, output revised message | `revised_message.md` |
| 7. Generate Messages | Build per-contact send table from revised message + contacts | `send_messages.md` |
| 8. Send | Send every Stage 7 row using mandatory helper flow | `send_status.md` |

---

## Output Format

The final deliverable is a **markdown file** (`revised_message.md`) that:
- Contains the complete, polished iMessage campaign
- Is formatted for easy reading and sending
- Includes all necessary messaging and tone guidance
- Maintains professional standards per the rubric

Each stage's output is versioned for traceability:
- First run: `<filename>.md`
- Subsequent runs: `<filename>_<YYYYMMDD_HHMMSS>.md`

For sending stages:
- Stage 7 output is a Markdown table in `imessage/07_generate_messages/output/send_messages.md`.
- Stage 8 consumes Stage 7 output only and writes send results in `imessage/08_send/output/send_status.md`.
- Stage 8 execution must use `python3 imessage/08_send/send_from_table.py` (no ad-hoc manual send commands).

---

## Model Selection Rationale

| Task | Model | Why |
|------|-------|-----|
| Writing | Nova Pro | Cost-effective, good for creative content generation |
| Evaluation | Claude Sonnet 4.5 | Needs precision and strict reasoning |
| Revision | Claude Sonnet 4.5 | Needs nuanced fix application and source verification |
| Stage 7 Generate | Nova Pro | Efficient structured generation for per-contact variants |
| Stage 8 Send | Nova Pro | Deterministic orchestration around scripted send helper |
