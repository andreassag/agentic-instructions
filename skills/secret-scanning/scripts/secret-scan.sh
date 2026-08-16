#!/usr/bin/env bash
set -euo pipefail

# Secret Scanner Skill Script
# Detects committed / staged secrets using gitleaks, trufflehog, or built-in heuristic pattern scanning.

echo "🔍 Starting secret scan..."

if command -v gitleaks >/dev/null 2>&1; then
  echo "Using gitleaks..."
  if git rev-parse --git-dir >/dev/null 2>&1; then
    gitleaks git --verbose --redact
  else
    gitleaks dir --verbose --redact .
  fi
  exit $?
fi

if command -v trufflehog >/dev/null 2>&1; then
  echo "Using trufflehog..."
  trufflehog git file://. --since-commit HEAD~10 --only-verified 2>/dev/null || trufflehog filesystem .
  exit $?
fi

echo "Neither gitleaks nor trufflehog detected in PATH. Running built-in pattern scan..."

# Built-in pattern checks
FOUND=0
PATTERNS=(
  "AKIA[0-9A-Z]{16}"                              # AWS Access Key
  "ghp_[a-zA-Z0-9]{36}"                          # GitHub Personal Access Token
  "gho_[a-zA-Z0-9]{36}"                          # GitHub OAuth Token
  "xox[baprs]-[0-9]{12}-[0-9]{12}-[a-zA-Z0-9]{24}" # Slack Token
  "-----BEGIN (RSA|EC|DSA|OPENSSH|PGP) PRIVATE KEY-----" # Private Keys
  "eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}" # JWT Tokens
)

for PATTERN in "${PATTERNS[@]}"; do
  MATCHES=$(git grep -EI "$PATTERN" 2>/dev/null || true)
  if [[ -n "$MATCHES" ]]; then
    # Filter out test fixtures or false positives if needed
    echo "⚠️ Potential secret match found with pattern '$PATTERN':"
    echo "$MATCHES" | head -n 5
    FOUND=$((FOUND + 1))
  fi
done

if [[ $FOUND -gt 0 ]]; then
  echo "❌ Secret scan failed: $FOUND potential secret pattern(s) detected."
  echo "   Please review and remove sensitive credentials before committing."
  exit 1
else
  echo "✓ No secret patterns detected."
  exit 0
fi
