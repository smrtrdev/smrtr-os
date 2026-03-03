# Feature: Login Manager

## Summary

Configure a login manager so the user boots into a password-based graphical login with `greetd` + `tuigreet`, then starts Niri.

## Requirements

### Option A: greetd + tuigreet (recommended)
- `greetd` — lightweight login manager for TTY/Wayland
- `tuigreet` — TUI greeter used as `default_session`
- Enable `greetd.service`
- Configure `/etc/greetd/config.toml` with:
  - `default_session` running tuigreet with remember/time/power actions
  - password-based login prompt (no `initial_session` autologin)
  - session command launching Niri via UWSM (`uwsm start -- niri-session`)

### Option B: No display manager (minimal)
- Auto-login via `getty` autologin on TTY1 (optional — requires explicit confirmation)
- **Security note:** Enabling autologin disables password-based authentication for local console access. Anyone with physical or console access will obtain a full shell as the user without a password. The script warns the user and prompts for explicit confirmation (default: no) before enabling autologin.
- Enable `getty@tty1.service` with autologin only if confirmed
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

### greetd Configuration (if Option A)

**`/etc/greetd/config.toml`:**
```toml
[terminal]
vt = 1

[default_session]
command = "tuigreet --theme 'time=yellow' --time --remember --remember-session --power-shutdown '/usr/bin/systemctl poweroff' --power-reboot '/usr/bin/systemctl reboot' --cmd 'uwsm start -- niri-session'"
user = "greeter"
```

### PAM Integration
- Whichever login method is chosen, the PAM config for that path must include `pam_gnome_keyring.so` so the keyring auto-unlocks on login.
  - greetd: `/etc/pam.d/greetd` (usually handled automatically by the `gnome-keyring` package, but verify)
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

- After boot, user sees a tuigreet password prompt (or auto-starts Niri from TTY if no DM).
- After login, Niri starts correctly with all autostart apps.
- Logout returns to `tuigreet` login screen.

## Dependencies

- `03-niri` (must be installed for the session to work)
