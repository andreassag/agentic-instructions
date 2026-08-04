#!/usr/bin/env bash
# hooks.sh — Claude platform pre/post write hooks
# Sourced by lib/platform_write.sh after writing CLAUDE.md

validate_git_root() {
  git rev-parse --git-dir >/dev/null 2>&1 \
    || { echo "[hub:claude:hooks] Not in a git repository."; return 1; }
}

register_claude_commands() {
  : # Commands registered by skills_deploy.sh — no additional action needed here.
}
