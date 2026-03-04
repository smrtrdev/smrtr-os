#!/usr/bin/env bash
set -euo pipefail
source "$SMRTR_INSTALL/helpers/helpers.sh"

log_step "Login manager setup..."

log_info "Using login setup: greetd + tuigreet."
log_step "Installing greetd + tuigreet (password login)..."
pkg_install greetd greetd-tuigreet

SESSION_CMD="/usr/bin/uwsm start -- niri-session"
if ! command -v uwsm &>/dev/null; then
    log_warn "uwsm not found; falling back to niri-session."
    SESSION_CMD="niri-session"
fi

sudo mkdir -p /etc/greetd
sudo tee /etc/greetd/config.toml >/dev/null <<EOF
[terminal]
vt = 1

[default_session]
command = "tuigreet --theme 'time=yellow' --time --remember --remember-session --power-shutdown '/usr/bin/systemctl poweroff' --power-reboot '/usr/bin/systemctl reboot' --cmd '$SESSION_CMD'"
user = "greeter"
EOF

sudo systemctl disable --now sddm.service 2>/dev/null || true
log_info "Enabling service: greetd.service"
sudo systemctl enable greetd.service
log_info "greetd configured and enabled (will start on next boot or when started manually)."

# Ensure PAM gnome-keyring config for password-based tuigreet login
if ! grep -q "pam_gnome_keyring.so" /etc/pam.d/greetd 2>/dev/null; then
    log_warn "Adding pam_gnome_keyring hooks to /etc/pam.d/greetd for keyring auto-unlock."
    sudo tee -a /etc/pam.d/greetd >/dev/null <<'EOF'
auth       optional     pam_gnome_keyring.so
session    optional     pam_gnome_keyring.so auto_start
EOF
fi

# Verify PAM gnome-keyring config
if ! grep -q "pam_gnome_keyring" /etc/pam.d/greetd 2>/dev/null; then
    log_warn "gnome-keyring PAM not found in /etc/pam.d/greetd — keyring may not auto-unlock."
fi

# Verify niri session file exists
if [[ ! -f /usr/share/wayland-sessions/niri.desktop ]]; then
    log_warn "niri.desktop session file not found. Creating it..."
    sudo mkdir -p /usr/share/wayland-sessions
    sudo tee /usr/share/wayland-sessions/niri.desktop >/dev/null <<'EOF'
[Desktop Entry]
Name=Niri
Comment=A scrollable-tiling Wayland compositor
Exec=niri-session
Type=Application
EOF
fi

log_info "Login manager setup complete."
