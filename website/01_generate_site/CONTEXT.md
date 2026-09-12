## Rules

- Read and follow `website/shared/references/DIRECTIONS.md` before starting this stage.


## Rules

- Use the maintained website source in `website/01_generate_site/references/`.
- **Always generate and save the website deliverable to `website/01_generate_site/output/index.html`.** This is the required final output path. Do not return a chat-only design, save the deliverable under another filename, or treat a file outside `website/01_generate_site/output/` as the final website. Keep asset paths relative to the output so the page can be opened and reviewed from disk.

## Process

The maintained source lives in `website/01_generate_site/references/`. `website/01_generate_site/output/index.html` is a **built artifact** assembled from `website/01_generate_site/references/template.html` + `website/01_generate_site/references/partials/*.html` via `website/01_generate_site/references/build_site.py` — edit the partials, then rerun the build; never hand-edit `website/01_generate_site/output/index.html` directly.

| Component | Description | How to use it | Location |
| --- | --- | --- | --- |
| Page shell | `<head>` (meta, fonts, stylesheet) plus `@include` markers wiring the partials together | Edit for global `<head>` changes (title, description, fonts) or to reorder/add sections | `website/01_generate_site/references/template.html` |
| Build script | Reads `website/01_generate_site/references/template.html`, inlines each `website/01_generate_site/references/partials/*.html`, writes the result | Run `/orchestra/environments/agents/website/bin/python website/01_generate_site/references/build_site.py` from the repository root after any partial edit to regenerate `website/01_generate_site/output/index.html` | `website/01_generate_site/references/build_site.py` |
| Header/nav | Logo, brand text, mobile menu toggle, main nav links | Edit nav items, logo image, or brand copy | `website/01_generate_site/references/partials/header.html` |
| Hero | Headline, intro copy, primary/secondary CTAs, hero images | Edit the main above-the-fold pitch and hero imagery | `website/01_generate_site/references/partials/hero.html` |
| Trust strip | Four short focus-area callouts under the hero | Edit the quick-scan credibility bullets | `website/01_generate_site/references/partials/trust-strip.html` |
| About | Mission statement and quote block | Edit mission/vision copy | `website/01_generate_site/references/partials/about.html` |
| Programs | Three program cards (Service, Extracurricular, Sponsor) | Add/edit/remove program offerings | `website/01_generate_site/references/partials/programs.html` |
| Values | Kindness / Service / Purpose value list | Edit organizational values copy | `website/01_generate_site/references/partials/values.html` |
| Future vision | Long-term vision statement and logo panel | Edit forward-looking mission copy | `website/01_generate_site/references/partials/future.html` |
| Team | Staff/board bios with photos | Add/edit/remove team member cards | `website/01_generate_site/references/partials/team.html` |
| Get involved | Mid-page CTA banner (start conversation, phone) | Edit the involvement call-to-action and phone number | `website/01_generate_site/references/partials/get-involved.html` |
| Contact | Contact details, social links, commented-out contact form | Edit phone/service area/social links; uncomment and wire up the form when a backend is chosen | `website/01_generate_site/references/partials/contact.html` |
| Footer | Footer brand, links, social, copyright | Edit footer links and copyright | `website/01_generate_site/references/partials/footer.html` |
| Images | Locally hosted logo, program, and team photos | Add new images to `website/01_generate_site/references/images/` and reference the corresponding filename in the relevant partial; generated asset links must resolve under `website/01_generate_site/output/images/` | `website/01_generate_site/references/images/` |
| Styling | All responsive CSS | Edit visual design, spacing, colors, breakpoints | `website/01_generate_site/references/style.css` |
| Behavior | Mobile nav toggle, scroll-reveal animation, footer year, (disabled) form handler | Edit interactive behavior | `website/01_generate_site/references/script.js` |


## Quality Requirements

- The generated page must open directly from `website/01_generate_site/output/index.html` with local assets.
- The first implementation must be ready for the evaluation stage, with no known blockers hidden from the next reviewer.
- Record unresolved content, legal, privacy, safeguarding, image-rights, and brand-approval gaps for the next stage.
- Convey hope, prayer, community, and civic care without becoming visually loud, preachy, or commercial.
- Make the first viewport answer what the organization is, who it serves, and what information the visitor can explore next.
- Use a clear hierarchy, warm human-centered imagery when provided, restrained decoration, and a palette with sufficient contrast.
- Favor expressive but readable typography, generous spacing, and strong mobile behavior over ornamental complexity.
- Make informational links obvious, but do not add transactional actions, manipulative urgency, or unsupported promises.
- Use semantic HTML, descriptive link text, meaningful image alt text, keyboard-visible focus, logical heading order, and reduced-motion-friendly animation.
- Do not put important information only in imagery, hover states, color, or animation.
- Keep sections full-width and purposeful; use cards only for genuinely repeated informational items such as stories, events, or updates.
