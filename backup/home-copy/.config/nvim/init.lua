-- note: whenever a module is added or a plugin is changed
-- the following needs to occur for the configuration change to be recognized
--[[

  -> packer must be re-compiled, :PackerSync
  -> .dotfiles repo symlinks need re-farmed so that the new module path is picked up: ./stow_home.sh

]] --
require("fractals/plugins")
require("fractals/options")
require("fractals/autocmds")
require("fractals/colorscheme")
require("fractals/treesitter")
require("fractals/filebrowsing")
require("fractals/lsp")
require("fractals/clangd_exts")
require("fractals/editor")
require("fractals/nvimdap")
require("fractals/nvimlualine")
