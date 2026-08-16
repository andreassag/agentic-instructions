#!/usr/bin/env bash
set -euo pipefail

# Python Dependency Vulnerability Auditor (pip-audit / safety / uv)
echo "🔍 Auditing Python dependencies for vulnerabilities..."

if command -v pip-audit >/dev/null 2>&1; then
  echo "==> Running pip-audit..."
  pip-audit "$@"
elif command -v uv >/dev/null 2>&1 && uv pip --help | grep -q audit; then
  echo "==> Running uv pip audit..."
  uv pip audit "$@"
elif command -v safety >/dev/null 2>&1; then
  echo "==> Running safety check..."
  safety check "$@"
else
  echo "⚠️ pip-audit is not installed. Install with: pip install pip-audit (or uv tool install pip-audit)"
  exit 0
fi
