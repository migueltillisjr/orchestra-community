#!/usr/bin/env bash

set -euo pipefail

# Build a short CHANGE_SUMMARY from CHANGES.md without loading the full diff.
# Usage:
#   ./run_extract_change_summary.sh

if [[ ! -f "CHANGES.md" ]]; then
  echo "Error: CHANGES.md not found. Run ./run_generate_changes.sh first." >&2
  exit 1
fi

extract_fenced_block() {
  local heading="$1"
  awk -v h="$heading" '
    $0 == h { in_heading=1; next }
    in_heading && /^```/ { if (!in_fence) { in_fence=1; next } else { exit } }
    in_heading && in_fence { print }
  ' CHANGES.md
}

STATUS_LINES="$(extract_fenced_block "## STAGED_FILE_STATUS")"
FILE_LINES="$(extract_fenced_block "## STAGED_FILES")"

if [[ -z "$FILE_LINES" ]]; then
  echo "No staged changes detected; nothing to summarize for release."
  exit 0
fi

TOTAL_FILES="$(echo "$FILE_LINES" | sed '/^\s*$/d' | wc -l | tr -d ' ')"
ADDED_COUNT="$(echo "$STATUS_LINES" | awk '$1=="A" {c++} END {print c+0}')"
MODIFIED_COUNT="$(echo "$STATUS_LINES" | awk '$1=="M" {c++} END {print c+0}')"
DELETED_COUNT="$(echo "$STATUS_LINES" | awk '$1=="D" {c++} END {print c+0}')"
RENAMED_COUNT="$(echo "$STATUS_LINES" | awk '$1=="R" {c++} END {print c+0}')"

PRIMARY_SCOPE="$(echo "$FILE_LINES" | sed '/^\s*$/d' | awk -F/ '{print $1}' | sort | uniq -c | sort -nr | head -3 | awk '{print $2}' | awk 'BEGIN{ORS=""} {if (NR>1) printf ", "; printf "%s", $0} END{print ""}')"
if [[ -z "$PRIMARY_SCOPE" ]]; then
  PRIMARY_SCOPE="repository root"
fi

echo "Updated ${TOTAL_FILES} files across ${PRIMARY_SCOPE} (A:${ADDED_COUNT} M:${MODIFIED_COUNT} D:${DELETED_COUNT} R:${RENAMED_COUNT}) to improve release readiness and deployment reliability."
