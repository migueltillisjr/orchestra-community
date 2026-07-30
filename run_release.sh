#!/usr/bin/env bash

set -euo pipefail

# Deterministic release script for this repository.
# Usage:
#   ./run_release.sh
#   ./run_release.sh --summary "Custom release summary"

SUMMARY_OVERRIDE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --summary)
      if [[ $# -lt 2 ]]; then
        echo "Error: --summary requires a value." >&2
        exit 1
      fi
      SUMMARY_OVERRIDE="$2"
      shift 2
      ;;
    -h|--help)
      echo "Usage: $0 [--summary \"Custom release summary\"]"
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

if [[ ! -f "CHANGELOG.md" ]]; then
  echo "Error: CHANGELOG.md not found in repo root: $REPO_ROOT" >&2
  exit 1
fi

run_cmd() {
  "$@"
}

commit_with_lock_recovery() {
  local message="$1"
  local output
  local exit_code

  set +e
  output=$(git commit -m "$message" 2>&1)
  exit_code=$?
  set -e

  if [[ $exit_code -eq 0 ]]; then
    echo "$output"
    return 0
  fi

  if echo "$output" | grep -q "index.lock"; then
    set +e
    test -f .git/index.lock
    local lock_exists=$?
    set -e

    if [[ $lock_exists -eq 0 ]]; then
      echo "Persistent lock blocker: .git/index.lock exists." >&2
      echo "$output" >&2
      return 1
    fi

    echo "Transient index.lock detected; retrying commit once..."
    set +e
    output=$(git commit -m "$message" 2>&1)
    exit_code=$?
    set -e

    if [[ $exit_code -eq 0 ]]; then
      echo "$output"
      return 0
    fi

    echo "Commit retry failed:" >&2
    echo "$output" >&2
    return 1
  fi

  echo "Commit failed:" >&2
  echo "$output" >&2
  return 1
}

if [[ -n "$(git status --porcelain)" ]]; then
  echo "Local changes detected. Proceeding with deterministic release flow."
else
  echo "No local changes detected before sync."
fi

echo "Switching to main and syncing with origin..."
run_cmd git checkout main
run_cmd git pull origin main

current_branch="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$current_branch" != "main" ]]; then
  echo "Error: current branch is '$current_branch' (expected 'main')." >&2
  exit 1
fi

run_cmd git add -A :/

if [[ -z "$(git diff --cached --name-only)" ]]; then
  echo "No staged changes to release after sync; exiting without release."
  exit 0
fi

top_release_line="$(grep -nE '^##[[:space:]]+release/[0-9]+\.[0-9]+\.[0-9]+' CHANGELOG.md | head -1 || true)"
if [[ -z "$top_release_line" ]]; then
  echo "Error: no valid release heading found in CHANGELOG.md" >&2
  exit 1
fi

current_release="$(echo "$top_release_line" | sed -E 's/^[0-9]+:##[[:space:]]+(release\/[0-9]+\.[0-9]+\.[0-9]+).*$/\1/')"
if [[ -z "$current_release" ]]; then
  echo "Error: failed to parse current release heading from: $top_release_line" >&2
  exit 1
fi

major_minor="$(echo "$current_release" | sed -E 's#release/([0-9]+\.[0-9]+)\.[0-9]+#\1#')"
patch="$(echo "$current_release" | sed -E 's#release/[0-9]+\.[0-9]+\.([0-9]+)#\1#')"

if [[ -z "$major_minor" || -z "$patch" ]]; then
  echo "Error: failed to parse semantic version from $current_release" >&2
  exit 1
fi

echo "Fetching tags to locate next available release version..."
run_cmd git fetch --tags --prune --prune-tags

next_patch=$((patch + 1))
while true; do
  candidate="release/${major_minor}.${next_patch}"

  local_exists=1
  remote_exists=1

  if git rev-parse -q --verify "refs/tags/$candidate" >/dev/null 2>&1; then
    local_exists=0
  fi
  if git ls-remote --exit-code --tags origin "refs/tags/$candidate" >/dev/null 2>&1; then
    remote_exists=0
  fi

  if [[ $local_exists -ne 0 && $remote_exists -ne 0 ]]; then
    break
  fi

  next_patch=$((next_patch + 1))
