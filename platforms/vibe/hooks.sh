#!/usr/bin/env bash
# hooks.sh — Vibe platform pre/post write hooks

ensure_vibe_dir() {
  local target_dir="${1:-$PWD}"
  ensure_dir "$target_dir/.vibe"
}
