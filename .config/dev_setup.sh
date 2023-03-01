# software support
echo "creating fractals::environment::\"updates_to_path_var_req_for_dev.txt\" file for tracking PATH var appends..."
touch ~/updates_to_path_var_req_for_dev_setup.txt

# add firefox repository for latest/manage as deb pkg
echo "installing fractals::environment::adding apt repository... mozillateam (firefox)"
sudo add-apt-repository ppa:mozillateam/ppa
echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
' | sudo tee /etc/apt/preferences.d/mozilla-firefox
echo "enable mozillateam automatic updates... firefox"
echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox

# add neovim repository for latest/manage as deb pkg
# sudo add-apt-repository ppa:neovim-ppa/stable
echo "installing fractals::environment::adding apt repository... neovim"
sudo add-apt-repository ppa:neovim-ppa/unstable

# install minimum dev dependencies
echo "installing fractals::environment::updating packages..."
sudo apt update -y
echo "installing fractals::environment::upgrading to ubuntu latest..."
sudo apt upgrade -y

SOFTWARE_PACKAGES=" \
  curl \
  build-essential \
  cmake \
  ninja-build \
  clang \
  clangd \
  gdb \
  git \
  tmux \
  ripgrep \
  xz-utils \

  vim \ # depend on repository adds
  neovim \
  firefox \
  "

echo "installing fractals::environment::SOFTWARE_PACKAGES $SOFTWARE_PACKAGES"
sudo apt install -f -y $SOFTWARE_PACKAGES

# language support
LANGUAGE_PACKAGES=" \
 python3 \
 python3-dev \
 python3-venv \
 python3-pip \
 lua5.3 \
  "

echo "installing fractals::environment::LANGUAGE_PACKAGES $LANGUAGE_PACKAGES"
sudo apt install -f -y $LANGUAGE_PACKAGES

echo "installing fractals::environment::config directory... neovim"
nvim --headless -c 'call mkdir(stdpath("config"), "p") | exe "edit" stdpath("config") . "/init.lua" | write | quit'
echo "installing fractals::environment::plugins manager... neovim"
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# special cases

# python
########
echo "upgrading fractals::environment::special_cases... python3-pip"
python3 -m pip install --upgrade pip

# flutter/dart
##############
echo "installing fractals::environment::special_cases... flutter/dart-sdk"
sudo snap install flutter --classic
echo "running fractals::environment::special_cases... flutter init"
flutter sdk-path
echo "running fractals::environment::special_cases... flutter doctor"
flutter doctor

# nodejs
########
echo "installing fractals::environment::special_cases... nodejs toolchain"
curl -fsSL https://deb.nodesource.com/setup_19.x | sudo -E bash - &&\
sudo apt install -f -y nodejs

# rust
######
echo "installing fractals::environment::special_cases... rust toolchain"
sudo curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
sudo rustup update

# lua
#####
echo "installing fractals::environment::special_cases... lua-language-server"
cd $HOME && mkdir tools && cd tools
git clone --depth 1 https://github.com/LuaLS/lua-language-server
cd lua-language-server && bash make.sh
echo "tracking update to fractals::environment::PATH: $PATH... lua-language-server path"
cat "$HOME/tools/lua-language-server/bin:" >> updates_to_path_var_req_for_dev_setup
echo "added fractals::environment::PATH append to \"updates_to_path_var_req_for_dev_setup.txt\""
