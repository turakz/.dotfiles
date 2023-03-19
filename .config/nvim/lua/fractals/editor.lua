vim.opt.listchars = {
  space = '⋅',
  eol = '↵'
}

vim.opt.relativenumber = true;

-----------------------------------------------------------
-- Define keymaps of Neovim and installed plugins.
-----------------------------------------------------------

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Change leader to a comma
vim.g.mapleader = ','

-----------------------------------------------------------
-- Neovim shortcuts
-----------------------------------------------------------

-- Disable arrow keys
--map('', '<up>', '<nop>')
--map('', '<down>', '<nop>')
--map('', '<left>', '<nop>')
--map('', '<right>', '<nop>')

-- Clear search highlighting with <leader> and c
map('n', '<leader>c', ':nohl<CR>')

-- Toggle auto-indenting for code paste
map('n', '<F2>', ':set invpaste paste?<CR>')
vim.opt.pastetoggle = '<F12>'

-- Change split orientation
map('n', '<leader>tk', '<C-w>t<C-w>K') -- change vertical to horizontal
map('n', '<leader>th', '<C-w>t<C-w>H') -- change horizontal to vertical

-- Move around splits using Ctrl + {h,j,k,l}
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- Reload configuration without restart nvim
map('n', '<leader>r', ':so %<CR>')

-- Fast saving with <leader> and s
map('n', '<leader>s', ':w<CR>')

-- Close all windows and exit from Neovim with <leader> and q
map('n', '<leader>q', ':qa!<CR>')

-----------------------------------------------------------
-- Applications and Plugins shortcuts
-----------------------------------------------------------

-- terminal mappings
map('n', '<C-t>', ':Term<CR>', { noremap = true }) -- open
map('t', '<Esc>', '<C-\\><C-n>')                   -- exit

-- nvimtree
map('n', '<space>fet', ':NvimTreeToggle<CR>')    -- open/close and then focus on tree
map('n', '<space>fe', ':NvimTreeFocus<CR>')    -- open/close and then focus on tree
map('n', '<space>fr', ':NvimTreeRefresh<CR>')  -- refresh
map('n', '<leader>n', ':NvimTreeFindFile<CR>') -- search file
map('n', '<space>fc', ':NvimTreeCollapse<CR>') -- collapse recursively

-- tagbar
map('n', '<leader>z', ':TagbarToggle<CR>') -- open/close

-- telescope filebrowser/finding mappings
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
-- file_browser
vim.api.nvim_set_keymap(
  "n",
  "<space>fb",
  ":Telescope file_browser<CR>",
  { noremap = true }
)
-- open file_browser with the path of the current buffer
vim.api.nvim_set_keymap(
  "n",
  "<space>fbp",
  ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
  { noremap = true }
)
