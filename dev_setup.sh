#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./_utils.sh
source "${SCRIPT_DIR}/_utils.sh"

################################################################################
# Version detection & per-distro configuration
#
# Detects Ubuntu version via lsb_release; can be overridden with:
#   UBUNTU_VERSION=24.04 ./dev_setup.sh
# Only 24.04 and 26.04 are supported. Older distros need a case branch added.
################################################################################
UBUNTU_VERSION="${UBUNTU_VERSION:-$(lsb_release -rs)}"
log_info "detected Ubuntu ${UBUNTU_VERSION}"

case "${UBUNTU_VERSION}" in
  24.04)
    LLVM_VERSION=18
    NODE_MAJOR=20
    LUAROCKS_VERSION=3.11.1
    LIBCXX_PRINTERS_BRANCH=release/18.x
    ;;
  26.04)
    LLVM_VERSION=21
    NODE_MAJOR=24
    LUAROCKS_VERSION=3.13.0
    LIBCXX_PRINTERS_BRANCH=release/21.x
    ;;
  *)
    log_fatal "unsupported Ubuntu version: ${UBUNTU_VERSION}. Supported: 24.04, 26.04. Add a case branch above to extend."
    exit 1
    ;;
esac

log_info "using LLVM/Clang ${LLVM_VERSION}, Node ${NODE_MAJOR}.x, luarocks ${LUAROCKS_VERSION}"

################################################################################
# System packages (apt)
################################################################################
log_info "updating apt package index..."
sudo apt update -y

# Base development toolchain. LLVM-versioned packages are templated on
# ${LLVM_VERSION}; everything else is version-agnostic in the current archive.
SOFTWARE_PACKAGES="\
  bash-completion \
  bison \
  black \
  build-essential \
  ccache \
  clang-${LLVM_VERSION} \
  clang-format-${LLVM_VERSION} \
  clang-tidy-${LLVM_VERSION} \
  clangd-${LLVM_VERSION} \
  cmake \
  cmake-doc \
  cmake-format \
  cppcheck \
  curl \
  fd-find \
  flake8 \
  g++ \
  gdb \
  gdb-multiarch \
  git \
  git-lfs \
  htop \
  libc++-${LLVM_VERSION}-dev \
  libc++abi-${LLVM_VERSION}-dev \
  libevent-dev \
  libgmp-dev \
  libmpfr-dev \
  libmpfr-doc \
  libncurses-dev \
  lld-${LLVM_VERSION} \
  lldb-${LLVM_VERSION} \
  llvm-${LLVM_VERSION} \
  llvm-${LLVM_VERSION}-dev \
  mold \
  ninja-build \
  pkg-config \
  python3-lldb-${LLVM_VERSION} \
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
  xz-utils \
  zip \
  zsh \
  "

log_info "installing apt software packages..."
# SC2086 intentional: word-splitting turns the space-separated string into
# individual arguments to apt-get. Quoting would pass one giant "package name".
# shellcheck disable=SC2086
if ! sudo apt-get install -y ${SOFTWARE_PACKAGES}; then
  log_fatal "failed to install required software packages"
  exit 1
fi

# Version-agnostic lldb-dap symlink so nvim-dap and friends can reference /usr/local/bin/lldb-dap.
LLDB_DAP_TARGET="/usr/bin/lldb-dap-${LLVM_VERSION}"
if [ ! -L /usr/local/bin/lldb-dap ]; then
  if [ -x "${LLDB_DAP_TARGET}" ]; then
    log_info "creating lldb-dap symlink to ${LLDB_DAP_TARGET}..."
    sudo ln -s "${LLDB_DAP_TARGET}" /usr/local/bin/lldb-dap
  else
    log_warn "lldb-dap target ${LLDB_DAP_TARGET} not found; skipping symlink"
  fi
else
  log_skip "lldb-dap symlink"
fi

################################################################################
# Language support
################################################################################
LANGUAGE_PACKAGES="\
  default-jdk \
  liblua5.4-dev \
  lua5.4 \
  pipx \
  python-is-python3 \
  python3 \
  python3-debugpy \
  python3-dev \
  python3-mypy \
  python3-pip \
  python3-venv \
  "

log_info "installing lua, python, jdk..."
# shellcheck disable=SC2086 # intentional word-splitting; see SOFTWARE_PACKAGES note above
if ! sudo apt-get install -y ${LANGUAGE_PACKAGES}; then
  log_fatal "failed to install language support packages"
  exit 1
fi

################################################################################
# Node.js (via nodesource, modern keyring pattern)
#
# Uses signed apt source (not the deprecated pipe-curl-to-bash setup_X.x script).
################################################################################
if ! command -v node >/dev/null 2>&1 \
   || [ "$(node --version | cut -d. -f1 | tr -d 'v')" -lt "${NODE_MAJOR}" ]; then
  log_info "installing nodejs ${NODE_MAJOR}.x..."
  sudo apt-get install -y ca-certificates curl gnupg
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
    | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
  echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x nodistro main" \
    | sudo tee /etc/apt/sources.list.d/nodesource.list
  sudo apt-get update
  sudo apt-get install -y nodejs
