-- note: whenever a module is added or a plugin is changed
-- the following needs to occur for the configuration change to be recognized
--[[

  -> packer must be re-compiled, :PackerSync
  -> .dotfiles repo symlinks need re-farmed so that the new module path is picked up: ./stow_home.sh

]] --
-- load plugins first
require("fractals/plugins")
-- basic options
require("fractals/options")
-- autocommands
require("fractals/autocmds")
-- colorscheme
require("fractals/colorscheme")
-- treesitter
require("fractals/treesitter")
-- file explorer / telescope
require("fractals/filebrowsing")
-- lsp + completion
require("fractals/lsp")
require("fractals/clangd_exts")
-- editor configs
require("fractals/editor")
-- debugging
require("fractals/nvimdap")
-- statusline
require("fractals/nvimlualine")
-- snippets
require("fractals/snippets")
-- utilites/build tools
require("fractals/utilities")
