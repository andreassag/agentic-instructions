#!/usr/bin/env bash
safe_write() {
  local dest=$1 content=$2
  local tmp; tmp=$(mktemp)
  printf '%s\n' "$content" > "$tmp"
  mv "$tmp" "$dest"
}
ensure_dir() { [ -d "$1" ] || mkdir -p "$1"; }
