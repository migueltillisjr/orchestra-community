# Website Directions

These directions apply to every stage of the Pray for America's Youth website workflow. Each stage `CONTEXT.md` adds only phase-specific instructions.

## Environment

- Use the shared python agent environment for python `.py` scripts at `/orchestra/environments/agents/website`; its dependencies are already installed.
- Run every Python command through `/orchestra/environments/agents/website/bin/python` so the shared environment's libraries are used.
- Do not create a local virtual environment for python, install packages, or fall back to the system interpreter. If the shared environment is missing, stop and report it.
- Keep secrets in `website/.env`; never expose credentials, tokens, or private configuration in generated files or chat output.

## Shared References

Read these before making or evaluating changes:

- `website/shared/references/REQUIREMENTS.md` defines the informational-only product scope, content structure, responsive behavior, accessibility requirements, and acceptance criteria.
- `website/shared/references/RUBRIC.md` defines weighted scoring and release gates.
- `website/shared/references/organization_info/` contains the source-backed identity, mission, service area, program boundaries, contact details, legal gaps, media notes, privacy guidance, provider findings, and launch decisions.
- `website/shared/references/images/` contains captured public-site assets that remain provisional until rights, consent, crop suitability, and organization approval are confirmed.

Use only documented facts. P.R.A.Y. means Positive Reinforcement for America's Youth; Keith Smith is identified as founder; and the published service area is the Fox Valley and surrounding areas. Do not invent program names, schedules, statistics, legal status, phone numbers, addresses, testimonials, impact claims, or organizational relationships.

## Scope

- Build an informational website only. Do not add donations, volunteer applications, event registration, prayer submissions, partner inquiries, contact forms, program applications, or other data-collection workflows.
- Use informational links for mission, vision, founder, work themes, service area, resources, events, organization details, and verified social accounts.
- Preserve unrelated user changes and keep maintained website source separate from generated output.

## Visual Direction

- Create a hopeful, human, community-centered experience that feels safe and credible without becoming a generic charity template, commercial funnel, or visually loud campaign.
- Use the P.R.A.Y. name and expanded name as the primary identity signal. Define the acronym in visible text on first use.
- Use `Cormorant` and `BioRhyme` as typography references because they appear on the existing site. Provide readable fallbacks, test loading behavior, and do not rely on downloaded fonts for meaning.
- Use a calm, optimistic palette with strong contrast and generous neutral space. No official color system is published, so provisional colors must not be described as approved branding.
- Use semantic HTML, meaningful alt text, logical headings, visible keyboard focus, WCAG AA contrast, responsive layouts, and readable content at all required breakpoints.

## Common Verification

Unless a stage says otherwise, review at 320px, 375px, 768px, 1024px, and 1440px widths. Check overflow, navigation, informational links, image and font loading, contrast, focus states, keyboard operation, reduced motion, privacy boundaries, console errors, and local asset paths. Never claim a check passed unless it was actually run.
