#!/usr/bin/env bash
file_hash() { sha256sum "$1" 2>/dev/null | awk '{print $1}'; }
string_hash() { printf '%s' "$1" | sha256sum | awk '{print $1}'; }

context_changed() {
  local platform=$1 new_hash=$2 state_file=$3
  local stored; stored=$(jq -r --arg p "$platform" '.hashes[$p] // empty' "$state_file" 2>/dev/null)
  [[ "$new_hash" != "$stored" ]]
}
