#!/usr/bin/env bash
set -euo pipefail
source "$SMRTR_INSTALL/helpers/helpers.sh"

log_step "Installing Mako notification daemon..."
pkg_install mako

log_step "Installing Mako config..."
install_config "mako/config" "$USER_CONFIG/mako/config"

log_info "Notification daemon setup complete."
