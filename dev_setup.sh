#!/usr/bin/env bash
set -euo pipefail

# TODO(fractals): make into a function/organize into utilities
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

#if ! hash git 2> /dev/null; then
#  echo -e "${RED}FATAL ERROR: please install git before running, terminating...${NOFMT}"
#  exit 1
#else
#  echo -e "${GREEN}fractals::${NOFMT}${CYAN}checking for latest .dofiles/...${NOFMT}"
#  git fetch
#  git pull
#  git submodule update --init --recursive
#fi

# add firefox repository for latest/manage as deb pkg
#echo -e "installing ${GREEN}fractals::${NOFMT}environment::adding apt repository... mozillateam (firefox)"
#sudo add-apt-repository ppa:mozillateam/ppa
#echo '
#Package: *
#Pin: release o=LP-PPA-mozillateam
#Pin-Priority: 1001
#' | sudo tee /etc/apt/preferences.d/mozilla-firefox
#echo -e "enable mozillateam automatic updates... firefox"
#echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox


###########
# software
##########
echo -e "${GREEN}fractals::${NOFMT}${CYAN}updating packages...${NOFMT}"
sudo apt update -y

#echo -e "${GREEN}fractals::${NOFMT}${CYAN}upgrading to ubuntu latest...${NOFMT}"
#sudo apt upgrade -y

SOFTWARE_PACKAGES=" \
  bison \
  black \
  curl \
  bash-completion \
  build-essential \
  ccache \
  clang-18 \
  clang-format-18 \
  clang-tidy-18 \
  clangd-18 \
  cmake \
  cmake-doc \
  cmake-format \
  cppcheck \
  fd-find \
  flake8 \
  gdb-multiarch \
  g++ \
  git \
  git-lfs \
  htop \
  lld-18 \
  lldb-18 \
  llvm-18 \
  llvm-18-dev \
  libevent-dev \
  libgmp3-dev \
  libmpfr-doc \
  libmpfr-dev \
  mold \
  ncurses-dev \
  ninja-build \
  pkg-config \
  python3-lldb-18 \
  ripgrep \
  shellcheck \
  shfmt \
  software-properties-common \
  stow \
  tig \
  tmux \
  tree \
  unzip \
  valgrind \
  vim \
  vim-gui-common \
  wget \
  xclip \
  xsel \
  zip \
  zsh \
  xz-utils \
  "

echo -e "${GREEN}fractals::${NOFMT}${CYAN}installing software...${NOFMT}"
if ! sudo apt-get install -y $SOFTWARE_PACKAGES; then
  echo -e "${RED}FATAL ERROR: Failed to install required software packages${NOFMT}"
  exit 1
fi

# Create version-agnostic lldb-dap symlink for DAP configurations
if [ ! -L /usr/local/bin/lldb-dap ]; then
  echo -e "${GREEN}fractals::${NOFMT}${CYAN}creating lldb-dap symlink...${NOFMT}"
  sudo ln -s /usr/bin/lldb-dap-18 /usr/local/bin/lldb-dap
else
  echo -e "${GREEN}fractals::${NOFMT}${CYAN}lldb-dap symlink${NOFMT} ${ORANGE}already exists${NOFMT}"
fi

##################
# language support
##################
LANGUAGE_PACKAGES=" \
  lua5.4 \
  liblua5.4-dev \
  default-jdk \
  pipx \
  python-is-python3 \
  python3 \
  python3-dev \
  python3-mypy \
  python3-pip \
  python3-venv \
  python3-debugpy \
  "

echo -e "${GREEN}fractals::${NOFMT}${CYAN}installing lua, python...${NOFMT}"
if ! sudo apt-get install -y $LANGUAGE_PACKAGES; then
  echo -e "${RED}FATAL ERROR: Failed to install language support packages${NOFMT}"
  exit 1
fi

