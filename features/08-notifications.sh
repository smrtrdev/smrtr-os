#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/helpers.sh"

log_step "Installing Mako notification daemon..."
pkg_install mako

log_step "Installing Mako config..."
install_config "mako/config" "$USER_CONFIG/mako/config"

log_info "Notification daemon setup complete."
