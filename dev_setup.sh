#!/usr/bin/env bash

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

if ! hash git 2> /dev/null; then
  echo -e "${RED}FATAL ERROR: please${NOFMT}${GREEN}git${NOFMT} ${RED}before running, terminating...${NOFMT}"
  return
else
  echo -e "${GREEN}fractals::${NOFMT}${CYAN}checking for latest .dofiles/...${NOFMT}"
  git fetch
  git pull
  git submodule update --init --recursive
fi

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

# removed:
  # libc6-dev-i386 \
  # lib32z1 \

SOFTWARE_PACKAGES=" \
  black \
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
  zsh \
  xz-utils \
  "

echo -e "${GREEN}fractals::${NOFMT}${CYAN}installing software...${NOFMT}"
sudo apt-get install -y $SOFTWARE_PACKAGES

##################
# language support
##################
LANGUAGE_PACKAGES=" \
  lua5.3 \
  pipx \
  python-is-python3 \
  python3 \
  python3-dev \
  python3-mypy \
  python3-pip \
  python3-venv \
  "

echo -e "${GREEN}fractals::${NOFMT}${CYAN}installing lua, python...${NOFMT}"
sudo apt-get install -y $LANGUAGE_PACKAGES

echo -e "${GREEN}fractals::${NOFMT}${CYAN}upgrading pip...${NOFMT}"
python3 -m pip install --upgrade pip

echo -e "${GREEN}fractals::${NOFMT}${CYAN}snap installing pyright... ${NOFMT}"
sudo snap install pyright --classic

echo -e "${GREEN}fractals::${NOFMT}${CYAN}pip3 upgrading pynvim... ${NOFMT}"
pip3 install pynvim --upgrade

echo -e "${GREEN}fractals::${NOFMT}${CYAN}pipx installing hatch... ${NOFMT}"
pipx install hatch

######
# lua
#####
if ! hash lua-language-server 2> /dev/null; then
  echo -e "${GREEN}fractals::${NOFMT}${CYAN}installing lua-language-server...${NOFMT}"
  cd $HOME
  mkdir tools
  echo -e "${ORANGE}making${NOFMT} ${CYAN}/home/tools/${NOFMT}"
  cd tools
  wd=$(pwd)
  echo -e "${GREEN}fractals::current working directory:${NOFMT} ${CYAN}${wd}${NOFMT}"
  git clone --depth 1 https://github.com/LuaLS/lua-language-server
  cd lua-language-server
  bash make.sh
else
  echo -e "${GREEN}fractals::${NOFMT}${CYAN}lua-language-server${NOCMFT} ${ORANGE}already installed${NOFMT}"
fi

####################################################
# neovim
# add neovim repository for latest/manage as deb pkg
####################################################
if ! hash nvim 2> /dev/null; then
  echo -e "${GREEN}fractals::${NOFMT}${CYAN}installing neovim...${NOFMT}"
  sudo add-apt-repository ppa:neovim-ppa/unstable

  echo -e "${GREEN}fractals::${NOFMT}${CYAN}configuring neovim...${NOFMT}\n"
  nvim --headless -c 'call mkdir(stdpath("config"), "p") | exe "edit" stdpath("config") . "/init.lua" | write | quit'

  echo -e "${GREEN}fractals::${NOFMT}${CYAN}installing neovim plugin manager packer...${NOFMT}"
  git clone --depth 1 https://github.com/wbthomason/packer.nvim\
   ~/.local/share/nvim/site/pack/packer/start/packer.nvim

else
  echo -e "${GREEN}fractals::${NOFMT}${CYAN}neovim${NOCMFT} ${ORANGE}already installed${NOFMT}"
fi
echo -e "${GREEN}fractals::${NOFMT}${CYAN}running packer...${NOFMT}\n"
nvim --headless +PackerClean +PackerSync +UpdateRemotePlugins +TSUpdateSync :checkhealth +q!

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
#echo -e "installing ${GREEN}fractals::${NOFMT}environment::special_cases... nodejs toolchain"
#curl -fsSL https://deb.nodesource.com/setup_19.x | sudo -E bash - &&\
#sudo apt install -f -y nodejs

######
# rust
######
echo -e "\n${GREEN}fractals::${NOFMT}${CYAN}installing rust toolchain...${NOFMT}"
sudo curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
sudo rustup update

##############################################
# ble.sh: https://github.com/akinomyoga/ble.sh
##############################################
echo -e "${GREEN}fractals::${NOFMT}${CYAN}installing ble.sh in ${HOME}...${NOFMT}"
cd ~
wd=$(pwd)
echo -e "${GREEN}fractals::current working directory:${NOFMT} ${CYAN}${wd}${NOFMT}"
git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
make -C ble.sh install PREFIX=~/.local
cd .dotfiles
wd=$(pwd)
echo -e "${GREEN}fractals::current working directory:${NOFMT} ${CYAN}${wd}${NOFMT}"

###########
# starship:
###########
if ! hash starship 2> /dev/null; then
  echo -e "${GREEN}fractals::${NOFMT}${CYAN}installing starship...${NOFMT}"
  curl -sS https://starship.rs/install.sh | sh
else
  echo -e "${GREEN}fractals::${NOFMT}${CYAN}starship${NOCMFT} ${ORANGE}already installed${NOFMT}"
fi

###########
# COMPLETE
##########
echo -e "${GREEN}fractals::${NOFMT}${CYAN}installation complete!${NOFMT}"
echo -e "${ORANGE}\treminder: append to PATH in ${CYAN}.bashrc${NOFMT}${ORANGE}: ${NOFMT}${CYAN}/home/tools/lua-language-server/bin:${NOFMT}"
echo -e "${ORANGE}\treminder: farm symlinks for home directory, remove dead links in your actual ${CYAN}.config/${NOFMT} ${ORANGE}directory${NOFMT}"
#echo -e "${ORANGE}\treminder: open neovim and run :PackerClean, :PackerSync, :UpdateRemotePlugins, :TSUpdateSync, :checkhealth${NOFMT}"
echo -e "${ORANGE}\treminder: make sure to update \$HOME path: ${CYAN}$HOME${NOFMT} ${ORANGE}in${NOFMT} ${CYAN}~/.config/hatch/config.toml${NOFMT} ${ORANGE}of your host machine${NOFMT}"
echo -e "${ORANGE}\treminder: and afterwards, please restart your terminal session${NOFMT}"
