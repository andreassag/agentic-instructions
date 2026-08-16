#!/usr/bin/env bash

init_tools() {
  local manifest=$1 target_dir=$2

  local tools_to_check=()

  if [[ -n "$manifest" && -f "$manifest" ]]; then
    while IFS= read -r t; do
      [[ -n "$t" ]] && tools_to_check+=("$t")
    done < <(yq e '.tools[]?' "$manifest" 2>/dev/null)
  fi

  if [[ ${#tools_to_check[@]} -eq 0 ]]; then
    tools_to_check=("rtk" "qmd" "graphify")
  fi

  local unique_tools=()
  for t in "${tools_to_check[@]}"; do
    local exists=0
    for u in "${unique_tools[@]}"; do
      [[ "$u" == "$t" ]] && { exists=1; break; }
    done
    [[ $exists -eq 0 ]] && unique_tools+=("$t")
  done

  for tool_name in "${unique_tools[@]}"; do
    local bin_path
    bin_path=$(command -v "$tool_name" 2>/dev/null || true)

    if [[ -n "$bin_path" ]]; then
      case "$tool_name" in
        graphify)
          if [[ -d "$target_dir" && ! -d "$target_dir/graphify-out" ]]; then
            info "Initializing graphify knowledge graph for project ($target_dir)..."
            (cd "$target_dir" && "$bin_path" update . >/dev/null 2>&1) || true
          fi
          ;;
        rtk)
          # Clean up any external rtk-created rule file in favor of hub-managed rtk.md
          rm -f "$target_dir/.agents/rules/antigravity-rtk-rules.md"
          ;;
      esac
    fi
  done
}

# Alias for backwards compatibility
deploy_tools() {
  init_tools "$@"
}
