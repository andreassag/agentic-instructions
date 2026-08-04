#!/usr/bin/env bash
deploy_skills() {
  local manifest=$1 platform=$2 target_dir=$3

  while IFS= read -r skill_path; do
    [[ -z "$skill_path" ]] && continue
    local skill_name; skill_name=$(dirname "$skill_path")
    local skill_script="$HUB_HOME/skills/$skill_path"
    local skill_md="$HUB_HOME/skills/$skill_name/SKILL.md"

    case "$platform" in
      antigravity)
        local dest="$target_dir/.agents/skills/$skill_name"
        ensure_dir "$dest"
        [[ -f "$skill_md" ]] && cp "$skill_md" "$dest/SKILL.md"
        cat > "$dest/run.sh" <<EOF
#!/usr/bin/env bash
HUB_HOME="\${HUB_HOME:-$HUB_HOME}"
exec "\${HUB_HOME}/skills/${skill_path}" "\$@"
EOF
        chmod +x "$dest/run.sh"
        ;;
      claude)
        local dest_dir="$target_dir/.claude/commands"
        ensure_dir "$dest_dir"
        local skill_name_slug="${skill_name//\//-}"
        local cmd_file="$dest_dir/hub-${skill_name_slug}.md"
        {
          echo "# hub: ${skill_name}"
          echo ""
          [[ -f "$skill_md" ]] && cat "$skill_md"
          echo ""
          echo "## Invocation"
          echo '```bash'
          echo "bash \"\$HUB_HOME/skills/${skill_path}\""
          echo '```'
        } > "$cmd_file"
        ;;
      copilot|vibe|codex)
        ;;
    esac
  done < <(yq e '.skills[]? // ""' "$manifest" | grep -v '^$')
}
