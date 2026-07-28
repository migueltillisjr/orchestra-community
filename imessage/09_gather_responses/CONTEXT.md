# Stage 09 — Gather Responses

Analyze recent message history per contact and prepare a response recommendation table.

## Input

Read contacts from `imessage/07_generate_messages/output/send_messages.md`.

## Process

1. Read `imessage/07_generate_messages/output/send_messages.md` and collect each contact number.
2. For each contact number, retrieve the latest 5 exchanged messages, example:
    ```bash
    ./imessage.py --get-messages-for "+16197045891" --limit 5 --compact
    ```

3. For each contact, analyze those 5 messages and create:
	- a concise summary of the recent conversation context, and
	- a suggested next response aligned to that summary, and
	- a `suggestion` decision value.
4. Build a Markdown table with exactly these columns, example:
    ```markdown
    | number | summary | response | suggestion |
    |--------|---------|----------|------------|
    | +16197045891 | Contact asked about ETF basics and timing. | Thanks for reaching out. A good start is broad-market ETFs; would you like a 2-minute breakdown tailored to your goal? | relevant |
    ```
5. Create one row per contact.
6. Write the table to `imessage/09_gather_responses/output/response.md`.

## Rules

- Do not skip contacts from `imessage/07_generate_messages/output/send_messages.md`.
- Use the last 5 messages per contact as the analysis basis.
- Keep each contact to one row.
- Output must be written to disk (not chat-only).
- For multi-contact runs, do not overwrite prior rows during the same run.
- Preferred write strategy: build all rows in memory and perform one final file write.
- If writing incrementally, append new rows only and preserve existing header + prior rows.
- The `response` field must follow one of two outcomes only:
    - If relevant: provide a concrete suggested message the user can send.
    - If not relevant: do not provide a business/finance follow-up message; set response to `not relevant`.
- Relevant responses must incorporate both:
    - what was discussed in the last 5 messages, and
    - the original campaign/advertisement intent and value proposition.
- Relevant responses should feel like a natural continuation of the existing thread (not a cold reset).
- If the last 5 messages are not relevant to finance, starting a meeting, attempts to get in contact, or other business topics, set `suggestion` to:
    - `text not relevant | open "imessage://+<number>"`

## Output

**Use the `write` tool to save to `imessage/09_gather_responses/output/`.**
Example
```markdown
| number | summary | response | suggestion |
|--------|---------|----------|------------|
| +16197045891 | Contact asked about ETF basics and timing. | Since you asked about ETF basics, I can send the free ETF guide I mentioned earlier with a simple 2-minute breakdown focused on long-term growth and how to pick a starter fund. Want me to send it now? | relevant |
| +12567167855 | Recent texts are casual/social with no finance or business intent. | not relevant | text not relevant \| open "imessage://+12567167855" |
```

## Run Versioning

- First run: `response.md`
- Subsequent runs: `response_<YYYYMMDD_HHMMSS>.md`