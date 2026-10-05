#!/usr/bin/env bash

deploy_rules() {
  local manifest=${1:-""}
  local target_dir=${2:-"${PWD}"}

  local rules_dest="$target_dir/.agents/rules"
  ensure_dir "$rules_dest"

  [[ -z "$manifest" || ! -f "$manifest" ]] && return 0

  _write_rule_file() {
    local rule_name=$1
    local src_file=$2
    local dest_file="$rules_dest/${rule_name}.md"

    [[ -f "$src_file" ]] || return 0
    cp -f "$src_file" "$dest_file"
  }

  # Deploy all rules/*.md (universal, always-on rules)
  for r_file in "$HUB_HOME"/rules/*.md; do
    [[ -f "$r_file" ]] || continue
    local r_name; r_name=$(basename "$r_file" .md)
    _write_rule_file "$r_name" "$r_file"
  done

  info "Deployed rules to: $rules_dest"
}
