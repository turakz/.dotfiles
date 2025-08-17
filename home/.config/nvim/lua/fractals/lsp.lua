local cmp = require'cmp'
local lspconfig = require'lspconfig'

-- CMP setup
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

-- LSP keybinds
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  local opts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
end

-- capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- configure hover popup to prevent cutoff
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
  max_width = 80,
  max_height = 20,
})

-- clangd
lspconfig.clangd.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
}

-- cmake language server
lspconfig.cmake.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- lua
lspconfig.lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- python
lspconfig.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- flutter
require('flutter-tools').setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- rust
lspconfig.rust_analyzer.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      checkOnSave = true,  -- Changed from object to boolean
      check = {
        command = "clippy"  -- Moved clippy command here
      }
    }
  }
}

-- bash language server
lspconfig.bashls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- powershell (if you use it regularly)
lspconfig.powershell_es.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
}
