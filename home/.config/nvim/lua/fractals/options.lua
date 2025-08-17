-----------------------------------------------------------
-- general neovim settings and configuration
-----------------------------------------------------------

-- default options are not included
-- see: https://neovim.io/doc/user/vim_diff.html
-- [2] defaults - *nvim-defaults*
local g = vim.g       -- global variables
local opt = vim.opt   -- set options (global/buffer/windows-scoped)

-----------------------------------------------------------
-- general
-----------------------------------------------------------
opt.mouse = 'a'                       -- enable mouse support
opt.clipboard = 'unnamed,unnamedplus' -- copy/paste to system clipboard
g.mapleader = " "                      -- leader key
g.modelines = 2
opt.compatible = false
opt.cursorline = true
opt.number = true
opt.relativenumber = true
opt.scrolloff = 0
opt.spell = false
opt.spelllang = "en_us"
opt.syntax = "on"
opt.termguicolors = true
opt.wrap = false
opt.updatetime = 250                   -- faster updates for cursorhold, lsp

-- searching
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- host system / filetype
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-----------------------------------------------------------
-- tabs, indentation, document formatting
-----------------------------------------------------------
opt.shiftwidth = 2        -- shift 2 spaces when indenting
opt.tabstop = 2           -- 1 tab == 2 spaces
opt.smartindent = true    -- auto-indent new lines
opt.expandtab = true      -- use spaces instead of tabs
opt.fixeol = true         -- ensure file ends with newline
opt.indentexpr = ""       -- disable legacy indentexpr
opt.list = true           -- show whitespace chars
opt.smarttab = true
opt.textwidth = 0
opt.listchars = {
  space = '·',        -- normal space
  tab = '»·',         -- tab, can show width more clearly
  trail = '•',        -- trailing spaces
  nbsp = '⍽',         -- non-breaking space
  eol = '↵',         -- newline / carriage-return symbol
}

-----------------------------------------------------------
-- undo / backup
-----------------------------------------------------------
opt.backup = false
opt.swapfile = false
opt.undodir = vim.fn.expand(vim.fn.stdpath("state") .. "/undo")
opt.undofile = true

treesitter = false

-----------------------------------------------------------
-- neovim ui
-----------------------------------------------------------
opt.showmatch = true                     -- highlight matching parentheses
opt.foldmethod = 'marker'                -- folding method; consider 'expr' with treesitter
-- opt.colorcolumn = '80'                 -- uncomment to show line length marker
opt.splitright = true                     -- vertical splits open to the right
opt.splitbelow = true                     -- horizontal splits open below
opt.linebreak = true                      -- wrap on word boundaries
opt.laststatus = 3                        -- global statusline

-----------------------------------------------------------
-- performance / memory
-----------------------------------------------------------
opt.hidden = true         -- allow background buffers
opt.lazyredraw = true     -- faster scrolling
opt.synmaxcol = 240       -- max column for syntax highlighting

-----------------------------------------------------------
-- end of configuration
-----------------------------------------------------------
