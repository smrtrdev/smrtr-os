# Feature: System Services & Tweaks

## Summary

Apply system-level tweaks, enable services, configure environment variables, and set up the keyring for a smooth desktop experience.

## Requirements

### Sudo
- Increase sudo timeout: add `Defaults timestamp_timeout=30` to `/etc/sudoers.d/smrtr`

### File Watcher Limits
- Increase inotify watches for IDEs/file watchers:
  ```
  # /etc/sysctl.d/90-smrtr.conf
  fs.inotify.max_user_watches = 524288
  fs.inotify.max_user_instances = 1024
  ```

### SSD TRIM
- Enable `fstrim.timer` for SSD maintenance

### Time Sync
- Enable `systemd-timesyncd.service`
- Set timezone based on auto-detection (`timedatectl set-timezone` using IP geolocation or prompt user)

### Locale
- Ensure `en_US.UTF-8` is generated and set as default
- User can customize via prompt during install

### Power Management (laptops)
- `power-profiles-daemon` or `tlp` — Battery optimization
- Enable the chosen service

### Swappiness
- Set `vm.swappiness=10` in `/etc/sysctl.d/90-smrtr.conf` (better for systems with enough RAM)

### Keyring
- `gnome-keyring` — Stores passwords, SSH keys, and secrets
- `libsecret` — Library for accessing the keyring (used by git, gh, browsers, etc.)
- Enable PAM auto-unlock (configure for the chosen login method — see spec 11):
  - Add `auth optional pam_gnome_keyring.so` at end of auth section
  - Add `session optional pam_gnome_keyring.so auto_start` at end of session section
  - For SDDM: `/etc/pam.d/sddm` (usually handled automatically by gnome-keyring package, but verify)
  - For TTY autologin: `/etc/pam.d/login`
- Keyring daemon autostart is defined in spec 03 (Niri): `spawn-at-startup "gnome-keyring-daemon" "--start" "--components=secrets,ssh"`

### XDG User Directories
- `xdg-user-dirs` — Create standard directories (Documents, Downloads, Pictures, etc.)
- Run `xdg-user-dirs-update` during install
- Ensure `~/Pictures/Screenshots/` exists (used by niri screenshot-path)

### Config Backup
- Before overwriting any existing config file, back it up to `~/.config/smrtr-backup/<timestamp>/`
- The backup is done by `lib/helpers.sh` (see spec 14) — each feature script calls `backup_config <path>` before writing
- Only back up on first run (skip if backup dir already exists for the same path)

### Environment Variables (canonical location)

This is the **single canonical source** for all general environment variables. Shell rc files (bash/nushell) only set `EDITOR`/`VISUAL` as fallbacks for TTY-only sessions. Niri's `environment {}` block only sets compositor-specific vars like `DISPLAY`.

**~/.config/environment.d/smrtr.conf:**
```ini
EDITOR=nvim
VISUAL=nvim
TERMINAL=ghostty
BROWSER=zen-browser
XDG_CURRENT_DESKTOP=niri
XDG_SESSION_TYPE=wayland
QT_QPA_PLATFORMTHEME=qt6ct
MOZ_ENABLE_WAYLAND=1
SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/keyring/ssh
XCURSOR_THEME=catppuccin-mocha-dark-cursors
XCURSOR_SIZE=24
```

Note: `environment.d` files are read by `systemd --user` and by display managers that support them (including SDDM). For TTY autologin (Option B in spec 11), the install script should also source these in the shell profile as a fallback.

## Acceptance Criteria

- System clock is correct and synced.
- SSD TRIM runs weekly.
- Sudo doesn't prompt for password within 30 minutes.
- Standard user directories exist (including ~/Pictures/Screenshots/).
- IDE file watchers don't hit limits.
- Keyring auto-unlocks on login — browsers and git credential helpers store secrets without extra prompts.
- `ssh-add` works without a separate ssh-agent (gnome-keyring provides it).
- All environment variables are accessible from Niri-launched applications.
- Existing configs are backed up before being overwritten.

## Dependencies

- `01-base-packages`
- `11-login-manager` (PAM config depends on login method)
