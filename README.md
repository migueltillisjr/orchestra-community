# orchestra-community

This repository contains the helper assets used to work with Orchestra agent repositories in this environment. It is meant to make it easier to clone external agent repos into the workspace, configure the required environment variables, and trigger the release workflow.

## What is in this repo?

- [run-clone_agent_repo.sh](run-clone_agent_repo.sh) — clones a Git repository into the Orchestra workspace via the server endpoint.
- [example-env](example-env) — a minimal environment template for the clone script.
- [NOTES.md](NOTES.md) — operational notes and example commands.

## Prerequisites

Before using the clone helper, make sure you have:

- Bash and curl available locally
- Access to the Orchestra server
- A valid username/password (or other auth method supported by the server)
- The required environment variables set in a local .env file or exported in your shell

## Environment variables

The clone script expects the following variables:

- AWS_BEARER_TOKEN_BEDROCK
- AWS_BEARER_TOKEN
- AWS_REGION
- ORCHESTRA_SERVER_URL
- ORCHESTRA_DIRECTORY
- OPENCODE_SERVER_USERNAME
- OPENCODE_SERVER_PASSWORD
- ORCHESTRA_INSECURE_TLS
- ORCHESTRA_CURL_CONNECT_TIMEOUT
- ORCHESTRA_CURL_MAX_TIME

A starter template is available in [example-env](example-env).

## Clone an agent repository

Run the helper script with the repository URL and the server credentials:

```bash
./run-clone_agent_repo.sh \
  'https://github.com/your-org/your-agent-repo.git' \
  -u 'your-username' \
  -p 'your-password' \
  -s 'https://your-orchestra-server.example.com/acme' \
  --insecure
```

You can also override the workspace directory header with -d/--directory if needed.

## Cut a release

If the target repository has a release agent configured, you can trigger it with:

```bash
source .env && \
export AWS_BEARER_TOKEN_BEDROCK AWS_BEARER_TOKEN && \
opencode run --agent release "cut a release"
```

## Notes

- Use --insecure only when the server uses a self-signed or private certificate.
- If the server is hosted under a tenant path, include that path in the server URL (for example, https://server.example.com/acme).
