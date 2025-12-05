-- mason package manager: https://github.com/mason-org/mason.nvim
require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  },
  pip = {
    python_cmd = "/usr/bin/python",
    upgrade_pip = true,
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
