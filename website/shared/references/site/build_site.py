#!/usr/bin/env python3
"""Assemble template.html + partials/*.html into ../output/index.html.

Copies CSS, JS, and images to output/ so all resources are co-located.

Run this after editing any partial or asset so index.html and resources stay in sync.
"""
from pathlib import Path
import re
import shutil

# Script is in 01_generate_site/references/, so source files are here
SOURCE_DIR = Path(__file__).parent
# Output goes to 01_generate_site/output/
OUTPUT_DIR = SOURCE_DIR.parent / "output"
TEMPLATE = SOURCE_DIR / "template.html"
OUTPUT = OUTPUT_DIR / "index.html"
INCLUDE_RE = re.compile(r"[ \t]*<!--\s*@include\s+(\S+)\s*-->[ \t]*\n?")

# Resources to copy to output directory
RESOURCES = ["style.css", "script.js"]
RESOURCE_DIRS = ["images"]


def build() -> None:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    
    # Copy CSS and JS files
    for resource in RESOURCES:
        src = SOURCE_DIR / resource
        dst = OUTPUT_DIR / resource
        if src.exists():
            shutil.copy2(src, dst)
    
    # Copy resource directories
    for resource_dir in RESOURCE_DIRS:
        src = SOURCE_DIR / resource_dir
        dst = OUTPUT_DIR / resource_dir
        if src.exists():
            if dst.exists():
                shutil.rmtree(dst)
            shutil.copytree(src, dst)
    
    # Build HTML
    template = TEMPLATE.read_text()

    def replace(match: re.Match) -> str:
        partial_path = SOURCE_DIR / match.group(1)
        return partial_path.read_text()

    OUTPUT.write_text(INCLUDE_RE.sub(replace, template))
    print(f"Wrote {OUTPUT.relative_to(SOURCE_DIR.parent.parent)}")


if __name__ == "__main__":
    build()
