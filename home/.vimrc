" https://vimhelp.org/options.txt.html
" minimal Vim/Neovim compatibility .vimrc

" only source Lua config for neovim
if has("nvim")
  source ~/.config/nvim/init.lua
else
  echo "fractals::.dotfiles::nvim not found"
endif

" Legacy Vim can use minimal sensible defaults
if !has("nvim")
  set nocompatible
  set number
  set relativenumber
  set nowrap
  syntax on
endif
