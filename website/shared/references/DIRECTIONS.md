## Rules

- Only do as defined in *.md files. Nothing else.
- Run everything relative to the project workspace.
- The canonical website source details live in `/orchestra/home/{USER_NAME}/website/shared/references/site/`; use this folder as the maintained reference for site assets, templates, partials, styling, scripts, and build inputs.
- When running python scripts use the shared python agent environment for python `.py` scripts at `/orchestra/environments/agents/website`; its dependencies are already installed.
- Run every Python command through `/orchestra/environments/agents/website/bin/python` so the shared environment's libraries are used.
- Do not create a local virtual environment for python, install packages, or fall back to the system interpreter. If the shared environment is missing, stop and report it.
- Keep secrets in `website/.env`; never expose credentials, tokens, or private configuration in generated files or chat output.
- Don't use `sudo` to run scripts
