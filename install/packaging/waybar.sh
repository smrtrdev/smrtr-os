#!/usr/bin/env bash
set -euo pipefail
source "$SMRTR_INSTALL/helpers/helpers.sh"

log_step "Installing Waybar..."
pkg_install waybar otf-font-awesome

log_step "Installing Waybar config..."
install_config "waybar/config.jsonc" "$USER_CONFIG/waybar/config.jsonc"
install_config "waybar/style.css" "$USER_CONFIG/waybar/style.css"

# Conditionally include battery module
log_step "Detecting battery..."
if ls /sys/class/power_supply/BAT* &>/dev/null; then
    log_info "Battery detected — enabling battery module."
    sed -i 's/SMRTR_BATTERY_PLACEHOLDER/"battery",/' "$USER_CONFIG/waybar/config.jsonc"
else
    log_info "No battery detected — removing battery module."
    sed -i '/SMRTR_BATTERY_PLACEHOLDER/d' "$USER_CONFIG/waybar/config.jsonc"
fi

log_info "Waybar setup complete."
