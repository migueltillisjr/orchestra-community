# Google Veo / Gemini Video Generator

Generate professional AI-powered videos with your own likeness using Google's Veo model and Gemini API.

## Quick Start

### 1. Prerequisites

- Python 3.13+
- [Gemini API key](https://aistudio.google.com) (free tier available)
- 1-3 clear reference photos of yourself (JPG, PNG, or WebP)

### 2. Setup

```bash
# Activate virtual environment
source .ai_vids/bin/activate

# Upgrade pip
python -m pip install --upgrade pip

# Install dependencies
pip install -r requirements.txt
```

### 3. Configure Your API Key

Edit `.env` and add your Gemini API key:

```env
GEMINI_API_KEY=your_key_here
```

Get a free key at [Google AI Studio](https://aistudio.google.com).

### 4. Add Your Reference Images

Place 1-3 clear photos in the `inputs/` folder:

```
inputs/
  me_1.jpg          # Clear, well-lit photo
  me_2.jpg          # Different angle (optional)
  me_3.jpg          # Another angle (optional)
```

**Good reference image rules:**
- Use clear, well-lit photos
- Use different angles if possible
- Avoid sunglasses, heavy filters, or extreme facial expressions
- Only use photos where you have permission

### 5. Generate Your Video

```bash
source .ai_vids/bin/activate

# With one reference image
python generate_veo_video.py \
  --prompt prompts/founder_video.txt \
  --images inputs/me_1.jpg \
  --output outputs/founder_video.mp4

# With three reference images
python generate_veo_video.py \
  --prompt prompts/founder_video.txt \
  --images inputs/me_1.jpg inputs/me_2.jpg inputs/me_3.jpg \
  --output outputs/founder_video.mp4
```

Generated videos save to `outputs/`.

---

## Folder Structure

| Folder | Purpose |
|--------|---------|
| `inputs/` | Place your 1-3 reference photos here |
| `outputs/` | Generated MP4 videos appear here |
| `prompts/` | Video prompts (text descriptions of what to generate) |
| `.ai_vids/` | Python virtual environment |

---

## Creating Custom Prompts

Add new prompts to `prompts/` folder. Example:

```bash
touch prompts/operations_audit_ad.txt
```

Then edit with your description. Use this template:

```text
Use the uploaded reference images as the same person throughout the video.

Create an 8-second business ad showing me helping a small business owner simplify operations.

Scene:
I am reviewing a workflow map on a laptop. The screen transitions from scattered tasks into a clean operations scorecard.

Style:
Modern consulting commercial, realistic office environment, warm light, calm and trustworthy.

Motion:
Camera slowly moves from the laptop screen to me reviewing the system.

Audio:
Light background music only. No spoken words.

Avoid:
No logos, no financial guarantees, no fake testimonial, no misleading claims.
```

### Run with custom prompt:

```bash
python generate_veo_video.py \
  --prompt prompts/operations_audit_ad.txt \
  --images inputs/me_1.jpg inputs/me_2.jpg inputs/me_3.jpg \
  --output outputs/operations_audit_ad.mp4
```

---

## Command Line Options

```bash
python generate_veo_video.py \
  --prompt prompts/founder_video.txt  # Path to prompt file (required)
  --output outputs/video.mp4           # Output video path (default: outputs/veo_output.mp4)
  --images inputs/me_1.jpg ...         # Reference images (optional, up to 3)
  --model veo-3.1-generate-preview     # Model to use (default shown)
  --poll-seconds 10                    # Seconds between status checks
```

---

## Troubleshooting

### Missing API Key

```
Error: Missing GEMINI_API_KEY
```

**Fix:** Add your key to `.env`:
```env
GEMINI_API_KEY=your_key_here
```

Or export in shell:
```bash
export GEMINI_API_KEY="your_key_here"
```

### Reference Images Not Working

**Check file format:**
```bash
file inputs/me_1.jpg
```

**Supported formats:** `.jpg`, `.jpeg`, `.png`, `.webp`

### Model Not Available

```
Error: Model not found / Permission denied
```

**Check:**
- Your Gemini API key is valid
- Your Google account has access to Veo model
- Billing is enabled (if required)
- Visit [Google AI Studio](https://aistudio.google.com) to verify access

### Update SDK if errors occur

```bash
pip install --upgrade google-genai
```

---

## Best Practices

### Start Simple

**Best first video format:**
- 8 seconds long
- Vertical aspect ratio
- No spoken words (silent or background music only)
- Professional office or business scene
- Clear visual transformation

This reduces:
- Awkward mouth movement
- Identity drift concerns
- Lip-sync issues
- Fake endorsement risks

### Use Permission-Based Content

**Always include this at the top of prompts:**

```text
The reference images are of me, and I have permission to use them.

Generate a professional video using my likeness. Do not make the person appear to endorse a product, political message, medical claim, financial guarantee, or anything misleading. Do not imitate a celebrity or another real person. Keep the result professional, realistic, and non-deceptive.
```

---

## Example Video Templates

### Founder Intro
```text
Use the uploaded reference images as the same person throughout the video.

Create an 8-second vertical video for social media.

Scene:
I am standing in a modern office, looking confident and approachable. Behind me are subtle visuals of organized business workflows, clean dashboards, and automation diagrams.

Style:
Professional founder introduction, realistic, cinematic, clean lighting, premium business brand feel.

Motion:
Slow camera push-in, subtle head movement, natural expression.

Audio:
Soft modern background music. No spoken words.

Avoid:
No logos, no fake claims, no exaggerated money imagery, no celebrity resemblance.
```

### AI Consulting Brand Video
```text
Use the uploaded reference images as the same person throughout the video.

Create a cinematic 8-second video for an AI business consulting brand.

Scene:
I am working at a desk with a clean dashboard showing automated workflows, customer questions, and business process improvements.

Mood:
Focused, confident, trustworthy, practical.

Style:
Realistic, professional, modern, clean, premium lighting.

Motion:
Slow camera push-in, subtle hand movement, natural facial expression.

Audio:
Soft background music. No spoken words.
```

---

## Output

Generated videos are saved as MP4 files in `outputs/` folder. Download and use directly in your content, website, or social media.
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
├── ai_vid/shared/references/      # Report inputs (update these per task)
├── ai_vid/01_stage     # Stage 1: scope the topic
├── ai_vid/01_stage# Stage 2: gather sources
├── ai_vid/01_stage             # Stage 3: build outline
├── ai_vid/01_stage            # Stage 4: write first draft
├── ai_vid/01_stage            # Stage 5: self-revise
├── ai_vid/01_stage        # Stage 6: format and finalize
├── ai_vid/01_stage          # Stage 7: grade against rubric
├── ai_vid/01_stage       # Stage 8: fix evaluation issues
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
- Drop source URLs in `ai_vid/01_stage` to feed them to the research stage.
- The evaluation stage uses Claude for strict grading — if everything passes on the first try, the rubric/requirements may need tightening.
- Subsequent runs append timestamps to filenames so previous outputs are preserved.
