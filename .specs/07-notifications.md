# Feature: Notification Daemon

## Summary

Install and configure mako as the notification daemon for system and application notifications.

## Requirements

### Packages
- `mako` — Lightweight Wayland notification daemon

### Configuration

**~/.config/mako/config:**
```ini
max-visible=3
default-timeout=5000
layer=overlay
anchor=top-right

font=JetBrainsMono Nerd Font 11
background-color=#1e1e2e
text-color=#cdd6f4
border-color=#89b4fa
border-size=2
border-radius=8
padding=12
margin=8
width=350

[urgency=critical]
default-timeout=0
border-color=#f38ba8
```

### Integration
- Started in Niri autostart: `spawn-at-startup "mako"`
- Notification actions (e.g., dismiss) work with keybindings:
  - `SUPER + N` — Dismiss all notifications (`makoctl dismiss --all`)

## Acceptance Criteria

- Notifications appear in top-right corner with styled appearance.
- Notifications auto-dismiss after 5 seconds (except critical).
- `SUPER + N` dismisses all visible notifications.

## Dependencies

- `03-niri` (autostart and keybinding)
- `04-terminal` (fonts)
