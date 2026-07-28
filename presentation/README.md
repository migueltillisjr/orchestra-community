# Presentation Generator

An AI-powered pipeline that builds, evaluates, and revises slide presentations using multiple OpenCode agents, with optional AI image generation via Higgsfield.

## Quick Start

### 1. Prerequisites

- [OpenCode CLI](https://opencode.ai) installed and configured
- Python 3.13+
- AWS Bedrock access (for Nova Pro and Claude Sonnet models)
- Higgsfield CLI (optional, for AI-generated visuals)

### 2. Setup

```bash
# Create and activate virtual environment
python3 -m venv .presentation
source .presentation/bin/activate

# Install Python dependencies
pip install -r requirements.txt

# Configure environment variables
cp .env.example .env   # then edit .env with your credentials
```

#### Higgsfield Setup (for AI image generation)

```bash
# Install Higgsfield CLI
brew install higgsfield-ai/tap/higgsfield

# Authenticate (opens browser)
higgsfield auth login
```

This will open your browser for authentication. Once approved, credentials are stored locally and the Python SDK will use them automatically.

### 3. Configure Your Presentation

Update these files in `presentation/shared/references/` before running:

| File | What to put here |
|------|-----------------|
| `presentation/shared/references/REQUIREMENTS.md` | Presentation specs (purpose, audience, tone, length) |
| `presentation/shared/references/RUBRIC.md` | Grading rubric formatted as a markdown table |
| `presentation/shared/references/GLOBAL_CONTEXT.md` | Source content (e.g., a blog post) the presentation is based on |
| `presentation/shared/references/TEMPLATE.html` | HTML slideshow template — the final output is generated from this |

### 4. Run

```bash
source .presentation/bin/activate
source .env
./run_presentation.sh
```

This runs the full pipeline: purpose → audience → title → structure → content → visuals → assembly → evaluate → revise.

---

## Files to Update Per Presentation

| File | Purpose |
|------|---------|
| `presentation/shared/references/REQUIREMENTS.md` | Presentation specs — purpose, audience, tone, length, visual style |
| `presentation/shared/references/RUBRIC.md` | Grading criteria for the presentation |
| `presentation/shared/references/GLOBAL_CONTEXT.md` | The source content (blog post, brief, etc.) to base the presentation on |
| `presentation/shared/references/TEMPLATE.html` | HTML slideshow template — stage 8 copies this and replaces slide content |
| `presentation/08_final_assembly/references/AI_DEFENSE.md` | (Optional) Writing style rules for natural-sounding content |

---

## Viewing Output

Each stage writes its results to its own `output/` directory:

```
presentation/01_purpose/output/purpose.md
presentation/02_audience/output/audience.md
presentation/03_title/output/title.md
presentation/04_structure/output/structure.md
presentation/05_slide_content/output/slides.md
presentation/06_visuals/output/visuals.md
presentation/07_speaker_notes/output/speaker_notes.md
presentation/08_final_assembly/output/final_presentation.html
presentation/09_evaluation/output/evaluation.md
presentation/10_revision_pass/output/revised_presentation.html
```

The final deliverable is `presentation/10_revision_pass/output/revised_presentation.html` — a self-contained HTML slideshow you can open directly in a browser. It includes keyboard navigation (← → arrows, Space), a progress bar, slide dots, fullscreen mode (F key), and a print-friendly layout.

---

## Running Stages Independently

Each stage can be triggered on its own:

```bash
# Run just the writing stages (1–8)
opencode run --agent presentation "Build the presentation. Work through stages 1–8 only."

# Run just the evaluation
./09_evaluation/run_eval.sh
./09_evaluation/run_eval.sh presentation/10_revision_pass/output/revised_presentation.md

# Run just the revision pass
./10_revision_pass/run_revise.sh

# Generate AI images (optional)
python3 scripts/higgsfield_gen.py "A cybersecurity operations center with holographic displays"

# Clean all outputs (start fresh)
./clean.sh
```

---

## AI Image Generation (Higgsfield)

The `scripts/higgsfield_gen.py` script generates presentation visuals using AI:

```bash
# Default cybersecurity prompt
python3 scripts/higgsfield_gen.py

# Custom prompt
python3 scripts/higgsfield_gen.py "A futuristic shield protecting a network of connected devices"
```

**Requirements:**
- Set `HF_KEY` (or `HF_API_KEY` + `HF_API_SECRET`) in your `.env`
- Images are saved to `higgsfield_outputs/`

---

## Project Structure

```
├── .opencode/agents/           # AI agent definitions
│   ├── presentation.md         # Writer agent (Nova Pro)
│   ├── eval.md                 # Evaluator agent (Claude Sonnet)
│   └── revise.md               # Revision agent (Claude Sonnet)
├── presentation/shared/references/          # Presentation inputs (update per task)
│   ├── REQUIREMENTS.md
│   ├── RUBRIC.md
│   ├── GLOBAL_CONTEXT.md
│   └── TEMPLATE.html
├── presentation/01_purpose/                 # Stage 1: clarify purpose
├── presentation/02_audience/                # Stage 2: define audience
├── presentation/03_title/                   # Stage 3: create title
├── presentation/04_structure/               # Stage 4: build slide structure
├── presentation/05_slide_content/           # Stage 5: write slide content
├── presentation/06_visuals/                 # Stage 6: visual suggestions
├── presentation/07_speaker_notes/           # Stage 7: speaker notes (optional)
├── presentation/08_final_assembly/          # Stage 8: assemble final presentation
├── presentation/09_evaluation/              # Stage 9: grade against rubric
├── presentation/10_revision_pass/           # Stage 10: fix evaluation issues
├── scripts/
│   ├── to_pdf.py               # Markdown → PDF converter
│   └── higgsfield_gen.py       # AI image generation
├── run_presentation.sh         # Main pipeline script
└── clean.sh                    # Reset all outputs
```

Each stage folder contains:
- `CONTEXT.md` — Instructions the agent follows for that stage
- `output/` — Generated artifacts
- `references/` — Stage-specific reference materials

---

## Tips

- Run `./clean.sh` between runs to reset all outputs.
- The evaluation stage uses Claude for strict grading — Nova Pro was too lenient.
- Subsequent runs append timestamps to filenames so previous outputs are preserved.
- Use `higgsfield_gen.py` to create custom visuals for your slides.
