# Agents

This project uses three OpenCode agents orchestrated via shell scripts to generate, evaluate, and revise slide presentations.

## Architecture

```
run_presentation.sh
├── presentation agent (stages 1–8)  →  builds presentation
├── eval agent (stage 9)             →  grades against rubric
├── revise agent (stage 10)          →  applies fixes
└── eval agent (stage 11)            →  final grade on revised version
```

---

## Agent Definitions

All agent files live in `.opencode/agents/`.

### 1. `presentation.md` — Presentation Writer

| Property | Value |
|----------|-------|
| Model | `amazon-bedrock/amazon.nova-pro-v1:0` |
| Temperature | 0.1 |
| Steps | 20 |
| Purpose | Build the presentation through stages 1–8 |

**Behavior:**
- Reads `presentation/shared/references/REQUIREMENTS.md`, `RUBRIC.md`, and `GLOBAL_CONTEXT.md` before starting.
- Walks through: purpose → audience → title → structure → content → visuals → notes → assembly.
- Each stage reads the previous stage's `output/` and writes its own deliverables to disk.
- Stops after stage 8 when run non-interactively via `run_presentation.sh`.

**Tools enabled:** read, write, edit, bash, grep, glob, todowrite, webfetch, websearch

---

### 2. `eval.md` — Presentation Evaluator

| Property | Value |
|----------|-------|
| Model | `amazon-bedrock/anthropic.claude-sonnet-4-5-20250929-v1:0` |
| Temperature | 0.0 |
| Steps | 10 |
| Purpose | Critically grade the presentation against the rubric |

**Behavior:**
- Reads the rubric and requirements, then the presentation.
- Follows `presentation/09_evaluation/CONTEXT.md` for YES/NO verification per criterion.
- Assigns emoji ratings: ✅ Competent, ⚠️ Approaching Competence, ❌ Not Evident.
- Writes evaluation to `presentation/09_evaluation/output/evaluation.md`.

**Tools enabled:** read, write, bash, grep, glob

---

### 3. `revise.md` — Revision Agent

| Property | Value |
|----------|-------|
| Model | `amazon-bedrock/anthropic.claude-sonnet-4-5-20250929-v1:0` |
| Temperature | 0.2 |
| Steps | 15 |
| Purpose | Apply evaluation fixes to produce a passing presentation |

**Behavior:**
- Reads the evaluation output and identifies non-Competent criteria.
- Reads the current presentation from `presentation/08_final_assembly/output/final_presentation.html`.
- Applies fixes systematically.
- Writes the revised presentation to `presentation/10_revision_pass/output/revised_presentation.html`.

**Tools enabled:** read, write, edit, bash, grep, glob, webfetch, websearch

---

## Scripts

| Script | Purpose |
|--------|---------|
| `run_presentation.sh` | Full pipeline — stages 1–8, eval, revise, final eval |
| `presentation/09_evaluation/run_eval.sh [file]` | Standalone evaluation (optional file override) |
| `presentation/10_revision_pass/run_revise.sh` | Standalone revision pass |
| `scripts/to_pdf.py` | Convert final markdown to PDF |
| `scripts/higgsfield_gen.py [prompt]` | Generate AI images for slide visuals |
| `clean.sh` | Remove all generated files from output directories |

---

## Stage I/O Contract

| Stage | Purpose | Output |
|-------|---------|--------|
| 1. Purpose | Clarify the main message and goal | `purpose.md` |
| 2. Audience | Define who it's for, tone, word choice | `audience.md` |
| 3. Title | Create a strong, relevant title | `title.md` |
| 4. Structure | Build 5-slide logical structure | `structure.md` |
| 5. Slide Content | Write focused content per slide with citations | `slides.md` |
| 6. Visuals | Suggest modern, tech-related visuals per slide | `visuals.md` |
| 7. Speaker Notes | Skipped (none required for this presentation) | `speaker_notes.md` |
| 8. Final Assembly | Produce a self-contained HTML slideshow from the template | `final_presentation.html` |
| 9. Evaluation | Grade against rubric with emoji scoring | `evaluation.md` |
| 10. Revision Pass | Fix non-Competent criteria, output revised HTML | `revised_presentation.html` |

---

## Output Format

The final deliverable is a **self-contained HTML file** (`revised_presentation.html`) that:
- Opens directly in any browser as a working slideshow
- Uses keyboard navigation (← → arrows, Space, F for fullscreen)
- Has a progress bar, slide dots, and slide counter
- Follows a dark glassmorphism design theme
- Is responsive and fits all content within viewport
- Includes a print-friendly mode

The HTML template lives at `presentation/shared/references/TEMPLATE.html`. Stage 8 copies it and replaces only the slide content.

---

## Model Selection Rationale

| Task | Model | Why |
|------|-------|-----|
| Writing | Nova Pro | Cost-effective, good for creative content generation |
| Evaluation | Claude Sonnet 4.5 | Needs precision and strict reasoning |
| Revision | Claude Sonnet 4.5 | Needs nuanced fix application and source verification |
