#!/usr/bin/env bash
set -euo pipefail

# Conventional Commits Validator
# Usage:
#   ./commit-lint.sh [commit-msg-file | "commit message string"]
#   ./commit-lint.sh --latest
#   ./commit-lint.sh --range origin/main..HEAD

PATTERN="^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\([a-zA-Z0-9_-]+\))?!?: .+$"

lint_message() {
  local msg="$1"
  local header
  header=$(echo "$msg" | head -n 1)

  if [[ -z "$header" ]]; then
    echo "❌ Error: Commit message header is empty."
    return 1
  fi

  if [[ ${#header} -gt 72 ]]; then
    echo "⚠️ Warning: Commit message header exceeds 72 characters (${#header} chars): '$header'"
  fi

  if [[ "$header" =~ \.$ ]]; then
    echo "❌ Error: Commit message header must not end with a period: '$header'"
    return 1
  fi

  if ! [[ "$header" =~ $PATTERN ]]; then
    echo "❌ Error: Commit header does not follow Conventional Commits format."
    echo "   Received: '$header'"
    echo "   Expected: <type>(<scope>): <subject>  or  <type>: <subject>"
    echo "   Allowed types: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert"
    return 1
  fi

  echo "✓ Commit message valid: $header"
  return 0
}

TARGET="${1:-""}"

if [[ "$TARGET" == "--latest" || -z "$TARGET" ]]; then
  if git rev-parse --git-dir >/dev/null 2>&1; then
    LATEST=$(git log -1 --pretty=%B 2>/dev/null || true)
    if [[ -n "$LATEST" ]]; then
      lint_message "$LATEST"
      exit $?
    else
      echo "No git commits found in current repository."
      exit 0
    fi
  else
    echo "Not a git repository. Provide a commit message or file path."
    exit 1
  fi
elif [[ "$TARGET" == "--range" ]]; then
  RANGE="${2:-origin/main..HEAD}"
  FAILURES=0
  while IFS= read -r hash; do
    [[ -z "$hash" ]] && continue
    MSG=$(git log -1 --pretty=%B "$hash")
    if ! lint_message "$MSG"; then
      FAILURES=$((FAILURES + 1))
    fi
  done < <(git log --pretty=%H "$RANGE" 2>/dev/null || true)
  if [[ $FAILURES -gt 0 ]]; then
    echo "❌ Commit lint failed on $FAILURES commit(s) in range $RANGE."
    exit 1
  fi
  echo "✓ All commits in range $RANGE are valid."
  exit 0
elif [[ -f "$TARGET" ]]; then
  lint_message "$(cat "$TARGET")"
else
  lint_message "$TARGET"
fi
