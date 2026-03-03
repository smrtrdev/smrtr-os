#!/usr/bin/env bash
set -euo pipefail
source "$SMRTR_INSTALL/helpers/helpers.sh"

log_step "Installing Ghostty and fonts..."
pkg_install ghostty ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji

log_step "Installing Ghostty config..."
install_config "ghostty/config" "$USER_CONFIG/ghostty/config"

log_info "Terminal setup complete."
