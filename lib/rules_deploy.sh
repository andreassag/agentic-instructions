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

    local companion_yaml="${src_file%.md}.yaml"
    local meta=""
    if [[ -f "$companion_yaml" ]]; then
      meta=$(yq e '.antigravity // ""' "$companion_yaml" 2>/dev/null)
      if [[ "$meta" == "null" ]]; then
        meta=""
      fi
    fi

    if [[ -n "$meta" ]]; then
      {
        echo "---"
        printf '%s\n' "$meta"
        echo "---"
        echo ""
        cat "$src_file"
      } > "$dest_file"
    else
      cp -f "$src_file" "$dest_file"
    fi
  }

  # Deploy universal and core protocol rules
  for r_file in "$HUB_HOME"/rules/*.md; do
    [[ -f "$r_file" ]] || continue
    local r_name; r_name=$(basename "$r_file" .md)
    _write_rule_file "$r_name" "$r_file"
  done

  # Deploy tech instruction rules
  while IFS= read -r file; do
    [[ -z "$file" ]] && continue
    local src_file=""
    if [[ -f "$HUB_HOME/instructions/$file" ]]; then
      src_file="$HUB_HOME/instructions/$file"
    elif [[ -f "$HUB_HOME/$file" ]]; then
      src_file="$HUB_HOME/$file"
    fi

    if [[ -n "$src_file" && -f "$src_file" ]]; then
      local base_name; base_name=$(basename "$file" .md)
      _write_rule_file "$base_name" "$src_file"
    else
      warn "Rule instruction file not found: $file"
    fi
  done < <(yq e '.instructions[]?' "$manifest" 2>/dev/null | grep -v '^$')

  # Deploy tool rules
  local tools_found=0
  while IFS= read -r tool; do
    [[ -z "$tool" ]] && continue
    tools_found=1
    local tool_src="$HUB_HOME/instructions/tools/${tool}.md"
    if [[ -f "$tool_src" ]]; then
      _write_rule_file "$tool" "$tool_src"
    fi
  done < <(yq e '.tools[]?' "$manifest" 2>/dev/null | grep -v '^$')

  # Fallback default tools if none specified
  if [[ $tools_found -eq 0 ]]; then
    for default_tool in rtk qmd graphify; do
      local tool_src="$HUB_HOME/instructions/tools/${default_tool}.md"
      if [[ -f "$tool_src" ]]; then
        _write_rule_file "$default_tool" "$tool_src"
      fi
    done
  fi

  info "Deployed Antigravity rules to: $rules_dest"
}
