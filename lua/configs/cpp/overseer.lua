local M = {}

function M.setup()
    local overseer = require("overseer")

    -- Register C++ build templates
    overseer.register_template({
        name = "C++ Build",
        builder = function()
            return {
                cmd = { "make" },
                components = {
                    { "on_output_quickfix", open = true },
                    "default",
                },
            }
        end,
        condition = {
            filetype = { "cpp", "c" },
            callback = function()
                return vim.fn.filereadable("Makefile") == 1
            end,
        },
    })

    -- CMake build template
    overseer.register_template({
        name = "CMake Build",
        builder = function()
            return {
                cmd = { "cmake", "--build", "build" },
                components = {
                    { "on_output_quickfix", open = true },
                    "default",
                },
            }
        end,
        condition = {
            filetype = { "cpp", "c" },
            callback = function()
                return vim.fn.filereadable("CMakeLists.txt") == 1
            end,
        },
    })

    -- Clang compile single file
    overseer.register_template({
        name = "Clang++ Compile",
        builder = function()
            local file = vim.fn.expand("%:p")
            local output = vim.fn.expand("%:r")
            return {
                cmd = { "clang++", "-std=c++17", "-Wall", "-Wextra", file, "-o", output },
                components = {
                    { "on_output_quickfix", open = true },
                    "default",
                },
            }
        end,
        condition = {
            filetype = { "cpp" },
        },
    })
end

return M
