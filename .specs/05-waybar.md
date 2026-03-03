# Feature: Status Bar (Waybar)

## Summary

Install and configure Waybar as the status bar with essential system info modules.

## Requirements

### Packages
- `waybar`
- `otf-font-awesome` — Icons used in waybar modules

### Configuration

**~/.config/waybar/config.jsonc:**

```jsonc
{
  "layer": "top",
  "position": "top",
  "height": 32,
  "modules-left": ["niri/workspaces"],
  "modules-center": ["clock"],
  "modules-right": [
    "tray",
    "network",
    "bluetooth",
    "pulseaudio",
    "battery",
    "custom/power"
  ],

  "niri/workspaces": {
    "format": "{id}",
    "on-click": "activate"
  },

  "clock": {
    "format": "{:%a %d %b  %H:%M}",
    "tooltip-format": "{:%Y-%m-%d %A}"
  },

  "network": {
    "format-wifi": " {essid}",
    "format-ethernet": " {ifname}",
    "format-disconnected": "󰤭 ",
    "tooltip-format": "{ipaddr}",
    "on-click": "ghostty -e nmtui"
  },

  "bluetooth": {
    "format": "",
    "format-connected": " {device_alias}",
    "format-disabled": "",
    "on-click": "ghostty -e bluetuith"
  },

  "pulseaudio": {
    "format": "{icon} {volume}%",
    "format-muted": "󰖁 ",
    "format-icons": {
      "default": ["", "", ""]
    },
    "on-click": "ghostty -e pulsemixer"
  },

  "battery": {
    "format": "{icon} {capacity}%",
    "format-charging": "󰂄 {capacity}%",
    "format-icons": ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"],
    "states": {
      "warning": 20,
      "critical": 10
    }
  },

  "tray": {
    "spacing": 8
  },

  "custom/power": {
    "format": "⏻",
    "on-click": "systemctl poweroff",
    "on-click-right": "systemctl reboot",
    "tooltip": "Left: shutdown, Right: reboot"
  }
}
```

**~/.config/waybar/style.css:**
- Dark background with slight transparency
- Clean sans-serif font (system default or Noto Sans)
- Subtle module separators
- Highlight for active workspace
- Warning/critical colors for low battery
- Consistent padding and spacing
- Minimal, flat aesthetic — no gradients or shadows

### Conditional Modules
- `battery` module should only appear on laptops (detect via `/sys/class/power_supply/BAT*`)
- The install script should generate the config with or without battery based on detection

## Acceptance Criteria

- Waybar appears at the top of the screen when Niri starts.
- All modules display correct data (time, network, volume, workspaces).
- Clicking workspaces in waybar switches to that workspace.
- Clicking network module opens nmtui in a terminal.
- Clicking bluetooth module opens bluetuith in a terminal.
- Clicking audio module opens pulsemixer in a terminal.
- Battery module only shows on laptops.
- Visual style is clean and consistent.

## Dependencies

- `01-base-packages` (audio, bluetooth, network)
- `03-niri` (waybar is autostarted by Niri)
