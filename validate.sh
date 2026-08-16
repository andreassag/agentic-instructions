#!/usr/bin/env bash
# validate.sh — Entry point for test and validation suite
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SCRIPT_DIR/tests/run_all.sh" "$@"
