#!/usr/bin/env bash
# Shared helpers for dotfiles setup scripts.
# Source from other scripts: `source "$(dirname "${BASH_SOURCE[0]}")/_lib.sh"`

# --- color palette (honors NO_COLOR and non-tty stderr) ---
if [[ -t 2 ]] && [[ -z ${NO_COLOR-} ]] && [[ ${TERM-} != "dumb" ]]; then
  NOFMT='\033[0m'
  RED='\033[0;31m'
  ORANGE='\033[0;33m'
  YELLOW='\033[1;33m'
  GREEN='\033[0;32m'
  BLUE='\033[0;34m'
  PURPLE='\033[0;35m'
  CYAN='\033[0;36m'
else
  NOFMT=''
  RED=''
  ORANGE=''
  YELLOW=''
  GREEN=''
  BLUE=''
  PURPLE=''
  CYAN=''
fi
export NOFMT RED ORANGE YELLOW GREEN BLUE PURPLE CYAN

# --- logging helpers (all follow the fractals:: prefix convention) ---
log_info()     { echo -e "${GREEN}fractals::${NOFMT}${CYAN}$*${NOFMT}"; }
log_skip()     { echo -e "${GREEN}fractals::${NOFMT}${CYAN}$*${NOFMT} ${ORANGE}already installed${NOFMT}"; }
log_warn()     { echo -e "${ORANGE}fractals::${NOFMT}${YELLOW}$*${NOFMT}"; }
log_error()    { echo -e "${RED}fractals::error:${NOFMT} ${RED}$*${NOFMT}" >&2; }
log_fatal()    { echo -e "${RED}FATAL:${NOFMT} ${RED}$*${NOFMT}" >&2; }
log_reminder() { echo -e "${ORANGE}\treminder: $*${NOFMT}"; }

# --- utilities ---

# Create ~/tools if missing and cd into it. Callers should invoke from a subshell
# if they don't want to inherit the directory change.
ensure_tools_dir() {
  mkdir -p "${HOME}/tools"
  cd "${HOME}/tools" || { log_fatal "could not cd into ${HOME}/tools"; exit 1; }
}
