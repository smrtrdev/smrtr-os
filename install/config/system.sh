#!/usr/bin/env bash
set -euo pipefail
source "$SMRTR_INSTALL/helpers/helpers.sh"

# --- Sudoers ---

log_step "Configuring sudo timeout..."
sudo mkdir -p /etc/sudoers.d
_sudoers_tmp=$(mktemp)
echo 'Defaults timestamp_timeout=30' > "$_sudoers_tmp"
if ! sudo visudo -cf "$_sudoers_tmp" >/dev/null 2>&1; then
    rm -f "$_sudoers_tmp"
    log_error "sudoers validation failed; aborting sudoers configuration."
    exit 1
fi
sudo install -m 440 "$_sudoers_tmp" /etc/sudoers.d/smrtr
rm -f "$_sudoers_tmp"

# --- Sysctl Tweaks ---

log_step "Applying sysctl tweaks..."
sudo tee /etc/sysctl.d/90-smrtr.conf >/dev/null <<'EOF'
fs.inotify.max_user_watches = 524288
fs.inotify.max_user_instances = 1024
vm.swappiness = 10
EOF
sudo sysctl --system >/dev/null 2>&1

# --- SSD TRIM ---

log_step "Enabling SSD TRIM timer..."
enable_service fstrim.timer

# --- Time Sync ---

log_step "Enabling time synchronization..."
enable_service systemd-timesyncd.service

# Timezone
current_tz=$(timedatectl show --property=Timezone --value 2>/dev/null || echo "")
if [[ -z "$current_tz" || "$current_tz" == "UTC" ]]; then
    log_step "Setting timezone..."
    # Try auto-detection via IP geolocation (HTTPS to avoid plaintext data leakage)
    detected_tz=$(curl -sf "https://ipapi.co/timezone" 2>/dev/null || echo "")
    if [[ -n "$detected_tz" ]]; then
        if ask_yes_no "Detected timezone: $detected_tz. Use this?"; then
            sudo timedatectl set-timezone "$detected_tz"
            log_info "Timezone set to $detected_tz"
        else
            read -rp "Enter timezone (e.g., America/New_York): " manual_tz
            sudo timedatectl set-timezone "$manual_tz"
        fi
    else
        read -rp "Enter timezone (e.g., America/New_York): " manual_tz
        sudo timedatectl set-timezone "$manual_tz"
    fi
else
    log_info "Timezone already set: $current_tz"
fi

# --- Locale ---

log_step "Verifying locale..."
if ! locale -a 2>/dev/null | grep -q "en_US.utf8"; then
    log_info "Generating en_US.UTF-8 locale..."
    sudo sed -i 's/^#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
    sudo locale-gen
fi
if ! grep -q "LANG=en_US.UTF-8" /etc/locale.conf 2>/dev/null; then
    echo "LANG=en_US.UTF-8" | sudo tee /etc/locale.conf >/dev/null
fi

# --- Power Management (laptop detection) ---

if ls /sys/class/power_supply/BAT* &>/dev/null; then
    log_step "Laptop detected — installing power management..."
    pkg_install power-profiles-daemon
    enable_service power-profiles-daemon.service
fi

# --- Keyring ---

log_step "Installing keyring..."
pkg_install gnome-keyring libsecret

# --- XDG User Directories ---

log_step "Setting up XDG directories..."
pkg_install xdg-user-dirs
xdg-user-dirs-update
ensure_dir "$HOME/Pictures/Screenshots"

# --- Environment Variables ---

log_step "Installing environment.d config..."
install_config "environment.d/smrtr.conf" "$USER_CONFIG/environment.d/smrtr.conf"

log_info "System services setup complete."