done

staged_stats="$(git diff --cached --name-status)"
file_count="$(git diff --cached --name-only | wc -l | tr -d ' ')"
added_count="$(echo "$staged_stats" | awk '$1=="A" {c++} END {print c+0}')"
modified_count="$(echo "$staged_stats" | awk '$1=="M" {c++} END {print c+0}')"
deleted_count="$(echo "$staged_stats" | awk '$1=="D" {c++} END {print c+0}')"
primary_files="$(git diff --cached --name-only | head -5 | paste -sd ', ' -)"

if [[ -n "$SUMMARY_OVERRIDE" ]]; then
  summary="$SUMMARY_OVERRIDE"
else
  summary="Release prep: updated ${file_count} file(s) (A:${added_count} M:${modified_count} D:${deleted_count}); primary scope: ${primary_files}."
fi

existing_changelog="$(cat CHANGELOG.md)"
printf "## %s\n\n* %s\n\n%s" "$candidate" "$summary" "$existing_changelog" > CHANGELOG.md

run_cmd git add -A :/
run_cmd git rm --cached --ignore-unmatch release_sumary.txt >/dev/null 2>&1 || true

staged_files="$(git diff --cached --name-only)"
if ! echo "$staged_files" | grep -qx "CHANGELOG.md"; then
  echo "Error: CHANGELOG.md is not staged before commit." >&2
  exit 1
fi

changelog_diff="$(git diff --cached -- CHANGELOG.md)"
if echo "$changelog_diff" | grep -nE '^-##[[:space:]]+release/' >/dev/null; then
  echo "Error: staged CHANGELOG.md removed existing release heading(s)." >&2
  exit 1
fi
if ! echo "$changelog_diff" | grep -nE '^\+##[[:space:]]+release/[0-9]+\.[0-9]+\.[0-9]+' >/dev/null; then
  echo "Error: staged CHANGELOG.md does not add a valid release heading." >&2
  exit 1
fi

# Enforce exactly one blank line between summary bullet and next heading in the new top entry.
if ! awk 'NR<=8 {print}' CHANGELOG.md | grep -qE '^\* .+'; then
  echo "Error: new changelog summary bullet missing." >&2
  exit 1
fi
if ! awk 'NR<=8 {print}' CHANGELOG.md | grep -qE '^## release/[0-9]+\.[0-9]+\.[0-9]+'; then
  echo "Error: new top changelog heading missing." >&2
  exit 1
fi

commit_with_lock_recovery "$summary"

run_cmd git rev-parse -q --verify HEAD >/dev/null
last_commit_message="$(git log -1 --pretty=%B)"
if [[ "$last_commit_message" != "$summary" ]]; then
  echo "Error: last commit message does not match release summary." >&2
  exit 1
fi

if ! git diff-tree --no-commit-id --name-only -r HEAD | grep -qx "CHANGELOG.md"; then
  echo "Error: CHANGELOG.md not included in release commit." >&2
  exit 1
fi

run_cmd git push origin main --no-verify

run_cmd git fetch origin main
local_head="$(git rev-parse HEAD)"
remote_head="$(git rev-parse origin/main)"
if [[ "$local_head" != "$remote_head" ]]; then
  echo "Error: local HEAD does not match origin/main after push." >&2
  exit 1
fi

head_changelog_title="$(git show HEAD:CHANGELOG.md | head -1)"
if [[ "$head_changelog_title" != "## $candidate" ]]; then
  echo "Error: HEAD changelog top line is '$head_changelog_title' (expected '## $candidate')." >&2
  exit 1
fi

current_branch="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$current_branch" != "main" ]]; then
  echo "Error: not on main before tagging." >&2
  exit 1
fi

run_cmd git tag "$candidate"
run_cmd git rev-parse -q --verify "refs/tags/$candidate" >/dev/null
run_cmd git push origin "refs/tags/$candidate" --no-verify

run_cmd git checkout main
run_cmd git pull origin main

cat <<EOF
Release complete.
- Version created: $candidate
- Changelog entry added: yes
- Commit pushed to origin/main: yes
- Tag created and pushed: yes
- Final branch: $(git rev-parse --abbrev-ref HEAD)
EOF
