#!/usr/bin/env bash
deploy_tools() {
  local manifest=$1 target_dir=$2
  local tools_dest="$target_dir/.agents/tools"
  ensure_dir "$tools_dest"

  local tools_to_deploy=("graphify" "rtk" "qmd")

  if [[ -f "$manifest" ]]; then
    while IFS= read -r t; do
      [[ -n "$t" ]] && tools_to_deploy+=("$t")
    done < <(yq e '.tools.required[]?' "$manifest" 2>/dev/null)

    while IFS= read -r t; do
      [[ -n "$t" ]] && tools_to_deploy+=("$t")
    done < <(yq e '.tools.optional[]?' "$manifest" 2>/dev/null)
  fi

  local unique_tools=()
  for t in "${tools_to_deploy[@]}"; do
    local exists=0
    for u in "${unique_tools[@]}"; do
      [[ "$u" == "$t" ]] && { exists=1; break; }
    done
    [[ $exists -eq 0 ]] && unique_tools+=("$t")
  done

  for tool_name in "${unique_tools[@]}"; do
    local tool_dest="$tools_dest/$tool_name"
    local bin_path
    bin_path=$(command -v "$tool_name" 2>/dev/null || true)

    if [[ -n "$bin_path" ]]; then
      ln -sf "$bin_path" "$tool_dest"
      chmod +x "$tool_dest" 2>/dev/null || true

      # Project-level tool initialization
      case "$tool_name" in
        graphify)
          if [[ -d "$target_dir" ]]; then
            info "Initializing graphify knowledge graph for project ($target_dir)..."
            (cd "$target_dir" && "$bin_path" update . >/dev/null 2>&1 || true)
          fi
          ;;
      esac
    else
      info "Tool '$tool_name' not found in PATH. Skipping symlink."
    fi
  done
}
