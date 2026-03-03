# Feature: Shared Helper Library (lib/helpers.sh)

## Summary

Define the shared bash functions used by all feature scripts. This is not a feature that runs independently — it is sourced by `install.sh` and by each feature script.

## Requirements

### File Location
- `lib/helpers.sh` — sourced at the top of every feature script:
  ```bash
  #!/usr/bin/env bash
  set -euo pipefail
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  source "$SCRIPT_DIR/../lib/helpers.sh"
  ```

### Logging Functions

```bash
log_info "message"     # Blue prefix [INFO], printed to stdout
log_warn "message"     # Yellow prefix [WARN], printed to stderr
log_error "message"    # Red prefix [ERROR], printed to stderr
log_step "message"     # Bold prefix [=>], used for major steps within a feature
```

### Package Installation

```bash
pkg_install <package1> <package2> ...
```
- Wraps `sudo pacman -S --needed --noconfirm`
- Skips packages already installed

```bash
aur_install <package1> <package2> ...
```
- Wraps `paru -S --needed --noconfirm`
- Used for AUR packages
- Fails with clear error if `paru` is not available

```bash
pkg_installed <package>
```
- Returns 0 if the package is installed, 1 otherwise
- Uses `pacman -Qi` to check

### Config Management

```bash
backup_config <target_path>
```
- If `<target_path>` exists, copies it to `~/.config/smrtr-backup/<timestamp>/<relative_path>`
- Only creates backup if the file exists and differs from the source
- Logs what was backed up

```bash
install_config <source_relative> <target_path>
```
- Copies `$REPO_DIR/config/<source_relative>` to `<target_path>`
- Calls `backup_config` first if target exists
- Creates parent directories as needed
- Sets appropriate permissions (644 for files, 755 for dirs)

```bash
ensure_dir <path>
```
- Creates directory and all parents if they don't exist
- No-op if already exists

### User Prompts

```bash
ask_yes_no "question" [default]
```
- Prompts user with y/n question
- Returns 0 for yes, 1 for no
- Default is "y" if not specified

```bash
ask_choice "question" "option1" "option2" ...
```
- Presents numbered options
- Returns the selected option string

### Service Management

```bash
enable_service <service_name>
```
- Wraps `sudo systemctl enable --now <service_name>`
- Logs the action
- Idempotent (safe to call if already enabled)

```bash
enable_user_service <service_name>
```
- Wraps `systemctl --user enable --now <service_name>`
- For user-level services (e.g., PipeWire)

### Constants

```bash
REPO_DIR        # Absolute path to the smrtr-os repo root
CONFIG_DIR      # $REPO_DIR/config
BACKUP_DIR      # ~/.config/smrtr-backup/$(date +%Y%m%d_%H%M%S)
USER_CONFIG     # ~/.config
```

`BACKUP_DIR` timestamp is set once when `helpers.sh` is sourced, so all backups within a single install run go to the same directory.

## Acceptance Criteria

- Every feature script can source `helpers.sh` and use all functions.
- `pkg_install` and `aur_install` are idempotent.
- Config backups are created before overwriting existing files.
- Logging output is colored and clearly distinguishes info/warn/error.
- Running a feature script standalone works (helpers.sh resolves paths correctly).

## Dependencies

- None (this is sourced by all other features).
