-- mason nvimdap: https://github.com/jay-babu/mason-nvim-dap.nvim
-- require("mason").setup{}
-- require("mason-nvim-dap").setup{}

-- nvimdapui: https://github.com/rcarriga/nvim-dap-ui
require("dapui").setup({
  console = {
    enabled = true,
    open_on_start = true,
  }
})

-- baleia: colorize ANSI escape codes in dap-repl and any dap-ui text buffers.
-- Terminal buffers (used when console = "integratedTerminal") already render
-- ANSI natively via nvim's :terminal, so this only targets non-terminal DAP buffers.
local baleia = require("baleia").setup({})
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "dap-repl", "dapui_console" },
  callback = function(args)
    baleia.automatically(args.buf)
  end,
})

-- nvimdap: https://github.com/mfussenegger/nvim-dap
-- note for future self bc docs were not obvious
-- dap and dapui provide lua functions once you install the extensions
-- these lua functions can be mapped to keys
-- they correspond to typical debugging stuffs like: toggle break, run to line, step in/over/out, goto next break, evaluate/inspect, hover etc
-- lesson here is: if the docs are thin, consider if theyre just giving you functions that is what actually executes the extension
-- i spent like 2 hours trying to launch dap + gdb without realizing it was working behind the scenes, i had just needed to actually toggle the dapUI on
local dap = require("dap")

-- load vscode launch.json files
--require('dap.ext.vscode').load_launchjs(nil, {
--  gdb = {'c', 'cpp'},
--  cppdbg = {'c', 'cpp'}
--})

-- dap-python: https://github.com/mfussenegger/nvim-dap-python
-- auto-detect .venv in cwd, fallback to system python
local function get_python_path()
  local venv = vim.fn.getcwd() .. '/.venv/bin/python'
  if vim.fn.executable(venv) == 1 then
    return venv
  end
  return 'python'
end

require("dap-python").setup(get_python_path())
table.insert(dap.configurations.python, {
  type = 'python',
  justMyCode = true,
  request = 'launch',
  name = 'cwd:dap-python',
  program = '${file}',
  cwd = '${workspaceFolder}',
  -- ... more options, see https://github.com/microsoft/debugpy/wiki/Debug-configurations-settings
})

table.insert(dap.configurations.python, {
  type = 'python',
  justMyCode = true,
  request = 'launch',
  name = 'cwd:pytest-dap-python',
  module = 'pytest',
})

dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
  -- Performance tuning for large binaries (like alchemy with LLVM symbols)
  options = {
    initialize_timeout_sec = 30,  -- Increase timeout for large symbol tables
    disconnect_timeout_sec = 10,
  }
}

-- lldb adapter (better for c++ templates and llvm-based projects)
-- lldb was built by the llvm team, so it has superior support for:
-- - c++ templates and template instantiations (no hanging on step-over/step-out)
-- - modern c++ features (crtp, std::variant, concepts, ranges)
-- - llvm/clang symbol tables (fast symbol resolution)
-- - stl container pretty-printing (std::vector, std::map, etc.)
-- prefer lldb over gdb for template-heavy c++ codebases
local function find_lldb_dap()
  for _, v in ipairs({ 21, 20, 19, 18 }) do
    local path = "/usr/bin/lldb-dap-" .. v
    if vim.fn.executable(path) == 1 then
      return path
    end
  end
  return "lldb-dap"
end

dap.adapters.lldb = {
  type = "executable",
  command = find_lldb_dap(),
  name = "lldb",
  options = {
    initialize_timeout_sec = 30,
  }
}

-- dap lua: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#local-lua-debugger-vscode
dap.adapters["local-lua"] = {
  type = "executable",
  command = "node",
  args = {
    os.getenv("HOME") .. "/tools/local-lua-debugger-vscode/extension/debugAdapter.js"
  },
  enrich_config = function(config, on_config)
    if not config["extensionPath"] then
      local c = vim.deepcopy(config)
      -- 💀 If this is missing or wrong you'll see
      -- "module 'lldebugger' not found" errors in the dap-repl when trying to launch a debug session
      c.extensionPath = os.getenv("HOME") .. "/tools/local-lua-debugger-vscode/"
      on_config(c)
    else
      on_config(config)
    end
  end,
}

