#!/usr/bin/env bash
# hooks.sh — Antigravity platform pre/post write hooks

append_agents_md() {
  local target_dir="${1:-$PWD}"
  local agents_md="$target_dir/.agents/AGENTS.md"
  ensure_dir "$target_dir/.agents"
  if [[ ! -f "$agents_md" ]]; then
    echo "# Agent Configuration" > "$agents_md"
    echo "" >> "$agents_md"
    echo "This project uses [hub](https://github.com/exterex/agentic-instructions) to manage agent instructions." >> "$agents_md"
  fi
}
