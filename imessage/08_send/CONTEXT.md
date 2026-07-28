# Stage 8 — Send iMessages

Send each prepared message from Stage 7 using `imessage.py`.

## Input

Read the most recent Stage 7 output table from `imessage/07_generate_messages/output/`:

- Prefer `send_messages.md` when it exists for the current run.
- Otherwise, use the latest `send_messages_<YYYYMMDD_HHMMSS>.md`.

## Process

1. Locate and read the selected Stage 7 file from `imessage/07_generate_messages/output/`.
2. Parse the Markdown table with exactly these columns:
     - `Number`
     - `Message`
3. Strictly iterate over each data row in the file, in order.
4. Send by running the Stage 8 helper script only:
    ```bash
    python3 imessage/08_send/send_from_table.py
    ```
5. Let the helper script perform row extraction, decoding, per-row sends, and status writing.
6. Write the status file to disk.

## Critical Rules

1. Read `imessage/08_send/CONTEXT.md` for the exact procedure.
2. Read `imessage/07_generate_messages/output/send_messages.md` if present; otherwise select the latest `send_messages_<YYYYMMDD_HHMMSS>.md` in that folder.
3. Parse only the markdown table rows with columns `Number` and `Message`.
4. For each row, decode:
     - `\n` to newline
     - `\|` to `|`
5. Send exactly one iMessage per row using `imessage/08_send/send_from_table.py` (which invokes `imessage.py` safely).
6. Record one status entry per attempted send and write to `imessage/08_send/output/send_status.md` (or timestamped variant).

## Quote-Safety Requirement (Mandatory)

- Never send by embedding long message bodies in a single-quoted shell argument.
- Forbidden example:
    - `python3 imessage.py +16197045891 'Here\'s ...'`
- Required safe methods:
    - Preferred: non-shell argv execution (for example, Python `subprocess.run(["python3", "imessage.py", number, message], check=False)`).
    - Acceptable shell fallback: heredoc into a variable, then pass `"$msg"`.
    - Also supported: pass the message through stdin heredoc directly to `imessage.py`.
- Do not use unsupported flags like `--send-message`, `--number`, or `--message`.

## Rules

- Do not generate new message content in this stage.
- Do not read contacts from `CONTACT_LIST.md` in this stage.
- Source of truth is strictly the Stage 7 output table.
- Always execute sends via `python3 imessage/08_send/send_from_table.py`.
- Do not use ad-hoc/manual send commands for Stage 8 execution.
- Send exactly one iMessage per row in that table.
- Do not skip rows unless sending fails; failures must be logged.
- Do not return chat-only output.

## Output

**Use the `write` tool to save to `imessage/08_send/output/`.**

| File | Contents |
|------|----------|
| `send_status.md` | send execution summary with one row per attempted send |

Helper script (required):

```bash
# Send using latest Stage 7 output file (stdin-safe internally)
python3 imessage/08_send/send_from_table.py

# Validate parsing/decoding without sending
python3 imessage/08_send/send_from_table.py --dry-run
```

Suggested status table format:

| Number | Status | Notes |
|--------|--------|-------|
| +16197045891 | sent | message delivered via `imessage.py` |

If `send_status.md` already exists for the current run, write `send_status_<YYYYMMDD_HHMMSS>.md` instead.

## Run Versioning

- First run: `send_status.md`
- Subsequent runs: `send_status_<YYYYMMDD_HHMMSS>.md`