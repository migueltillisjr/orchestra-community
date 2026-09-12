## Rules

- Read and follow `/orchestra/home/{USER_NAME}/website/shared/references/DIRECTIONS.md` before starting this stage.
- Use the maintained website source in `/orchestra/home/{USER_NAME}/website/01_generate_site/references/`.
- **Always generate and save the website deliverable to `/orchestra/home/{USER_NAME}/website/01_generate_site/output/index.html`.** This is the required final output path. Do not return a chat-only design, save the deliverable under another filename, or treat a file outside `/orchestra/home/{USER_NAME}/website/01_generate_site/output/` as the final website. Keep asset paths relative to the output so the page can be opened and reviewed from disk.

## Process

1. Review the user's request and edit only the resources listed below that are relevant to the requested change. Use each resource's description and location to identify the correct file. 

    | Component | Description | How to use it | Location |
    | --- | --- | --- | --- |
    | Page shell | `<head>` (meta, fonts, stylesheet) plus `@include` markers wiring the partials together | Edit for global `<head>` changes (title, description, fonts) or to reorder/add sections | `/orchestra/home/{USER_NAME}/website/01_generate_site/references/template.html` |
    | Header/nav | Logo, brand text, mobile menu toggle, main nav links | Edit nav items, logo image, or brand copy | `/orchestra/home/{USER_NAME}/website/01_generate_site/references/partials/header.html` |
    | Hero | Headline, intro copy, primary/secondary CTAs, hero images | Edit the main above-the-fold pitch and hero imagery | `/orchestra/home/{USER_NAME}/website/01_generate_site/references/partials/hero.html` |
    | Trust strip | Four short focus-area callouts under the hero | Edit the quick-scan credibility bullets | `/orchestra/home/{USER_NAME}/website/01_generate_site/references/partials/trust-strip.html` |
    | About | Mission statement and quote block | Edit mission/vision copy | `/orchestra/home/{USER_NAME}/website/01_generate_site/references/partials/about.html` |
    | Programs | Three program cards (Service, Extracurricular, Sponsor) | Add/edit/remove program offerings | `/orchestra/home/{USER_NAME}/website/01_generate_site/references/partials/programs.html` |
    | Values | Kindness / Service / Purpose value list | Edit organizational values copy | `/orchestra/home/{USER_NAME}/website/01_generate_site/references/partials/values.html` |
    | Future vision | Long-term vision statement and logo panel | Edit forward-looking mission copy | `/orchestra/home/{USER_NAME}/website/01_generate_site/references/partials/future.html` |
    | Team | Staff/board bios with photos | Add/edit/remove team member cards | `/orchestra/home/{USER_NAME}/website/01_generate_site/references/partials/team.html` |
    | Get involved | Mid-page CTA banner (start conversation, phone) | Edit the involvement call-to-action and phone number | `/orchestra/home/{USER_NAME}/website/01_generate_site/references/partials/get-involved.html` |
    | Contact | Contact details, social links, commented-out contact form | Edit phone/service area/social links; uncomment and wire up the form when a backend is chosen | `/orchestra/home/{USER_NAME}/website/01_generate_site/references/partials/contact.html` |
    | Footer | Footer brand, links, social, copyright | Edit footer links and copyright | `/orchestra/home/{USER_NAME}/website/01_generate_site/references/partials/footer.html` |
    | Images | Locally hosted logo, program, and team photos | Add new images to `/orchestra/home/{USER_NAME}/website/01_generate_site/references/images/` and reference the corresponding filename in the relevant partial; generated asset links must resolve under `/orchestra/home/{USER_NAME}/website/01_generate_site/output/images/` | `/orchestra/home/{USER_NAME}/website/01_generate_site/references/images/` |
    | Styling | All responsive CSS | Edit visual design, spacing, colors, breakpoints | `/orchestra/home/{USER_NAME}/website/01_generate_site/references/style.css` |
    | Behavior | Mobile nav toggle, scroll-reveal animation, footer year, (disabled) form handler | Edit interactive behavior | `/orchestra/home/{USER_NAME}/website/01_generate_site/references/script.js` |

2. From the repository root, run `/orchestra/environments/agents/website/bin/python /orchestra/home/{USER_NAME}/website/01_generate_site/references/build_site.py` to rebuild the website.
