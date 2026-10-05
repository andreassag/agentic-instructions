#!/usr/bin/env bash
# platform_write.sh — Write hub content for a given platform.
# Dispatches to platform-specific hooks then handles per-platform file writing.

write_platform_file() {
  local platform=$1 context=$2 target_dir=$3
  local config="$HUB_HOME/platforms/$platform/platform.yaml"
  [[ -f "$config" ]] || fatal "No platform config: $config"

  local platform_type
  platform_type=$(yq e '.platform' "$config")

  local hooks_file="$HUB_HOME/platforms/$platform/hooks.sh"
  if [[ -f "$hooks_file" ]]; then
    # shellcheck disable=SC1090
    source "$hooks_file"
  fi

  case "$platform_type" in
    antigravity)
      _write_antigravity "$config" "$context" "$target_dir"
      ;;
    copilot)
      _write_copilot "$config" "$context" "$target_dir"
      ;;
    vibe)
      _write_vibe "$config" "$context" "$target_dir"
      ;;
    jetbrains)
      _write_jetbrains "$config" "$context" "$target_dir"
      ;;
    *)
      # Generic single-file writer with hub markers
      _write_marker_file "$config" "$context" "$target_dir"
      ;;
  esac
}

# --- Antigravity: deploy to .agents/rules/, .agents/skills/, .agents/agents/ ---
_write_antigravity() {
  local config=$1 context=$2 target_dir=$3
  ensure_dir "$target_dir/.agents/rules"
  ensure_dir "$target_dir/.agents/skills"
  ensure_dir "$target_dir/.agents/agents"
  # Actual file writing is handled by rules_deploy, skills_deploy, agents_deploy
  # This hook is a no-op since cmd_init calls them directly
  info "Antigravity platform: directories ensured"
}

# --- Copilot: .github/copilot-instructions.md + .github/instructions/*.instructions.md ---
_write_copilot() {
  local config=$1 context=$2 target_dir=$3
  local dest; dest=$(yq e '.destination' "$config")
  local abs_dest="$target_dir/$dest"
  local header; header=$(yq e '.header // ""' "$config")

  ensure_dir "$target_dir/.github"
  ensure_dir "$target_dir/.github/instructions"

  {
    [[ -n "$header" ]] && echo "$header"
    echo ""
    printf '%s\n' "$context"
  } > "$abs_dest"

  # Deploy per-rule instruction files with Copilot applyTo frontmatter
  declare -f deploy_copilot_rules >/dev/null && deploy_copilot_rules "$target_dir"
  declare -f deploy_copilot_skill_rules >/dev/null && deploy_copilot_skill_rules "$target_dir"

  info "Written: $abs_dest"
}

# --- Vibe: AGENTS.md + .vibe/agents/*.toml ---
_write_vibe() {
  local config=$1 context=$2 target_dir=$3
  local header; header=$(yq e '.header // ""' "$config")

  declare -f build_vibe_agents_md >/dev/null && build_vibe_agents_md "$target_dir"
  declare -f deploy_vibe_agents >/dev/null && deploy_vibe_agents "$target_dir"

  info "Written: $target_dir/AGENTS.md + $target_dir/.vibe/agents/"
}

# --- JetBrains: .aiassistant/rules/*.md ---
_write_jetbrains() {
  local config=$1 context=$2 target_dir=$3

  ensure_dir "$target_dir/.aiassistant/rules"

  declare -f deploy_jetbrains_rules >/dev/null && deploy_jetbrains_rules "$target_dir"
  declare -f deploy_jetbrains_skill_rules >/dev/null && deploy_jetbrains_skill_rules "$target_dir"

  info "Written: $target_dir/.aiassistant/rules/"
}

# --- Generic single-file with hub markers ---
_write_marker_file() {
  local config=$1 context=$2 target_dir=$3
  local dest header marker_start marker_end
  dest=$(yq e '.destination' "$config")
  header=$(yq e '.header // ""' "$config")
  marker_start=$(yq e '.marker.start // "<!-- hub:start -->"' "$config")
  marker_end=$(yq e '.marker.end // "<!-- hub:end -->"' "$config")

  local abs_dest="$target_dir/$dest"
  ensure_dir "$(dirname "$abs_dest")"

  # Remove previous hub block if present
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
