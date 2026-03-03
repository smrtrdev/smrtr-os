#!/usr/bin/env bash
set -euo pipefail
source "$SMRTR_INSTALL/helpers/helpers.sh"

log_step "Installing Walker runtime dependencies..."
pkg_install gtk4 gtk4-layer-shell cairo poppler-glib protobuf openbsd-netcat

log_step "Installing Walker and Elephant packages..."
aur_install walker elephant elephant-providerlist elephant-desktopapplications

log_step "Enabling Elephant service..."
enable_user_service elephant.service

log_step "Installing Walker config..."
install_config "walker/config.toml" "$USER_CONFIG/walker/config.toml"
ensure_dir "$USER_CONFIG/walker/themes"
install_config "walker/themes/catppuccin.css" "$USER_CONFIG/walker/themes/catppuccin.css"

log_info "App launcher setup complete."
