#!/usr/bin/env python3
"""
Parse the revised presentation markdown, extract visual element descriptions,
generate AI images for each via Higgsfield CLI, and save to 08_final_assembly/output/.
"""

import json
import os
import re
import subprocess
import sys
from pathlib import Path

PROJECT_DIR = Path(__file__).resolve().parent.parent
INPUT_FILE = PROJECT_DIR / "10_revision_pass" / "output" / "revised_presentation.md"
OUTPUT_DIR = PROJECT_DIR / "08_final_assembly" / "output"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

MODEL = os.getenv("HF_MODEL", "seedream_v4_5")


def generate_image(prompt: str, filename: str) -> Path | None:
    """Use the Higgsfield CLI to generate an image and wait for the result."""
    cmd = [
        "higgsfield", "generate", "create", MODEL,
        "--prompt", prompt,
        "--aspect_ratio", "16:9",
        "--wait",
        "--json",
    ]

    try:
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=300)

        if result.returncode != 0:
            print(f"  ❌ CLI error: {result.stderr.strip()}")
            return None

        # Parse JSON output to find the image URL
        output = result.stdout.strip()
        data = json.loads(output)

        # Extract URL from response (CLI returns a list of jobs)
        url = None
        if isinstance(data, list) and data:
            url = data[0].get("result_url")
        elif isinstance(data, dict):
            url = data.get("result_url") or data.get("url")

        if not url:
            print(f"  ⚠️  No URL in response: {output[:200]}")
            return None

        # Download the image
        import requests
        resp = requests.get(url, timeout=120)
        resp.raise_for_status()

        ext = ".png"
        ct = resp.headers.get("Content-Type", "")
        if "jpeg" in ct or "jpg" in ct:
            ext = ".jpg"
        elif "webp" in ct:
            ext = ".webp"

        output_path = OUTPUT_DIR / f"{filename}{ext}"
        output_path.write_bytes(resp.content)
        return output_path

    except subprocess.TimeoutExpired:
        print(f"  ❌ Timeout (5min)")
        return None
    except json.JSONDecodeError:
        print(f"  ❌ Could not parse CLI output: {result.stdout[:200]}")
        return None
    except Exception as e:
        print(f"  ❌ Error: {e}")
        return None


def extract_visuals(markdown_text: str) -> list:
    """
    Parse the markdown and extract visual descriptions per slide.
    Returns a list of dicts: {slide, description, prompt}
    """
    visuals = []
    current_slide = None

    for line in markdown_text.splitlines():
        slide_match = re.match(r"^##\s+Slide\s+(\d+):\s*(.+)", line)
        if slide_match:
            current_slide = int(slide_match.group(1))
            continue

        # Skip references slide
        if current_slide and current_slide >= 6:
            continue

        # Extract visual element bullet points with (Source: ...)
        if current_slide and line.strip().startswith("- ") and "Source:" in line:
            desc = line.strip().lstrip("- ")
            desc = re.sub(r"\s*\(Source:.*?\)", "", desc)
            if desc:
                visuals.append({
                    "slide": current_slide,
                    "description": desc,
                    "prompt": f"Professional presentation visual: {desc}. Modern, clean, technology-themed, corporate style, dark blue and teal color scheme, high resolution, suitable for a PowerPoint slide, no text.",
                })

    return visuals


def main():
    # Optional: override input file with first argument
    input_file = INPUT_FILE
    if len(sys.argv) > 1:
        input_file = Path(sys.argv[1])

    if not input_file.exists():
        print(f"Error: {input_file} not found.")
        sys.exit(1)

    markdown_text = input_file.read_text(encoding="utf-8")
    visuals = extract_visuals(markdown_text)

    if not visuals:
        print("No visual elements found in the presentation.")
        sys.exit(1)

    print(f"Found {len(visuals)} visual elements to generate.")
    print(f"Model: {MODEL}")
    print(f"Output: {OUTPUT_DIR}\n")

    for i, visual in enumerate(visuals, start=1):
        slide = visual["slide"]
        desc = visual["description"]
        prompt = visual["prompt"]
        filename = f"slide_{slide:02d}_visual_{i:02d}"

        print(f"[{i}/{len(visuals)}] Slide {slide}: {desc}")

        saved_path = generate_image(prompt, filename)

        if saved_path:
            print(f"  ✅ Saved: {saved_path}")
        print()

    print(f"✅ Done. Check: {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