echo -e "${GREEN}fractals::${NOFMT}${CYAN}upgrading pip...${NOFMT}"
python3 -m pip install --user --upgrade pip setuptools wheel

echo -e "${GREEN}fractals::${NOFMT}${CYAN}snap installing pyright... ${NOFMT}"
sudo snap install pyright --classic


##################################
# Helper function for tools directory
##################################
ensure_tools_dir() {
  mkdir -p "${HOME}/tools"
  cd "${HOME}/tools"
}

##################################
# gdb with python support for dap
##################################
if ! hash gdb 2> /dev/null; then
  echo -e "${GREEN}fractals::${NOFMT}${CYAN}installing gdb with python dap support...${NOFMT}"
  ensure_tools_dir
  wget "http://ftp.gnu.org/gnu/gdb/gdb-15.1.tar.gz"
  tar -xvzf gdb-15.1.tar.gz
  cd gdb-15.1
  bash configure --with-python=/usr/bin/python --with-gmp=/usr/lib/x86_64-linux-gnu/ --with-mpfr=/usr/lib/x86_64-linux-gnu/
  make
  sudo make install
  gdb --version
  cd ..
  rm gdb-15.1.tar.gz
fi

######
# lua + debugger
#####
if ! hash luarocks 2> /dev/null; then
  echo -e "${GREEN}fractals::${NOFMT}${CYAN}installing luarocks...${NOFMT}"
  cd /tmp
  wget https://luarocks.org/releases/luarocks-3.11.1.tar.gz
  tar xzf luarocks-3.11.1.tar.gz
  cd luarocks-3.11.1

  # --- 3) Build and install for Lua 5.4 with versioned rocks dir ---
  ./configure --prefix=/usr/local \
              --lua-version=5.4
  make build
  sudo make install
  echo -e "${GREEN}fractals::${NOFMT}${CYAN}cleaning up luarocks tmp dir...${NOFMT}"
  rm -rf /tmp/luarocks-3.11.1*
  export PATH="$HOME/.luarocks/bin:$PATH"
  echo -e "${GREEN}fractals::${NOFMT}${CYAN}added $HOME/.luarocks/bin: to PATH...${NOFMT}"
else
  echo -e "${GREEN}fractals::${NOFMT}${CYAN}luarocks${NOFMT} ${ORANGE}already installed${NOFMT}"
fi

if ! [ -d "${HOME}/tools/local-lua-debugger-vscode" ]; then
  if hash npm 2> /dev/null; then
    echo -e "${GREEN}fractals::${NOFMT}${CYAN}installing lua-local-debugger...${NOFMT}"
    ensure_tools_dir
    git clone https://github.com/tomblind/local-lua-debugger-vscode.git
    cd local-lua-debugger-vscode
    npm install
    npm run build
  else
    echo -e "${ORANGE}fractals::${NOFMT}${CYAN}lua-local-debugger${NOFMT} ${ORANGE}cannot be installed,${NOFMT} ${CYAN}npm${NOFMT}${ORANGE} missing${NOFMT}"
  fi
else
  echo -e "${GREEN}fractals::${NOFMT}${CYAN}lua-local-debugger${NOFMT} ${ORANGE}already installed${NOFMT}"
fi

####################################################
# neovim
# add neovim repository for latest/manage as deb pkg
####################################################
if ! hash nvim 2> /dev/null; then
    echo -e "${GREEN}fractals::${NOFMT}${CYAN}installing neovim...${NOFMT}"
    sudo add-apt-repository ppa:neovim-ppa/unstable -y
    sudo apt update
    sudo apt install neovim -y

    # Only do initial config if it's a fresh install
    echo -e "${GREEN}fractals::${NOFMT}${CYAN}configuring neovim...${NOFMT}"
    nvim --headless -c 'call mkdir(stdpath("config"), "p") | quit'

    # lazy.nvim bootstraps itself automatically on first launch
    echo -e "${GREEN}fractals::${NOFMT}${CYAN}lazy.nvim will bootstrap on first nvim launch...${NOFMT}"
