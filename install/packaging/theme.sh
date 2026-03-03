#!/usr/bin/env bash
set -euo pipefail
source "$SMRTR_INSTALL/helpers/helpers.sh"

log_step "Installing theme packages..."
aur_install catppuccin-gtk-theme-mocha catppuccin-cursors-mocha

pkg_install papirus-icon-theme qt6ct qt5ct

if ask_yes_no "Install CJK font support (noto-fonts-cjk)?" "n"; then
    pkg_install noto-fonts-cjk
fi

# --- Install GTK configs ---

log_step "Installing GTK settings..."
install_config "gtk-3.0/settings.ini" "$USER_CONFIG/gtk-3.0/settings.ini"
install_config "gtk-4.0/settings.ini" "$USER_CONFIG/gtk-4.0/settings.ini"

# --- Install fontconfig ---

log_step "Installing fontconfig..."
install_config "fontconfig/fonts.conf" "$USER_CONFIG/fontconfig/fonts.conf"

# --- System cursor theme ---

log_step "Setting system cursor theme..."
sudo mkdir -p /usr/share/icons/default
sudo tee /usr/share/icons/default/index.theme >/dev/null <<'EOF'
[Icon Theme]
Inherits=catppuccin-mocha-dark-cursors
EOF

log_info "Theme and appearance setup complete."
