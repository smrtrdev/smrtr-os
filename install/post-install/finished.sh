#!/usr/bin/env bash
# Sourced by post-install/all.sh — runs in the main process so helper
# functions are available without re-sourcing.

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
