## Rules

- Use the shared agent environment at `/orchestra/environments/agents/business_card`; its dependencies are already installed.
- Run every Python command through `/orchestra/environments/agents/business_card/bin/python` so the shared environment's libraries are used.
- Do not create a local virtual environment, install packages, or fall back to the system interpreter. If the shared environment is missing, stop and report it.
- `export_png.py` uses Playwright's own bundled headless Chromium (not a system browser), so it runs on headless servers/containers with no display and no workstation browser install. If Chromium isn't installed yet for this environment, run `/orchestra/environments/agents/business_card/bin/python -m playwright install --with-deps chromium` once, then retry.

## Process

1. Treat `01_create/output/` as the source artifact for print preparation. Confirm that `01_create/output/business_card.html` exists before continuing.
2. Copy the complete contents of `01_create/output/*` into `02_print_prep/output/`, including `business_card.html` and the entire `images/` directory. Preserve the source filenames and relative image paths.
3. Confirm that `02_print_prep/output/business_card.html` references the copied assets from `02_print_prep/output/images/`, including `headshot_pic.jpg` and `qr-code.jpg`. Do not substitute unrelated images or regenerate the QR destination during print preparation.
4. Read the print-prep source needed by the renderer, `02_print_prep/references/scripts/export_png.py`. It uses Playwright (a headless Chrome browser) to screenshot the actual `.front` and `.back` card elements from `02_print_prep/output/business_card.html`, the same way `business_card_studio.html`'s "Download PNG" buttons capture the live DOM. Do not use `export_pdf.py`'s manual fpdf2 redraw or the generic Markdown-to-PDF converter for the business card.
5. Run `/orchestra/environments/agents/business_card/bin/python 02_print_prep/references/scripts/export_png.py`. If the shared environment is unavailable, stop and report it instead of using a local or system interpreter.
6. Ensure the script writes `02_print_prep/output/business_card_front.png` and `02_print_prep/output/business_card_back.png`, each a screenshot of the card's actual 3.5 × 2 inch design at 600 DPI (2100 × 1200 px), with no cropping, distortion, or missing overlays (photo frame, QR code).
7. Inspect both PNGs and verify the front and back each show the complete card design pixel-for-pixel as it renders in the browser, with readable text, a clear portrait, and a scannable QR code.
8. Leave `02_print_prep/output/business_card.html`, `02_print_prep/output/images/`, `02_print_prep/output/business_card_front.png`, and `02_print_prep/output/business_card_back.png` together as the print-prep handoff. Report the PNG paths and any asset or print-quality limitation.



## Quality Requirements

- The prior-stage `01_create/output/business_card.html` and all files under `01_create/output/images/` must be copied before conversion.
- The output must be two PNGs — `business_card_front.png` and `business_card_back.png` — each capturing the full 3.5 × 2 inch card design at 600 DPI (2100 × 1200 px).
- No clipped artwork, distortion, or missing overlays (photo frame, QR code) may appear; the PNGs must match the live HTML rendering exactly.
- Text must remain readable at actual print size, the portrait must remain clear, and the QR code must retain strong contrast and quiet space.
- Confirm both PNGs can be opened and reviewed independently of the browser preview.

