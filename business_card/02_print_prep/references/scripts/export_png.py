#!/usr/bin/env python3
"""Render the assembled business card's front and back as high-resolution PNGs.

Loads 02_print_prep/output/business_card.html in a headless browser and
screenshots the .front and .back card elements directly, the same way the
business_card_studio's "Download PNG" buttons capture the live DOM. This is
the print-prep export mechanism for stage 02_print_prep, replacing the
manual fpdf2 redraw in export_pdf.py.

Uses Playwright's own bundled Chromium (not a system-installed browser), so
this also runs on headless servers/containers with no workstation UI or
browser installed. Run `python -m playwright install --with-deps chromium`
once per environment before the first export.
"""

import sys
from pathlib import Path

try:
    from playwright.sync_api import Error as PlaywrightError
    from playwright.sync_api import sync_playwright
except ImportError:
    print("Missing dependency. Install the project's requirements.txt first.", file=sys.stderr)
    sys.exit(1)

STAGE_ROOT = Path(__file__).resolve().parent.parent.parent
HTML_FILE = STAGE_ROOT / "output" / "business_card.html"
FRONT_PNG = STAGE_ROOT / "output" / "business_card_front.png"
BACK_PNG = STAGE_ROOT / "output" / "business_card_back.png"

# card is authored at 3.5x2in; render at this many pixels per inch for print quality
DPI = 600
DEVICE_SCALE_FACTOR = DPI / 96  # Playwright viewport/screenshot scaling is expressed relative to 96 CSS dpi


def main() -> None:
    if not HTML_FILE.is_file():
        print(f"Missing {HTML_FILE}; run the HTML build step first.", file=sys.stderr)
        sys.exit(1)

    with sync_playwright() as p:
        try:
            # bundled Chromium works headless with no display and no system
            # browser install, unlike channel="chrome" which needs a
            # workstation-installed Google Chrome. --no-sandbox is required
            # when this runs as root in a container (common on CI/servers),
            # where Chromium's sandbox can't set up its namespaces.
            browser = p.chromium.launch(headless=True, args=["--no-sandbox"])
        except PlaywrightError:
            print(
                "Chromium isn't installed for Playwright. Run:\n"
                "  python -m playwright install --with-deps chromium\n"
                "using the same interpreter as this script, then retry.",
                file=sys.stderr,
            )
            sys.exit(1)

        page = browser.new_page(device_scale_factor=DEVICE_SCALE_FACTOR)
        page.goto(HTML_FILE.resolve().as_uri())
        page.wait_for_load_state("networkidle")

        front = page.locator(".card.front")
        back = page.locator(".card.back")
        front.screenshot(path=str(FRONT_PNG))
        back.screenshot(path=str(BACK_PNG))

        browser.close()

    print(f"Wrote {FRONT_PNG}")
    print(f"Wrote {BACK_PNG}")


if __name__ == "__main__":
    main()
