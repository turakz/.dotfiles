local lint = require("lint")

-- Configure linters by filetype
lint.linters_by_ft = {
  -- python = { "flake8" },  -- or "ruff" for faster linting
  c = { "cppcheck" },
  cpp = { "cppcheck" },
  -- bash = { "shellcheck" },
  -- sh = { "shellcheck" },
  -- lua = { "luacheck" },
  -- cmake = { "cmakelint" },
  -- rust uses clippy via rust_analyzer LSP, so not needed here
}

-- Custom cppcheck configuration for better C++ support
-- replace args entirely (defaults include filename which conflicts with --project)
local cppcheck = lint.linters.cppcheck
cppcheck.args = {
  "--project=build/compile_commands.json",
  "--enable=warning,style,performance,portability",
  "--std=c++20",
  "--inline-suppr",
  "--quiet",
  "--template={file}:{line}:{column}: [{id}] {severity}: {message}",
}

-- Custom luacheck config (optional - for Neovim Lua config)
lint.linters.luacheck.args = {
  "--globals", "vim",  -- recognize vim as global
  "--formatter", "plain",
  "--codes",
  "--ranges",
  "-"
}

-- Auto-lint on these events
local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = lint_augroup,
  callback = function()
    lint.try_lint()
  end,
})

-- Manual lint trigger
vim.keymap.set("n", "<leader>cl", function()
  lint.try_lint()
end, { desc = "Trigger linting" })
