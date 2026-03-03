#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/helpers.sh"

log_step "Installing file manager and media viewers..."
pkg_install nautilus file-roller gvfs gvfs-mtp imv zathura zathura-pdf-mupdf mpv

# --- Create nvim.desktop wrapper ---

log_step "Creating nvim.desktop wrapper..."
DESKTOP_FILE="$HOME/.local/share/applications/nvim.desktop"
ensure_dir "$(dirname "$DESKTOP_FILE")"
cat > "$DESKTOP_FILE" <<'EOF'
[Desktop Entry]
Name=Neovim
Comment=Edit text files in Neovim
Exec=ghostty -e nvim %F
Terminal=false
Type=Application
Icon=nvim
MimeType=text/plain;
Categories=Utility;TextEditor;
EOF
log_info "Created nvim.desktop wrapper."

# --- Install mimeapps.list ---

log_step "Installing MIME type defaults..."
install_config "mimeapps.list" "$USER_CONFIG/mimeapps.list"

# Update desktop database
if command -v update-desktop-database &>/dev/null; then
    update-desktop-database "$HOME/.local/share/applications"
fi

log_info "File manager setup complete."
