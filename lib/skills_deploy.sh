#!/usr/bin/env bash

deploy_skills() {
  # shellcheck disable=SC2034
  local manifest=$1 platform=$2 target_dir=$3

  local skills_dest="$target_dir/.agents/skills"
  ensure_dir "$skills_dest"

  # Deploy all skill packages
  for skill_dir in "$HUB_HOME"/skills/*/; do
    [[ -d "$skill_dir" ]] || continue
    local skill_name; skill_name=$(basename "$skill_dir")
    local dest="$skills_dest/$skill_name"
    ensure_dir "$dest"

    cp -rf "$skill_dir"* "$dest/" 2>/dev/null || true

    # Ensure scripts are executable
    while IFS= read -r script; do
      [[ -f "$script" ]] && chmod +x "$script"
    done < <(find "$dest" -type f \( -name '*.sh' -o -name '*.py' \) 2>/dev/null)
  done

  info "Deployed Antigravity skills to: $skills_dest"
}
