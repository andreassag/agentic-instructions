#!/usr/bin/env bash
# hooks.sh — Copilot platform pre/post write hooks

validate_github_dir() {
  local target_dir="${1:-$PWD}"
  ensure_dir "$target_dir/.github"
}
