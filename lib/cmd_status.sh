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

  [[ -f "$state_file" ]] || fatal "Hub is not initialized in this project. Run: hub init"

  if [[ $json_out -eq 1 ]]; then
    cat "$state_file"
    return 0
  fi

  local init_at profile platforms
  init_at=$(jq -r '.initialized_at // "unknown"' "$state_file" 2>/dev/null || echo "unknown")
  profile=$(jq -r '.profile // .agent // "none"' "$state_file" 2>/dev/null || echo "none")
  platforms=$(jq -r 'if .platforms then (.platforms | join(", ")) else "antigravity" end' "$state_file" 2>/dev/null || echo "antigravity")

  echo "Hub Status:"
  echo "  Initialized at: $init_at"
  echo "  Profile:        $profile"
  echo "  Platforms:      $platforms"
}
