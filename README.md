# smrtr-os

A minimal, opinionated Arch Linux post-installation setup. Automates the configuration of a modern Wayland desktop with sensible defaults.

## What you get

- **Niri** — Scrollable-tiling Wayland compositor
- **Ghostty** — Terminal emulator with JetBrainsMono Nerd Font
- **Waybar** — Status bar with workspaces, clock, network, audio, bluetooth, battery
- **Walker** — Application launcher with clipboard history
- **Mako** — Notification daemon
- **Nushell + Bash** — Both shells configured with starship prompt, zoxide, fzf, eza, bat
- **Zellij** — Terminal multiplexer
- **Neovim** — Text editor (optional LazyVim setup)
- **Podman** — Rootless containers (Docker drop-in replacement)
- **Catppuccin Mocha** — Consistent dark theme across all components
- **Zen Browser + Brave** — Wayland-native web browsers

## Prerequisites

- Fresh Arch Linux install with base system and networking
- A non-root user account with sudo access
- Internet connection

## Quick start

```bash
git clone https://github.com/smrtr/smrtr-os.git
cd smrtr-os
./install.sh
```

The installer runs each feature module in order, prompting for choices along the way (default shell, login manager, optional packages).

## Features

| Script | What it does |
|--------|-------------|
| `01-base-packages.sh` | Pacman config, paru, PipeWire, networking, bluetooth, firewall, GPU drivers |
| `02-shell.sh` | Nushell, bash, starship, fzf, eza, bat, zoxide, zellij, fastfetch |
| `03-niri.sh` | Niri compositor, swaylock, swayidle, wallpaper, portals, keybindings |
| `04-terminal.sh` | Ghostty terminal, fonts |
| `05-waybar.sh` | Status bar with conditional battery module |
| `06-app-launcher.sh` | Walker launcher with catppuccin theme |
| `07-notifications.sh` | Mako notification daemon |
| `08-file-manager.sh` | Nautilus, imv, zathura, mpv, MIME defaults |
| `09-development-tools.sh` | Neovim, git, lazygit, mise, podman, Claude Code |
| `10-theme.sh` | GTK/Qt theme, Papirus icons, cursors, fontconfig |
| `11-login-manager.sh` | SDDM or TTY autologin |
| `12-browser.sh` | Zen Browser (default) + Brave |
| `13-system-services.sh` | Sudo, sysctl, TRIM, timezone, locale, keyring, XDG dirs, env vars |

## Keybindings

All keybindings use `Mod` (Super/Windows key).

| Key | Action |
|-----|--------|
| `Mod+Return` | Open terminal (Ghostty) |
| `Mod+D` | Open app launcher (Walker) |
| `Mod+E` | Open file manager (Nautilus) |
| `Mod+V` | Clipboard history |
| `Mod+Q` | Close window |
| `Mod+F` | Maximize column |
| `Mod+Shift+F` | Fullscreen window |
| `Mod+Shift+Space` | Toggle floating |
| `Mod+C` | Center column |
| `Mod+H/L` | Focus left/right column |
| `Mod+J/K` | Focus down/up window |
| `Mod+Shift+H/L` | Move column left/right |
| `Mod+Shift+J/K` | Move window down/up |
| `Mod+Minus/Equal` | Shrink/grow column width |
| `Mod+R` | Cycle preset widths (1/3, 1/2, 2/3) |
| `Mod+1-9` | Switch to workspace |
| `Mod+Shift+1-9` | Move column to workspace |
| `Print` | Screenshot (region) |
| `Mod+Print` | Screenshot (screen) |
| `Mod+Shift+Print` | Screenshot (window) |
| `Mod+N` | Dismiss notifications |
| `Mod+Escape` | Lock screen |
| `Mod+Shift+N` | Toggle night light |
| `Mod+Shift+E` | Quit Niri |
| Media keys | Volume, brightness, playback |

## Config locations

All configs are stored in `~/.config/`:

```
~/.config/
├── niri/config.kdl          # Compositor
├── ghostty/config            # Terminal
├── waybar/{config.jsonc,style.css}  # Status bar
├── walker/                   # App launcher
├── mako/config               # Notifications
├── nushell/                  # Nushell shell
├── starship.toml             # Prompt
├── zellij/                   # Multiplexer
├── fastfetch/                # System info
├── gtk-3.0/settings.ini      # GTK3 theme
├── gtk-4.0/settings.ini      # GTK4 theme
├── fontconfig/fonts.conf      # Font fallbacks
├── git/config                # Git defaults
├── mise/config.toml          # Tool versions
├── environment.d/smrtr.conf  # Environment variables
└── smrtr/                    # Bash aliases, wallpapers
```

## Customization

- **Wallpaper:** Replace `~/.config/smrtr/wallpapers/default.jpg`
- **Night light coordinates:** Edit `wlsunset` latitude/longitude in `~/.config/niri/config.kdl`
- **Keybindings:** Edit `~/.config/niri/config.kdl` binds block
- **Theme colors:** All configs use catppuccin mocha — search for hex codes to swap
- **Shell:** Switch default with `chsh -s /usr/bin/bash` or `chsh -s /usr/bin/nu`
- **Tool versions:** Edit `~/.config/mise/config.toml`

## Structure

```
smrtr-os/
├── install.sh         # Main entry point
├── lib/helpers.sh     # Shared functions
├── features/          # Numbered feature scripts
├── config/            # Dotfiles and configs
└── .specs/            # Feature specifications
```

Each feature script is standalone — you can re-run any individual script:

```bash
./features/03-niri.sh
```

Existing configs are backed up to `~/.config/smrtr-backup/<timestamp>/` before being overwritten.
