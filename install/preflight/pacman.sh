#!/usr/bin/env bash
set -euo pipefail
source "$SMRTR_INSTALL/helpers/helpers.sh"

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

log_info "Pacman configured."
