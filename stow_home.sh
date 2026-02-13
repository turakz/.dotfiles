#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./_utils.sh
source "${SCRIPT_DIR}/_utils.sh"

log_info "farming symlinks with stow..."
if stow home --no-folding; then
  # shellcheck disable=SC2088 # literal '~' is intentional in the display message
  log_info '~/.config symlinks farmed!'
else
  log_warn "farming symlinks failed — check for existing files at target paths that would collide"
  exit 1
fi