dap.configurations.c = {
  {
    name = "launch lldb",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    args = function()
      local args = vim.fn.input("cmd line args: ")
      return vim.split(args, " +")
    end,
    cwd = function()
      local git_root = vim.fn.systemlist("git rev-parse --show-toplevel 2>/dev/null")[1]
      if vim.v.shell_error == 0 and git_root and git_root ~= "" then
        print("DEBUG: Running from git root: " .. git_root)
        return git_root
      else
        local fallback = vim.fn.getcwd()
        print("DEBUG: No git root found, using cwd: " .. fallback)
        return fallback
      end
    end,
    stopOnEntry = false,
    -- Program stdout goes to nvim's :terminal (renders ANSI natively).
    -- ANSI in dap-repl / dapui_console text buffers is handled by baleia.
    console = "integratedTerminal",
    externalConsole = true,
    -- ASAN_OPTIONS=detect_leaks=0 disables LeakSanitizer's exit-time check
    -- when debugging. LSan works by fork()ing a child that ptrace-attaches to
    -- the parent to walk its memory for unreachable allocations. Under a
    -- debugger the process is already ptrace'd, so LSan's attach fails and it
    -- aborts with "LeakSanitizer has encountered a fatal error" — noise, not a
    -- real leak. Standalone runs keep full leak detection because this env
    -- override only applies to DAP-launched processes.
    --
    -- Format note: lldb-dap expects env as an ARRAY of "KEY=VALUE" strings,
    -- not a KV object. The object form ({ASAN_OPTIONS = "..."}) is silently
    -- ignored by the adapter — the launch appears to accept env, but nothing
    -- actually reaches the target process.
    env = {
      "ASAN_OPTIONS=detect_leaks=0",
    },
  },
  {
    name = "launch gdb",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    args = function()
      local args = vim.fn.input("cmd line args: ")
      return vim.split(args, " +")
    end,
    cwd = function()
      -- find git root to ensure consistent cwd regardless of where nvim is opened
      local git_root = vim.fn.systemlist("git rev-parse --show-toplevel 2>/dev/null")[1]
      if vim.v.shell_error == 0 and git_root and git_root ~= "" then
        print("DEBUG: Running from git root: " .. git_root)
        return git_root
      else
        -- fallback to current directory if not in a git repo
        local fallback = vim.fn.getcwd()
        print("DEBUG: No git root found, using cwd: " .. fallback)
        return fallback
      end
    end,
    stopAtBeginningOfMainSubprogram = false,
  },
  {
    name = "select gdb and attach to process",
    type = "gdb",
    request = "attach",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    pid = function()
      local name = vim.fn.input('Executable name (filter): ')
      return require("dap.utils").pick_process({ filter = name })
    end,
    cwd = '${workspaceFolder}'
  },
  {
    name = 'attach to gdbserver :1234',
    type = 'gdb',
    request = 'attach',
    target = 'localhost:1234',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}'
  }
}

dap.configurations.cpp = dap.configurations.c
dap.configurations.rust = dap.configurations.c

-- dap lua cfg: https://zignar.net/2023/06/10/debugging-lua-in-neovim/
dap.configurations.lua = {
  {
    name = 'lua',
    type = 'local-lua',
    request = 'launch',
    cwd = '${workspaceFolder}',
    program = {
      lua = 'lua', -- or whatever your lua executable is
      file = '${file}',
    },
    args = {},
  },
}

-- debug with a separate terminal
--dap.defaults.fallback.external_terminal = {
--  command = '/usr/bin/env',
--  args = {'tmux', 'split-window', '-h'}
--}
--dap.defaults.fallback.force_external_terminal = true
