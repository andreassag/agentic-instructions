#!/usr/bin/env bash
cmd_clean() {
  local target_dir="${PWD}"
  local platform_filter=""
  local clean_all=0

  while [[ $# -gt 0 ]]; do
    case $1 in
      --platform) platform_filter=$2; shift 2 ;;
      --all)      clean_all=1; shift ;;
      *)          shift ;;
    esac
  done

  local state_file="$target_dir/.agent/state.json"
  [[ -d "$target_dir/.agent" ]] || { info "No .agent directory found. Nothing to clean."; return 0; }

  local platforms=()
  if [[ -n "$platform_filter" ]]; then
    IFS=',' read -r -a platforms <<< "$platform_filter"
  elif [[ -f "$state_file" ]]; then
    while IFS= read -r p; do
      [[ -n "$p" ]] && platforms+=("$p")
    done < <(jq -r '.platforms[]? // empty' "$state_file")
  fi

  for platform in "${platforms[@]}"; do
    local config="$HUB_HOME/platforms/$platform/platform.yaml"
    [[ -f "$config" ]] || continue

    local dest marker_start marker_end
    dest=$(yq e '.destination' "$config")
    marker_start=$(yq e '.marker.start' "$config")
    marker_end=$(yq e '.marker.end' "$config")

    local abs_dest="$target_dir/$dest"
    if [[ -f "$abs_dest" ]] && grep -qF "$marker_start" "$abs_dest"; then
      local tmp; tmp=$(mktemp)
      awk -v start="$marker_start" -v end="$marker_end" \
        'found && $0==end{found=0;next} $0==start{found=1;next} !found{print}' \
        "$abs_dest" > "$tmp"
      if [[ -s "$tmp" ]]; then
        mv "$tmp" "$abs_dest"
        info "Cleaned hub markers from: $abs_dest"
      else
        rm -f "$tmp" "$abs_dest"
        info "Removed empty file: $abs_dest"
      fi
    fi
  done

  if [[ $clean_all -eq 1 ]]; then
    rm -rf "$target_dir/.agent"
    info "Removed .agent/ directory."
  fi
}
