local M = {}

function M.setup()
    -- Configure CMake integration
    require("cmake-tools").setup({
        cmake_command = "cmake",
        cmake_build_directory = "build",
        cmake_generate_options = { "-D", "CMAKE_EXPORT_COMPILE_COMMANDS=1" },
        cmake_console_size = 10,
        cmake_show_console = "always",
        cmake_variants_message = {
            short = { show = true },
            long = { show = true, max_length = 40 },
        },
    })
end

return M