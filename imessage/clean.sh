#!/bin/bash
# Clean all output directories but keep .gitkeep files.

set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "🧹 Cleaning output directories..."

find "$PROJECT_DIR" -type d -name "output" | while read -r dir; do
  if echo "$dir" | grep -q "08_final_assembly"; then
    find "$dir" -type f ! -name ".gitkeep" ! -name "*.png" -delete
  else
    find "$dir" -type f ! -name ".gitkeep" -delete
  fi
  echo "   Cleaned: $dir"
done

echo ""
echo "✅ All output directories refreshed."
