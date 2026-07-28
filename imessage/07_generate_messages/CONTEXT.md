# Stage 7 — Send Message

Prepare and send the finalized iMessage campaign.

## Input

Read `imessage/06_revision_pass/output/revised_message.md` for the final, polished message content.

## Process

1. Read `imessage/06_revision_pass/output/revised_message.md`.
2. Extract the core message text to use as the campaign base.
3. Read `imessage/shared/references/CONTACT_LIST.md` and collect all recipient phone numbers.
4. For each contact in the list:
	- Use that contact's number for all remaining per-contact steps.
	- Get the last 5 messages exchanged with that contact, example:
        ```bash
        ./imessage.py --get-messages-for "+16197045891" --limit 5
        ```
5. Generate a unique, relevant message for each contact using:
	- the base campaign content from stage 6, and
	- that contact's recent message history.
6. Create `imessage/07_generate_messages/output/send_messages.md` as a Markdown table with one row per contact using this format, example:
    ```
    | Number | Message |
    |--------|---------|
    | +16197045891 | Hello from Agent. |
    ```
    - Keep each contact as exactly one table row.
    - Keep each message in a single `Message` cell even when it has multiple paragraphs.
    - Encode in-message line breaks as literal `\n` so the row is not split and content stays plain-text-safe.
    - Escape any `|` characters inside message text as `\|`.
    - Before sending with `imessage.py`, convert `\n` sequences back to real newlines.
    - For complex messages, prefer this pattern:
    ```
    | Number | Message |
    |--------|---------|
     | +16197045891 | Line one.\n\nLine two with support text \| opt-out text. |
    ```
7. Write the file to disk using the `write` tool.
8. Only after the file is written, optionally print a short preview in chat.

## Critical Write Requirement

- Do not return chat-only output.
- Do not rely on clipboard-only output (for example `pbcopy`) as the final result.
- The stage is incomplete until `imessage/07_generate_messages/output/send_messages.md` (or timestamped variant) exists on disk.

## Output

**Use the `write` tool to save to `imessage/07_generate_messages/output/`.**

| File | Contents |
|------|----------|
| `send_messages.md` | recipient(s) and message content in a Markdown table |

If `send_messages.md` already exists for the current run, write `send_messages_<YYYYMMDD_HHMMSS>.md` instead.

## Run Versioning

- First run: `send_messages.md`
- Subsequent runs: `send_messages_<YYYYMMDD_HHMMSS>.md`