-----------------------------------------------------------
-- lsp.lua
-- LSP setup and keymaps
-- integrates mason
-- can also manually configure
-----------------------------------------------------------

local cmp = require'cmp'

-- completion engine setup
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }, {
    { name = 'buffer' },
  })
})

-- CMD-line completion
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = { { name = 'buffer' } }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } })
})

-- keybindings for LSPs
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  local opts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
end

-- capabilities for nvim-cmp completion engine
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- hover popup customization
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
  max_width = 80,
  max_height = 20,
})


-- manual LSP configs
--require("lspconfig").mojo.setup({
--    cmd = { 'mojo-lsp-server' }, -- Command to start the Mojo LSP server
--    root_dir = require("lspconfig.util").find_git_ancestor, -- Detect project root using Git
--    single_file_support = true, -- Enable LSP features for single Mojo files
--    filetypes = { "mojo", "*.🔥" }, -- File types associated with Mojo
--    on_attach = on_attach,
--    capabilities = capabilities,
--})

local function get_root_dir(fname)
  return vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true, path = fname })[1])
end

-- define a custom vimlspconfig for mojo
local mojo_config = {
  name = "mojo",                     -- must be a string
  cmd = { "mojo-lsp-server" },
  root_dir = get_root_dir(vim.api.nvim_buf_get_name(0)),
  filetypes = { "mojo", "🔥" },      -- avoid using "*.🔥", just the literal filetype name
  single_file_support = true,
  on_attach = on_attach,
  capabilities = capabilities,
}

-- Auto-start for mojo files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "mojo", "🔥" },
  callback = function()
    vim.lsp.start(mojo_config)
  end,
})

-- lspconfig: DEPRECATED
-- Flutter manual setup
require('flutter-tools').setup {
  on_attach = on_attach,
  capabilities = capabilities,
}


-- lspconfig: PREFERRED
-- mason integration
require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

require("mason-lspconfig").setup({
  ensure_installed = {
    "bashls",
    "clangd",
    "cmake",
    "lua_ls",
    "rust_analyzer",
    "powershell_es",
    "pyright"
  },
  automatic_enable = true,
})

-- apply on_attach and capabilities to Mason-managed clients
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local bufnr = ev.buf
    if client and client.server_capabilities then
      -- Apply on_attach keymaps
      on_attach(client, bufnr)
      -- You could apply extra per-client config here if needed
    end
  end,
})
