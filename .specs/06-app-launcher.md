# Feature: Application Launcher (Walker)

## Summary

Install and configure Walker as the application launcher for quick app launching, search, and dmenu-style clipboard history.

## Requirements

### Packages
- `walker` (AUR) — Wayland-native, themeable, fast application launcher
- Supports dmenu mode (used for clipboard history via `Mod+V` in Niri)

### Configuration

**~/.config/walker/config.toml:**
- Enable modules: applications, commands, files
- Appearance: centered, dark theme (catppuccin mocha colors), rounded corners
- Terminal: `ghostty` (for commands that need a terminal)
- Dmenu mode: enabled (used by clipboard history keybinding)

**~/.config/walker/themes/catppuccin.css** (or inline in config):
- Background: `#1e1e2e`
- Foreground: `#cdd6f4`
- Selection: `#45475a`
- Accent/border: `#89b4fa`
- Font: JetBrainsMono Nerd Font

### Integration
- `Mod+D` in Niri keybindings launches Walker (defined in spec 03)
- `Mod+V` in Niri launches clipboard history via Walker dmenu mode (defined in spec 03):
  `cliphist list | walker --dmenu | cliphist decode | wl-copy`

## Acceptance Criteria

- `Mod+D` opens the Walker overlay.
- Typing filters installed applications.
- Selecting an app launches it.
- Walker is visually consistent with catppuccin mocha theme.
- `Mod+V` opens clipboard history in Walker dmenu mode.

## Dependencies

- `03-niri` (keybinding integration)
- `04-terminal` (fonts)
