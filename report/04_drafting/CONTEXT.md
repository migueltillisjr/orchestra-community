# Stage 4 — Drafting

Write the report section by section, checking in with the user along the way.

## Input

Read `report/03_outline/output/outline.md` for the confirmed structure.

## Process

Write the report one section at a time. After each section:
- Show it to the user
- Ask for feedback or approval
- Move to the next section only after confirmation

## Output

Use the write tool to save the following files to disk at the full repository-relative paths below:

| File | Contents |
|------|----------|
| `draft.md` | The complete first draft of the report with all sections |

## Run Versioning

On subsequent runs, append a unique run ID (timestamp) to the filename:
- First run: `draft.md`
- Subsequent runs: `draft_<YYYYMMDD_HHMMSS>.md`

Generate the timestamp using `bash`: `date +%Y%m%d_%H%M%S`

## Rules

- Treat every file reference as a full repository-relative path.
- Always use the write tool to create the required outputs on disk at the exact paths specified here.
- Do not rely on chat-only output.
