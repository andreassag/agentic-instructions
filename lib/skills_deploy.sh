#!/usr/bin/env bash

deploy_skills() {
  local manifest=$1 target_dir=$2

  local skills_dest="$target_dir/.agents/skills"
  ensure_dir "$skills_dest"

  # Build list of skill names declared in the profile manifest
  local declared_skills=()
  if [[ -n "$manifest" && -f "$manifest" ]]; then
    while IFS= read -r s; do
      [[ -n "$s" ]] && declared_skills+=("$s")
    done < <(yq e '.skills[]?' "$manifest" 2>/dev/null | grep -v '^$')
  fi

  # Resolve each declared skill name to a skill directory.
  # A skill entry can be:
  #   "go-guidelines"                 -> skills/go-guidelines/
  #   "test-runner"                   -> skills/test-runner/
  #   "git-workflow/commit-lint.sh"   -> normalised to "git-workflow" (script path)
  local resolved_skills=()
  for entry in "${declared_skills[@]}"; do
    # Strip any trailing script path (e.g. "git-workflow/commit-lint.sh" -> "git-workflow")
    local skill_name="${entry%%/*}"
    local already=0
    for u in "${resolved_skills[@]}"; do
      [[ "$u" == "$skill_name" ]] && { already=1; break; }
    done
    [[ $already -eq 0 ]] && resolved_skills+=("$skill_name")
  done

  if [[ ${#resolved_skills[@]} -eq 0 ]]; then
    # No skills declared — deploy everything (backward-compat fallback)
    warn "No skills declared in manifest. Deploying all available skills."
    for skill_dir in "$HUB_HOME"/skills/*/; do
      [[ -d "$skill_dir" ]] || continue
      local skill_name; skill_name=$(basename "$skill_dir")
      _deploy_skill_dir "$skill_dir" "$skills_dest/$skill_name"
    done
  else
    # Profile-gated: deploy only declared skills (full subfolder each)
    for skill_name in "${resolved_skills[@]}"; do
      local skill_dir="$HUB_HOME/skills/${skill_name}"
      if [[ -d "$skill_dir" ]]; then
        _deploy_skill_dir "$skill_dir" "$skills_dest/$skill_name"
      else
        warn "Skill directory not found: $skill_dir (referenced as '$skill_name')"
      fi
    done
  fi

  info "Deployed skills to: $skills_dest"
}

# Deploy all files within a skill directory (SKILL.md + scripts/ + any other assets)
_deploy_skill_dir() {
  local src_dir=$1 dest_dir=$2
  ensure_dir "$dest_dir"
  cp -rf "$src_dir"/. "$dest_dir/" 2>/dev/null || true

  # Ensure all shell and python scripts are executable
  while IFS= read -r script; do
    [[ -f "$script" ]] && chmod +x "$script"
  done < <(find "$dest_dir" -type f \( -name '*.sh' -o -name '*.py' \) 2>/dev/null)
}
