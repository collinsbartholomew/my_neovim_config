local M = {}

function M.setup()
    -- Configure DAP for C++
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()

    -- C++ debug configuration
    dap.adapters.cppdbg = {
        id = "cppdbg",
        type = "executable",
        command = "/home/collins/.local/share/nvim/mason/bin/cpptools",
        options = {
            detached = false,
        },
    }

    dap.configurations.cpp = {
        {
            name = "Launch file",
            type = "cppdbg",
            request = "launch",
            program = function()
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
            stopAtEntry = true,
            setupCommands = {
                {
                    description = "Enable pretty printing",
                    text = "-enable-pretty-printing",
                    ignoreFailures = false,
                },
            },
        },
    }

    dap.configurations.c = dap.configurations.cpp
end

return M