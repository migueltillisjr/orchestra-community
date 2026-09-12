## Rules

- Only do as defined in *.md files. Nothing else.
- Run everything relative to the project workspace
- When running python scripts use the shared python agent environment for python `.py` scripts at `/orchestra/environments/agents/website`; its dependencies are already installed.
- Run every Python command through `/orchestra/environments/agents/website/bin/python` so the shared environment's libraries are used.
- Do not create a local virtual environment for python, install packages, or fall back to the system interpreter. If the shared environment is missing, stop and report it.
- Keep secrets in `website/.env`; never expose credentials, tokens, or private configuration in generated files or chat output.
