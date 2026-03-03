# Feature: Terminal Emulator

## Summary

Install and configure Ghostty as the primary terminal emulator with a clean, modern appearance.

## Requirements

### Packages
- `ghostty` (available in official Arch repos)

### Configuration

**~/.config/ghostty/config:**

```
font-family = JetBrainsMono Nerd Font
font-size = 13
theme = catppuccin-mocha
window-padding-x = 8
window-padding-y = 8
window-decoration = false
cursor-style = bar
cursor-style-blink = true
copy-on-select = clipboard
confirm-close-surface = false
gtk-titlebar = false
```

### Fonts
- Install `ttf-jetbrains-mono-nerd` (Nerd Font variant for icons/glyphs)
- Install `noto-fonts`, `noto-fonts-emoji` for broad Unicode coverage

### Integration
- Niri keybinding `SUPER + Return` should launch `ghostty`
- Set `ghostty` as the default terminal in environment variables: `TERMINAL=ghostty`

## Acceptance Criteria

- Ghostty launches with the configured font and appearance.
- Nerd Font glyphs render correctly (for starship prompt, eza icons, etc.).
- Emoji render correctly.
- No title bar shown (Wayland native, no decorations).

## Dependencies

- `01-base-packages` (paru for AUR)
- `02-shell` (bash config is loaded inside the terminal)
