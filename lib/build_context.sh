#!/usr/bin/env bash
build_context() {
  local manifest=$1
  local stack_arg=${2:-""}
  local output=""

  _append_instructions() {
    local key=$1
    while IFS= read -r file; do
      [[ -z "$file" ]] && continue
      local abs="$HUB_HOME/instructions/$file"
      [[ -f "$abs" ]] || fatal "Instruction file not found: $abs"
      output+=$'\n'"$(cat "$abs")"
    done < <(yq e ".instructions.${key}[]? // \"\"" "$manifest" | grep -v '^$')
  }

  _append_instructions "agent"
  _append_instructions "tech"
  _append_instructions "context"

  while IFS= read -r file; do
    [[ -z "$file" ]] && continue
    local abs="$HUB_HOME/$file"
    [[ -f "$abs" ]] || { warn "Extra instruction not found: $abs"; continue; }
    output+=$'\n'"$(cat "$abs")"
  done < <(yq e '.instructions.extra[]? // ""' "$manifest" | grep -v '^$')

  if [[ -n "$stack_arg" ]]; then
    local stacks=()
    IFS=',' read -r -a stacks <<< "$stack_arg"
    for s in "${stacks[@]}"; do
      [[ -z "$s" ]] && continue
      local tech_file="$HUB_HOME/instructions/tech/${s}.md"
      local ctx_file="$HUB_HOME/instructions/context/${s}.md"
      if [[ -f "$tech_file" ]]; then
        output+=$'\n'"$(cat "$tech_file")"
      elif [[ -f "$ctx_file" ]]; then
        output+=$'\n'"$(cat "$ctx_file")"
      elif [[ -f "$HUB_HOME/instructions/$s" ]]; then
        output+=$'\n'"$(cat "$HUB_HOME/instructions/$s")"
      else
        warn "Stack instruction not found for: '$s'"
      fi
    done
  fi

  local tools_to_include=("graphify" "rtk" "qmd")
  if [[ -f "$manifest" ]]; then
    while IFS= read -r t; do
      [[ -n "$t" ]] && tools_to_include+=("$t")
    done < <(yq e '.tools.required[]?' "$manifest" 2>/dev/null)
    while IFS= read -r t; do
      [[ -n "$t" ]] && tools_to_include+=("$t")
    done < <(yq e '.tools.optional[]?' "$manifest" 2>/dev/null)
  fi

  local unique_tool_ins=()
  for t in "${tools_to_include[@]}"; do
    local exists=0
    for u in "${unique_tool_ins[@]}"; do
      [[ "$u" == "$t" ]] && { exists=1; break; }
    done
    [[ $exists -eq 0 ]] && unique_tool_ins+=("$t")
  done

  for tool_name in "${unique_tool_ins[@]}"; do
    local tool_md="$HUB_HOME/instructions/tools/${tool_name}.md"
    if [[ -f "$tool_md" ]]; then
      output+=$'\n'"$(cat "$tool_md")"
    fi
  done

  printf '%s' "$output"
}
