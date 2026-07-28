# Stage 8 — Final Assembly

**OUTPUT FORMAT: HTML ONLY. Do NOT output markdown. The final file MUST be a `.html` file.**

## Input

Read:
- `presentation/05_slide_content/output/slides.md`
- `presentation/06_visuals/output/visuals.md`

## References

| File | Purpose |
|------|---------|
| `presentation/shared/references/TEMPLATE.html` | **MANDATORY** — This is the HTML template. Copy its entire structure (CSS, JavaScript, HTML layout) and only replace the slide content inside the `<section class="stage">` element. |

## Process

1. **Read `presentation/shared/references/TEMPLATE.html` in full.** This is a complete, working HTML slideshow with embedded CSS and JavaScript.
2. **Copy the entire HTML file** — `<!DOCTYPE html>` through `</html>` — as the starting point.
3. **Replace ONLY the slide `<article>` elements** inside `<section class="stage">` with content from `presentation/05_slide_content/output/slides.md` and `presentation/06_visuals/output/visuals.md`.
4. **Keep everything else from the template unchanged:**
   - The `<style>` block (all CSS)
   - The `<script>` block (navigation JS)
   - The `.topbar`, `.progress-shell`, `.controls` elements
   - The class names (`.slide`, `.slide.full`, `.slide.active`, `.content`, `.visual`, `.glass-card`, `.eyebrow`, etc.)
5. Use the template's component patterns for visuals: `.threat-chart`, `.mini-card`, `.mfa-diagram`, `.factor`, `.metric`, `.timeline`, `.ref-list`, `.ref`, etc.
6. Ensure exactly **6 `<article class="slide">` elements** (5 content + 1 references).
7. The first slide must have class `slide full active`.
8. The references slide must have class `slide full`.
9. Update the `<title>` tag and `.brand span` text to match the presentation title.

## CRITICAL RULES

- **The output file extension MUST be `.html`**
- **The output MUST start with `<!DOCTYPE html>` and end with `</html>`**
- **Do NOT output markdown. Do NOT output a `.md` file.**
- **The file must open directly in a web browser as a working slideshow.**

## Output

**Use the `write` tool to create this file on disk:**

| File | Contents |
|------|----------|
| `presentation/08_final_assembly/output/final_presentation.html` | A complete, self-contained HTML file copied from the template with slide content replaced |

## Run Versioning

- First run: `final_presentation.html`
- Subsequent runs: `final_presentation_<YYYYMMDD_HHMMSS>.html`
