#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./convert_md_to_pdf.sh
#   ./convert_md_to_pdf.sh input.md
#   ./convert_md_to_pdf.sh input.md output.pdf
#
# Behavior:
#   - No args: converts all *.md files in current directory
#   - One arg: converts that markdown file to same-name PDF
#   - Two args: converts input markdown to specified PDF

INPUT_MD="${1:-}"
OUTPUT_PDF="${2:-}"

if [[ -d ".event_plan" ]]; then
  source ".event_plan/bin/activate"
elif [[ -d ".venv" ]]; then
  source ".venv/bin/activate"
else
  python3 -m venv .event_plan
  source ".event_plan/bin/activate"
fi

python -m pip install --quiet --upgrade pip
python -m pip install --quiet "fpdf2" "markdown"

convert_one() {
  local input_file="$1"
  local output_file="$2"

  python - "$input_file" "$output_file" <<'PY'
import sys
import re
import textwrap
from pathlib import Path

from fpdf import FPDF
import markdown


input_path = Path(sys.argv[1])
output_path = Path(sys.argv[2])


def find_font():
    candidates = [
        "/System/Library/Fonts/Supplemental/Arial Unicode.ttf",
        "/System/Library/Fonts/Supplemental/Arial.ttf",
        "/System/Library/Fonts/Supplemental/Helvetica.ttf",
        "/System/Library/Fonts/Supplemental/Times New Roman.ttf",
        "/System/Library/Fonts/Supplemental/Andale Mono.ttf",
        "/Library/Fonts/Arial Unicode.ttf",
        "/Library/Fonts/Arial.ttf",
        "/Library/Fonts/DejaVuSans.ttf",
        "/Library/Fonts/NotoSans-Regular.ttf",
        "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
        "/usr/share/fonts/truetype/dejavu/DejaVuSansCondensed.ttf",
        "/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf",
        "/usr/share/fonts/truetype/noto/NotoSans-Regular.ttf",
    ]

    for candidate in candidates:
        if Path(candidate).exists():
            return candidate

    return None


def clean_text(text):
    replacements = {
        "\u00a0": " ",
        "\u200b": "",
        "\ufeff": "",

        # Smart punctuation
        "“": '"',
        "”": '"',
        "‘": "'",
        "’": "'",
        "–": "-",
        "—": "-",
        "…": "...",

        # Arrows
        "→": "->",
        "←": "<-",
        "↔": "<->",
        "⇒": "=>",
        "⇐": "<=",
        "⇔": "<=>",
        "➜": "->",
        "➔": "->",
        "➝": "->",
        "➞": "->",
        "➟": "->",

        # Bullets and symbols
        "•": "-",
        "◦": "-",
        "▪": "-",
        "▫": "-",
        "✓": "check",
        "✔": "check",
        "✗": "x",
        "✘": "x",
        "★": "*",
        "☆": "*",

        # Box drawing
        "├": "+",
        "└": "+",
        "┌": "+",
        "┐": "+",
        "┘": "+",
        "┬": "+",
        "┴": "+",
        "┼": "+",
        "─": "-",
        "│": "|",
        "╭": "+",
        "╮": "+",
        "╯": "+",
        "╰": "+",
        "═": "=",
        "║": "|",
        "╔": "+",
        "╗": "+",
        "╚": "+",
        "╝": "+",
    }

    for old, new in replacements.items():
        text = text.replace(old, new)

    # Strip emojis and dingbats that often break local fonts.
    text = re.sub(
        r"[\U0001F300-\U0001FAFF\U00002700-\U000027BF]",
        "",
        text,
    )

    return text


def break_long_tokens(text, max_len=70):
    """
    fpdf can crash on very long unbroken strings such as URLs,
    file paths, tokens, base64, long commands, or table cells.
    This inserts zero-width-ish break spaces as real spaces.
    """
    def break_token(token):
        if len(token) <= max_len:
            return token

        # Preserve URLs a little better by breaking after separators.
        token = re.sub(r"([/&?=._:-])", r"\1 ", token)

        pieces = []
        for part in token.split(" "):
            if len(part) > max_len:
                pieces.extend(textwrap.wrap(part, width=max_len, break_long_words=True))
            else:
                pieces.append(part)

        return " ".join(pieces)

    return " ".join(break_token(tok) for tok in text.split(" "))


def safe_line(line):
    line = clean_text(line)
    line = break_long_tokens(line)
    return line


def markdown_to_html(md_text):
    return markdown.markdown(
        md_text,
        extensions=[
            "extra",
            "tables",
            "sane_lists",
            "nl2br",
        ],
        output_format="html5",
    )


def add_basic_html_style(html):
    return f"""
<h1>{input_path.stem.replace("_", " ").title()}</h1>
{html}
"""


def force_unicode_font_in_html(html, font_name):
    replacements = [
        ('face="courier"', f'face="{font_name}"'),
        ("face='courier'", f"face='{font_name}'"),
        ('face="Courier"', f'face="{font_name}"'),
        ("face='Courier'", f"face='{font_name}'"),
        ("font-family: courier", f"font-family: {font_name}"),
        ("font-family: Courier", f"font-family: {font_name}"),
        ("font-family: monospace", f"font-family: {font_name}"),
    ]

    for old, new in replacements:
        html = html.replace(old, new)

    return html


class PDF(FPDF):
    def header(self):
        self.set_font(self.main_font, "", 8)
        self.set_text_color(90, 90, 90)
        self.cell(0, 6, input_path.name, new_x="LMARGIN", new_y="NEXT", align="R")
        self.ln(2)

    def footer(self):
        self.set_y(-12)
        self.set_font(self.main_font, "", 8)
        self.set_text_color(120, 120, 120)
        self.cell(0, 8, f"Page {self.page_no()}", align="C")


def render_plain_text_pdf(md_text, font_path):
    pdf = PDF(orientation="P", unit="mm", format="A4")
    pdf.set_auto_page_break(auto=True, margin=12)
    pdf.set_margins(left=12, top=12, right=12)
    pdf.main_font = "Helvetica"

    if font_path:
        pdf.add_font("UnicodeFont", "", font_path)
        pdf.main_font = "UnicodeFont"

    pdf.add_page()
    pdf.set_font(pdf.main_font, "", 9)
    pdf.set_text_color(20, 20, 20)

    for raw_line in md_text.splitlines():
        line = safe_line(raw_line)

        if not line.strip():
            pdf.ln(4)
            continue

        try:
            if line.startswith("# "):
                pdf.set_font(pdf.main_font, "", 15)
                pdf.multi_cell(0, 7, safe_line(line.replace("# ", "").strip()))
                pdf.ln(2)
                pdf.set_font(pdf.main_font, "", 9)

            elif line.startswith("## "):
                pdf.set_font(pdf.main_font, "", 13)
                pdf.multi_cell(0, 6, safe_line(line.replace("## ", "").strip()))
                pdf.ln(2)
                pdf.set_font(pdf.main_font, "", 9)

            elif line.startswith("### "):
                pdf.set_font(pdf.main_font, "", 11)
                pdf.multi_cell(0, 5.5, safe_line(line.replace("### ", "").strip()))
                pdf.ln(1)
                pdf.set_font(pdf.main_font, "", 9)

            else:
                pdf.multi_cell(0, 4.8, line)

        except Exception as exc:
            # Last-resort fallback for any individual line.
            fallback = re.sub(r"[^\x20-\x7E]", "", line)
            fallback = break_long_tokens(fallback, max_len=50)

            try:
                pdf.set_font(pdf.main_font, "", 8)
                pdf.multi_cell(0, 4.5, fallback)
                pdf.set_font(pdf.main_font, "", 9)
            except Exception:
                pdf.set_font(pdf.main_font, "", 8)
                pdf.multi_cell(0, 4.5, "[Line skipped because it could not be rendered safely]")
                pdf.set_font(pdf.main_font, "", 9)

    return pdf


def convert_file():
    md_text = input_path.read_text(encoding="utf-8", errors="replace")
    md_text = clean_text(md_text)

    font_path = find_font()

    html_text = break_long_tokens(md_text, max_len=70)
    html = markdown_to_html(html_text)
    html = add_basic_html_style(html)

    pdf = PDF(orientation="P", unit="mm", format="A4")
    pdf.set_auto_page_break(auto=True, margin=12)
    pdf.set_margins(left=12, top=12, right=12)
    pdf.main_font = "Helvetica"

    if font_path:
        pdf.add_font("UnicodeFont", "", font_path)
        pdf.main_font = "UnicodeFont"
    else:
        print("Warning: No Unicode font found. Falling back to Helvetica.")

    html = force_unicode_font_in_html(html, pdf.main_font)

    pdf.add_page()
    pdf.set_font(pdf.main_font, "", 9)
    pdf.set_text_color(20, 20, 20)

    try:
        pdf.write_html(html)
    except Exception as exc:
        print(f"HTML rendering failed for {input_path.name}. Falling back to plain text.")
        print(f"Original error: {exc}")
        pdf = render_plain_text_pdf(md_text, font_path)

    pdf.output(str(output_path))
    print(f"Created PDF: {output_path}")


convert_file()
PY
}

if [[ -z "$INPUT_MD" ]]; then
  shopt -s nullglob
  md_files=(./*.md)

  if [[ ${#md_files[@]} -eq 0 ]]; then
    echo "No .md files found in current directory."
    exit 0
  fi

  for md_file in "${md_files[@]}"; do
    pdf_file="${md_file%.md}.pdf"
    echo "Converting: $md_file -> $pdf_file"
    convert_one "$md_file" "$pdf_file"
  done

  echo "Done converting ${#md_files[@]} Markdown file(s)."
else
  if [[ ! -f "$INPUT_MD" ]]; then
    echo "Error: Markdown file not found: $INPUT_MD"
    exit 1
  fi

  if [[ -z "$OUTPUT_PDF" ]]; then
    OUTPUT_PDF="${INPUT_MD%.*}.pdf"
  fi

  convert_one "$INPUT_MD" "$OUTPUT_PDF"
fi