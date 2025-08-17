-- treesitter: https://github.com/nvim-treesitter/nvim-treesitter
require("nvim-treesitter.configs").setup {
  -- parsers to always have installed
  ensure_installed = {
    "bash", "c", "cpp", "cmake", "make",
    "json", "lua", "python", "rust", "yaml",
    "markdown", "vim", "regex", "comment"
  },

  -- install parsers asynchronously
  sync_install = false,

  -- auto-install missing parsers
  auto_install = true,

  -- skip installing these
  ignore_install = { },

  highlight = {
    enable = true,
    -- only keep regex highlighting where it's actually useful
    additional_vim_regex_highlighting = { "markdown" },
  },

  -- treesitter indentation (disable per-language if buggy)
  indent = {
    enable = true,
    disable = { "python" }, -- python indentation is notoriously flaky
  },
}
