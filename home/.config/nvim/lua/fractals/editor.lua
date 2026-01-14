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
map('n', '<leader>dh', function() require('dap.ui.widgets').hover() end, { desc = "hover/inspect variable" })
map('n', '<leader>de', function() require('dap').repl.open() end, { desc = "open debug repl" })
map('n', '<leader>dv', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.scopes)
end, { desc = "view scopes" })

-- dap function keys
map('n', '<F5>', dap.continue, { desc = "dap continue" })
map('n', '<F6>', dap.step_over, { desc = "dap step over" })
map('n', '<F7>', dap.step_into, { desc = "dap step into" })
map('n', '<F8>', dap.step_out, { desc = "dap step out" })
map('n', '<F9>', dap.toggle_breakpoint, { desc = "dap toggle breakpoint" })
map('n', '<F10>', dapui.toggle, { desc = "dap ui toggle" })
map('n', '<F12>', dap.clear_breakpoints, { desc = "dap clear breakpoints" })

-----------------------------------------------------------
-- todo-comments mappings
-----------------------------------------------------------
-- Search todos with Telescope
map('n', '<leader>ft', ':TodoTelescope<CR>', { desc = "find todos" })
-- Jump to next/prev todo
map('n', ']t', function() require("todo-comments").jump_next() end, { desc = "next todo" })
map('n', '[t', function() require("todo-comments").jump_prev() end, { desc = "previous todo" })

-----------------------------------------------------------
-- trouble.nvim mappings
-----------------------------------------------------------
map('n', '<leader>xx', ':Trouble diagnostics toggle<CR>', { desc = "toggle trouble diagnostics" })
map('n', '<leader>xw', ':Trouble diagnostics toggle filter.buf=0<CR>', { desc = "buffer diagnostics (trouble)" })
map('n', '<leader>xl', ':Trouble loclist toggle<CR>', { desc = "toggle location list (trouble)" })
map('n', '<leader>xq', ':Trouble qflist toggle<CR>', { desc = "toggle quickfix (trouble)" })
map('n', '<leader>xr', ':Trouble lsp_references<CR>', { desc = "LSP references (trouble)" })

-----------------------------------------------------------
-- actions-preview mappings
-----------------------------------------------------------
-- Override default code action with preview
map('n', '<leader>cap', function() require("actions-preview").code_actions() end, { desc = "code actions preview" })

-----------------------------------------------------------
-- refactoring.nvim mappings
-----------------------------------------------------------
-- Extract function (visual mode)
map('x', '<leader>re', function() require('refactoring').refactor('Extract Function') end, { desc = "extract function" })
map('x', '<leader>rf', function() require('refactoring').refactor('Extract Function To File') end, { desc = "extract function to file" })
-- Extract variable
map('x', '<leader>rv', function() require('refactoring').refactor('Extract Variable') end, { desc = "extract variable" })
-- Inline variable
map('n', '<leader>ri', function() require('refactoring').refactor('Inline Variable') end, { desc = "inline variable" })

-----------------------------------------------------------
-- venv-selector mappings (Python only)
-----------------------------------------------------------
map('n', '<leader>vs', ':VenvSelect<CR>', { desc = "select python venv" })
map('n', '<leader>vc', ':VenvSelectCached<CR>', { desc = "select cached venv" })

-----------------------------------------------------------
-- persistence.nvim (session) mappings
-----------------------------------------------------------
map('n', '<leader>qs', function() require("persistence").load() end, { desc = "restore session" })
map('n', '<leader>ql', function() require("persistence").load({ last = true }) end, { desc = "restore last session" })
map('n', '<leader>qd', function() require("persistence").stop() end, { desc = "don't save session" })

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
    spelling = { enabled = false, suggestions = 20 },
  },
})

-- Updated spec format (newer which-key version)
local wk = require("which-key")
wk.add({
  { "<leader>c", group = "Code/Diag" },
  { "<leader>d", group = "Debug/DAP" },
  { "<leader>f", group = "Find (Telescope)" },
  { "<leader>g", group = "Git" },
  { "<leader>t", group = "Toggle" },
  { "<leader>x", group = "Trouble/Diagnostics" },
  { "<leader>r", group = "Refactor" },
  { "<leader>v", group = "Venv (Python)" },
  { "<leader>q", group = "Quit/Session" },
})

-- Add diagnostic mappings
map('n', '<leader>cd', ':lua vim.diagnostic.open_float()<CR>', { desc = "show diagnostics" })
map('n', '<leader>cdl', ':lua vim.diagnostic.setqflist()<CR>', { desc = "list all diagnostics" })
map('n', ']d', ':lua vim.diagnostic.goto_next()<CR>', { desc = "next diagnostic" })
map('n', '[d', ':lua vim.diagnostic.goto_prev()<CR>', { desc = "previous diagnostic" })
