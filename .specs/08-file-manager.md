# Feature: File Manager, Media Viewers & MIME Types

## Summary

Install a graphical file manager, media viewers, and configure all file associations in a single canonical `mimeapps.list`.

## Requirements

### Packages

**File manager:**
- `nautilus` — GNOME Files (GTK, Wayland-native, simple)
- `file-roller` — Archive manager integration
- `gvfs` — Virtual filesystem (trash, MTP devices, SMB shares)
- `gvfs-mtp` — Android phone file access

**Image viewer:**
- `imv` — Lightweight Wayland-native image viewer

**PDF viewer:**
- `zathura` — Minimal, keyboard-driven document viewer
- `zathura-pdf-mupdf` — PDF backend for zathura

**Media player:**
- `mpv` — Lightweight video and audio player

### MIME Type Defaults

This spec owns the canonical `~/.config/mimeapps.list`. All MIME associations from all features are consolidated here:

```ini
[Default Applications]
# Directories
inode/directory=org.gnome.Nautilus.desktop

# Text
text/plain=nvim.desktop

# Images
image/png=imv-dir.desktop
image/jpeg=imv-dir.desktop
image/gif=imv-dir.desktop
image/webp=imv-dir.desktop
image/svg+xml=imv-dir.desktop
image/bmp=imv-dir.desktop

# PDF
application/pdf=org.pwmt.zathura.desktop

# Video
video/mp4=mpv.desktop
video/x-matroska=mpv.desktop
video/webm=mpv.desktop
video/x-msvideo=mpv.desktop

# Audio
audio/mpeg=mpv.desktop
audio/flac=mpv.desktop
audio/ogg=mpv.desktop
audio/wav=mpv.desktop

# Web (set by spec 12 - browser)
text/html=zen-browser.desktop
x-scheme-handler/http=zen-browser.desktop
x-scheme-handler/https=zen-browser.desktop
x-scheme-handler/about=zen-browser.desktop

# Archives
application/zip=org.gnome.FileRoller.desktop
application/x-tar=org.gnome.FileRoller.desktop
application/gzip=org.gnome.FileRoller.desktop
application/x-7z-compressed=org.gnome.FileRoller.desktop
```

Note: `nvim.desktop` must be created or an existing one used that wraps `ghostty -e nvim %F` so text files open nvim inside a terminal window.

### Integration
- `Mod+E` keybinding in Niri opens Nautilus (defined in spec 03)
- Nautilus window rules in Niri set default column width (defined in spec 03)

## Acceptance Criteria

- `Mod+E` opens the file manager.
- USB drives and Android phones mount and appear.
- Archive files can be opened.
- Double-clicking an image opens imv.
- Double-clicking a PDF opens zathura.
- Double-clicking a video/audio file opens mpv.
- Double-clicking a text file opens nvim in a terminal.
- Links from any app open in Zen Browser.

## Dependencies

- `01-base-packages` (udisks2)
- `03-niri` (keybinding, window rules)
- `04-terminal` (ghostty needed for nvim.desktop wrapper)
