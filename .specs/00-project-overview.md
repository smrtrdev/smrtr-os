# smrtr-os — Project Overview

## Vision

smrtr-os is a minimal, opinionated Arch Linux post-installation setup. It automates the configuration of a modern Wayland desktop environment with sensible defaults. Unlike omarchy (which it draws inspiration from), smrtr-os prioritizes simplicity — fewer moving parts, fewer abstractions, and a flat script structure that's easy to read and modify.

## Design Principles

- **Simple over clever** — Plain bash scripts, no framework, no plugin system.
- **Minimal dependencies** — Only install what's actually needed.
- **Idempotent** — Running the installer again should be safe and produce the same result.
- **Modular** — Each feature is a standalone script that can be run independently.
- **No migration system** — Fresh installs only; no upgrade path complexity.
- **User's dotfiles** — Configs live in the repo and get symlinked/copied to the right places.

## Target Environment

- **OS:** Arch Linux (fresh install with base system + networking)
- **Display protocol:** Wayland
- **Window manager:** Niri (scrollable tiling compositor)
- **Shell:** Bash and Nushell (user chooses default during install), starship prompt
- **Terminal:** Ghostty (primary)
- **Multiplexer:** Zellij
- **Launcher:** Walker

## Repository Structure

```
smrtr-os/
├── install.sh              # Main entry point — runs all features in order
├── lib/                    # Shared helper functions (logging, pkg install)
├── features/               # One script per feature (XX-name.sh)
│   ├── 01-base-packages.sh
│   ├── 02-development-tools.sh
│   ├── 03-niri.sh
│   ├── ...
├── config/                 # Dotfiles and config templates
│   ├── niri/
│   ├── waybar/
│   ├── ghostty/
│   ├── starship.toml
│   └── ...
├── .specs/                 # Feature specifications (this folder)
└── README.md
```

## Installation Flow

1. User boots into a fresh Arch install with base system, networking, and a user account.
2. User clones this repo and runs `./install.sh`.
3. The script sources `lib/helpers.sh` for common functions.
4. Each feature script in `features/` is executed in numeric order.
5. Feature scripts install packages, copy/symlink configs, and enable services.
6. Existing user configs are backed up to `~/.config/smrtr-backup/` before being overwritten.
7. At the end, the user is prompted to reboot.

## Conventions

- Feature scripts are numbered `XX-name.sh` to control execution order.
- Each feature script must be runnable standalone: `./features/03-niri.sh`.
- Package installation uses a helper that wraps `pacman -S --needed --noconfirm` and `paru -S --needed --noconfirm` for AUR.
- Config files in `config/` mirror the target path under `~/.config/`.
- All scripts use `set -euo pipefail`.
