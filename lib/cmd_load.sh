#!/usr/bin/env bash
source "$HUB_HOME/lib/cmd_init.sh"

cmd_load() {
  local agent_name=${1:-""}
  [[ -z "$agent_name" ]] && fatal "Missing agent name. Usage: hub load <agent-name>"
  shift || true
  cmd_init --agent "$agent_name" "$@"
}
