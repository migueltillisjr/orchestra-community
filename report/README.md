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

Update these files in `report/shared/references/` before running:

| File | What to put here |
|------|-----------------|
| `report/shared/references/REQUIREMENTS.md` | Your report prompt, task instructions, and submission guidelines |
| `report/shared/references/RUBRIC.md` | The grading rubric formatted as a markdown table |
| `report/shared/references/TEMPLATE.md` | (Optional) Document template the final report should follow |

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
| `report/shared/references/REQUIREMENTS.md` | Report instructions — what you need to write |
| `report/shared/references/RUBRIC.md` | Grading criteria — how the report will be scored |
| `report/shared/references/TEMPLATE.md` | (Optional) Required document structure/template |
| `report/02_research_and_sources/references/` | Drop URLs or source docs here for the research stage to use |
| `report/06_final_polish/references/AI_DEFENSE.md` | Writing style rules to make the output sound natural |

---

## Viewing Output

Each stage writes its results to its own `output/` directory:

```
report/01_topic_and_scope/output/scope.md
report/02_research_and_sources/output/sources.md, frameworks.md
report/03_outline/output/outline.md
report/04_drafting/output/draft.md
report/05_revision/output/revised_draft.md, revision_notes.md
report/06_final_polish/output/final_report.md
report/07_evaluation/output/evaluation.md
report/08_revision_pass/output/revised_report.md, revised_report.pdf
```

The final deliverable is `report/08_revision_pass/output/revised_report.md` (and its PDF).

---

## Running Stages Independently

You don't have to run the full pipeline. Each stage can be triggered on its own:

```bash
# Run just the writing stages (1–6)
opencode run --agent report "Build the report. Use APA citation style. Work through stages 1–6 only."

# Run just the evaluation
./07_evaluation/run_eval.sh                              # evaluates default final_report.md
./07_evaluation/run_eval.sh report/08_revision_pass/output/revised_report.md  # evaluate a specific file

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
├── report/shared/references/      # Report inputs (update these per task)
├── report/01_topic_and_scope/     # Stage 1: scope the topic
├── report/02_research_and_sources/# Stage 2: gather sources
├── report/03_outline/             # Stage 3: build outline
├── report/04_drafting/            # Stage 4: write first draft
├── report/05_revision/            # Stage 5: self-revise
├── report/06_final_polish/        # Stage 6: format and finalize
├── report/07_evaluation/          # Stage 7: grade against rubric
├── report/08_revision_pass/       # Stage 8: fix evaluation issues
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
- Drop source URLs in `report/02_research_and_sources/references/REFERENCES.md` to feed them to the research stage.
- The evaluation stage uses Claude for strict grading — if everything passes on the first try, the rubric/requirements may need tightening.
- Subsequent runs append timestamps to filenames so previous outputs are preserved.
