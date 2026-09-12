#!/usr/bin/env bash
set -euo pipefail

# deploy_cloudflare_worker.sh
#
# Deploy a static HTML/CSS/JS site to Cloudflare Workers Static Assets
# and print the public workers.dev URL.
#
# This script deploys exclusively to the "prayforamericasyouth" Worker.
#
# Usage:
#   ./deploy_cloudflare_worker.sh ./site-directory
#
# Examples:
#   ./deploy_cloudflare_worker.sh ../output
#
# Authentication:
#   Option A: Interactive Wrangler login
#     npx wrangler login
#
#   Option B: Set a Cloudflare API token
#     export CLOUDFLARE_API_TOKEN="..."
#
# Requirements:
#   - Node.js
#   - npm / npx
#   - Internet access

die() {
  echo "ERROR: $*" >&2
  exit 1
}

command -v node >/dev/null 2>&1 || die "Node.js is required."
command -v npx >/dev/null 2>&1 || die "npx is required."

SITE_DIR="${1:-}"
WORKER_NAME="prayforamericasyouth"

[[ -n "$SITE_DIR" ]] || die "Usage: $0 <site-directory>"
[[ -d "$SITE_DIR" ]] || die "Site directory not found: $SITE_DIR"

# Resolve absolute path without depending on realpath being installed.
SITE_DIR="$(cd "$SITE_DIR" && pwd)"

[[ -f "$SITE_DIR/index.html" ]] || \
  die "Expected an index.html in: $SITE_DIR"

echo "Site directory : $SITE_DIR"
echo "Worker name    : $WORKER_NAME"
echo

# Confirm Wrangler can authenticate. If no API token is configured,
# Wrangler may use the browser-based OAuth credentials created by
# `wrangler login`.
echo "Checking Cloudflare authentication..."
if ! npx --yes wrangler@latest whoami >/dev/null 2>&1; then
  if [[ -n "${CLOUDFLARE_API_TOKEN:-}" ]]; then
    die "Cloudflare authentication failed with CLOUDFLARE_API_TOKEN."
  fi

  echo "No active Wrangler login was found."
  echo "Opening Cloudflare login..."
  npx --yes wrangler@latest login
fi

TMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/cf-worker-deploy.XXXXXX")"
cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

PUBLIC_DIR="$TMP_DIR/public"
mkdir -p "$PUBLIC_DIR"

# Copy the site so we do not modify the user's project.
# cp -R with '/.' preserves dotfiles as well.
cp -R "$SITE_DIR"/. "$PUBLIC_DIR"/

# Never deploy common local/dev files if they happen to be in the site directory.
cat > "$PUBLIC_DIR/.assetsignore" <<'EOF'
.git/
.gitignore
.DS_Store
node_modules/
.env
.env.*
wrangler.toml
wrangler.json
wrangler.jsonc
deploy_cloudflare_worker.sh
*.log
EOF

# Workers Static Assets can serve a static project without a Worker entry point.
# The asset directory is relative to this temporary config file.
cat > "$TMP_DIR/wrangler.jsonc" <<EOF
{
  "\$schema": "node_modules/wrangler/config-schema.json",
  "name": "$WORKER_NAME",
  "compatibility_date": "$(date +%Y-%m-%d)",
  "workers_dev": true,
  "assets": {
    "directory": "./public",
    "html_handling": "auto-trailing-slash",
    "not_found_handling": "404-page"
  }
}
EOF

echo
echo "Deploying to Cloudflare Workers..."
echo

# Capture both stdout and stderr because Wrangler's presentation can vary
# between versions.
set +e
DEPLOY_OUTPUT="$(
  cd "$TMP_DIR" &&
  npx --yes wrangler@latest deploy --config "$TMP_DIR/wrangler.jsonc" 2>&1
)"
STATUS=$?
set -e

printf '%s\n' "$DEPLOY_OUTPUT"

if [[ $STATUS -ne 0 ]]; then
  die "Wrangler deployment failed."
fi

# Prefer the workers.dev URL emitted by Wrangler.
PUBLIC_URL="$(
  printf '%s\n' "$DEPLOY_OUTPUT" |
    grep -Eo 'https://[A-Za-z0-9._-]+\.workers\.dev([/?#][^[:space:]]*)?' |
    head -n 1 |
    sed -E 's/[),.;]+$//' || true
)"

# Fallback: Wrangler sometimes prints another HTTPS URL format in deployment
# summaries. Use it only if no workers.dev URL was found.
if [[ -z "$PUBLIC_URL" ]]; then
  PUBLIC_URL="$(
    printf '%s\n' "$DEPLOY_OUTPUT" |
      grep -Eo 'https://[^[:space:]]+' |
      head -n 1 |
      sed -E 's/[),.;]+$//' || true
  )"
fi

echo
echo "============================================================"

if [[ -n "$PUBLIC_URL" ]]; then
  # Construct custom domain from worker ID + .com
  CUSTOM_DOMAIN="${WORKER_NAME}.com"
  
  echo "DEPLOYED"
  echo "Custom domain: $CUSTOM_DOMAIN"
  echo "Public URL: $PUBLIC_URL"
  echo "============================================================"
  # Final line is intentionally URL-only so other scripts can use:
  # URL=$(./deploy_cloudflare_worker.sh ./site | tail -n 1)
  echo "$CUSTOM_DOMAIN"
else
  echo "Deployment succeeded, but no public URL could be parsed."
  echo "Check the Wrangler deployment output above or the"
  echo "Cloudflare Workers dashboard for the Worker named:"
  echo "  $WORKER_NAME"
  echo "============================================================"
  exit 2
fi
