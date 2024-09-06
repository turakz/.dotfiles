-- current <leader>
vim.g.mapleader = ' '

------------------------------------------------------------
-- Whitespace, Newlines, and Line Numbers
------------------------------------------------------------
vim.opt.listchars:append({ space = '⋅' })
vim.opt.listchars:append({ eol = '↵' })
vim.opt.relativenumber = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.spell = false
-- custom commands
function buffer_quit_all_except_visible(opts)
  local buffers = vim.fn.getbufinfo({ buflisted = 1 })
  for _, buffer in ipairs(buffers) do
    local is_visible = vim.fn.bufwinnr(buffer.bufnr) > 0
    if not is_visible then
      if buffer ~= vim.api.nvim_get_current_buf() then
        vim.api.nvim_buf_delete(buffer.bufnr, { force = true })
      end
    end
  end
end
vim.api.nvim_create_user_command("QAEV", buffer_quit_all_except_visible, {})

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
map('n', '<F11>', ':set invpaste paste?<CR>')
-- this setting is apparently deprecated (?): vim.opt.pastetoggle = '<F12>'

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
map('n', '<F1>', ':NvimTreeFocus<CR>')         -- open/close and then focus on tree
map('n', '<F2>', ':NvimTreeToggle<CR>')        -- open/close and then focus on tree
map('n', '<F3>', ':NvimTreeCollapse<CR>')      -- collapse recursively
map('n', '<F4>', ':NvimTreeFindFile<CR>')      -- search file
map('n', '<S-F1>', ':NvimTreeRefresh<CR>')       -- refresh
-- with leader
map('n', '<leader>e', ':NvimTreeToggle<CR>')   -- open/close and then focus on tree
map('n', '<leader>c', ':NvimTreeCollapse<CR>') -- collapse recursively

-- tagbar
map('n', '<leader>z', ':TagbarToggle<CR>') -- open/close

-- telescope filebrowser/finding mappings
local telescope_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, {})
vim.keymap.set('n', '<leader>gf', telescope_builtin.git_files, {})
vim.keymap.set('n', '<leader>lg', telescope_builtin.live_grep, {})
-- vim.keymap.set('n', '<leader>gd', telescope_builtin.lsp_definitions, {})
vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, {})

-- file_browser
vim.api.nvim_set_keymap(
  "n",
  "<leader>fb",
  ":Telescope file_browser<CR>",
  { noremap = true }
)
-- open file_browser with the path of the current buffer
vim.api.nvim_set_keymap(
  "n",
  "<leader>fbp",
  ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
  { noremap = true }
)

-- add dap keybinds: https://github.com/JonTheBurger/.dotfiles/blob/master/home/.config/nvim/lua/jontheburger/plugins/nvim-dap.lua
vim.keymap.set('n', '<leader>dU', require("dapui").toggle, opts)
vim.keymap.set('n', '<leader>dR', require("dap").run_to_cursor, opts)
vim.keymap.set('n', '<leader>db', require("dap").toggle_breakpoint, opts)
vim.keymap.set('n', '<leader>dc', require("dap").continue, opts)
vim.keymap.set('n', '<leader>ds', require("dap").step_over, opts)
vim.keymap.set('n', '<leader>di', require("dap").step_into, opts)
vim.keymap.set('n', '<leader>do', require("dap").step_out, opts)
vim.keymap.set('n', '<leader>dq', require("dap").terminate, opts)

map('n', '<F5>', '<cmd>lua require("dap").continue()<cr>')
map('n', '<F6>', '<cmd>lua require("dap").step_over()<cr>')
map('n', '<F7>', '<cmd>lua require("dap").step_into()<cr>')
map('n', '<F8>', '<cmd>lua require("dap").step_out()<cr>')
map('n', '<F9>', '<cmd>lua require("dap").toggle_breakpoint()<cr>')
map('n', '<F10>', '<cmd>lua require("dapui").toggle()<cr>')
