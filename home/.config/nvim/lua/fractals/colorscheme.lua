-- onedark: https://github.com/navarasu/onedark.nvim
--[[
require('onedark').setup  {
    -- main options --
    style = 'deep', -- default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
    transparent = false,  -- show/hide background
    term_colors = true, -- change terminal color as per the selected theme style
    ending_tildes = false, -- show the end-of-buffer tildes. By default they are hidden
    cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

    -- toggle theme style ---
    toggle_style_key = nil, -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
    toggle_style_list = {'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'}, -- List of styles to toggle between

    -- change code style ---
    -- options are italic, bold, underline, none
    -- you can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
    code_style = {
        comments = 'italic',
        keywords = 'none',
        functions = 'none',
        strings = 'none',
        variables = 'none'
    },

    -- lualine options --
    lualine = {
        transparent = false, -- lualine center bar transparency
    },

    -- custom colors --
    colors = {
      bright_orange = "#ff8800",    -- define a new color
      green = '#00ffaa',            -- redefine an existing color
    },

    -- custom highlights --
    highlights = {
      TSKeyword = {fg = '$green'},
      TSString = {fg = '$bright_orange', bg = '#00ff00', fmt = 'bold'},
      TSFunction = {fg = '#0000ff', sp = '$cyan', fmt = 'underline,italic'},
      TSFuncBuiltin = {fg = '#0059ff'}
    },

    -- plugins config --
    diagnostics = {
        darker = true, -- darker colors for diagnostic
        undercurl = true,   -- use undercurl instead of underline for diagnostics
        background = true,    -- use background color for virtual text
    },
}
]]--
-- vim.cmd[[colorscheme onedark]]

-- tokyonight colorscheme: https://github.com/folke/tokyonight.nvim
require("tokyonight").setup({
  -- base style configuration
  style = "storm",        -- available: "storm", "moon", "night", "day"
  light_style = "day",    -- style used when background is set to light
  transparent = false,    -- disable background color if true
  terminal_colors = true, -- use theme colors in :terminal

  -- syntax highlighting styles
  styles = {
    comments = { italic = true },
    keywords = { italic = true },
    functions = {},
    variables = {},
    sidebars = "dark",   -- can be "dark", "transparent", or "normal"
    floats = "dark",
  },

  -- sidebar and float settings
  sidebars = { "qf", "help" }, -- darker background for these
  day_brightness = 0.3,        -- brightness for "day" style (0 dull → 1 vibrant)

  -- statusline and window behavior
  hide_inactive_statusline = false,
  dim_inactive = false,
  lualine_bold = false,

  -- override callbacks
  on_colors = function(colors) end,
  on_highlights = function(highlights, colors) end,
})

-- apply colorscheme
vim.cmd [[colorscheme tokyonight-storm]]
