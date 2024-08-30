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
  -- packer
  use "wbthomason/packer.nvim"

  -- show indentation structure
  use "lukas-reineke/indent-blankline.nvim"


  -- completion engine
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-path"
  use "hrsh7th/cmp-cmdline"
  use "hrsh7th/nvim-cmp"
  use "hrsh7th/vim-vsnip"
  use "hrsh7th/vim-vsnip-integ"

  -- nvim tree: file explorer/project explorer
  use {
    "nvim-tree/nvim-tree.lua",
  }

  -- telescope: file finding
  use {
    "nvim-telescope/telescope.nvim", tag = "0.1.8",
  -- or                            , branch = "0.1.x",
    requires = { {"nvim-lua/plenary.nvim"} }
  }
  use {
    "nvim-telescope/telescope-file-browser.nvim",
    requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  }
  use {"nvim-telescope/telescope-fzf-native.nvim", run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build" }

  -- treesitter: semantic highlighting => :TSInstall c || TSInstall cpp || TSInstall lua || TSInstall dart etc..
  use {
    "nvim-treesitter/nvim-treesitter",
    run = function()
      local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
      ts_update()
    end,
  }

  -- lsp
  use {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      requires = {
        "hrsh7th/cmp-nvim-lsp",
        "nvim-telescope/telescope.nvim"
      },
  }

  -- clangd extensions
  use {
    "p00f/clangd_extensions.nvim",
    requires = {
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
  }

  -- colorschemes
  use "navarasu/onedark.nvim"
  --use "folke/tokyonight.nvim"

  -- flutter/dart support
  use {
    "akinsho/flutter-tools.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- optional for vim.ui.select
    },
  }
  -- debugging
  use "mfussenegger/nvim-dap"

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end)
