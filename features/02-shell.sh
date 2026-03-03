#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/helpers.sh"

log_step "Installing shell tools..."
pkg_install nushell starship fzf fd ripgrep eza bat zoxide tldr fastfetch zellij htop btop tree

log_step "Installing AUR shell packages..."
aur_install carapace-bin

# --- Shell Selection ---

log_step "Shell selection..."
default_shell=$(ask_choice "Select default shell:" "bash" "nushell")
case "$default_shell" in
    bash)
        chsh -s /usr/bin/bash
        log_info "Default shell set to bash."
        ;;
    nushell)
        chsh -s /usr/bin/nu
        log_info "Default shell set to nushell."
        ;;
esac

# --- Install Config Files ---

log_step "Installing shell configs..."

# Bash configs
install_config "smrtr/bash/aliases.sh" "$USER_CONFIG/smrtr/bash/aliases.sh"
install_config "smrtr/bash/functions.sh" "$USER_CONFIG/smrtr/bash/functions.sh"

# Nushell configs
install_config "nushell/config.nu" "$USER_CONFIG/nushell/config.nu"
install_config "nushell/env.nu" "$USER_CONFIG/nushell/env.nu"
install_config "nushell/aliases.nu" "$USER_CONFIG/nushell/aliases.nu"

# Starship
install_config "starship.toml" "$USER_CONFIG/starship.toml"

# Zellij
install_config "zellij/config.kdl" "$USER_CONFIG/zellij/config.kdl"
install_config "zellij/layouts/default.kdl" "$USER_CONFIG/zellij/layouts/default.kdl"

# Fastfetch
install_config "fastfetch/config.jsonc" "$USER_CONFIG/fastfetch/config.jsonc"

# --- Bashrc Integration ---

log_step "Configuring .bashrc..."

BASHRC="$HOME/.bashrc"
MARKER="# smrtr-os shell integration"

if ! grep -qF "$MARKER" "$BASHRC" 2>/dev/null; then
    cat >> "$BASHRC" << 'SMRTR_BASHRC'

# smrtr-os shell integration
source ~/.config/smrtr/bash/aliases.sh
source ~/.config/smrtr/bash/functions.sh
eval "$(starship init bash)"
eval "$(zoxide init bash)"
eval "$(fzf --bash)"
command -v mise >/dev/null 2>&1 && eval "$(mise activate bash)"
export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-nvim}"
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth:erasedups
[[ $- == *i* ]] && [[ -z "$TMUX" ]] && [[ -z "$ZELLIJ" ]] && fastfetch
SMRTR_BASHRC
    log_info "Added smrtr-os integration to .bashrc"
else
    log_info ".bashrc already configured."
fi

# --- Create cache dirs for nushell integrations ---

log_step "Creating nushell cache directories..."
ensure_dir "$HOME/.cache/starship"
ensure_dir "$HOME/.cache/zoxide"
ensure_dir "$HOME/.cache/carapace"
ensure_dir "$HOME/.cache/mise"

log_info "Shell configuration complete."
