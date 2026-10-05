#!/usr/bin/env bash
# platform_clean.sh — Remove hub-managed files for a given platform.

clean_platform_file() {
  local platform=$1 target_dir=$2
  local config="$HUB_HOME/platforms/$platform/platform.yaml"
  [[ -f "$config" ]] || { warn "No platform config for '$platform'. Skipping."; return 0; }

  local platform_type
  platform_type=$(yq e '.platform' "$config")

  case "$platform_type" in
    antigravity)
      # .agents/ is cleaned by cmd_clean.sh directly
      ;;
    copilot)
      if [[ -f "$target_dir/.github/copilot-instructions.md" ]]; then
        rm -f "$target_dir/.github/copilot-instructions.md"
        info "Removed: $target_dir/.github/copilot-instructions.md"
      fi
      if [[ -d "$target_dir/.github/instructions" ]]; then
        rm -rf "$target_dir/.github/instructions"
        info "Removed: $target_dir/.github/instructions/"
      fi
      ;;
    vibe)
      if [[ -f "$target_dir/AGENTS.md" ]]; then
        rm -f "$target_dir/AGENTS.md"
        info "Removed: $target_dir/AGENTS.md"
      fi
      if [[ -d "$target_dir/.vibe" ]]; then
        rm -rf "$target_dir/.vibe"
        info "Removed: $target_dir/.vibe/"
      fi
      ;;
    jetbrains)
      if [[ -d "$target_dir/.aiassistant" ]]; then
        rm -rf "$target_dir/.aiassistant"
        info "Removed: $target_dir/.aiassistant/"
      fi
      ;;
    *)
      # Generic: clean marker block from destination file
      local dest marker_start marker_end
      dest=$(yq e '.destination' "$config")
      marker_start=$(yq e '.marker.start // "<!-- hub:start -->"' "$config")
      marker_end=$(yq e '.marker.end // "<!-- hub:end -->"' "$config")

      local abs_dest="$target_dir/$dest"
      [[ -f "$abs_dest" ]] || { info "No file at: $abs_dest"; return 0; }

      if ! grep -qF "$marker_start" "$abs_dest"; then
        info "No hub markers in: $abs_dest — nothing to clean."
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
        info "Removed empty file: $abs_dest"
      fi
      ;;
  esac
}
