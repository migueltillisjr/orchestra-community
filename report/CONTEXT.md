# Report Workflow

## Rules

- Use the shared agent environment at `/orchestra/environments/agents/report_*`; its dependencies are already installed.
- Run every Python command through `/orchestra/environments/agents/report_*/bin/python` so the shared environment's libraries are used.
- Do not create a local virtual environment, install packages, or fall back to the system interpreter. If the shared environment is missing, stop and report it.
- Treat every file reference in this workflow as a full repository-relative path.
- Always use the write tool to create the required outputs on disk at the exact paths specified here.
- Do not rely on chat-only output.
