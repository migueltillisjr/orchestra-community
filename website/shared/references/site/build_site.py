#!/usr/bin/env python3
"""Assemble template.html + partials/*.html into the active stage's output folder.

Copies CSS, JS, and images to the target output/ so all resources are co-located.

Run this after editing any partial or asset so index.html and resources stay in sync.
"""
from __future__ import annotations

import argparse
import re
import shutil
import sys
from pathlib import Path

SOURCE_DIR = Path(__file__).parent
PROJECT_ROOT = SOURCE_DIR.parents[2]
STAGE_OUTPUTS = {
    "01_generate_site": PROJECT_ROOT / "01_generate_site",
    "02_evaluate_site": PROJECT_ROOT / "02_evaluate_site",
    "03_refine_site": PROJECT_ROOT / "03_refine_site",
    "04_deploy_site": PROJECT_ROOT / "04_deploy_site",
}
TEMPLATE = SOURCE_DIR / "template.html"
INCLUDE_RE = re.compile(r"[ \t]*<!--\s*@include\s+(\S+)\s*-->[ \t]*\n?")

# Resources to copy to the stage directory
RESOURCES = {
    "style.css": SOURCE_DIR / "css" / "style.css",
    "script.js": SOURCE_DIR / "js" / "script.js",
}
RESOURCE_DIRS = ["images"]


def resolve_output_dir(stage: str | None = None, output_dir: str | None = None) -> Path:
    if output_dir:
        return Path(output_dir).expanduser().resolve()
    if stage:
        stage_dir = STAGE_OUTPUTS.get(stage)
        if stage_dir:
            return stage_dir
        return PROJECT_ROOT / stage
    return STAGE_OUTPUTS["01_generate_site"]


def build(stage: str | None = None, output_dir: str | None = None) -> None:
    output_path = resolve_output_dir(stage=stage, output_dir=output_dir)
    output_path.mkdir(parents=True, exist_ok=True)

    # Copy CSS and JS files
    for resource_name, src in RESOURCES.items():
        dst = output_path / resource_name
        if src.exists():
            if src.resolve() == dst.resolve():
                continue
            shutil.copy2(src, dst)

    # Copy resource directories
    for resource_dir in RESOURCE_DIRS:
        src = SOURCE_DIR / resource_dir
        dst = output_path / resource_dir
        if src.exists():
            if src.resolve() == dst.resolve():
                continue
            if dst.exists():
                shutil.copytree(src, dst, dirs_exist_ok=True)
            else:
                shutil.copytree(src, dst)

    # Build HTML
    template = TEMPLATE.read_text()

    def replace(match: re.Match) -> str:
        partial_path = SOURCE_DIR / match.group(1)
        return partial_path.read_text()

    output_file = output_path / "index.html"
    output_file.write_text(INCLUDE_RE.sub(replace, template))
    print(f"Wrote {output_file.relative_to(PROJECT_ROOT)}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Build the website into the selected stage output directory.")
    parser.add_argument("stage", nargs="?", choices=[*STAGE_OUTPUTS.keys()], help="Stage folder to target (default: 01_generate_site).")
    parser.add_argument("--output-dir", dest="output_dir", help="Absolute or relative path to use instead of the stage output folder.")
    args = parser.parse_args()

    build(stage=args.stage, output_dir=args.output_dir)