else
  echo -e "${GREEN}fractals::${NOFMT}${CYAN}neovim${NOFMT} ${ORANGE}already installed${NOFMT}"
fi

###############
# flutter/dart
##############
#echo -e "installing ${GREEN}fractals::${NOFMT}environment::special_cases... flutter/dart-sdk"
#sudo snap install flutter --classic
#echo -e "running ${GREEN}fractals::${NOFMT}environment::special_cases... flutter init"
#flutter sdk-path
#echo -e "running ${GREEN}fractals::${NOFMT}environment::special_cases... flutter doctor"
#flutter doctor

########
# nodejs
########
echo -e "installing ${GREEN}fractals::${NOFMT}environment::installing nodejs toolchain..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

######
# rust
######
echo -e "\n${GREEN}fractals::${NOFMT}${CYAN}installing rust toolchain...${NOFMT}"
if ! hash cargo 2> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source $HOME/.cargo/env
    rustup update
else
    echo -e "${GREEN}fractals::${NOFMT}${CYAN}rust${NOFMT} ${ORANGE}already installed${NOFMT}"
fi

#############
# pixie/mojo
############
echo -e "\n${GREEN}fractals::${NOFMT}${CYAN}installing pixie package manager for mojo dev...${NOFMT}"
if ! hash pixi 2> /dev/null; then
  curl -fsSL https://pixi.sh/install.sh | sh
  echo 'default-channels = ["https://conda.modular.com/max-nightly", "conda-forge"]' >> ${HOME}/.pixi/config.toml
else
  echo -e "${GREEN}fractals::${NOFMT}${CYAN}pixie${NOFMT} ${ORANGE} already installed${NOFMT}"
fi

##############################################
# ble.sh: https://github.com/akinomyoga/ble.sh
##############################################
if [ ! -d "${HOME}/ble.sh" ]; then
  echo -e "${GREEN}fractals::${NOFMT}${CYAN}installing ble.sh in ${HOME}...${NOFMT}"
  cd ~
  wd=$(pwd)
  echo -e "${GREEN}fractals::current working directory:${NOFMT} ${CYAN}${wd}${NOFMT}"
  git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
  make -C ble.sh install PREFIX=~/.local
  cd .dotfiles
  wd=$(pwd)
  echo -e "${GREEN}fractals::current working directory:${NOFMT} ${CYAN}${wd}${NOFMT}"
else
  echo -e "${GREEN}fractals::${NOFMT}${CYAN}ble.sh${NOFMT} ${ORANGE}already installed${NOFMT}"
fi

###########
# starship:
###########
if ! hash starship 2> /dev/null; then
  echo -e "${GREEN}fractals::${NOFMT}${CYAN}installing starship...${NOFMT}"
  curl -sS https://starship.rs/install.sh | sh
else
  echo -e "${GREEN}fractals::${NOFMT}${CYAN}starship${NOFMT} ${ORANGE}already installed${NOFMT}"
fi

###########
# COMPLETE
##########
echo -e "${GREEN}fractals::${NOFMT}${CYAN}installation complete!${NOFMT}"
echo -e "${ORANGE}\treminder: append to PATH in ${CYAN}.bashrc${NOFMT}${ORANGE}: ${NOFMT}${CYAN}/home/tools/lua-language-server/bin:${NOFMT}"
echo -e "${ORANGE}\treminder: farm symlinks for home directory, remove dead links in your actual ${CYAN}.config/${NOFMT} ${ORANGE}directory${NOFMT}"
echo -e "${ORANGE}\treminder: open neovim and run :Lazy sync, :UpdateRemotePlugins, :TSUpdateSync, :checkhealth${NOFMT}"
echo -e "${ORANGE}\treminder: and afterwards, please restart your terminal session${NOFMT}"
