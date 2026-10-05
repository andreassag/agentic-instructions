#!/usr/bin/env bash
# hooks.sh — VSCode Copilot platform write hooks

deploy_copilot_rules() {
  local target_dir="${1:-$PWD}"
  local rules_src="$HUB_HOME/rules"
  local dest_dir="$target_dir/.github/instructions"
  ensure_dir "$target_dir/.github"
  ensure_dir "$dest_dir"

  # Deploy each rule as a .instructions.md file with Copilot frontmatter
  for rule_file in "$rules_src"/*.md; do
    [[ -f "$rule_file" ]] || continue
    local rule_name; rule_name=$(basename "$rule_file" .md)

    # Read trigger from rule frontmatter to set applyTo
    local trigger globs apply_to
    trigger=$(grep -m1 '^trigger:' "$rule_file" 2>/dev/null | awk '{print $2}' || echo "always_on")
    globs=$(grep -m1 '^globs:' "$rule_file" 2>/dev/null | sed 's/^globs: *//' | tr -d '"' || echo "")

    if [[ "$trigger" == "glob" && -n "$globs" ]]; then
      apply_to="$globs"
    else
      apply_to="**"
    fi

    {
      echo "---"
      echo "applyTo: \"${apply_to}\""
      echo "---"
      echo ""
      # Strip existing YAML frontmatter from rule file
      awk '/^---/{found++; if(found==2){skip=0; next} else {skip=1; next}} skip{next} {print}' "$rule_file"
    } > "$dest_dir/${rule_name}.instructions.md"
  done
}

deploy_copilot_skill_rules() {
  local target_dir="${1:-$PWD}"
  local dest_dir="$target_dir/.github/instructions"
  ensure_dir "$dest_dir"

  # Tech-guideline skills with glob triggers get their own .instructions.md
  for skill_dir in "$target_dir/.agents/skills"/*/; do
    [[ -d "$skill_dir" ]] || continue
    local skill_md="$skill_dir/SKILL.md"
    [[ -f "$skill_md" ]] || continue

    local trigger globs
    trigger=$(grep -m1 '^trigger:' "$skill_md" 2>/dev/null | awk '{print $2}' || echo "")
    globs=$(grep -m1 '^globs:' "$skill_md" 2>/dev/null | sed 's/^globs: *//' | tr -d '"' || echo "")

    [[ "$trigger" == "glob" && -n "$globs" ]] || continue

    local skill_name; skill_name=$(basename "$skill_dir")
    {
      echo "---"
      echo "applyTo: \"${globs}\""
      echo "---"
      echo ""
      awk '/^---/{found++; if(found==2){skip=0; next} else {skip=1; next}} skip{next} {print}' "$skill_md"
    } > "$dest_dir/${skill_name}.instructions.md"
  done
}
