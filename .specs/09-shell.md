# Feature: Shell Configuration

## Summary

Configure both **bash** and **nushell** with a modern prompt (starship), useful aliases/custom commands, and essential CLI tools. During installation, the user chooses which shell to set as their default login shell.

## Requirements

### Packages
- `nushell` — Modern structured-data shell
- `starship` — Cross-shell prompt (works with both bash and nushell)
- `fzf` — Fuzzy finder
- `fd` — Fast file finder (used by fzf)
- `ripgrep` — Fast grep alternative
- `eza` — Modern `ls` replacement
- `bat` — `cat` with syntax highlighting
- `zoxide` — Smart `cd` replacement
- `tldr` — Simplified man pages
- `fastfetch` — System info display
- `zellij` — Terminal multiplexer (Rust-based, modern)
- `htop`, `btop` — System monitors
- `tree` — Directory tree viewer
- `carapace-bin` (AUR) — Multi-shell completion engine (works with nushell)

### Shell Selection

During install, prompt the user:
```
Select default shell:
  1) bash
  2) nushell
```

Set the chosen shell with `chsh -s /usr/bin/bash` or `chsh -s /usr/bin/nu`. Both shells are configured regardless of which is the default — the user can always switch.

---

### Bash Configuration

**~/.bashrc additions:**
- Source `~/.config/smrtr/bash/aliases.sh`
- Source `~/.config/smrtr/bash/functions.sh`
- Initialize starship: `eval "$(starship init bash)"`
- Initialize zoxide: `eval "$(zoxide init bash)"`
- Set up fzf keybindings and completion
- Initialize mise: `eval "$(mise activate bash)"`
- Set `EDITOR=nvim`, `VISUAL=nvim`
- Set `HISTSIZE=10000`, `HISTFILESIZE=20000`, `HISTCONTROL=ignoreboth:erasedups`
- Run `fastfetch` on interactive login

**Aliases (aliases.sh):**
- `ls` → `eza --icons`
- `ll` → `eza -la --icons`
- `lt` → `eza --tree --icons`
- `cat` → `bat --paging=never`
- `grep` → `rg`
- `cd` → `z` (zoxide)
- `..` → `cd ..`
- `...` → `cd ../..`
- `gs` → `git status`
- `gl` → `git log --oneline --graph`
- `gd` → `git diff`
- `gc` → `git commit`
- `gp` → `git push`

---

### Nushell Configuration

**~/.config/nushell/config.nu:**
- Set `$env.config.show_banner` to `false`
- Set `$env.config.edit_mode` to `"vi"` or `"emacs"` (user preference, default emacs)
- Set `$env.config.cursor_shape` for insert/normal modes
- Configure keybindings for fzf-like behavior (Ctrl+R history, Ctrl+T file picker)
- Run `fastfetch` on startup (in login config)

**~/.config/nushell/env.nu:**
- Initialize starship: `mkdir ~/.cache/starship; starship init nu | save -f ~/.cache/starship/init.nu`
- Initialize zoxide: `zoxide init nushell | save -f ~/.cache/zoxide/init.nu`
- Source them in config.nu:
  ```nu
  use ~/.cache/starship/init.nu
  source ~/.cache/zoxide/init.nu
  ```
- Initialize mise: `mise activate nu | save -f ~/.cache/mise/init.nu`, source in config.nu
- Set environment variables:
  ```nu
  $env.EDITOR = "nvim"
  $env.VISUAL = "nvim"
  ```

**Custom commands / aliases (~/.config/nushell/aliases.nu, sourced from config.nu):**
- `alias ls = eza --icons`
- `alias ll = eza -la --icons`
- `alias lt = eza --tree --icons`
- `alias cat = bat --paging=never`
- `alias grep = rg`
- `alias gs = git status`
- `alias gl = git log --oneline --graph`
- `alias gd = git diff`
- `alias gc = git commit`
- `alias gp = git push`

**Completions:**
- Set up carapace for external command completions:
  ```nu
  $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
  carapace _carapace nushell | save -f ~/.cache/carapace/init.nu
  source ~/.cache/carapace/init.nu
  ```

---

### Environment Variable Strategy

Environment variables are set in **two canonical locations** to cover all contexts:

1. **`~/.config/environment.d/smrtr.conf`** — picked up by systemd user session and display managers. This is the primary source for `EDITOR`, `VISUAL`, `TERMINAL`, `BROWSER`, `XDG_CURRENT_DESKTOP`, `XDG_SESSION_TYPE`, `QT_QPA_PLATFORMTHEME`, `SSH_AUTH_SOCK`, `MOZ_ENABLE_WAYLAND`.
2. **Shell rc files** (`.bashrc` / `env.nu`) — only set `EDITOR` and `VISUAL` as fallbacks for TTY-only sessions where systemd user session isn't active. Do NOT duplicate all vars here.

Niri's `environment {}` block should only set compositor-specific overrides (e.g., `DISPLAY ":0"` for xwayland-satellite), not general user env vars.

---

### Starship Config

**~/.config/starship.toml** (shared by both shells):
- Minimal prompt: directory, git branch, git status, command duration, newline, character
- No unnecessary modules (no cloud, no language version clutter)

---

### Zellij Config

**~/.config/zellij/config.kdl:**
- Default mode: normal
- Theme: match catppuccin mocha palette
- Simplified status bar (compact mode)
- Keybindings:
  - Keep defaults (Ctrl+t for tab, Ctrl+p for pane, etc.)
  - Or set `default_mode "locked"` with unlock key to avoid keybinding conflicts with other tools
- Copy command: `copy_command "wl-copy"` (Wayland clipboard integration)
- Scrollback: `scrollback_lines 10000`

**~/.config/zellij/layouts/default.kdl:**
- Simple layout: single pane with compact status bar at bottom

---

### Fastfetch

- Provide `~/.config/fastfetch/config.jsonc` showing: OS, kernel, uptime, packages, shell, WM, terminal, CPU, GPU, memory
- Triggered on new interactive login sessions in both bash (.bashrc) and nushell (config.nu)

## Acceptance Criteria

- Opening a terminal shows fastfetch output and a starship prompt (in whichever shell is default).
- Both `bash` and `nu` are available and configured — user can switch at any time.
- All aliases/custom commands work in both shells.
- fzf-like `Ctrl+R` (history) and `Ctrl+T` (file) keybindings work in both shells.
- `zellij` launches with custom config and correct theme.
- Zoxide `z` command works in both shells.
- Nushell completions work via carapace.

## Dependencies

- `01-base-packages` (needs paru, git)
- `02-development-tools` (mise must be installed before shell activation is configured)
