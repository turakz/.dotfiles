-- nvim-tree: https://github.com/nvim-tree/nvim-tree.lua
-- nvim tree defaults
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
require("nvim-tree").setup({
  filters = {
    -- hide certain files or directories in explorer
    dotfiles = false,
    custom = { "^build$"},
  },
})

-- telescope: https://github.com/nvim-telescope/telescope.nvim
local telescope = require("telescope")
telescope.setup({
  defaults = {
    -- Make sure it searches from current working directory
    cwd = vim.fn.getcwd(),

    -- File ignore patterns (make sure these aren't too restrictive)
    file_ignore_patterns = {
      "%.git/",
      "node_modules/",
      "%.cache/",
      "build/",  -- you already filter this in nvim-tree
    },

    -- Ripgrep arguments for live_grep
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",  -- search hidden files
      "--glob=!.git/*",  -- but ignore .git
    },
  },

  pickers = {
    live_grep = {
      -- Ensure it searches recursively
      additional_args = function()
        return { "--hidden", "--glob=!.git/*" }
      end,
    },
  },

  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    }
  }
})

-- must be called after setup
require('telescope').load_extension('fzf')
require('telescope').load_extension('file_browser')
