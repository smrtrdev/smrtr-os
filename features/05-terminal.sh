#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/helpers.sh"

log_step "Installing Ghostty and fonts..."
pkg_install ghostty ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji

log_step "Installing Ghostty config..."
install_config "ghostty/config" "$USER_CONFIG/ghostty/config"

log_info "Terminal setup complete."
