#!/bin/bash
# Clone an agent repository into the Orchestra workspace.
# Usage: ./run_clone_agent_repo.sh <git_url> [options]
#
# This script calls the Orchestra server's /project/clone endpoint to clone
# a git repo into the current user's workspace. The cloned repo's
# .opencode/agents/*.md files will be available as selectable agents in the UI
# once the user switches to that project directory.
#
# Examples:
#   ./run_clone_agent_repo.sh https://github.com/migueltillisjr/mwp-report-gen.git
#   ./run_clone_agent_repo.sh https://github.com/user/my-agents.git --name custom-name
#   ./run_clone_agent_repo.sh https://github.com/user/my-agents.git -u admin -p secret123

set -euo pipefail

# --- Configuration (env var defaults) ---
SERVER_URL="${ORCHESTRA_SERVER_URL:-http://localhost:4096}"
DIRECTORY="${ORCHESTRA_DIRECTORY:-}"
USERNAME="${OPENCODE_SERVER_USERNAME:-}"
PASSWORD="${OPENCODE_SERVER_PASSWORD:-}"
INSECURE_TLS="${ORCHESTRA_INSECURE_TLS:-false}"
CURL_CONNECT_TIMEOUT="${ORCHESTRA_CURL_CONNECT_TIMEOUT:-10}"
CURL_MAX_TIME="${ORCHESTRA_CURL_MAX_TIME:-300}"

# --- Parse arguments ---
GIT_URL=""
REPO_NAME=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -u|--user|--username)
      USERNAME="$2"
      shift 2
      ;;
    -p|--pass|--password)
      PASSWORD="$2"
      shift 2
      ;;
    -n|--name)
      REPO_NAME="$2"
      shift 2
      ;;
    -s|--server)
      SERVER_URL="$2"
      shift 2
      ;;
    --insecure)
      INSECURE_TLS="true"
      shift
      ;;
    -d|--directory)
      DIRECTORY="$2"
      shift 2
      ;;
    -h|--help)
      echo "Usage: $0 <git_url> [options]"
      echo ""
      echo "Options:"
      echo "  -u, --username   Basic auth username (overrides OPENCODE_SERVER_USERNAME)"
      echo "  -p, --password   Basic auth password (overrides OPENCODE_SERVER_PASSWORD)"
      echo "  -n, --name       Custom name for the cloned directory"
      echo "  -s, --server     Server URL (overrides ORCHESTRA_SERVER_URL, default: http://localhost:4096)"
      echo "      --insecure   Skip TLS certificate verification (curl -k)"
      echo "  -d, --directory  Workspace directory header value"
      echo "  -h, --help       Show this help message"
      echo ""
      echo "Examples:"
      echo "  $0 https://github.com/migueltillisjr/mwp-report-gen.git"
      echo "  $0 https://github.com/user/my-agents.git -u admin -p mypass"
      echo "  $0 https://github.com/user/my-agents.git --server https://web5.infopnr.com/acme --insecure"
      echo "  $0 https://github.com/user/my-agents.git --name reports --server https://web5.infopnr.com/acme"
      exit 0
      ;;
    -*)
      echo "Unknown option: $1"
      exit 1
      ;;
    *)
      if [[ -z "$GIT_URL" ]]; then
        GIT_URL="$1"
      else
        echo "Unexpected argument: $1"
        exit 1
      fi
      shift
      ;;
  esac
done

if [[ -z "$GIT_URL" ]]; then
  echo "Error: git URL is required."
  echo "Run '$0 --help' for usage."
  exit 1
fi

# --- Build request ---
BODY='{"url":"'"$GIT_URL"'"'
if [[ -n "$REPO_NAME" ]]; then
  BODY="$BODY"',"name":"'"$REPO_NAME"'"'
fi
BODY="$BODY}"

HEADERS=(-H "Content-Type: application/json")
COOKIE_JAR="$(mktemp -t orchestra-clone-cookie.XXXXXX)"
trap 'rm -f "$COOKIE_JAR"' EXIT

CURL_ARGS=(
  --silent
  --show-error
  --connect-timeout "$CURL_CONNECT_TIMEOUT"
  --max-time "$CURL_MAX_TIME"
)

if [[ "$INSECURE_TLS" == "true" ]]; then
  CURL_ARGS+=(--insecure)
fi

