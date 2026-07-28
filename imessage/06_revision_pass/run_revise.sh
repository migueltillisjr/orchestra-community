#!/bin/bash
# Run the revise agent (Stage 10) using OpenCode CLI non-interactive mode

set -e

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "🔧 Running Stage 6 — Revision Pass..."
echo "   Project: $PROJECT_DIR"
echo ""

cd "$PROJECT_DIR"

opencode run \
  --agent revise \
  "Read 06_revision_pass/CONTEXT.md and follow its instructions exactly. Read the evaluation at 05_evaluation/output/evaluation.md, read the message at 08_final_assembly/output/final_message.html, apply all recommended fixes, and write the revised message to 06_revision_pass/output/revised_message.html using the write tool."

echo ""
echo "✅ Revision pass complete. Check 06_revision_pass/output/revised_message.md"
