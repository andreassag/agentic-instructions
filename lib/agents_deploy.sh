#!/usr/bin/env bash

deploy_agents() {
  local manifest=${1:-""}
  local target_dir=${2:-"${PWD}"}

  local agents_dest="$target_dir/.agents/agents"
  ensure_dir "$agents_dest"

  # Deploy Antigravity agent roles
  for agent_file in "$HUB_HOME"/agents/*.md; do
    [[ -f "$agent_file" ]] || continue
    local file_name; file_name=$(basename "$agent_file")
    cp -f "$agent_file" "$agents_dest/$file_name"
  done

  info "Deployed Antigravity agents to: $agents_dest"
}
