#!/usr/bin/env bash
# hooks.sh — Codex platform pre/post write hooks

ensure_codex_dir() {
  local target_dir="${1:-$PWD}"
  ensure_dir "$target_dir/.codex"
}
