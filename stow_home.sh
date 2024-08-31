#!/usr/bin/env bash

# TODO(fractals): make into a function
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
  export NOFMT=''
  export RED=''
  export ORANGE=''
  export YELLOW=''
  export GREEN=''
  export BLUE=''
  export PURPLE=''
  export CYAN=''
fi

rm -f "${HOME}/.gtkrc-2.0"  # Some wise-guy keeps replacing my soft-link.
stow home --no-folding      # Farm soft-links; create directories.
if [ $? -eq 0 ]; then
  echo -e "fractals::environment ~/.config ${GREEN}symlinks farmed!${NOFMT}"
else
  echo -e "fractals::environment ~/.config ${ORANGE}farming symlinks failed, make sure there aren't already existing files${NOFMT}"
fi
