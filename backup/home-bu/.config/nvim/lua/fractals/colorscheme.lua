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

-- tokyonight: https://github.com/folke/tokyonight.nvim
require("tokyonight").setup({
  -- your configuration comes here
  -- or leave it empty to use the default settings
  style = "storm",        -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
  light_style = "day",    -- The theme is used when the background is set to light
  transparent = false,    -- Enable this to disable setting the background color
  terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
  styles = {
    -- Style to be applied to different syntax groups
    -- Value is any valid attr-list value for `:help nvim_set_hl`
    comments = { italic = true },
    keywords = { italic = true },
    functions = {},
    variables = {},
    -- Background styles. Can be "dark", "transparent" or "normal"
    sidebars = "dark",              -- style for sidebars, see below
    floats = "dark",                -- style for floating windows
  },
  sidebars = { "qf", "help" },      -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
  day_brightness = 0.3,             -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
  hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
  dim_inactive = false,             -- dims inactive windows
  lualine_bold = false,             -- When `true`, section headers in the lualine theme will be bold
  --- You can override specific color groups to use other groups or a hex color
  --- function will be called with a ColorScheme table
  ---@param colors ColorScheme
  on_colors = function(colors)
  end,
  --- You can override specific highlights to use other groups or a hex color
  --- function will be called with a Highlights and ColorScheme table
  ---@param highlights Highlights
  ---@param colors ColorScheme
  on_highlights = function(highlights, colors)
  end,
})

vim.cmd [[colorscheme tokyonight-storm]]