run_curl() {
  local response
  local exit_code

  set +e
  response=$(curl "$@")
  exit_code=$?
  set -e

  if [[ $exit_code -eq 0 ]]; then
    printf "%s" "$response"
    return 0
  fi

  # Keep HTTPS in use, but allow invalid certs when verification fails.
  if [[ "$INSECURE_TLS" != "true" && "$SERVER_URL" == https://* && $exit_code -eq 60 ]]; then
    echo "TLS verification failed; retrying over HTTPS with invalid-cert allowance..." >&2
    set +e
    response=$(curl --insecure "$@")
    exit_code=$?
    set -e
    if [[ $exit_code -eq 0 ]]; then
      printf "%s" "$response"
      return 0
    fi
  fi

  return $exit_code
}

if [[ -n "$DIRECTORY" ]]; then
  HEADERS+=(-H "x-opencode-directory: $DIRECTORY")
fi

# --- Authenticate ---
# Try local auth login first (JWT), fall back to basic auth
TOKEN=""
LOGIN_CODE=""
LOGIN_BODY=""
if [[ -n "$USERNAME" && -n "$PASSWORD" ]]; then
  if ! LOGIN_RESPONSE=$(run_curl "${CURL_ARGS[@]}" -c "$COOKIE_JAR" -w "\n%{http_code}" -X POST \
    "$SERVER_URL/auth/login" \
    -H "Content-Type: application/json" \
    -d '{"username":"'"$USERNAME"'","password":"'"$PASSWORD"'"}'); then
    echo "Warning: login request failed, falling back to basic auth if credentials are set."
    LOGIN_RESPONSE=""
  fi

  LOGIN_CODE=$(echo "$LOGIN_RESPONSE" | tail -1)
  LOGIN_BODY=$(echo "$LOGIN_RESPONSE" | sed '$d')

  # If auth endpoint returns HTML, URL likely points at a UI path (for example /acme).
  # Retry at host root and keep HTTPS.
  if [[ "$LOGIN_CODE" == "200" && "$LOGIN_BODY" == "<"* && "$SERVER_URL" == http*://*/* ]]; then
    ROOT_SERVER_URL=$(echo "$SERVER_URL" | sed -E 's#^(https?://[^/]+).*#\1#')
    if [[ "$ROOT_SERVER_URL" != "$SERVER_URL" ]]; then
      echo "Auth endpoint at $SERVER_URL returned HTML; retrying at $ROOT_SERVER_URL"
      SERVER_URL="$ROOT_SERVER_URL"
      if ! LOGIN_RESPONSE=$(run_curl "${CURL_ARGS[@]}" -c "$COOKIE_JAR" -w "\n%{http_code}" -X POST \
        "$SERVER_URL/auth/login" \
        -H "Content-Type: application/json" \
        -d '{"username":"'"$USERNAME"'","password":"'"$PASSWORD"'"}'); then
        echo "Warning: root login retry failed, falling back to basic auth if credentials are set."
        LOGIN_RESPONSE=""
      fi
      LOGIN_CODE=$(echo "$LOGIN_RESPONSE" | tail -1)
      LOGIN_BODY=$(echo "$LOGIN_RESPONSE" | sed '$d')
    fi
  fi

  if [[ "$LOGIN_CODE" == "200" ]]; then
    TOKEN=$(echo "$LOGIN_BODY" | python3 -c "import sys,json; print(json.load(sys.stdin).get('token',''))" 2>/dev/null || echo "")
    HEADERS+=(-b "$COOKIE_JAR")
  fi

  if [[ -n "$TOKEN" ]]; then
    HEADERS+=(-H "Authorization: Bearer $TOKEN")
  else
    # Fall back to basic auth
    HEADERS+=(-u "$USERNAME:$PASSWORD")
  fi
fi

echo "Cloning $GIT_URL into workspace..."
echo "Server: $SERVER_URL"
if [[ "$INSECURE_TLS" == "true" ]]; then
  echo "TLS verify: disabled (--insecure)"
fi
echo ""

if ! RESPONSE=$(run_curl "${CURL_ARGS[@]}" -w "\n%{http_code}" -X POST \
  "$SERVER_URL/project/clone" \
  "${HEADERS[@]}" \
  -d "$BODY"); then
  echo "❌ Clone request failed before HTTP response."
  echo "Hints:"
  echo "  - If your cert is self-signed/private, retry with --insecure"
  echo "  - Ensure server URL includes tenant base path (example: https://web5.infopnr.com/acme)"
  echo "  - Check network connectivity and DNS"
  exit 1
fi

HTTP_CODE=$(echo "$RESPONSE" | tail -1)
BODY_RESPONSE=$(echo "$RESPONSE" | sed '$d')

if [[ "$HTTP_CODE" == "200" ]]; then
  echo "✅ Clone successful!"
  echo "$BODY_RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$BODY_RESPONSE"
  echo ""
  CLONE_DIR=$(echo "$BODY_RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin).get('directory',''))" 2>/dev/null || echo "")
  if [[ -n "$CLONE_DIR" ]]; then
    echo "To use the agents from this repo, switch your project directory to:"
    echo "  $CLONE_DIR"
    echo ""
    echo "The following agents will be available:"
    if [[ -d "$CLONE_DIR/.opencode/agents" ]]; then
      for f in "$CLONE_DIR/.opencode/agents/"*.md; do
        [[ -f "$f" ]] && echo "  - $(basename "$f" .md)"
      done
    else
      echo "  (agents will be available on the server)"
    fi
  fi
else
  echo "❌ Clone failed (HTTP $HTTP_CODE)"
  echo "$BODY_RESPONSE"
  if [[ "$HTTP_CODE" == "401" ]]; then
    echo ""
    echo "Auth diagnostics:"
    if [[ -n "$LOGIN_CODE" ]]; then
      echo "  - /auth/login returned HTTP $LOGIN_CODE"
    fi
    if [[ "$USERNAME" == *"@"* ]]; then
      echo "  - Local auth uses the full email address as the username. Try creator01@example.com instead of creator01."
    fi
    echo "  - Confirm credentials in DynamoDB user table and that OPENCODE_AUTH_LOCAL mode matches your login method."
  fi
  exit 1
fi
