#!/usr/bin/env bash
detect_os() {
  case "$(uname -s)" in Linux*) echo linux;; Darwin*) echo macos;; *) echo unknown;; esac
}
is_wsl() { grep -qi microsoft /proc/version 2>/dev/null; }
hub_realpath() { [[ $1 == /* ]] && echo "$1" || echo "$PWD/${1#./}"; }

check_dep() {
  local name=$1
  command -v "$name" >/dev/null 2>&1 || fatal "Required dependency '$name' not found. Install: $2"
}

check_yq_variant() {
  command -v yq >/dev/null 2>&1 || fatal "yq not found. Install mikefarah/yq: https://github.com/mikefarah/yq"
  yq --version 2>&1 | grep -qE 'mikefarah|version v?[4-9]' \
    || fatal "Wrong yq variant detected. Install mikefarah/yq v4+: https://github.com/mikefarah/yq"
}
