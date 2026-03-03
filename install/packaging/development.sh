#!/usr/bin/env bash
set -euo pipefail
source "$SMRTR_INSTALL/helpers/helpers.sh"

# --- Core Dev Tools ---

log_step "Installing development tools..."
pkg_install neovim github-cli lazygit make cmake jq yq tokei hyperfine

log_step "Installing AUR development packages..."
aur_install mise-bin difftastic

# --- Git Config ---

log_step "Installing git config..."
install_config "git/config" "$USER_CONFIG/git/config"

# --- Mise Config ---

log_step "Installing mise config..."
install_config "mise/config.toml" "$USER_CONFIG/mise/config.toml"

# --- Podman (rootless containers) ---

log_step "Installing Podman..."
pkg_install podman podman-compose buildah

# Enable user lingering for long-running containers
sudo loginctl enable-linger "$USER"

# Configure registries
install_config "containers/registries.conf" "$USER_CONFIG/containers/registries.conf"

log_info "Podman configured for rootless operation."

# --- LazyVim (optional) ---

if ask_yes_no "Install LazyVim (preconfigured Neovim setup)?" "y"; then
    log_step "Installing LazyVim..."
    if [[ -d "$USER_CONFIG/nvim" ]]; then
        backup_config "$USER_CONFIG/nvim"
        rm -rf "$USER_CONFIG/nvim"
    fi
    # Pinned to a known-good commit; review and update deliberately to avoid supply-chain risk.
    LAZYVIM_STARTER_COMMIT="fca0af57cc3851b14f96a795a9c9bfafc5096dd1"
    git clone https://github.com/LazyVim/starter "$USER_CONFIG/nvim"
    git -C "$USER_CONFIG/nvim" checkout "$LAZYVIM_STARTER_COMMIT"
    rm -rf "$USER_CONFIG/nvim/.git"
    log_info "LazyVim installed. Run nvim to complete setup."
fi

# --- Claude Code (optional) ---

if ask_yes_no "Install Claude Code?" "n"; then
    log_step "Installing Claude Code..."
    curl -fsSL https://claude.ai/install.sh | bash
    log_info "Claude Code installed."
fi

log_info "Development tools setup complete."
