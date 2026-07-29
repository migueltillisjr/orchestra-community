# Stage 5 — Revision

Review the full draft for quality and correctness.

## Input

Read `report/04_drafting/output/draft.md` for the complete first draft.

## Process

Review the full draft for:
- Logical coherence and argument strength
- Proper use of terminology
- Smooth transitions between paragraphs
- Grammar, spelling, and tone consistency
- Correct and complete citations

## Output

Use the write tool to save the following files to disk at the full repository-relative paths below:

| File | Contents |
|------|----------|
| `revised_draft.md` | The revised report with all corrections applied |
| `revision_notes.md` | Summary of changes made and why |

## Run Versioning

On subsequent runs, append a unique run ID (timestamp) to the filename:
- First run: `revised_draft.md`, `revision_notes.md`
- Subsequent runs: `revised_draft_<YYYYMMDD_HHMMSS>.md`, `revision_notes_<YYYYMMDD_HHMMSS>.md`

Generate the timestamp using `bash`: `date +%Y%m%d_%H%M%S`

## Rules

- Treat every file reference as a full repository-relative path.
- Always use the write tool to create the required outputs on disk at the exact paths specified here.
- Do not rely on chat-only output.
