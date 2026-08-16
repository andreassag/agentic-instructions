#!/usr/bin/env bash
source "$HUB_HOME/lib/rules_deploy.sh"
source "$HUB_HOME/lib/skills_deploy.sh"
source "$HUB_HOME/lib/agents_deploy.sh"
source "$HUB_HOME/lib/workflows_deploy.sh"
source "$HUB_HOME/lib/tools_deploy.sh"

cmd_init() {
  local profile_name="" platform_arg="" force=0
  while [[ $# -gt 0 ]]; do
    case $1 in
      --profile)  profile_name=$2; shift 2 ;;
      --platform) platform_arg=$2; shift 2 ;;
      --force)    force=1; shift ;;
      --help-all) show_subcommand_help "init" 1; return 0 ;;
      -h|--help)  show_subcommand_help "init" 0; return 0 ;;
      *) shift ;;
    esac
  done

  # Validate that profile is specified
  if [[ -z "$profile_name" ]]; then
    fatal "No profile specified. Please specify a profile with '--profile <name>'. Run 'hub init --help-all' to see available options."
  fi

  git rev-parse --git-dir >/dev/null 2>&1 || fatal "Current directory is not a git repository."

  local target_dir="${PWD}"
  ensure_dir "$target_dir/.agents"

  if [[ -f "$target_dir/.agents/lock" && $force -eq 0 ]]; then
    fatal ".agents/lock file exists. Concurrent execution detected or stale lock. Pass --force to override."
  fi
  echo "$$" > "$target_dir/.agents/lock"
  _HUB_LOCK_FILE="$target_dir/.agents/lock"
  trap 'rm -f "${_HUB_LOCK_FILE:-}"' EXIT

  local manifest="$HUB_HOME/profiles/${profile_name}.yaml"
  [[ -f "$manifest" ]] || fatal "Profile manifest not found: $manifest"
  info "Loading profile manifest: $manifest"

  local platforms=()
  if [[ -n "$platform_arg" ]]; then
    IFS=',' read -r -a platforms <<< "$platform_arg"
  else
    for p_dir in "$HUB_HOME"/platforms/*/; do
      [[ -d "$p_dir" ]] || continue
      local p_name; p_name=$(basename "$p_dir")
      platforms+=("$p_name")
    done
    if [[ ${#platforms[@]} -eq 0 ]]; then
      platforms=("antigravity")
    fi
  fi

  local state_file="$target_dir/.agents/state.json"

  deploy_rules "$manifest" "$target_dir"
  for p in "${platforms[@]}"; do
    deploy_skills "$manifest" "$p" "$target_dir"
  done
  deploy_agents "$manifest" "$target_dir"
  deploy_workflows "$manifest" "$target_dir"
  deploy_tools "$manifest" "$target_dir"

  local iso_date; iso_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  ensure_dir "$target_dir/.agents"
  cat > "$state_file" <<EOF
{
  "hub_version": "1.0.0",
  "initialized_at": "$iso_date",
  "profile": "${profile_name}",
  "platforms": $(printf '%s\n' "${platforms[@]}" | jq -R . | jq -s .)
}
EOF

  rm -f "$target_dir/.agents/lock"
  info "Hub initialized successfully!"
}
