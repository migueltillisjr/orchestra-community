# MWP Report Generator

An AI-powered pipeline that writes, evaluates, and revises professional reports using multiple OpenCode agents.

## Quick Start

### 1. Prerequisites

- [OpenCode CLI](https://opencode.ai) installed and configured
- Python 3.13+
- AWS Bedrock access (for Nova Pro and Claude Sonnet models)

### 2. Setup

```bash
cd generate

# Create and activate virtual environment
python3 -m venv .report
source .report/bin/activate

# Install Python dependencies
pip install -r requirements.txt

# Configure environment variables (API keys, etc.)
cp .env.example .env   # then edit .env with your credentials
```

### 3. Configure Your Report

Update these files in `workspace_build/shared/references/` before running:

| File | What to put here |
|------|-----------------|
| `workspace_build/shared/references/REQUIREMENTS.md` | Your report prompt, task instructions, and submission guidelines |
| `workspace_build/shared/references/RUBRIC.md` | The grading rubric formatted as a markdown table |
| `workspace_build/shared/references/TEMPLATE.md` | (Optional) Document template the final report should follow |

### 4. Run

```bash
source .report/bin/activate
source .env
./run_report.sh
```

This runs the full pipeline: write → evaluate → revise → re-evaluate → export PDF.

---

## Files to Update Per Report

| File | Purpose |
|------|---------|
| `workspace_build/shared/references/REQUIREMENTS.md` | Report instructions — what you need to write |
| `workspace_build/shared/references/RUBRIC.md` | Grading criteria — how the report will be scored |
| `workspace_build/shared/references/TEMPLATE.md` | (Optional) Required document structure/template |
| `workspace_build/01_stage` | Drop URLs or source docs here for the research stage to use |
| `workspace_build/01_stage` | Writing style rules to make the output sound natural |

---

## Viewing Output

Each stage writes its results to its own `output/` directory:

```
workspace_build/01_stage
workspace_build/01_stage, frameworks.md
workspace_build/01_stage
workspace_build/01_stage
workspace_build/01_stage, revision_notes.md
workspace_build/01_stage
workspace_build/01_stage
workspace_build/01_stage, revised_report.pdf
```

The final deliverable is `workspace_build/01_stage` (and its PDF).

---

## Running Stages Independently

You don't have to run the full pipeline. Each stage can be triggered on its own:

```bash
# Run just the writing stages (1–6)
opencode run --agent report "Build the report. Use APA citation style. Work through stages 1–6 only."

# Run just the evaluation
./07_evaluation/run_eval.sh                              # evaluates default final_report.md
./07_evaluation/run_eval.sh workspace_build/01_stage  # evaluate a specific file

# Run just the revision pass
./08_revision_pass/run_revise.sh

# Generate PDF from the revised report
python3 scripts/to_pdf.py

# Clean all outputs (start fresh)
./clean.sh
```

---

## Project Structure

```
generate/
├── .opencode/agents/       # AI agent definitions
│   ├── report.md           # Writer agent (Nova Pro)
│   ├── eval.md             # Evaluator agent (Claude Sonnet)
│   └── revise.md           # Revision agent (Claude Sonnet)
├── workspace_build/shared/references/      # Report inputs (update these per task)
├── workspace_build/01_stage     # Stage 1: scope the topic
├── workspace_build/01_stage# Stage 2: gather sources
├── workspace_build/01_stage             # Stage 3: build outline
├── workspace_build/01_stage            # Stage 4: write first draft
├── workspace_build/01_stage            # Stage 5: self-revise
├── workspace_build/01_stage        # Stage 6: format and finalize
├── workspace_build/01_stage          # Stage 7: grade against rubric
├── workspace_build/01_stage       # Stage 8: fix evaluation issues
├── scripts/to_pdf.py       # Markdown → PDF converter
├── run_report.sh           # Main pipeline script
└── clean.sh                # Reset all outputs
```

Each stage folder contains:
- `CONTEXT.md` — Instructions the agent follows for that stage
- `output/` — Generated artifacts
- `references/` — Stage-specific reference materials

---

## Tips

- Run `./clean.sh` between runs to reset all outputs.
- Drop source URLs in `workspace_build/01_stage` to feed them to the research stage.
- The evaluation stage uses Claude for strict grading — if everything passes on the first try, the rubric/requirements may need tightening.
- Subsequent runs append timestamps to filenames so previous outputs are preserved.
