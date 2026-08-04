#!/usr/bin/env bash
cmd_status() {
  local target_dir="${PWD}"
  local state_file="$target_dir/.agents/state.json"
  [[ -f "$state_file" ]] || state_file="$target_dir/.agent/state.json"
  local json_out=0

  while [[ $# -gt 0 ]]; do
    case $1 in
      --json) json_out=1; shift ;;
      *) shift ;;
    esac
  done

  [[ -f "$state_file" ]] || { fatal "Hub is not initialized in this project. Run: hub init"; }

  if [[ $json_out -eq 1 ]]; then
    cat "$state_file"
    return 0
  fi

  echo "Hub Status:"
  echo "  Initialized at: $(jq -r '.initialized_at // "unknown"' "$state_file")"
  echo "  Agent:          $(jq -r '.agent // "none"' "$state_file")"
  echo "  Platforms:      $(jq -r '.platforms | join(", ")' "$state_file")"
}
