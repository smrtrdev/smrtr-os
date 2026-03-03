#!/usr/bin/env bash
# Sourced by preflight/all.sh — runs in the main process so traps and
# background jobs (sudo keepalive) persist for the full installation.

echo ""
echo "  ┌─────────────────────────────────────┐"
echo "  │         smrtr-os installer           │"
echo "  │   Arch Linux post-install setup      │"
echo "  └─────────────────────────────────────┘"
echo ""

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
