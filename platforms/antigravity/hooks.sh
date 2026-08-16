#!/usr/bin/env bash
# hooks.sh — Antigravity platform pre/post write hooks

ensure_rules_dir() {
  local target_dir="${1:-$PWD}"
  ensure_dir "$target_dir/.agents/rules"
}
