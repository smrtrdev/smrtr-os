#!/usr/bin/env bash
set -euo pipefail
source "$SMRTR_INSTALL/helpers/helpers.sh"

log_step "Installing Walker runtime dependencies..."
pkg_install gtk4 gtk4-layer-shell cairo poppler-glib protobuf openbsd-netcat

log_step "Installing Walker and Elephant packages..."
aur_install walker elephant elephant-providerlist elephant-desktopapplications

log_step "Enabling Elephant service (if provided by package)..."
ELEPHANT_UNIT=""
for candidate in elephant.service elephant.socket elephant-desktopapplications.service; do
    if [[ -f "/usr/lib/systemd/user/$candidate" || -f "/etc/systemd/user/$candidate" || -f "$HOME/.config/systemd/user/$candidate" ]]; then
        ELEPHANT_UNIT="$candidate"
        break
    fi
done

if [[ -n "$ELEPHANT_UNIT" ]]; then
    enable_user_service "$ELEPHANT_UNIT"
else
    log_info "No Elephant user unit found; skipping service enable."
fi

log_step "Installing Walker/Elephant config..."
install_config "walker/config.toml" "$USER_CONFIG/walker/config.toml"
ensure_dir "$USER_CONFIG/walker/themes"
install_config "walker/themes/catppuccin.css" "$USER_CONFIG/walker/themes/catppuccin.css"
install_config "walker/walker.desktop" "$USER_CONFIG/autostart/walker.desktop"
install_config "walker/restart.conf" "$USER_CONFIG/systemd/user/app-walker@autostart.service.d/restart.conf"
install_config "elephant/calc.toml" "$USER_CONFIG/elephant/calc.toml"
install_config "elephant/desktopapplications.toml" "$USER_CONFIG/elephant/desktopapplications.toml"

log_step "Reloading user systemd daemon..."
systemctl --user daemon-reload

log_step "Installing launcher executables..."
BIN_TARGET_DIR="$HOME/.local/bin"
ensure_dir "$BIN_TARGET_DIR"

for exe in smrtr-restart-walker smrtr-launch-walker; do
    cp -f "$REPO_DIR/bin/$exe" "$BIN_TARGET_DIR/$exe"
    chmod 755 "$BIN_TARGET_DIR/$exe"
done

RESTART_HELPER="$BIN_TARGET_DIR/smrtr-restart-walker"

log_step "Installing pacman hook for Walker/Elephant upgrades..."
sudo mkdir -p /etc/pacman.d/hooks
sudo tee /etc/pacman.d/hooks/smrtr-walker-restart.hook >/dev/null <<EOF
[Trigger]
Type = Package
Operation = Upgrade
Target = walker
Target = walker-debug
Target = elephant*

[Action]
Description = Restarting Walker services after system update
When = PostTransaction
Exec = $RESTART_HELPER
EOF

log_info "App launcher setup complete."
