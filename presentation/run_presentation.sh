#!/bin/bash
# Run the presentation agent end-to-end.
# Stages 1–8 via the presentation agent, then 9–10 via specialized agents.

set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "📝 Running Presentation Builder..."
echo "   Project: $PROJECT_DIR"
echo ""

cd "$PROJECT_DIR"

# Activate virtual environment and load env vars
source .presentation/bin/activate;source .env;

# Stage 1–8: Build the presentation
echo "=== Stages 1–8: Building presentation ==="
opencode run \
  --agent presentation \
  "Build the presentation. Read shared/references/REQUIREMENTS.md and shared/references/RUBRIC.md first, then work through stages 1 through 8 ONLY. Stop after writing 08_final_assembly/output/final_presentation.html. Do NOT attempt to run stages 9 or 10. Write output files to each stage's output/ directory."

echo ""
echo "=== Stage 9: Evaluation ==="
bash 09_evaluation/run_eval.sh

echo ""
echo "=== Stage 10: Revision Pass ==="
bash 10_revision_pass/run_revise.sh

echo ""
echo "=== Stage 11: Final Evaluation ==="
bash 09_evaluation/run_eval.sh 10_revision_pass/output/revised_presentation.html

echo ""
echo "✅ All stages complete."
echo "   Final presentation: 10_revision_pass/output/revised_presentation.html"
