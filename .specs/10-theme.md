# Feature: Theme & Appearance

## Summary

Apply a consistent dark theme across all desktop components: GTK apps, Qt apps, cursors, icons, and terminal colors.

## Requirements

### Approach
Unlike omarchy's full template-based theme engine, smrtr-os ships with **one default theme** (dark, catppuccin-mocha inspired) applied statically. Switching themes means editing config files — no runtime theme switcher.

### GTK Theme
- `catppuccin-gtk-theme-mocha` (AUR) or manually set colors via `~/.config/gtk-3.0/settings.ini` and `gtk-4.0`
- Dark mode: `gtk-application-prefer-dark-theme=1`

### Qt Theme
- `qt6ct`, `qt5ct` — Qt theme configuration tools
- Set environment variables:
  - `QT_QPA_PLATFORMTHEME=qt6ct`
- Configure qt6ct to use a dark color scheme matching the GTK theme

### Icons
- `papirus-icon-theme` — Clean, modern icon theme
- Set in GTK settings and qt6ct

### Cursor
- `catppuccin-cursors-mocha` (AUR) or `bibata-cursor-theme`
- Set cursor theme in:
  - Niri config: `cursor { theme "<name>"; size 24; }` in config.kdl
  - GTK settings
  - `/usr/share/icons/default/index.theme` (for display managers)

### Fonts
- System font: `noto-fonts` (Noto Sans)
- Monospace: `ttf-jetbrains-mono-nerd`
- Emoji: `noto-fonts-emoji`
- CJK (optional): `noto-fonts-cjk`
- Configure fontconfig for proper fallback order via `~/.config/fontconfig/fonts.conf`

### Color Palette (applied across configs)
Use catppuccin mocha as the base palette:
- Background: `#1e1e2e`
- Foreground: `#cdd6f4`
- Surface: `#313244`
- Accent/Blue: `#89b4fa`
- Green: `#a6e3a1`
- Red: `#f38ba8`
- Yellow: `#f9e2af`
- Pink: `#f5c2e7`

These colors are referenced in:
- Ghostty config (feature 04)
- Waybar style (feature 05)
- Mako config (feature 07)
- Walker config (feature 06)
- Niri focus ring (feature 03)

### Wallpaper
- Include a default dark wallpaper in `config/wallpapers/default.jpg`
- Set via swaybg in Niri autostart

## Acceptance Criteria

- All GTK apps (Nautilus, Zen Browser) use dark theme.
- Qt apps follow the dark theme.
- Icons are Papirus everywhere.
- Cursor theme is consistent across all apps (XWayland and Wayland).
- All terminal/waybar/notification colors match the palette.
- Fonts render cleanly with proper emoji and icon support.

## Dependencies

- `01-base-packages` (paru for AUR packages)
- `03-niri` (cursor block, wallpaper)
- `04-terminal` (font config)
- `05-waybar` (style.css uses colors)
- `07-notifications` (mako uses colors)
