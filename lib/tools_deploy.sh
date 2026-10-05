#!/usr/bin/env bash
# tools_init.sh — Post-deploy tool initialization (graphify index, rtk cleanup).
# Called after skills are deployed. Tool *installation* happens in install.sh.

init_tools() {
  local manifest=$1 target_dir=$2

  # Determine which tool skills are declared in the profile
  local tools_to_init=()
  if [[ -n "$manifest" && -f "$manifest" ]]; then
    while IFS= read -r s; do
      [[ -n "$s" ]] && tools_to_init+=("$s")
    done < <(yq e '.skills[]?' "$manifest" 2>/dev/null | grep -E '^(rtk|qmd|graphify)$')
  fi

  # Default: init all three tools if none explicitly listed
  if [[ ${#tools_to_init[@]} -eq 0 ]]; then
    tools_to_init=(rtk qmd graphify)
  fi

  for tool_name in "${tools_to_init[@]}"; do
    local bin_path
    bin_path=$(command -v "$tool_name" 2>/dev/null || true)

    [[ -z "$bin_path" ]] && continue

    case "$tool_name" in
      graphify)
        if [[ -d "$target_dir" && ! -d "$target_dir/graphify-out" ]]; then
          info "Initializing graphify knowledge graph..."
          (cd "$target_dir" && "$bin_path" update . >/dev/null 2>&1) || true
        fi
        ;;
      rtk)
        # Remove any externally created rtk rule file in favour of the hub-managed one
        rm -f "$target_dir/.agents/rules/antigravity-rtk-rules.md"
        ;;
    esac
  done
}

# Backward-compatibility alias
deploy_tools() {
  init_tools "$@"
}
