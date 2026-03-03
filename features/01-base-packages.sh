#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/helpers.sh"

log_step "Configuring pacman..."

# Enable Color, ParallelDownloads, ILoveCandy
sudo sed -i 's/^#Color$/Color/' /etc/pacman.conf
sudo sed -i 's/^#ParallelDownloads.*/ParallelDownloads = 5/' /etc/pacman.conf
if ! grep -q "^ILoveCandy" /etc/pacman.conf; then
    sudo sed -i '/^ParallelDownloads/a ILoveCandy' /etc/pacman.conf
fi

# Enable multilib
if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    sudo bash -c 'echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf'
fi

sudo pacman -Syu --noconfirm

# --- Core Packages ---

log_step "Installing core packages..."
pkg_install base-devel git wget curl jq unzip zip man-db

log_step "Installing filesystem tools..."
pkg_install ntfs-3g exfatprogs udisks2

# --- AUR Helper (paru) ---

log_step "Setting up paru..."
if ! command -v paru &>/dev/null; then
    log_info "Building paru from AUR..."
    tmpdir="$(mktemp -d)"
    git clone https://aur.archlinux.org/paru-bin.git "$tmpdir/paru-bin"
    (cd "$tmpdir/paru-bin" && makepkg -si --noconfirm)
    rm -rf "$tmpdir"
    log_info "paru installed successfully."
else
    log_info "paru already installed."
fi

# --- Audio (PipeWire) ---

log_step "Installing PipeWire audio stack..."
pkg_install pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber

enable_user_service pipewire.service
enable_user_service pipewire-pulse.service
enable_user_service wireplumber.service

# --- Networking ---

log_step "Installing networking..."
pkg_install networkmanager iwd

# Configure NetworkManager to use iwd as backend
sudo mkdir -p /etc/NetworkManager/conf.d
if [[ ! -f /etc/NetworkManager/conf.d/iwd.conf ]]; then
    sudo tee /etc/NetworkManager/conf.d/iwd.conf >/dev/null <<'EOF'
[device]
wifi.backend=iwd
EOF
fi

enable_service NetworkManager.service
enable_service iwd.service

# --- Bluetooth ---

log_step "Installing bluetooth..."
pkg_install bluez bluez-utils
enable_service bluetooth.service

# --- Printing (optional) ---

if ask_yes_no "Install printing support (CUPS)?" "n"; then
    log_step "Installing CUPS..."
    pkg_install cups cups-pdf
    enable_service cups.service
fi

# --- Firewall ---

log_step "Installing firewall..."
pkg_install ufw
enable_service ufw.service
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw --force enable

# --- GPU Drivers ---

log_step "Detecting GPU..."
gpu_info=$(lspci | grep -iE "vga|3d|display")
log_info "Detected: $gpu_info"

if echo "$gpu_info" | grep -qi "intel"; then
    log_step "Installing Intel GPU drivers..."
    pkg_install mesa vulkan-intel intel-media-driver
fi

if echo "$gpu_info" | grep -qi "amd\|radeon"; then
    log_step "Installing AMD GPU drivers..."
    pkg_install mesa vulkan-radeon libva-mesa-driver
fi

if echo "$gpu_info" | grep -qi "nvidia"; then
    log_step "Installing NVIDIA GPU drivers..."
    pkg_install nvidia nvidia-utils nvidia-settings
fi

log_info "Base packages setup complete."
