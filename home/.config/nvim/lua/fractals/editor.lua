-----------------------------------------------------------
-- editor.lua
-- keymaps, commands, and plugin shortcuts
-----------------------------------------------------------

-- set leader key
vim.g.mapleader = ' '

-----------------------------------------------------------
-- utility functions / custom commands
-----------------------------------------------------------

-- quit all buffers except visible ones
local function buffer_quit_all_except_visible()
  local buffers = vim.fn.getbufinfo({ buflisted = 1 })
  for _, buffer in ipairs(buffers) do
    local is_visible = vim.fn.bufwinnr(buffer.bufnr) > 0
    if not is_visible and buffer.bufnr ~= vim.api.nvim_get_current_buf() then
      vim.api.nvim_buf_delete(buffer.bufnr, { force = true })
    end
  end
end
vim.api.nvim_create_user_command("QAEV", buffer_quit_all_except_visible, {})

-----------------------------------------------------------
-- helper for consistent keymap options
-----------------------------------------------------------
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    if opts.desc then
      opts.desc = "editor.lua: " .. opts.desc
    end
    options = vim.tbl_extend('force', options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-----------------------------------------------------------
-- neovim shortcuts
-----------------------------------------------------------

-- clear search highlighting
map('n', '<leader>clr', ':nohl<CR>', { desc = "clear search highlight" })

-- toggle paste mode
map('n', '<F11>', ':set invpaste paste?<CR>', { desc = "toggle paste mode" })

-- split orientation
map('n', '<leader>tk', '<C-w>t<C-w>K', { desc = "vertical to horizontal split" })
map('n', '<leader>th', '<C-w>t<C-w>H', { desc = "horizontal to vertical split" })

-- move around splits with ctrl + {h,j,k,l}
map('n', '<C-h>', '<C-w>h', { desc = "move left" })
map('n', '<C-j>', '<C-w>j', { desc = "move down" })
map('n', '<C-k>', '<C-w>k', { desc = "move up" })
map('n', '<C-l>', '<C-w>l', { desc = "move right" })

-- reload config
map('n', '<leader>r', ':so %<CR>', { desc = "reload current file" })

-- fast save
map('n', '<leader>s', ':w<CR>', { desc = "save file" })

-- quit neovim
map('n', '<leader>q', ':qa!<CR>', { desc = "quit neovim" })

-----------------------------------------------------------
-- terminal mappings
-----------------------------------------------------------
map('n', '<C-t>', ':Term<CR>', { desc = "open terminal" })
map('t', '<Esc>', '<C-\\><C-n>', { desc = "exit terminal mode" })

-----------------------------------------------------------
-- nvim-tree mappings
-----------------------------------------------------------
map('n', '<F1>', ':NvimTreeFocus<CR>', { desc = "focus nvim tree" })
map('n', '<F2>', ':NvimTreeToggle<CR>', { desc = "toggle nvim tree" })
map('n', '<F3>', ':NvimTreeCollapse<CR>', { desc = "collapse nvim tree" })
map('n', '<F4>', ':NvimTreeFindFile<CR>', { desc = "find file in nvim tree" })
map('n', '<S-F1>', ':NvimTreeRefresh<CR>', { desc = "refresh nvim tree" })
map('n', '<leader>eo', ':NvimTreeToggle<CR>', { desc = "toggle nvim tree with leader" })
map('n', '<leader>ec', ':NvimTreeCollapse<CR>', { desc = "collapse nvim tree with leader" })

-----------------------------------------------------------
-- tagbar
-----------------------------------------------------------
map('n', '<leader>z', ':TagbarToggle<CR>', { desc = "toggle tagbar" })

-----------------------------------------------------------
-- telescope mappings
-----------------------------------------------------------
local telescope_builtin = require('telescope.builtin')
map('n', '<leader>ff', telescope_builtin.find_files, { desc = "find files" })
map('n', '<leader>gf', telescope_builtin.git_files, { desc = "git files" })
map('n', '<leader>lg', telescope_builtin.live_grep, { desc = "live grep" })
map('n', '<leader>fbf', telescope_builtin.buffers, { desc = "list buffers" })
map('n', '<leader>fh', telescope_builtin.help_tags, { desc = "help tags" })
map('n', '<leader>fb', ':Telescope file_browser<CR>', { desc = "open file browser" })
map('n', '<leader>fbp', ':Telescope file_browser path=%:p:h select_buffer=true<CR>', { desc = "file browser at current path" })

-----------------------------------------------------------
-- dap key mappings
-- https://github.com/JonTheBurger/.dotfiles/blob/master/home/.config/nvim/lua/jontheburger/plugins/nvim-dap.lua
-----------------------------------------------------------
local dap = require('dap')
local dapui = require('dapui')
map('n', '<leader>dU', dapui.toggle, { desc = "toggle dap ui" })
map('n', '<leader>dR', dap.run_to_cursor, { desc = "run to cursor" })
map('n', '<leader>db', dap.toggle_breakpoint, { desc = "toggle breakpoint" })
map('n', '<leader>dbc', dap.clear_breakpoints, { desc = "clear breakpoints" })
map('n', '<leader>dc', dap.continue, { desc = "continue" })
map('n', '<leader>ds', dap.step_over, { desc = "step over" })
map('n', '<leader>di', dap.step_into, { desc = "step into" })
map('n', '<leader>do', dap.step_out, { desc = "step out" })
map('n', '<leader>dq', dap.terminate, { desc = "terminate" })

-- dap function keys
map('n', '<F5>', dap.continue, { desc = "dap continue" })
map('n', '<F6>', dap.step_over, { desc = "dap step over" })
map('n', '<F7>', dap.step_into, { desc = "dap step into" })
map('n', '<F8>', dap.step_out, { desc = "dap step out" })
map('n', '<F9>', dap.toggle_breakpoint, { desc = "dap toggle breakpoint" })
map('n', '<F10>', dapui.toggle, { desc = "dap ui toggle" })
map('n', '<F12>', dap.clear_breakpoints, { desc = "dap clear breakpoints" })

-- Disable arrow keys
--map('', '<up>', '<nop>')
--map('', '<down>', '<nop>')
--map('', '<left>', '<nop>')
--map('', '<right>', '<nop>')

-- which-key config
require("which-key").setup({
  plugins = {
    marks = true,
    registers = true,
    spelling = { enabled = true, suggestions = 20 },
  },
})

-- Updated spec format (newer which-key version)
local wk = require("which-key")
wk.add({
  { "<leader>c", group = "Code Diag" },
  { "<leader>d", group = "Debug/DAP" },
  { "<leader>f", group = "Find (Telescope)" },
  { "<leader>g", group = "Git" },
  { "<leader>t", group = "Toggle" },
})

-- Add diagnostic mappings
map('n', '<leader>cd', ':lua vim.diagnostic.open_float()<CR>', { desc = "show diagnostics" })
map('n', '<leader>cdl', ':lua vim.diagnostic.setqflist()<CR>', { desc = "list all diagnostics" })
map('n', ']d', ':lua vim.diagnostic.goto_next()<CR>', { desc = "next diagnostic" })
map('n', '[d', ':lua vim.diagnostic.goto_prev()<CR>', { desc = "previous diagnostic" })
