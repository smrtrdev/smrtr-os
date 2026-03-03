#!/usr/bin/env bash
set -euo pipefail
source "$SMRTR_INSTALL/helpers/helpers.sh"

log_step "Login manager setup..."

login_method=$(ask_choice "Select login method:" "greetd + tuigreet (graphical login)" "TTY autologin (minimal)")

case "$login_method" in
    "greetd + tuigreet (graphical login)")
        log_step "Installing greetd + tuigreet (password login)..."
        pkg_install greetd tuigreet

        sudo mkdir -p /etc/greetd
        sudo tee /etc/greetd/config.toml >/dev/null <<EOF
[terminal]
vt = 1

[default_session]
command = "tuigreet --theme 'time=yellow' --time --remember --remember-session --power-shutdown '/usr/bin/systemctl poweroff' --power-reboot '/usr/bin/systemctl reboot' --cmd 'uwsm start -- niri-session'"
user = "greeter"
EOF

        sudo systemctl disable --now sddm.service 2>/dev/null || true
        enable_service greetd.service
        log_info "greetd configured and enabled."

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
        ;;

    "TTY autologin (minimal)")
        log_step "Configuring TTY autologin..."

        # Getty autologin override — security gate
        log_warn "SECURITY: Enabling autologin on TTY1 disables password-based authentication for local console access."
        log_warn "Anyone with physical or console access will obtain a shell as '$USER' without entering a password."
        if ask_yes_no "Enable autologin on TTY1? (disables local authentication)" "n"; then
            sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
            sudo tee /etc/systemd/system/getty@tty1.service.d/autologin.conf >/dev/null <<EOF
[Service]
ExecStart=
ExecStart=-/sbin/agetty -o '-p -f -- \\u' --noclear --autologin $USER %I \$TERM
EOF
            sudo systemctl daemon-reload
            sudo systemctl enable getty@tty1.service
            log_info "TTY autologin enabled."
        else
            log_info "Autologin skipped. TTY1 will require a password to log in."
        fi

        # Bash auto-start niri
        BASH_PROFILE="$HOME/.bash_profile"
        MARKER="# smrtr-os niri autostart"
        if ! grep -qF "$MARKER" "$BASH_PROFILE" 2>/dev/null; then
            cat >> "$BASH_PROFILE" << 'SMRTR_BASH_PROFILE'

# smrtr-os niri autostart
if [ -z "$WAYLAND_DISPLAY" ] && [ "${XDG_VTNR:-0}" -eq 1 ]; then
    exec niri-session
fi
SMRTR_BASH_PROFILE
            log_info "Added niri autostart to .bash_profile"
        fi

        # Nushell auto-start niri
        LOGIN_NU="$USER_CONFIG/nushell/login.nu"
        ensure_dir "$(dirname "$LOGIN_NU")"
        if ! grep -qF "niri-session" "$LOGIN_NU" 2>/dev/null; then
            cat >> "$LOGIN_NU" << 'SMRTR_LOGIN_NU'

# smrtr-os niri autostart
if ($env | get -i WAYLAND_DISPLAY | is-empty) and ($env.XDG_VTNR? == "1") {
    exec niri-session
}
SMRTR_LOGIN_NU
            log_info "Added niri autostart to login.nu"
        fi

        # Verify PAM gnome-keyring config for login
        if ! grep -q "pam_gnome_keyring" /etc/pam.d/login 2>/dev/null; then
            log_warn "gnome-keyring PAM not found in /etc/pam.d/login — keyring may not auto-unlock."
        fi

        log_info "TTY login manager setup complete."
        ;;
esac

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
