#!/usr/bin/env bash
source "$HUB_HOME/lib/cmd_init.sh"

cmd_update() {
  info "Updating hub configuration..."
  cmd_init "$@"
}
