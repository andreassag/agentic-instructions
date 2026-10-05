#!/usr/bin/env bash
# hooks.sh — Mistral Vibe platform write hooks

deploy_vibe_agents() {
  local target_dir="${1:-$PWD}"
  local agents_src="$HUB_HOME/agents"
  local dest_dir="$target_dir/.vibe/agents"
  ensure_dir "$dest_dir"

  # Convert each agent .md into a Vibe TOML file
  for agent_file in "$agents_src"/*.md; do
    [[ -f "$agent_file" ]] || continue
    local agent_name; agent_name=$(basename "$agent_file" .md)

    # Extract frontmatter fields
    local name desc
    name=$(grep -m1 '^name:' "$agent_file" 2>/dev/null | sed 's/^name: *//' | tr -d '"' || echo "$agent_name")
    desc=$(grep -m1 '^description:' "$agent_file" 2>/dev/null | sed 's/^description: *//' | tr -d '"' || echo "")

    {
      echo "# Managed by hub (agentic-instructions)"
      echo "agent_type = \"subagent\""
      echo "display_name = \"${name}\""
      echo "description = \"${desc}\""
      echo ""
      echo "[tools.bash]"
      echo "permission = \"ask\""
      echo ""
      echo "[tools.read_file]"
      echo "permission = \"always\""
      echo ""
      echo "[tools.edit]"
      echo "permission = \"ask\""
    } > "$dest_dir/${agent_name}.toml"
  done
}

build_vibe_agents_md() {
  local target_dir="${1:-$PWD}"
  local rules_src="$HUB_HOME/rules"
  local out="$target_dir/AGENTS.md"

  {
    echo "< Managed by hub (agentic-instructions) -->"
    echo "< Vibe reads this file as global repository instructions -->"
    echo ""
    for rule_file in "$rules_src"/*.md; do
      [[ -f "$rule_file" ]] || continue
      # Strip YAML frontmatter
      awk '/^---/{found++; if(found==2){skip=0; next} else {skip=1; next}} skip{next} {print}' "$rule_file"
      echo ""
      echo "---"
      echo ""
    done
  } > "$out"
}
