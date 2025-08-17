-- autocommand groups
-- Define autocommands with Lua APIs
-- See: h:api-autocmd, h:augroup
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Yank highlight
augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
  group = 'YankHighlight',
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 1000 })
  end
})

-- Remove trailing whitespace on save
autocmd('BufWritePre', {
  pattern = '*',
  callback = function()
    vim.cmd([[%s/\s\+$//e]])
  end
})

-- Disable auto-commenting
autocmd('BufEnter', {
  pattern = '*',
  command = 'set fo-=c fo-=r fo-=o'
})

-- Terminal settings
local term_group = augroup('TerminalSettings', { clear = true })
vim.api.nvim_create_user_command('Term', 'botright vsplit term://$SHELL', {})
autocmd('TermOpen', {
  group = term_group,
  callback = function()
    vim.opt_local.listchars = ""
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.cursorline = false
    vim.cmd('startinsert')
  end
})
autocmd('BufLeave', {
  group = term_group,
  pattern = 'term://*',
  command = 'stopinsert'
})
