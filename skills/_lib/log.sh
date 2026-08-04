#!/usr/bin/env bash
HUB_COLOR="${HUB_COLOR:-1}"
_log() {
  local lvl=$1 color=$2; shift 2
  if [[ "$HUB_COLOR" == "1" ]]; then
    printf "\033[${color}m[hub:%s]\033[0m %s\n" "$lvl" "$*" >&2
  else
    printf "[hub:%s] %s\n" "$lvl" "$*" >&2
  fi
}
info()  { _log INFO  "34" "$@"; }
warn()  { _log WARN  "33" "$@"; }
error() { _log ERROR "31" "$@"; }
fatal() { _log FATAL "1;31" "$@"; exit 1; }
