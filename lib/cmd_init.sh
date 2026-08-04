#!/usr/bin/env bash
source "$HUB_HOME/lib/build_context.sh"
source "$HUB_HOME/lib/platform_write.sh"
source "$HUB_HOME/lib/skills_deploy.sh"
source "$HUB_HOME/lib/tools_deploy.sh"

cmd_init() {
  local agent_name="" platform_arg="" stack_arg="" force=0
  while [[ $# -gt 0 ]]; do
    case $1 in
      --agent)    agent_name=$2; shift 2 ;;
      --platform) platform_arg=$2; shift 2 ;;
      --stack)    stack_arg=$2; shift 2 ;;
      --force)    force=1; shift ;;
      *) shift ;;
    esac
  done

  git rev-parse --git-dir >/dev/null 2>&1 || fatal "Current directory is not a git repository."

  local target_dir="${PWD}"
  ensure_dir "$target_dir/.agents"

  if [[ -f "$target_dir/.agents/lock" && $force -eq 0 ]]; then
    fatal ".agents/lock file exists. Concurrent execution detected or stale lock. Pass --force to override."
  fi
  echo "$$" > "$target_dir/.agents/lock"
  # Use a subshell-safe cleanup: store the path in a non-local var, clear trap on success
  _HUB_LOCK_FILE="$target_dir/.agents/lock"
  trap 'rm -f "${_HUB_LOCK_FILE:-}"' EXIT

  local manifest=""
  if [[ -n "$agent_name" ]]; then
    manifest="$HUB_HOME/agents/${agent_name}.yaml"
    [[ -f "$manifest" ]] || fatal "Agent manifest not found: $manifest"
  else
    manifest="$HUB_HOME/agents/systems-rust.yaml" # Default fallback
  fi

  info "Loading manifest: $manifest"
  local raw_context; raw_context=$(build_context "$manifest" "$stack_arg")

  local platforms=()
  if [[ -n "$platform_arg" ]]; then
    IFS=',' read -r -a platforms <<< "$platform_arg"
  else
    while IFS= read -r p; do
      [[ -n "$p" ]] && platforms+=("$p")
    done < <(yq e '.platforms.default[]?' "$manifest")
  fi

  local current_hash; current_hash=$(string_hash "$raw_context")
  local state_file="$target_dir/.agents/state.json"

  for p in "${platforms[@]}"; do
    if [[ $force -eq 0 ]] && ! context_changed "$p" "$current_hash" "$state_file"; then
      info "Platform '$p' content unchanged. Skipping write."
      continue
    fi

    write_platform_file "$p" "$raw_context" "$target_dir"
    deploy_skills "$manifest" "$p" "$target_dir"
  done
  deploy_tools "$manifest" "$target_dir"

  local iso_date; iso_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  cat > "$state_file" <<EOF
{
  "hub_version": "1.0.0",
  "initialized_at": "$iso_date",
  "agent": "${agent_name:-systems-rust}",
  "platforms": $(printf '%s\n' "${platforms[@]}" | jq -R . | jq -s .),
  "hashes": {
$(for p in "${platforms[@]}"; do echo "    \"$p\": \"$current_hash\""; done | paste -sd, -)
  }
}
EOF

  if [[ -f "$target_dir/.gitignore" ]]; then
    grep -qF ".agents/" "$target_dir/.gitignore" || echo ".agents/" >> "$target_dir/.gitignore"
  else
    echo ".agents/" > "$target_dir/.gitignore"
  fi

  info "Hub initialized successfully!"
}
