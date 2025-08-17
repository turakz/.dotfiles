-- cmake-tools integration
require("cmake-tools").setup {
  cmake_command = "cmake",
  cmake_build_directory = "build",
  cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
  cmake_build_options = {},
  cmake_console_size = 10,
  cmake_console_position = "belowright",
}

-- neovim-tasks integration
require("tasks").setup {
  default_params = {
    cmake = {
      cmd = "cmake",
      build_dir = "build",
    },
  },
}
