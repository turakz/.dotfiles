-- lua/fractals/plugins.lua
-- Plugin management with lazy.nvim

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin specifications
require("lazy").setup({
  -- Editing
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
  },

  -- Completion engine
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/vim-vsnip",
      "hrsh7th/vim-vsnip-integ",
    },
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "stevearc/dressing.nvim"
    },
    config = function()
      require("nvim-tree").setup({
        renderer = {
          group_empty = false,
        },
        filters = {
          dotfiles = false,
        },
        view = {
          adaptive_size = false,
        },
      })
    end,
  },

  -- Better UI for vim.ui.select/input
  {
    "stevearc/dressing.nvim",
    lazy = true,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master", -- pin to backwards compat branch
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
    },
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
  },
  {
    "williamboman/mason-lspconfig.nvim",
  },

  -- Clangd extensions
  {
    "p00f/clangd_extensions.nvim",
    dependencies = { "neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp" },
    ft = { "c", "cpp" },
  },

  -- c++ tools
  {
    "Badhi/nvim-treesitter-cpp-tools",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "cpp", "c" },
    config = function()
      require("nt-cpp-tools").setup({
        preview = {
          quit = 'q',
          accept = '<tab>'
        },
        header_extension = 'h',
        source_extension = 'cpp',
      })
    end,
  },

  -- Linting
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
  },

  -- Flutter
  {
    "akinsho/flutter-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
      "williamboman/mason.nvim"
    },
    ft = "dart",
  },

  -- DAP/Debugging
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "mfussenegger/nvim-dap-python",
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  },
  {
    "mfussenegger/nvim-dap-python",
    dependencies = { "mfussenegger/nvim-dap" },
    ft = "python",
  },
  -- inlined dap state
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        filter_references_pattern = '<module',
        virt_text_pos = 'eol',
      })
    end,
  },

  -- Render ANSI escape codes as highlights in dap-repl / dap-ui console buffers
  -- (regular text buffers otherwise print raw escape sequences like ^[[32m).
  -- submodules=false: baleia's test suite references a submodule with a broken
  -- git modules path; skipping it avoids lazy.nvim's install-time submodule error.
  {
    "m00qek/baleia.nvim",
    tag = "v1.4.0",
    submodules = false,
    dependencies = { "mfussenegger/nvim-dap" },
  },

  -- python virtual environment selector
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    ft = "python",
    config = function()
      require("venv-selector").setup({
        auto_refresh = true,
      })
    end,
  },

  -- Glyphs
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- Colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
  },

  -- Commenting
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
  },

  -- TODO comments highlighting
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("todo-comments").setup({
        signs = true,
        keywords = {
          FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
          TODO = { icon = " ", color = "info" },
          HACK = { icon = " ", color = "warning" },
          WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
          PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
          NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
          TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
        },
      })
    end,
  },

  -- Better diagnostics list
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup({
        position = "bottom",
        height = 10,
        icons = true,
        mode = "workspace_diagnostics",
        fold_open = "",
        fold_closed = "",
        group = true,
        padding = true,
        action_keys = {
          close = "q",
          cancel = "<esc>",
          refresh = "r",
          jump = { "<cr>", "<tab>" },
          open_split = { "<c-x>" },
          open_vsplit = { "<c-v>" },
          open_tab = { "<c-t>" },
          jump_close = { "o" },
          toggle_mode = "m",
          toggle_preview = "P",
          hover = "K",
          preview = "p",
          close_folds = { "zM", "zm" },
          open_folds = { "zR", "zr" },
          toggle_fold = { "zA", "za" },
          previous = "k",
          next = "j"
        },
      })
    end,
  },

  -- Better quickfix window
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = function()
      require("bqf").setup({
        auto_enable = true,
        preview = {
          win_height = 12,
          win_vheight = 12,
          delay_syntax = 80,
          border_chars = { '┃', '┃', '━', '━', '┏', '┓', '┗', '┛', '█' },
        },
        func_map = {
          vsplit = '',
          ptogglemode = 'z,',
          stoggleup = ''
        },
        filter = {
          fzf = {
            action_for = { ['ctrl-s'] = 'split' },
            extra_opts = { '--bind', 'ctrl-o:toggle-all', '--prompt', '> ' }
          }
        }
      })
    end,
  },

  -- Code actions preview
  {
    "aznhe21/actions-preview.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("actions-preview").setup({
        telescope = {
          sorting_strategy = "ascending",
          layout_strategy = "vertical",
          layout_config = {
            width = 0.8,
            height = 0.9,
            prompt_position = "top",
            preview_cutoff = 20,
            preview_height = function(_, _, max_lines)
              return max_lines - 15
            end,
          },
        },
      })
    end,
  },

  -- Refactoring support
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "lewis6991/async.nvim",
    },
    config = function()
      require("refactoring").setup({
        prompt_func_return_type = {
          cpp = true,
          c = true,
        },
        prompt_func_param_type = {
          cpp = true,
          c = true,
        },
      })
    end,
  },

  -- Session management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    config = function()
      require("persistence").setup({
        dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
        options = { "buffers", "curdir", "tabpages", "winsize" },
      })
    end,
  },

  -- Toggleterm
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
  },

  -- Which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
  },

  -- Git
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gstatus", "Gblame", "Gpush", "Gpull" },
  },

  -- CMake tools
  {
    "Civitasv/cmake-tools.nvim",
    ft = { "c", "cpp", "cmake" },
  },

  -- Neovim tasks
  {
    "Shatur/neovim-tasks",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  {
    "Sarctiann/mojo.nvim",
    main = "mojo",
    opts = {
      keymaps = { signature_help = "<C-k>" },
      debug = {
        search_for = {
          { name = "lldb-dap", role = "dap" },
          { name = "mojo-lldb-dap", role = "dap" },
          { name = "_mojo-lldb-dap", role = "dap" },
          { name = "mojo-lldb", role = "native" },
          { name = "lldb", role = "native" },
        },
      },
    },
    config = function(_, opts)
      require("mojo").setup(opts)

      -- Mirror of the plugin's private setup_run_terminal(): themed winbar,
      -- clean statusline, q/<Esc>/<CR> close in normal + terminal modes.
      local function style_run_terminal()
        local buf = vim.api.nvim_get_current_buf()
        local win = vim.api.nvim_get_current_win()
        vim.bo[buf].buflisted = false
        vim.b[buf].mojo_run = true
        vim.api.nvim_set_hl(0, "MojoRunWinBar", { bg = "#f0903a", fg = "#ffffff" })
        vim.wo[win].winbar = "%#MojoRunWinBar#  Press [q] [Esc] or [Enter] to close this pane  "
        vim.wo[win].winhl = "Normal:NormalFloat"
        vim.wo[win].statusline = " "
        local km = { noremap = true, silent = true }
        for _, mode in ipairs({ "n", "t" }) do
          local rhs = mode == "n" and ":close<CR>" or "<C-\\><C-N>:close<CR>"
          for _, key in ipairs({ "q", "<Esc>", "<CR>" }) do
            vim.api.nvim_buf_set_keymap(buf, mode, key, rhs, km)
          end
        end
        vim.api.nvim_create_autocmd("WinEnter", { buffer = buf, callback = function()
          local cur = vim.api.nvim_get_current_win()
          if vim.api.nvim_win_is_valid(cur) and vim.api.nvim_win_get_buf(cur) == buf then
            vim.wo[cur].statusline = " "
          end
        end })
      end

      -- :MojoTest — run current file with `-I <project root>` (Modular stdlib
      -- layout: named package at workspace root, imports resolve via that -I).
      vim.api.nvim_create_user_command("MojoTest", function()
        if vim.bo.filetype ~= "mojo" then
          return vim.notify("MojoTest: not a Mojo file", vim.log.levels.ERROR)
        end
        local file = vim.fn.expand("%:p")
        local mojo = require("mojo.env").get_mojo_cmd()
        local root = require("mojo.env.util").root_for(file)
        if not (mojo and root) then
          return vim.notify("MojoTest: missing mojo binary or project root", vim.log.levels.ERROR)
        end
        vim.cmd(("belowright terminal %s run -I %s %s"):format(
          mojo, vim.fn.shellescape(root), vim.fn.shellescape(file)))
        style_run_terminal()
      end, { desc = "Run current Mojo file with <project root> on -I" })

      -- mojo-lsp-server takes -I as a CLI arg (per --help); its LSP settings
      -- don't expose an equivalent. Modular stdlib layout: source is a named
      -- package at root, tests under test/ mirror the source tree.
      vim.lsp.config("mojo", {
        cmd = function(dispatchers, config)
          local root = (config and config.root_dir) or vim.fn.getcwd()
          local server = require("mojo.env").get_lsp_cmd(root) or { "mojo-lsp-server" }
          table.insert(server, "-I")
          table.insert(server, root)
          return vim.lsp.rpc.start(server, dispatchers, {
            cwd = config and config.cmd_cwd,
            env = config and config.cmd_env,
            detached = config and config.detached,
          })
        end,
      })

      -- Patch the plugin's debug build to inject `-I <root>` (same convention
      -- as LSP + MojoTest — the plugin's `mojo build` invocation omits it,
      -- so cross-package imports fail to resolve during the debug build).
      require("mojo.adapters.dap").build = function()
        local file = vim.fn.expand("%:p")
        local mojo = require("mojo.env").get_mojo_cmd()
        local root = require("mojo.env.util").root_for(file)
        if not (mojo and root and file ~= "") then
          vim.notify("Mojo debug: missing mojo binary, project root, or file",
            vim.log.levels.ERROR)
          return nil
        end
        local dbg_dir = vim.fs.joinpath(root, "_mojo-debug")
        vim.fn.mkdir(dbg_dir, "p")
        local out = vim.fs.joinpath(dbg_dir, vim.fn.fnamemodify(file, ":t:r") .. ".bin")
        local result = vim.fn.system({
          mojo, "build", "--debug-level=full", "-O0",
          "-I", root, file, "-o", out,
        })
        if vim.v.shell_error ~= 0 then
          vim.notify("Mojo debug: build failed\n" .. result, vim.log.levels.ERROR)
          return nil
        end
        return out
      end
    end,
  },
})
