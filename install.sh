#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/helpers.sh"

# --- Welcome Banner ---

echo ""
echo "  ┌─────────────────────────────────────┐"
echo "  │         smrtr-os installer           │"
echo "  │   Arch Linux post-install setup      │"
echo "  └─────────────────────────────────────┘"
echo ""

# --- Prerequisite Checks ---

log_step "Checking prerequisites..."

if [[ $EUID -eq 0 ]]; then
    log_error "Do not run this script as root. Run as your normal user (sudo will be used when needed)."
    exit 1
fi

if [[ ! -f /etc/arch-release ]]; then
    log_error "This script is designed for Arch Linux."
    exit 1
fi

if ! ping -c 1 -W 3 archlinux.org &>/dev/null; then
    log_error "No internet connection detected."
    exit 1
fi

if ! sudo -v; then
    log_error "sudo access is required."
    exit 1
fi

# Keep sudo alive for the duration of the script
(while true; do sudo -n true; sleep 60; done) &
SUDO_PID=$!
trap 'kill $SUDO_PID 2>/dev/null' EXIT

log_info "All prerequisites met."

# --- Run Feature Scripts ---

log_step "Running feature scripts..."

for script in "$SCRIPT_DIR"/features/*.sh; do
    [[ -f "$script" ]] || continue
    feature_name="$(basename "$script")"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    log_step "Running: $feature_name"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    bash "$script"
    log_info "Completed: $feature_name"
done

# --- Finish ---

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
log_step "smrtr-os installation complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if ask_yes_no "Reboot now?"; then
    sudo reboot
else
    log_info "Please reboot when ready to apply all changes."
fi
