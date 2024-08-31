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

# add firefox repository for latest/manage as deb pkg
#echo -e "installing fractals::environment::adding apt repository... mozillateam (firefox)"
#sudo add-apt-repository ppa:mozillateam/ppa
#echo '
#Package: *
#Pin: release o=LP-PPA-mozillateam
#Pin-Priority: 1001
#' | sudo tee /etc/apt/preferences.d/mozilla-firefox
#echo -e "enable mozillateam automatic updates... firefox"
#echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox

# install minimum dev dependencies
echo -e "installing fractals::environment::${CYAN}updating packages${NOFMT}..."
sudo apt update -y
echo -e "installing fractals::environment::${CYAN}upgrading to ubuntu latest...${NOFMT}"
sudo apt upgrade -y

# removed:
  # libc6-dev-i386 \
  # lib32z1 \

SOFTWARE_PACKAGES=" \
  curl \

  bash-completion \
  build-essential \
  ccache \
  clang-format \
  clang-tidy \
  clang \
  clangd \
  cmake \
  cmake-doc \
  fd-find \
  firefox \
  gdb \
  gdb-multiarch \
  g++ \
  git \
  git-lfs \
  htop \
  lld \
  lldb \
  llvm \
  libc++-dev \
  mold \
  neovim \
  ninja-build \
  openjdk-8-jdk \
  ripgrep \
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
  xz-utils \
  "

echo -e "installing fractals::environment::${CYAN}SOFTWARE_PACKAGES${NOFMT}"
sudo apt install -f -y $SOFTWARE_PACKAGES

# language support
LANGUAGE_PACKAGES=" \
  black \
  lua5.3 \
  pipx \
  ptpython \
  python-is-python3 \
  python3 \
  python3-dev \
  python3-hatch-requirements.txt \
  python3-hatch-vcs \
  python3-hatchling \
  python3-mypy \
  python3-pip \
  python3-venv \
  "

echo -e "installing fractals::environment::${CYAN}LANGUAGE_PACKAGES${NOFMT}"
sudo apt install -f -y $LANGUAGE_PACKAGES

echo -e "upgrading fractals::environment::special_cases... ${CYAN}python3-pip${NOFMT}"
python3 -m pip install --upgrade pip
sudo snap install pyright --classic
pip3 install pynvim --upgrade

# lua
#####
echo -e "installing fractals::environment::special_cases... ${CYAN}lua-language-server${NOFMT}"
cd $HOME
mkdir tools
echo -e "making ${CYAN}/home/tools/${NOFMT}"
cd tools
pwd
git clone --depth 1 https://github.com/LuaLS/lua-language-server
cd lua-language-server
bash make.sh
echo -e "${ORANGE}please append the following to PATH in.bashrc${NOFMT}: ${CYAN}/home/tools/lua-language-server/bin:${NOFMT}"

# add neovim repository for latest/manage as deb pkg
echo -e "installing fractals::environment::adding apt repository... ${CYAN}neovim${NOFMT}"
sudo add-apt-repository ppa:neovim-ppa/unstable

echo -e "installing fractals::environment::config directory... ${CYAN}neovim${NOFMT}"
nvim --headless -c 'call mkdir(stdpath("config"), "p") | exe "edit" stdpath("config") . "/init.lua" | write | quit'
echo -e "installing fractals::environment::plugins manager... ${CYAN}neovim${NOFMT}"
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# flutter/dart
##############
#echo -e "installing fractals::environment::special_cases... flutter/dart-sdk"
#sudo snap install flutter --classic
#echo -e "running fractals::environment::special_cases... flutter init"
#flutter sdk-path
#echo -e "running fractals::environment::special_cases... flutter doctor"
#flutter doctor

# nodejs
########
#echo -e "installing fractals::environment::special_cases... nodejs toolchain"
#curl -fsSL https://deb.nodesource.com/setup_19.x | sudo -E bash - &&\
#sudo apt install -f -y nodejs

# rust
######
echo -e "installing fractals::environment::special_cases... ${CYAN}rust toolchain${NOFMT}"
sudo curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
sudo rustup update

# end
echo -e "fractals::environment::installation complete!"
echo -e "${ORANGE}\treminder: farm config file symlinks for home directory${NOFMT}"
echo -e "${ORANGE}\treminder: open neovim and run :PackerSync${NOFMT}"
