-- plugin management
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
  use "wbthomason/packer.nvim"

  -- editing
  use "lukas-reineke/indent-blankline.nvim"
  use "numToStr/Comment.nvim"
  use "tpope/vim-sleuth"

  -- completion engine
  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-path"
  use "hrsh7th/cmp-cmdline"
  use "hrsh7th/vim-vsnip"
  use "hrsh7th/vim-vsnip-integ"

  -- file explorer
  use "nvim-tree/nvim-tree.lua"

  -- telescope
  use { "nvim-telescope/telescope.nvim", tag = "0.1.8", requires = { "nvim-lua/plenary.nvim" } }
  use { "nvim-telescope/telescope-file-browser.nvim", requires = { "telescope.nvim" } }
  use { "nvim-telescope/telescope-fzf-native.nvim", run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build" }

  -- treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    run = function()
      local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
      ts_update()
    end,
  }
  use { "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" }
  use { "nvim-treesitter/nvim-treesitter-context", after = "nvim-treesitter" }

  -- LSP
  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    requires = { "hrsh7th/cmp-nvim-lsp" }
  }

  -- clangd extensions
  use { "p00f/clangd_extensions.nvim", requires = { "neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp" } }

  -- flutter
  use { "akinsho/flutter-tools.nvim", requires = { "nvim-lua/plenary.nvim", "stevearc/dressing.nvim" } }

  -- dap/debugging
  use "mfussenegger/nvim-dap"
  use {
    "rcarriga/nvim-dap-ui",
      requires = {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio" -- dap depends on this
      }
  }
  use "mfussenegger/nvim-dap-python"

  -- statusline
  use { "nvim-lualine/lualine.nvim", requires = { "nvim-tree/nvim-web-devicons", opt = true } }

  -- colorscheme
  use "folke/tokyonight.nvim"

  -- snippets, commenting
  use "numToStr/Comment.nvim"

  -- toggleterm
  use "akinsho/toggleterm.nvim"

  -- which-key
  use "folke/which-key.nvim"

  -- git
  use "lewis6991/gitsigns.nvim"
  use "tpope/vim-fugitive"  -- no setup required

  -- sleuth
  use "tpope/vim-sleuth"

  -- cmake-tools
  use "Civitasv/cmake-tools.nvim"

  -- neovim-tasks
  use "Shatur/neovim-tasks"

  if packer_bootstrap then
    require("packer").sync()
  end
end)
