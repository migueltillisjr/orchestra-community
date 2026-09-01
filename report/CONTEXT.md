# Report Workflow

## Rules

- Before continuing, detect whether `python3.13` is installed. When it is available, ensure the agent directory has a `.report/` virtual environment. Create it with `python3.13 -m venv .report` when it does not exist, then install `requirements.txt` into that environment with `.report/bin/python -m pip install -r requirements.txt`.
- Treat every file reference in this workflow as a full repository-relative path.
- Always use the write tool to create the required outputs on disk at the exact paths specified here.
- Do not rely on chat-only output.
