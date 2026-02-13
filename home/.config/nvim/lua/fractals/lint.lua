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
-- nvim-lint appends the buffer filename by default; disable that so we can
-- either pass --project= (which forbids extra file args) or append the
-- filename ourselves when no compile_commands.json exists.
local cppcheck = lint.linters.cppcheck
cppcheck.append_fname = false
cppcheck.args = {
  "--enable=warning,style,performance,portability",
  "--inline-suppr",
  "--quiet",
  "--template={file}:{line}:{column}: [{id}] {severity}: {message}",
  function()
    if vim.fn.isdirectory("build") == 1 then
      return "--cppcheck-build-dir=build"
    end
    return nil
  end,
  function()
    if vim.fn.filereadable("build/compile_commands.json") == 1 then
      return "--project=build/compile_commands.json"
    end
    return vim.api.nvim_buf_get_name(0)
  end,
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
