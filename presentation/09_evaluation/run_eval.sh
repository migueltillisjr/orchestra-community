#!/bin/bash
# Run the eval agent (Stage 9) using OpenCode CLI non-interactive mode
#
# Usage:
#   ./run_eval.sh                                            # evaluates default
#   ./run_eval.sh path/to/presentation.md                    # evaluates specific file

set -e

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PRES_FILE="${1:-08_final_assembly/output/final_presentation.html}"

echo "🔍 Running Stage 9 — Evaluation..."
echo "   Project:       $PROJECT_DIR"
echo "   Presentation:  $PRES_FILE"
echo ""

cd "$PROJECT_DIR"

opencode run \
  --agent eval \
  "Read 09_evaluation/CONTEXT.md and follow its instructions exactly. Read the presentation at ${PRES_FILE}, evaluate it against shared/references/RUBRIC.md and shared/references/REQUIREMENTS.md, and write the evaluation to 09_evaluation/output/evaluation.md using the write tool."

echo ""
echo "✅ Evaluation complete. Check 09_evaluation/output/evaluation.md"
