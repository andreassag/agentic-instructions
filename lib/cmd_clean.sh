#!/usr/bin/env bash

cmd_clean() {
  local target_dir="${PWD}"
  local platform_filter=""
  local clean_all=1

  while [[ $# -gt 0 ]]; do
    case $1 in
      --platform) platform_filter=$2; clean_all=0; shift 2 ;;
      --help-all) show_subcommand_help "clean" 1; return 0 ;;
      -h|--help)  show_subcommand_help "clean" 0; return 0 ;;
      *)          shift ;;
    esac
  done

  local state_file="$target_dir/.agents/state.json"
  [[ -f "$state_file" ]] || state_file="$target_dir/.agent/state.json"

  local platforms=()
  if [[ -n "$platform_filter" ]]; then
    IFS=',' read -r -a platforms <<< "$platform_filter"
  else
    # Default to cleaning all platforms from state.json and platforms/ directory
    if [[ -f "$state_file" ]]; then
      while IFS= read -r p; do
        [[ -n "$p" ]] && platforms+=("$p")
      done < <(jq -r '.platforms[]? // empty' "$state_file")
    fi
    for p_dir in "$HUB_HOME"/platforms/*/; do
      local p_name; p_name=$(basename "$p_dir")
      local already=0
      for existing in "${platforms[@]}"; do
        [[ "$existing" == "$p_name" ]] && { already=1; break; }
      done
      [[ $already -eq 0 ]] && platforms+=("$p_name")
    done
  fi

  for platform in "${platforms[@]}"; do
    local config="$HUB_HOME/platforms/$platform/platform.yaml"
    [[ -f "$config" ]] || continue

    local dest marker_start marker_end
    dest=$(yq e '.destination' "$config" 2>/dev/null || true)
    marker_start=$(yq e '.marker.start' "$config" 2>/dev/null || true)
    marker_end=$(yq e '.marker.end' "$config" 2>/dev/null || true)

    if [[ -n "$dest" && "$dest" != "null" ]]; then
      local abs_dest="$target_dir/$dest"
      if [[ -f "$abs_dest" && -n "$marker_start" && "$marker_start" != "null" ]] && grep -qF "$marker_start" "$abs_dest"; then
        local tmp; tmp=$(mktemp)
        awk -v start="$marker_start" -v end="$marker_end" \
          'found && $0==end{found=0;next} $0==start{found=1;next} !found{print}' \
          "$abs_dest" > "$tmp"
        if [[ -s "$tmp" ]]; then
          if ! grep -vE '^\s*($|# Agent Configuration|This project uses \[hub\])' "$tmp" >/dev/null 2>&1; then
            rm -f "$tmp" "$abs_dest"
            info "Removed file: $abs_dest"
          else
            mv "$tmp" "$abs_dest"
            info "Cleaned hub markers from: $abs_dest"
          fi
        else
          rm -f "$tmp" "$abs_dest"
          info "Removed empty file: $abs_dest"
        fi
      fi
    fi
  done

  # Clean legacy root AGENTS.md if it only contains hub marker content
  local legacy_agents="$target_dir/AGENTS.md"
  if [[ -f "$legacy_agents" ]] && grep -qF "# hub:" "$legacy_agents"; then
    rm -f "$legacy_agents"
    info "Removed legacy: $legacy_agents"
  fi

  if [[ $clean_all -eq 1 ]]; then
    # Remove Hub managed directories
    if [[ -d "$target_dir/.agents" || -d "$target_dir/.agent" ]]; then
      rm -rf "$target_dir/.agents" "$target_dir/.agent"
      info "Removed .agents/ directory."
    fi

    # Remove tool-generated artifacts
    if [[ -d "$target_dir/graphify-out" ]]; then
      rm -rf "$target_dir/graphify-out"
      info "Removed graphify-out/ artifact directory."
    fi
    if [[ -d "$target_dir/.qmd" ]]; then
      rm -rf "$target_dir/.qmd"
      info "Removed .qmd/ index directory."
    fi
    if [[ -d "$target_dir/.cache/qmd" ]]; then
      rm -rf "$target_dir/.cache/qmd"
      info "Removed .cache/qmd/ directory."
    fi
    # Platform-specific artifacts
    if [[ -d "$target_dir/.vibe" ]]; then
      rm -rf "$target_dir/.vibe"
      info "Removed .vibe/ directory."
    fi
    if [[ -d "$target_dir/.aiassistant" ]]; then
      rm -rf "$target_dir/.aiassistant"
      info "Removed .aiassistant/ directory."
    fi
    if [[ -d "$target_dir/.github/instructions" ]]; then
      rm -rf "$target_dir/.github/instructions"
      info "Removed .github/instructions/ directory."
    fi
    if [[ -f "$target_dir/.github/copilot-instructions.md" ]]; then
      rm -f "$target_dir/.github/copilot-instructions.md"
      info "Removed .github/copilot-instructions.md"
    fi
  fi
}
