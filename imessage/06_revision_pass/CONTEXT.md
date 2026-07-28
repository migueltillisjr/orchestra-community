# Stage 6 — Revision Pass

Apply all fixes identified in the evaluation to produce an improved message.

## Input

Read `imessage/05_evaluation/output/evaluation.md` for the list of issues and recommendations.
Read `imessage/04_final_assembly/output/final_message.md` for the current message.

## Process

1. Read the evaluation and identify every criterion rated ⚠️ or ❌.
2. For each non-Competent criterion, apply the recommended fix.
3. Preserve all sections rated ✅ Competent — do not weaken them.
4. Maintain professional tone and visual consistency throughout.

## Output

**Use the `write` tool to save to `imessage/06_revision_pass/output/`.**

| File | Contents |
|------|----------|
| `revised_message.md` | The complete revised message ready to re-evaluate |

## Run Versioning

- First run: `revised_message.md`
- Subsequent runs: `revised_message_<YYYYMMDD_HHMMSS>.md`

## Rules

- Only include the message in the output
- Don't include anything other than the message in the output
