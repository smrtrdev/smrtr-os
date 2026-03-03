# Feature: Web Browsers

## Summary

Install Zen Browser (default) and Brave as web browsers with Wayland-native configuration.

## Requirements

### Packages
- `zen-browser-bin` (AUR) — Firefox-based, privacy-focused, modern UI (default browser)
- `brave-bin` (AUR) — Chromium-based, privacy-focused

### Wayland Flags

**Zen Browser (Firefox-based):**
- `MOZ_ENABLE_WAYLAND=1` is set in `~/.config/environment.d/smrtr.conf` (spec 13)

**Brave (Chromium-based) — `~/.config/brave-flags.conf`:**
```
--enable-features=UseOzonePlatform
--ozone-platform=wayland
--enable-wayland-ime
```

### Integration
- Set Zen Browser as the default: `xdg-settings set default-web-browser zen-browser.desktop`
- MIME types are set in spec 08 (canonical `mimeapps.list`): `text/html`, `x-scheme-handler/http`, `x-scheme-handler/https` → `zen-browser.desktop`
- `BROWSER=zen-browser` is set in `~/.config/environment.d/smrtr.conf` (spec 13)

## Acceptance Criteria

- Both browsers launch in native Wayland mode (no XWayland).
- Zen Browser is the system default browser.
- Links from other apps open in Zen Browser.
- Brave is available as a secondary browser.

## Dependencies

- `01-base-packages` (paru for AUR)
- `08-file-manager` (mimeapps.list)