else
  log_skip "nodejs >= ${NODE_MAJOR}"
fi

################################################################################
# luarocks (built from source; not packaged for Lua 5.4 on all Ubuntus)
################################################################################
if ! command -v luarocks >/dev/null 2>&1; then
  log_info "installing luarocks ${LUAROCKS_VERSION} from source..."
  (
    cd /tmp
    wget "https://luarocks.org/releases/luarocks-${LUAROCKS_VERSION}.tar.gz"
    tar xzf "luarocks-${LUAROCKS_VERSION}.tar.gz"
    cd "luarocks-${LUAROCKS_VERSION}"
    ./configure --prefix=/usr/local --lua-version=5.4
    make build
    sudo make install
    log_info "cleaning up luarocks tmp dir..."
    rm -rf "/tmp/luarocks-${LUAROCKS_VERSION}"*
  )
  export PATH="${HOME}/.luarocks/bin:${PATH}"
  log_info "added ${HOME}/.luarocks/bin to PATH for this session"
else
  log_skip "luarocks"
fi

################################################################################
# lua-local-debugger-vscode (needs npm)
################################################################################
if [ ! -d "${HOME}/tools/local-lua-debugger-vscode" ]; then
  if command -v npm >/dev/null 2>&1; then
    log_info "installing lua-local-debugger..."
    (
      ensure_tools_dir
      git clone https://github.com/tomblind/local-lua-debugger-vscode.git
      cd local-lua-debugger-vscode
      npm install
      npm run build
    )
  else
    log_warn "lua-local-debugger cannot be installed, npm missing"
  fi
else
  log_skip "lua-local-debugger"
fi

################################################################################
# Neovim (unstable PPA)
################################################################################
if ! command -v nvim >/dev/null 2>&1; then
  log_info "installing neovim from ppa:neovim-ppa/unstable..."
  sudo add-apt-repository ppa:neovim-ppa/unstable -y
  sudo apt update
  sudo apt install neovim -y

  log_info "creating nvim config directory..."
  nvim --headless -c 'call mkdir(stdpath("config"), "p") | quit'

  log_info "lazy.nvim will bootstrap on first nvim launch"
else
  log_skip "neovim"
fi

################################################################################
# Rust (rustup)
################################################################################
if ! command -v cargo >/dev/null 2>&1; then
  log_info "installing rust toolchain via rustup..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  # shellcheck source=/dev/null
  source "${HOME}/.cargo/env"
  rustup update
else
  log_skip "rust"
fi

################################################################################
# ble.sh (readline replacement for bash)
################################################################################
if [ ! -d "${HOME}/ble.sh" ]; then
  log_info "installing ble.sh into ${HOME}..."
  (
    cd "${HOME}"
    git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
    make -C ble.sh install PREFIX="${HOME}/.local"
  )
else
  log_skip "ble.sh"
fi

################################################################################
# starship prompt
################################################################################
if ! command -v starship >/dev/null 2>&1; then
  log_info "installing starship prompt..."
  curl -sS https://starship.rs/install.sh | sh
else
  log_skip "starship"
fi

################################################################################
# libc++ gdb pretty-printers
#
# Ubuntu's libc++-dev packages don't ship the gdb printer script — LLVM keeps
# it in-tree at libcxx/utils/gdb/libcxx/printers.py but doesn't package it.
# ~/.gdbinit auto-loads them from ~/.gdb/libcxx/ (see home/.gdbinit).
# Bump LIBCXX_PRINTERS_BRANCH in the version case block when upgrading libc++.
################################################################################
if [ ! -f "${HOME}/.gdb/libcxx/printers.py" ]; then
  log_info "installing libc++ gdb pretty-printers (${LIBCXX_PRINTERS_BRANCH})..."
  mkdir -p "${HOME}/.gdb/libcxx"
  touch "${HOME}/.gdb/libcxx/__init__.py"
  curl -fsSL -o "${HOME}/.gdb/libcxx/printers.py" \
    "https://raw.githubusercontent.com/llvm/llvm-project/${LIBCXX_PRINTERS_BRANCH}/libcxx/utils/gdb/libcxx/printers.py"
else
  log_skip "libc++ gdb pretty-printers"
fi

################################################################################
# Done
################################################################################
log_info "installation complete!"
log_reminder "farm symlinks for home directory (run ./stow_home.sh); remove dead links in your actual .config/ directory"
log_reminder "open neovim, let lazy.nvim bootstrap, then run :Lazy sync, :UpdateRemotePlugins, :TSUpdateSync, :checkhealth"
log_reminder "restart your terminal session"
