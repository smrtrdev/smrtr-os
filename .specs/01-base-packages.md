# Feature: Base Packages & AUR Helper

## Summary

Install essential system packages and set up the AUR helper (paru). This is the foundation that all other features depend on.

## Requirements

### AUR Helper
- Install `paru` if not already present (clone from AUR and `makepkg -si`).
- Ensure `base-devel` is installed first (required for building AUR packages).

### Core System Packages

Install the following package groups:

**Build tools & basics:**
- `base-devel`, `git`, `wget`, `curl`, `jq`, `unzip`, `zip`, `man-db`

**Filesystem & hardware:**
- `ntfs-3g`, `exfatprogs`, `udisks2`

**Audio (PipeWire stack):**
- `pipewire`, `pipewire-alsa`, `pipewire-pulse`, `pipewire-jack`, `wireplumber`
- Enable user services: `systemctl --user enable --now pipewire.service pipewire-pulse.service wireplumber.service`
- Note: on modern Arch these are socket-activated, but enabling explicitly ensures they start reliably

**Networking:**
- `networkmanager`, `iwd` (as backend for NetworkManager)
- Enable `NetworkManager.service` and `iwd.service`

**Bluetooth:**
- `bluez`, `bluez-utils`
- Enable `bluetooth.service`

**Printing (optional, gated by prompt):**
- `cups`, `cups-pdf`
- Enable `cups.service`

**Firewall:**
- `ufw`
- Enable `ufw.service`, set default deny incoming / allow outgoing

**GPU drivers:**
- Auto-detect GPU vendor (intel/amd/nvidia) from `lspci`
- Install appropriate mesa/vulkan packages
- For NVIDIA: `nvidia`, `nvidia-utils`, `nvidia-settings`

### Pacman Configuration
- Enable `Color`, `ParallelDownloads = 5`, and `ILoveCandy` in `/etc/pacman.conf`.
- Enable `multilib` repository.

## Acceptance Criteria

- Running the script on a fresh Arch install with only `base` and `linux` results in a working system with audio, networking, bluetooth, and firewall.
- `paru` is available for subsequent feature scripts.
- Script is idempotent — safe to run multiple times.

## Dependencies

- None (this is the first feature to run).
