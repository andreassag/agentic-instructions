#!/usr/bin/env bash
# hooks.sh — JetBrains AI Assistant platform write hooks

deploy_jetbrains_rules() {
  local target_dir="${1:-$PWD}"
  local rules_src="$HUB_HOME/rules"
  local dest_dir="$target_dir/.aiassistant/rules"
  ensure_dir "$dest_dir"

  for rule_file in "$rules_src"/*.md; do
    [[ -f "$rule_file" ]] || continue
    local rule_name; rule_name=$(basename "$rule_file" .md)

    # Read trigger/glob from frontmatter to set JetBrains rule application mode
    local trigger globs
    trigger=$(grep -m1 '^trigger:' "$rule_file" 2>/dev/null | awk '{print $2}' || echo "always_on")
    globs=$(grep -m1 '^globs:' "$rule_file" 2>/dev/null | sed 's/^globs: *//' | tr -d '"' || echo "")

    # JetBrains uses a metadata comment block at top of rule files
    {
      echo "< hub:rule name=${rule_name} trigger=${trigger} -->"
      if [[ -n "$globs" ]]; then
        echo "< hub:globs ${globs} -->"
      fi
      echo ""
      # Strip existing YAML frontmatter
      awk '/^---/{found++; if(found==2){skip=0; next} else {skip=1; next}} skip{next} {print}' "$rule_file"
    } > "$dest_dir/${rule_name}.md"
  done
}

deploy_jetbrains_skill_rules() {
  local target_dir="${1:-$PWD}"
  local dest_dir="$target_dir/.aiassistant/rules"
  ensure_dir "$dest_dir"

  # Deploy tech-guideline skills (glob-triggered) as JetBrains rules
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
      echo "< hub:rule name=${skill_name} trigger=glob -->"
      echo "< hub:globs ${globs} -->"
      echo ""
      awk '/^---/{found++; if(found==2){skip=0; next} else {skip=1; next}} skip{next} {print}' "$skill_md"
    } > "$dest_dir/${skill_name}.md"
  done
}
