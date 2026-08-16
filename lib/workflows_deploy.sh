#!/usr/bin/env bash

deploy_workflows() {
  # shellcheck disable=SC2034
  local manifest=${1:-""}
  local target_dir=${2:-"${PWD}"}

  local workflows_dest="$target_dir/.agents/workflows"
  ensure_dir "$workflows_dest"

  # Deploy Antigravity workflows
  for wf_file in "$HUB_HOME"/workflows/*.md; do
    [[ -f "$wf_file" ]] || continue
    local wf_name; wf_name=$(basename "$wf_file")
    cp -f "$wf_file" "$workflows_dest/$wf_name"
  done

  info "Deployed Antigravity workflows to: $workflows_dest"
}
