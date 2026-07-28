#!/usr/bin/env python3

import argparse
import datetime as dt
import re
import subprocess
import sys
from pathlib import Path


def find_input_file(output_dir: Path) -> Path:
    base_file = output_dir / "send_messages.md"
    if base_file.exists():
        return base_file

    candidates = sorted(output_dir.glob("send_messages_*.md"))
    if not candidates:
        raise FileNotFoundError(
            f"No send message files found in {output_dir}. "
            "Expected send_messages.md or send_messages_<YYYYMMDD_HHMMSS>.md"
        )

    return candidates[-1]


def parse_send_table(file_path: Path) -> list[tuple[str, str]]:
    rows: list[tuple[str, str]] = []

    for raw_line in file_path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()

        if not line.startswith("|"):
            continue

        # Skip header and separator lines.
        if line.lower().startswith("| number | message |"):
            continue
        if re.match(r"^\|\s*-+\s*\|\s*-+\s*\|\s*$", line):
            continue

        # Parse leniently: require a leading table bar and a first column separator,
        # but tolerate a missing trailing bar on the row.
        row = line[1:].strip() if line.startswith("|") else line
        if row.endswith("|"):
            row = row[:-1].strip()

        if "|" not in row:
            continue

        number, message = row.split("|", 1)
        number = number.strip()
        message = message.strip()

        if not number or not message:
            continue

        rows.append((number, message))

    return rows


def decode_message(raw_message: str) -> str:
    return raw_message.replace(r"\n", "\n").replace(r"\|", "|")


def choose_status_file(output_dir: Path) -> Path:
    primary = output_dir / "send_status.md"
    if not primary.exists():
        return primary

    stamp = dt.datetime.now().strftime("%Y%m%d_%H%M%S")
    return output_dir / f"send_status_{stamp}.md"


def run_send(python_bin: str, imessage_script: Path, number: str, message: str) -> subprocess.CompletedProcess:
    return subprocess.run(
        [python_bin, str(imessage_script), number],
        input=message,
        text=True,
        capture_output=True,
        check=False,
    )


def write_status(status_path: Path, source_file: Path, results: list[dict]) -> None:
    lines = [
        f"# Stage 8 Send Status",
        "",
        f"Source file: `{source_file}`",
        "",
        "| Number | Status | Notes |",
        "|--------|--------|-------|",
    ]

    for result in results:
        notes = result["notes"].replace("\n", " ").replace("|", r"\|").strip()
        if not notes:
            notes = "-"
        lines.append(f"| {result['number']} | {result['status']} | {notes} |")

    status_path.parent.mkdir(parents=True, exist_ok=True)
    status_path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Send Stage 7 generated iMessages using stdin-safe invocation."
    )
    parser.add_argument(
        "--input-file",
        help="Optional explicit path to send_messages markdown file.",
    )
    parser.add_argument(
        "--python-bin",
        default=sys.executable,
        help="Python executable to run imessage.py (default: current interpreter).",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Parse and decode rows without sending messages.",
    )

    args = parser.parse_args()

    project_dir = Path(__file__).resolve().parents[1]
    stage7_output_dir = project_dir / "07_generate_messages" / "output"
    stage8_output_dir = project_dir / "08_send" / "output"
    imessage_script = project_dir / "imessage.py"

    input_file = Path(args.input_file) if args.input_file else find_input_file(stage7_output_dir)
    if not input_file.exists():
        print(f"Input file not found: {input_file}", file=sys.stderr)
        return 1

    rows = parse_send_table(input_file)
    if not rows:
        print(f"No sendable rows found in {input_file}", file=sys.stderr)
        return 1

    results: list[dict] = []

    for number, raw_message in rows:
        decoded_message = decode_message(raw_message)

        if args.dry_run:
            results.append(
                {
                    "number": number,
                    "status": "dry-run",
                    "notes": "decoded and validated; not sent",
                }
            )
            continue

        proc = run_send(args.python_bin, imessage_script, number, decoded_message)
        status = "sent" if proc.returncode == 0 else "failed"
        notes = (proc.stdout or "").strip() or (proc.stderr or "").strip()

        results.append(
            {
                "number": number,
                "status": status,
                "notes": notes,
            }
        )

    status_file = choose_status_file(stage8_output_dir)
    write_status(status_file, input_file, results)

    print(f"Processed {len(results)} row(s).")
    print(f"Status written to: {status_file}")

    failures = [result for result in results if result["status"] == "failed"]
    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
