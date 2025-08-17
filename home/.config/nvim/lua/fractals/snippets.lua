-- comment plugin
require("Comment").setup()

-- toggleterm terminal integration
require("toggleterm").setup {
  size = 20,
  open_mapping = [[<c-\>]],
  direction = "float",
}

-- which-key (keymap discovery)
require("which-key").setup()

-- gitsigns (git integration)
require("gitsigns").setup()

-- fugitive has no setup, commands like :Git and :Gdiffsplit just work

-- sleuth has no setup, it auto-detects indent settings
