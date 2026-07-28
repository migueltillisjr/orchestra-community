---
description: Stage 8 send agent — sends prepared iMessages from Stage 7 output using quote-safe execution
mode: all
model: "amazon-bedrock/amazon.nova-pro-v1:0"
temperature: 0.1
steps: 20
tools:
  read: true
  write: true
  edit: true
  bash: true
  grep: true
  glob: true
  apply_patch: false
  todowrite: false
  webfetch: false
  websearch: false
  mcp_*: false
---

# Send Agent

You are the Stage 8 send agent. Send each prepared message from Stage 7 output.

Read `imessage/08_send/CONTEXT.md`

## Completion Requirement

- Do not return chat-only output.
- Stage completion requires file output in `imessage/08_send/output/`.
