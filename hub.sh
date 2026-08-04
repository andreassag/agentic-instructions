#!/usr/bin/env bash
set -euo pipefail

HUB_HOME="${HUB_HOME:-$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)}"

# shellcheck source=skills/_lib/log.sh
source "$HUB_HOME/skills/_lib/log.sh"
source "$HUB_HOME/skills/_lib/fs.sh"
source "$HUB_HOME/skills/_lib/platform.sh"
source "$HUB_HOME/skills/_lib/hash.sh"

HUB_DRY_RUN=0; HUB_VERBOSE=0; HUB_NO_COLOR=0
export HUB_HOME HUB_DRY_RUN HUB_VERBOSE HUB_NO_COLOR

ARGS=()
while [[ $# -gt 0 ]]; do
  case $1 in
    --hub-home)   HUB_HOME=$2; shift 2 ;;
    --dry-run)    HUB_DRY_RUN=1; shift ;;
    --verbose)    HUB_VERBOSE=1; set -x; shift ;;
    --no-color)   HUB_NO_COLOR=1; HUB_COLOR=0; shift ;;
    *)            ARGS+=("$1"); shift ;;
  esac
done
set -- "${ARGS[@]+"${ARGS[@]}"}"

SUBCOMMAND=${1:-""}; shift || true

case "$SUBCOMMAND" in
  init)        source "$HUB_HOME/lib/cmd_init.sh"   ; cmd_init "$@" ;;
  update)      source "$HUB_HOME/lib/cmd_update.sh" ; cmd_update "$@" ;;
  load)        source "$HUB_HOME/lib/cmd_load.sh"   ; cmd_load "$@" ;;
  clean)       source "$HUB_HOME/lib/cmd_clean.sh"  ; cmd_clean "$@" ;;
  status)      source "$HUB_HOME/lib/cmd_status.sh" ; cmd_status "$@" ;;
  --version|-v)  echo "hub 1.0.0 (agentic-instructions)" ;;
  --help|-h)   cat "$HUB_HOME/docs/hub-help.txt" ;;
  "")          fatal "No subcommand. Run: hub --help" ;;
  *)           fatal "Unknown subcommand: '$SUBCOMMAND'. Run: hub --help" ;;
esac
