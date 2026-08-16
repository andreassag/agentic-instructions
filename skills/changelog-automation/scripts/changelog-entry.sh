#!/usr/bin/env bash
set -euo pipefail

# Changelog Entry Generator
# Generates a Keep-a-Changelog compatible entry from conventional commit history.

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "Error: Current directory is not a git repository."
  exit 1
fi

LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || true)
if [[ -n "$LAST_TAG" ]]; then
  RANGE="${LAST_TAG}..HEAD"
  echo "Generating changelog entries since tag $LAST_TAG..."
else
  RANGE="HEAD"
  echo "No previous git tags found. Generating changelog from full history..."
fi

FEAT=()
FIX=()
DOCS=()
REFACTOR=()
PERF=()
OTHER=()

while IFS= read -r line; do
  [[ -z "$line" ]] && continue
  HASH=$(echo "$line" | awk '{print $1}')
  MSG=$(echo "$line" | cut -d' ' -f2-)

  case "$MSG" in
    feat*|Feat*)       FEAT+=("- $MSG ($HASH)") ;;
    fix*|Fix*)         FIX+=("- $MSG ($HASH)") ;;
    docs*|Docs*)       DOCS+=("- $MSG ($HASH)") ;;
    refactor*|Refactor*) REFACTOR+=("- $MSG ($HASH)") ;;
    perf*|Perf*)       PERF+=("- $MSG ($HASH)") ;;
    chore*|ci*|test*|build*) ;; # Skip internal chores from public changelog
    *)                 OTHER+=("- $MSG ($HASH)") ;;
  esac
done < <(git log "$RANGE" --oneline --no-merges 2>/dev/null || true)

TODAY=$(date +"%Y-%m-%d")
ENTRY="## [Unreleased] - $TODAY"

if [[ ${#FEAT[@]} -gt 0 ]]; then
  ENTRY+=$'\n\n### Added\n'$(printf '%s\n' "${FEAT[@]}")
fi

if [[ ${#FIX[@]} -gt 0 ]]; then
  ENTRY+=$'\n\n### Fixed\n'$(printf '%s\n' "${FIX[@]}")
fi

if [[ ${#PERF[@]} -gt 0 ]]; then
  ENTRY+=$'\n\n### Performance\n'$(printf '%s\n' "${PERF[@]}")
fi

if [[ ${#REFACTOR[@]} -gt 0 ]]; then
  ENTRY+=$'\n\n### Changed\n'$(printf '%s\n' "${REFACTOR[@]}")
fi

if [[ ${#DOCS[@]} -gt 0 ]]; then
  ENTRY+=$'\n\n### Documentation\n'$(printf '%s\n' "${DOCS[@]}")
fi

if [[ ${#OTHER[@]} -gt 0 ]]; then
  ENTRY+=$'\n\n### Other\n'$(printf '%s\n' "${OTHER[@]}")
fi

echo "$ENTRY"
