#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/helpers.sh"

log_step "Installing browsers..."
aur_install zen-browser-bin brave-bin

log_step "Installing Brave Wayland flags..."
install_config "brave-flags.conf" "$USER_CONFIG/brave-flags.conf"

log_step "Setting Zen Browser as default..."
xdg-settings set default-web-browser zen-browser.desktop 2>/dev/null || \
    log_warn "Could not set default browser via xdg-settings (no desktop session active)."

log_info "Browser setup complete."
