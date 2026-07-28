#!/bin/bash
# Run the revise agent (Stage 10) using OpenCode CLI non-interactive mode

set -e

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "🔧 Running Stage 10 — Revision Pass..."
echo "   Project: $PROJECT_DIR"
echo ""

cd "$PROJECT_DIR"

opencode run \
  --agent revise \
  "Read 10_revision_pass/CONTEXT.md and follow its instructions exactly. Read the evaluation at 09_evaluation/output/evaluation.md, read the presentation at 08_final_assembly/output/final_presentation.html, apply all recommended fixes, and write the revised presentation to 10_revision_pass/output/revised_presentation.html using the write tool."

echo ""
echo "✅ Revision pass complete. Check 10_revision_pass/output/revised_presentation.html"
