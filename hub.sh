#!/usr/bin/env bash
set -euo pipefail

HUB_HOME="${HUB_HOME:-$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)}"

# shellcheck source=lib/log.sh
source "$HUB_HOME/lib/log.sh"
source "$HUB_HOME/lib/fs.sh"
source "$HUB_HOME/lib/platform.sh"
source "$HUB_HOME/lib/hash.sh"


HUB_DRY_RUN=0; HUB_VERBOSE=0; HUB_NO_COLOR=0
export HUB_HOME HUB_DRY_RUN HUB_VERBOSE HUB_NO_COLOR

show_subcommand_help() {
  local sub=${1:-""}
  local is_all=${2:-0}

  list_available_profiles() {
    echo "AVAILABLE PROFILES (--profile):"
    for f in "$HUB_HOME"/profiles/*.yaml; do
      [[ -f "$f" ]] || continue
      local name desc
      name=$(basename "$f" .yaml)
      desc=$(yq e '.description // ""' "$f" 2>/dev/null)
      printf "  %-26s %s\n" "$name" "$desc"
    done
  }

  list_available_platforms() {
    echo "AVAILABLE PLATFORMS (--platform):"
    for f in "$HUB_HOME"/platforms/*/platform.yaml; do
      [[ -f "$f" ]] || continue
      local p_name dest
      p_name=$(basename "$(dirname "$f")")
      dest=$(yq e '.destination // ""' "$f" 2>/dev/null)
      printf "  %-26s -> %s\n" "$p_name" "$dest"
    done
  }

  case "$sub" in
    init)
      cat << 'EOF'
hub init — Initialize hub in the current git repository

USAGE:
  hub init [flags]

FLAGS:
  --profile NAME     Stack profile to initialize (e.g. backend-go-engineer, systems-rust, ml-python)
  --platform NAME    Target platform (default: antigravity)
  --force            Overwrite existing configurations and ignore content hashes
  -h, --help         Show this help message
  --help-all         Show this help message along with all available profiles

EXAMPLES:
  hub init --profile systems-rust
  hub init --profile backend-go-engineer
  hub init --profile ml-python --force
  hub init --help-all
EOF
      if [[ $is_all -eq 1 ]]; then
        echo ""
        list_available_profiles
        echo ""
        list_available_platforms
      fi
      ;;
    update)
      cat << 'EOF'
hub update — Re-apply hub configuration

USAGE:
  hub update [flags]

FLAGS:
  --profile NAME     Override stack profile
  --platform NAME    Override target platform
  --force            Force rewrite of platform files regardless of hash
  -h, --help         Show this help message
  --help-all         Show this help message along with all available profiles

EXAMPLES:
  hub update
  hub update --force
EOF
      if [[ $is_all -eq 1 ]]; then
        echo ""
        list_available_profiles
        echo ""
        list_available_platforms
      fi
      ;;
    load)
      cat << 'EOF'
hub load — Load a named stack profile

USAGE:
  hub load <profile-name> [flags]

ARGUMENTS:
  <profile-name>     Name of the profile manifest (from profiles/*.yaml)

FLAGS:
  --platform NAME    Target platform (default: antigravity)
  --force            Force overwrite of existing configuration
  -h, --help         Show this help message
  --help-all         Show this help message along with all available profiles

EXAMPLES:
  hub load backend-go-engineer
  hub load ml-python --force
  hub load r-biostatistician
  hub load --help-all
EOF
      if [[ $is_all -eq 1 ]]; then
        echo ""
        list_available_profiles
        echo ""
        list_available_platforms
      fi
      ;;
    clean)
      cat << 'EOF'
hub clean — Remove hub-managed files from the current repository

USAGE:
  hub clean [flags]

FLAGS:
  --platform NAME    Clean a specific platform only (preserves .agents/)
  -h, --help         Show this help message

BEHAVIOR:
  hub clean                        # Removes all hub-managed platform files and .agents/ directory
  hub clean --platform antigravity # Removes AGENTS.md, preserves .agents/

EXAMPLES:
  hub clean
  hub clean --platform antigravity
EOF
      ;;

    status)
      cat << 'EOF'
hub status — Show current hub state

USAGE:
  hub status [flags]

FLAGS:
  --json             Output status in JSON format
  -h, --help         Show this help message

EXAMPLES:
  hub status
  hub status --json
EOF
      ;;
    *)
      if [[ $is_all -eq 1 ]]; then
        if [[ -f "$HUB_HOME/docs/hub-help.txt" ]]; then
          cat "$HUB_HOME/docs/hub-help.txt"
        fi
        echo ""
        list_available_profiles
        echo ""
        list_available_platforms
      elif [[ -f "$HUB_HOME/docs/hub-help.txt" ]]; then
        cat "$HUB_HOME/docs/hub-help.txt"
      else
        echo "Run: hub --help or hub --help-all"
      fi
      ;;
  esac
}
export -f show_subcommand_help

ARGS=()
while [[ $# -gt 0 ]]; do
  case $1 in
    --hub-home)   HUB_HOME=$2; shift 2 ;;
    --dry-run)    HUB_DRY_RUN=1; shift ;;
    --verbose)    HUB_VERBOSE=1; set -x; shift ;;
    --no-color)   HUB_NO_COLOR=1; shift ;;
    *)            ARGS+=("$1"); shift ;;
  esac
done
set -- "${ARGS[@]+"${ARGS[@]}"}"

SUBCOMMAND=${1:-""}; shift || true

# Handle global help or version
case "$SUBCOMMAND" in
  --version|-v)  echo "hub 1.0.0 (agentic-instructions)"; exit 0 ;;
  --help-all)    show_subcommand_help "" 1; exit 0 ;;
  --help|-h)     show_subcommand_help "" 0; exit 0 ;;
  help-all)      show_subcommand_help "${1:-""}" 1; exit 0 ;;
  help)
    if [[ "${1:-}" == "--all" || "${1:-}" == "-a" || "${1:-}" == "all" ]]; then
      show_subcommand_help "${2:-""}" 1
    else
      show_subcommand_help "${1:-""}" 0
    fi
    exit 0
    ;;
  "")            fatal "No subcommand. Run: hub --help" ;;
esac

# Check for subcommand-level --help-all / --help / -h
for arg in "$@"; do
  if [[ "$arg" == "--help-all" ]]; then
    show_subcommand_help "$SUBCOMMAND" 1
    exit 0
  elif [[ "$arg" == "-h" || "$arg" == "--help" ]]; then
    show_subcommand_help "$SUBCOMMAND" 0
    exit 0
  fi
done

case "$SUBCOMMAND" in
  init)        source "$HUB_HOME/lib/cmd_init.sh"   ; cmd_init "$@" ;;
  update)      source "$HUB_HOME/lib/cmd_update.sh" ; cmd_update "$@" ;;
  load)        source "$HUB_HOME/lib/cmd_load.sh"   ; cmd_load "$@" ;;
  clean)       source "$HUB_HOME/lib/cmd_clean.sh"  ; cmd_clean "$@" ;;
  status)      source "$HUB_HOME/lib/cmd_status.sh" ; cmd_status "$@" ;;
  *)           fatal "Unknown subcommand: '$SUBCOMMAND'. Run: hub --help" ;;
esac


