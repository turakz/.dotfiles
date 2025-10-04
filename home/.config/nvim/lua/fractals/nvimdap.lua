-- mason nvimdap: https://github.com/jay-babu/mason-nvim-dap.nvim
-- require("mason").setup{}
-- require("mason-nvim-dap").setup{}

-- nvimdapui: https://github.com/rcarriga/nvim-dap-ui
require("dapui").setup{}

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
-- dap-python: https://github.com/nvim-dap-python
-- venvs
-- require("dap-python").setup("/path/to/venv/bin/python")
-- if using the above, then `/path/to/venv/bin/python -m debugpy --version`
-- must work in the shell
-- normal
require("dap-python").setup("python")
-- if using the above, then `python -m debugpy --version`
-- must work in the shell
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

local dap = require("dap")
dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
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

local dap = require("dap")
dap.configurations.c = {
  {
    name = "Launch",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    args = function()
      local args = vim.fn.input("cmd line args: ")
      return vim.split(args, " +")
    end,
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
  },
  {
    name = "Select and attach to process",
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
    name = 'Attach to gdbserver :1234',
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
