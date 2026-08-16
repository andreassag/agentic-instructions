#!/usr/bin/env bash
# platform_clean.sh — Removes hub-managed marker blocks from platform destination files.
# Used by cmd_clean.sh for targeted platform teardown.

clean_platform_file() {
  local platform=$1 target_dir=$2
  local config="$HUB_HOME/platforms/$platform/platform.yaml"
  [[ -f "$config" ]] || { warn "No platform config for '$platform'. Skipping."; return 0; }

  local dest marker_start marker_end
  dest=$(yq e '.destination' "$config")
  marker_start=$(yq e '.marker.start' "$config")
  marker_end=$(yq e '.marker.end' "$config")

  local abs_dest="$target_dir/$dest"

  if [[ ! -f "$abs_dest" ]]; then
    info "No file to clean at: $abs_dest"
    return 0
  fi

  if ! grep -qF "$marker_start" "$abs_dest"; then
    info "No hub markers found in: $abs_dest — nothing to clean."
    return 0
  fi

  local tmp; tmp=$(mktemp)
  awk -v start="$marker_start" -v end="$marker_end" \
    'found && $0==end{found=0;next} $0==start{found=1;next} !found{print}' \
    "$abs_dest" > "$tmp"

  if [[ -s "$tmp" ]]; then
    mv "$tmp" "$abs_dest"
    info "Removed hub markers from: $abs_dest"
  else
    rm -f "$tmp" "$abs_dest"
    info "Removed empty file after clean: $abs_dest"
  fi
}
