-----------------------------------------------------------
-- General Neovim settings and configuration
-----------------------------------------------------------

-- Default options are not included
-- See: https://neovim.io/doc/user/vim_diff.html
-- [2] Defaults - *nvim-defaults*

local g = vim.g       -- Global variables
local opt = vim.opt   -- Set options (global/buffer/windows-scoped)

-----------------------------------------------------------
-- General
-----------------------------------------------------------
opt.mouse = 'a'                       -- Enable mouse support
opt.clipboard = 'unnamedplus'         -- Copy/paste to system clipboard
opt.swapfile = false                  -- Don't use swapfile
opt.completeopt = 'menuone,noinsert,noselect'  -- Autocomplete options

g.mapleader = " "
g.modelines = 2
opt.compatible = false
opt.cursorline = true
opt.number = true
opt.relativenumber = true
opt.scrolloff = 0
opt.spell = true
opt.spelllang = "en_us"
opt.syntax = "on"
opt.termguicolors = true
opt.updatetime = 750
opt.wrap = false

-- Searching
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Host System Integration
opt.mouse = "a"
opt.clipboard = "unnamed,unnamedplus"

-- Disable netrw
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- Document Spacing
-- opt.colorcolumn = "80,88,120"
opt.shiftwidth = 2
opt.signcolumn = "yes"
opt.expandtab = true
opt.fixeol = true
opt.indentexpr = ""
opt.list = true
opt.smarttab = true
opt.tabstop = 3
opt.textwidth = 0
opt.listchars = { space = '·', tab = "»»" }

-- Undo File
opt.backup = false
opt.swapfile = false
opt.undodir = vim.fn.expand(vim.fn.stdpath("state") .. "/undo")
opt.undofile = true


-----------------------------------------------------------
-- Neovim UI
-----------------------------------------------------------
opt.list = true               -- Enable list mode
opt.number = true             -- Show line number
opt.showmatch = true          -- Highlight matching parenthesis
opt.foldmethod = 'marker'   -- Enable folding (default)
--opt.colorcolumn = '80'      -- Line length marker at 80 columns
opt.splitright = true       -- Vertical split to the right
opt.splitbelow = true       -- Horizontal split to the bottom
opt.ignorecase = true       -- Ignore case letters when search
opt.smartcase = true        -- Ignore lowercase for the whole pattern
opt.linebreak = true        -- Wrap on word boundary
opt.termguicolors = true    -- Enable 24-bit RGB colors
opt.laststatus=3            -- Set global statusline

-----------------------------------------------------------
-- Tabs, indent
-----------------------------------------------------------
opt.expandtab = true        -- Use spaces instead of tabs
opt.shiftwidth = 2          -- Shift 4 spaces when tab
opt.tabstop = 2             -- 1 tab == 4 spaces
opt.smartindent = true      -- Autoindent new lines

-----------------------------------------------------------
-- Memory, CPU
-----------------------------------------------------------
opt.hidden = true           -- Enable background buffers
opt.history = 100           -- Remember N lines in history
opt.lazyredraw = true       -- Faster scrolling
opt.synmaxcol = 240         -- Max column for syntax highlight
opt.updatetime = 250        -- ms to wait for trigger an event

-----------------------------------------------------------
-- Startup
-----------------------------------------------------------
