#!/bin/bash
# Run the iMessage campaign agent end-to-end.
# Stages 1–4 via prep, stage 5 via eval, stage 6 via revise,
# stage 7 via generate_messages, and stage 8 via send.

set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "💬 Running iMessage Campaign Builder..."
echo "   Project: $PROJECT_DIR"
echo ""

cd "$PROJECT_DIR"

# Activate virtual environment and load env vars
source .imessage/bin/activate; source .env;

# # Stage 1–4: Build the campaign
# echo "=== Stages 1–4: Building campaign ==="
# opencode run \
#   --agent imessage_prep \
#   "Build the iMessage campaign. Read shared/references/RUBRIC.md first, then work through stages 1 through 4 ONLY. Stop after writing 04_final_assembly/output/final_message.md. Do NOT attempt to run stages 5 or 6. Write output files to each stage's output/ directory."

# echo ""
# echo "=== Stage 5: Evaluating campaign ==="
# opencode run \
#   --agent imessage_eval \
#   "Evaluate the campaign. Read shared/references/RUBRIC.md, then read 04_final_assembly/output/final_message.md. Grade against the rubric and write evaluation to 05_evaluation/output/evaluation.md."

# echo ""
# echo "=== Stage 6: Revising campaign ==="
# opencode run \
#   --agent imessage_revise \
#   "Revise the campaign based on evaluation. Read 05_evaluation/output/evaluation.md and 04_final_assembly/output/final_message.md. Apply all recommended fixes and write the revised message to 06_revision_pass/output/revised_message.md."

# echo ""
# echo "=== Stage 7: Generating send messages ==="
# opencode run \
#   --agent imessage_generate_messages \
#   "Generate per-contact send messages. Read 06_revision_pass/output/revised_message.md and shared/references/CONTACT_LIST.md, then write 07_generate_messages/output/send_messages.md as a Number/Message markdown table."

# echo ""
# echo "=== Stage 8: Sending campaign ==="
# opencode run \
#   --agent imessage_send \
#   "Send from Stage 7 output only by running python3 08_send/send_from_table.py (mandatory). Do not use manual/ad-hoc send commands. Ensure send status is written to 08_send/output/send_status.md (or timestamped variant)."

echo ""
echo "=== Stage 9: Gathering responses ==="
opencode run \
  --agent imessage_respond \
  "Gather response context. Read 09_gather_responses/CONTEXT.md, process every number in 07_generate_messages/output/send_messages.md, retrieve each contact's last 5 messages, generate per-contact summary/response/suggestion, and write 09_gather_responses/output/response.md. Ensure multi-row output does not overwrite prior rows during the same run."



echo ""
echo "✅ Campaign pipeline complete."
# echo "   Final message: 06_revision_pass/output/revised_message.md"
# echo ""
# echo "📱 To send manually, use:"
# echo "   ./imessage.py \"+16197045891\" \"Your message here\""
# echo ""
# echo "📊 To check unread messages:"
# echo "   ./imessage.py --get-unread"
# echo "   ./imessage.py --get-unread --limit 5 --compact"
# echo ""
# echo "💡 Permissions required:"
# echo "   • Privacy & Security → Automation → VS Code/Terminal → Messages (for sending)"
# echo "   • Privacy & Security → Full Disk Access → VS Code/Terminal (for reading unread)"