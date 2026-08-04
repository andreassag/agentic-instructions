#!/usr/bin/env bash
build_context() {
  local manifest=$1
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

  printf '%s' "$output"
}
