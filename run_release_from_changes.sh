#!/usr/bin/env bash

set -euo pipefail

# One-command deterministic release flow:
# 1) Generate CHANGES.md from staged changes
# 2) Require AI-authored CHANGE_SUMMARY via --summary
# 3) Run release with summary
# 4) Remove CHANGES.md

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
      echo "Usage: $0 --summary \"AI-authored release summary\""
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

if [[ -z "${SUMMARY_OVERRIDE// }" ]]; then
  echo "Error: --summary is required. AI must generate a descriptive summary from CHANGES.md." >&2
  exit 1
fi

./run_generate_changes.sh
./run_release.sh --summary "$SUMMARY_OVERRIDE"
rm -f CHANGES.md

echo "Release flow completed via run_release_from_changes.sh"
