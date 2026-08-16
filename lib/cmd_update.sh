#!/usr/bin/env bash
source "$HUB_HOME/lib/cmd_init.sh"

cmd_update() {
  local target_dir="${PWD}"
  local state_file="$target_dir/.agents/state.json"
  [[ -f "$state_file" ]] || state_file="$target_dir/.agent/state.json"

  local current_profile=""
  if [[ -f "$state_file" ]]; then
    current_profile=$(jq -r '.profile // .agent // empty' "$state_file" 2>/dev/null || true)
  fi

  if [[ -z "$current_profile" ]]; then
    fatal "Hub is not initialized or state.json missing. Run: hub init --profile <name>"
  fi

  info "Updating hub configuration for profile: $current_profile..."
  cmd_init --profile "$current_profile" "$@"
}
