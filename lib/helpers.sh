#!/usr/bin/env bash
# smrtr-os shared helper library
# Sourced by install.sh and all feature scripts

# Constants
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_DIR="$REPO_DIR/config"
USER_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"
BACKUP_DIR="$USER_CONFIG/smrtr-backup/$(date +%Y%m%d_%H%M%S)"

# --- Logging ---

log_info() {
    printf '\033[1;34m[INFO]\033[0m %s\n' "$*"
}

log_warn() {
    printf '\033[1;33m[WARN]\033[0m %s\n' "$*" >&2
}

log_error() {
    printf '\033[1;31m[ERROR]\033[0m %s\n' "$*" >&2
}

log_step() {
    printf '\033[1m[=>]\033[0m %s\n' "$*"
}

# --- Package Management ---

pkg_installed() {
    pacman -Qi "$1" &>/dev/null
}

pkg_install() {
    local to_install=()
    for pkg in "$@"; do
        if ! pkg_installed "$pkg"; then
            to_install+=("$pkg")
        fi
    done
    if [[ ${#to_install[@]} -gt 0 ]]; then
        log_info "Installing packages: ${to_install[*]}"
        sudo pacman -S --needed --noconfirm "${to_install[@]}"
    else
        log_info "All packages already installed: $*"
    fi
}

aur_install() {
    if ! command -v paru &>/dev/null; then
        log_error "paru is not installed. Cannot install AUR packages."
        return 1
    fi
    local to_install=()
    for pkg in "$@"; do
        if ! pkg_installed "$pkg"; then
            to_install+=("$pkg")
        fi
    done
    if [[ ${#to_install[@]} -gt 0 ]]; then
        log_info "Installing AUR packages: ${to_install[*]}"
        paru -S --needed --noconfirm "${to_install[@]}"
    else
        log_info "All AUR packages already installed: $*"
    fi
}

# --- Config Management ---

ensure_dir() {
    [[ -d "$1" ]] || mkdir -p "$1"
}

backup_config() {
    local target="$1"
    [[ -e "$target" ]] || return 0

    local rel_path="${target#$HOME/}"
    local backup_path="$BACKUP_DIR/$rel_path"

    ensure_dir "$(dirname "$backup_path")"
    cp -a "$target" "$backup_path"
    log_info "Backed up $target → $backup_path"
}

install_config() {
    local source_rel="$1"
    local target="$2"
    local source="$CONFIG_DIR/$source_rel"

    if [[ ! -e "$source" ]]; then
        log_error "Config source not found: $source"
        return 1
    fi

    backup_config "$target"
    ensure_dir "$(dirname "$target")"
    cp -a "$source" "$target"
    chmod 644 "$target"
    log_info "Installed config: $source_rel → $target"
}

# --- User Prompts ---

ask_yes_no() {
    local question="$1"
    local default="${2:-y}"
    local prompt

    if [[ "$default" == "y" ]]; then
        prompt="$question [Y/n] "
    else
        prompt="$question [y/N] "
    fi

    read -rp "$prompt" answer
    answer="${answer:-$default}"

    [[ "${answer,,}" == "y" ]]
}

ask_choice() {
    local question="$1"
    shift
    local options=("$@")
    local i

    echo "$question"
    for i in "${!options[@]}"; do
        echo "  $((i + 1))) ${options[$i]}"
    done

    local choice
    while true; do
        read -rp "Enter choice [1-${#options[@]}]: " choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#options[@]} )); then
            echo "${options[$((choice - 1))]}"
            return 0
        fi
        echo "Invalid choice. Try again."
    done
}

# --- Service Management ---

enable_service() {
    log_info "Enabling service: $1"
    sudo systemctl enable --now "$1"
}

enable_user_service() {
    log_info "Enabling user service: $1"
    systemctl --user enable --now "$1"
}
