#!/usr/bin/env bash
set -euo pipefail
source "$SMRTR_INSTALL/helpers/helpers.sh"

log_step "Installing Walker..."
aur_install walker

log_step "Installing Walker config..."
install_config "walker/config.toml" "$USER_CONFIG/walker/config.toml"
ensure_dir "$USER_CONFIG/walker/themes"
install_config "walker/themes/catppuccin.css" "$USER_CONFIG/walker/themes/catppuccin.css"

log_info "App launcher setup complete."
