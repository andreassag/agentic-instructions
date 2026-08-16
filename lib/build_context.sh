#!/usr/bin/env bash
build_context() {
  local manifest=$1
  local output=""

  if [[ -n "$manifest" && -f "$manifest" ]]; then
    while IFS= read -r file; do
      [[ -z "$file" ]] && continue
      local abs=""
      if [[ -f "$HUB_HOME/instructions/$file" ]]; then
        abs="$HUB_HOME/instructions/$file"
      elif [[ -f "$HUB_HOME/$file" ]]; then
        abs="$HUB_HOME/$file"
      fi

      if [[ -n "$abs" && -f "$abs" ]]; then
        output+=$'\n'"$(cat "$abs")"
      else
        warn "Instruction file not found: $file"
      fi
    done < <(yq e '(.instructions[]? // .instructions.tech[]?)' "$manifest" 2>/dev/null | grep -v '^$')
  fi

  local tools_to_include=()
  if [[ -f "$manifest" ]]; then
    while IFS= read -r t; do
      [[ -n "$t" ]] && tools_to_include+=("$t")
    done < <(yq e '.tools[]?' "$manifest" 2>/dev/null)
  fi

  # Default fallback if no manifest tools specified
  if [[ ${#tools_to_include[@]} -eq 0 ]]; then
    tools_to_include=("rtk" "qmd" "graphify")
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
