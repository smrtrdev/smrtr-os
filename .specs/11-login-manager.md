# Feature: Login Manager

## Summary

Configure a display manager (login screen) so the user boots directly into a graphical login prompt that starts Niri.

## Requirements

### Option A: SDDM (recommended)
- `sddm` — Modern display manager with Wayland support
- `sddm-catppuccin-theme` (AUR) or a simple dark theme
- Enable `sddm.service`

### Option B: No display manager (minimal)
- Auto-login via `getty` autologin on TTY1
- Enable `getty@tty1.service` with autologin
- Auto-start Niri based on which shell is the user's default:
  - **If bash:** Add to `~/.bash_profile`:
    ```bash
    if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
      exec niri-session
    fi
    ```
  - **If nushell:** Add to `~/.config/nushell/login.nu`:
    ```nu
    if ($env | get -i WAYLAND_DISPLAY | is-empty) and ($env.XDG_VTNR? == "1") {
      exec niri-session
    }
    ```
  - Note: regardless of default shell, both files should be configured so the user can switch shells without breaking auto-login

### SDDM Configuration (if Option A)

**`/etc/sddm.conf.d/smrtr.conf`:**
```ini
[General]
DisplayServer=wayland

[Theme]
Current=catppuccin-mocha
```

### PAM Integration
- Whichever login method is chosen, the PAM config for that path must include `pam_gnome_keyring.so` so the keyring auto-unlocks on login.
  - SDDM: `/etc/pam.d/sddm` (usually handled automatically by the `gnome-keyring` package)
  - Getty autologin: `/etc/pam.d/login`
- See `13-system-services` for full keyring setup details.

### Session File
- Ensure `/usr/share/wayland-sessions/niri.desktop` exists (installed with niri package)
- If missing, create it:
  ```ini
  [Desktop Entry]
  Name=Niri
  Comment=A scrollable-tiling Wayland compositor
  Exec=niri-session
  Type=Application
  ```

## Acceptance Criteria

- After boot, user sees a login screen (or auto-starts Niri if no DM).
- After login, Niri starts correctly with all autostart apps.
- Logout returns to the login screen.

## Dependencies

- `03-niri` (must be installed for the session to work)
- `10-theme` (login screen uses theme)
