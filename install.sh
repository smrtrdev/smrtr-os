#!/usr/bin/env bash
set -euo pipefail

export SMRTR_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SMRTR_INSTALL="$SMRTR_PATH/install"

source "$SMRTR_INSTALL/helpers/all.sh"
source "$SMRTR_INSTALL/preflight/all.sh"
source "$SMRTR_INSTALL/packaging/all.sh"
source "$SMRTR_INSTALL/config/all.sh"
source "$SMRTR_INSTALL/login/all.sh"
source "$SMRTR_INSTALL/post-install/all.sh"
