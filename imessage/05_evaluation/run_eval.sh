#!/bin/bash
# Run the eval agent (Stage 9) using OpenCode CLI non-interactive mode
#
# Usage:
#   ./run_eval.sh                                            # evaluates default
#   ./run_eval.sh path/to/message.md                    # evaluates specific file

set -e

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PRES_FILE="${1:-08_final_assembly/output/final_message.html}"

echo "🔍 Running Stage 5 — Evaluation..."
echo "   Project:       $PROJECT_DIR"
echo "   message:  $PRES_FILE"
echo ""

cd "$PROJECT_DIR"

opencode run \
  --agent eval \
  "Read 05_evaluation/CONTEXT.md and follow its instructions exactly. Read the message at ${PRES_FILE}, evaluate it against shared/references/RUBRIC.md and shared/references/REQUIREMENTS.md, and write the evaluation to 05_evaluation/output/evaluation.md using the write tool."

echo ""
echo "✅ Evaluation complete. Check 05_evaluation/output/evaluation.md"
