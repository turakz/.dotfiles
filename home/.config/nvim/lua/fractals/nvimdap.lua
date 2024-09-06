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
dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
}

dap.configurations.c = {
  {
    name = "Launch",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
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
  },
}

dap.configurations.cpp = dap.configurations.c
dap.configurations.rust = dap.configurations.cpp

-- dap-python: https://github.com/mfussenegger/nvim-dap-python
-- venvs
-- require("dap-python").setup("/path/to/venv/bin/python")
-- if using the above, then `/path/to/venv/bin/python -m debugpy --version`
-- must work in the shell
-- normal
require("dap-python").setup("python")
-- if using the above, then `python -m debugpy --version`
-- must work in the shell
