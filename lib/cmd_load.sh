#!/usr/bin/env bash
source "$HUB_HOME/lib/cmd_init.sh"

cmd_load() {
  if [[ "${1:-}" == "--help-all" ]]; then show_subcommand_help "load" 1; return 0; fi
  if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then show_subcommand_help "load" 0; return 0; fi
  local profile_name=${1:-""}
  [[ -z "$profile_name" ]] && fatal "Missing profile name. Usage: hub load <profile-name> (Run 'hub load --help-all' to see available profiles)"
  shift || true
  cmd_init --profile "$profile_name" --force "$@"
}
