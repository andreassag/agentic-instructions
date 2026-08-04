#!/usr/bin/env bash
write_platform_file() {
  local platform=$1 context=$2 target_dir=$3
  local config="$HUB_HOME/platforms/$platform/platform.yaml"
  [[ -f "$config" ]] || fatal "No platform config: $config"

  local dest marker_start marker_end header
  dest=$(yq e '.destination' "$config")
  marker_start=$(yq e '.marker.start' "$config")
  marker_end=$(yq e '.marker.end' "$config")
  header=$(yq e '.header // ""' "$config")

  local hooks_file="$HUB_HOME/platforms/$platform/hooks.sh"
  if [[ -f "$hooks_file" ]]; then
    # shellcheck disable=SC1090
    source "$hooks_file"
    declare -f append_agents_md >/dev/null && append_agents_md "$target_dir"
    declare -f validate_git_root >/dev/null && validate_git_root "$target_dir"
    declare -f validate_github_dir >/dev/null && validate_github_dir "$target_dir"
    declare -f ensure_codex_dir >/dev/null && ensure_codex_dir "$target_dir"
    declare -f ensure_vibe_dir >/dev/null && ensure_vibe_dir "$target_dir"
  fi

  local abs_dest="$target_dir/$dest"
  ensure_dir "$(dirname "$abs_dest")"

  if [[ -f "$abs_dest" ]] && grep -qF "$marker_start" "$abs_dest"; then
    local tmp; tmp=$(mktemp)
    awk -v start="$marker_start" -v end="$marker_end" \
      'found && $0==end{found=0;next} $0==start{found=1;next} !found{print}' \
      "$abs_dest" > "$tmp"
    mv "$tmp" "$abs_dest"
  fi

  local tmp; tmp=$(mktemp)
  {
    [[ -f "$abs_dest" ]] && cat "$abs_dest"
    echo "$marker_start"
    [[ -n "$header" ]] && echo "$header"
    echo ""
    printf '%s\n' "$context"
    echo "$marker_end"
  } > "$tmp"
  mv "$tmp" "$abs_dest"

  info "Written: $abs_dest"
}
