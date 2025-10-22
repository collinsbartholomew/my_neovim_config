-- added-by-agent: ccpp-setup 20251020
-- mason: codelldb
-- manual: If not using Mason's codelldb: sudo pacman -S lldb gdb

local M = {}

function M.setup()
    local dap_ok, dap = pcall(require, "dap")
    if not dap_ok then
        vim.notify("nvim-dap not available", vim.log.levels.WARN)
        return
    end

    -- Try to get codelldb from Mason first
    local codelldb_path = nil
    local liblldb_path = nil
    local mason_registry = require("mason-registry")
    if mason_registry.is_installed("codelldb") then
        local package = mason_registry.get_package("codelldb")
        local install_path = package:get_install_path()
        codelldb_path = install_path .. "/extension/adapter/codelldb"
        -- Platform specific liblldb path
        if vim.fn.has("mac") == 1 then
            liblldb_path = install_path .. "/extension/lldb/lib/liblldb.dylib"
        elseif vim.fn.has("unix") == 1 then
            liblldb_path = install_path .. "/extension/lldb/lib/liblldb.so"
        elseif vim.fn.has("win32") == 1 then
            liblldb_path = install_path .. "/extension/lldb/bin/liblldb.dll"
        end
    end

    -- Setup codelldb adapter
    dap.adapters.codelldb = {
        type = 'server',
        port = "${port}",
        executable = {
            command = codelldb_path or 'codelldb',
            args = { "--port", "${port}" },
        }
    }

    -- Setup gdb adapter
    dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "--quiet", "--interpreter=dap" }
    }

    -- Common launch configuration for C/C++
    local cpp_config = {
        {
            name = "Launch Program",
            type = "codelldb",
            request = "launch",
            program = function()
                -- Try common build directories first
                local build_dirs = { "build/", "build/bin/", "bin/", "." }
                local executables = {}
                for _, dir in ipairs(build_dirs) do
                    local files = vim.fn.glob(dir .. "*", false, true)
                    for _, file in ipairs(files) do
                        if vim.fn.executable(file) == 1 then
                            table.insert(executables, file)
                        end
                    end
                end

                if #executables > 0 then
                    return vim.fn.input('Path to executable: ', executables[1], 'file')
                else
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            args = {},
        },
        {
            name = "Launch with GDB",
            type = "gdb",
            request = "launch",
            program = function()
                local build_dirs = { "build/", "build/bin/", "bin/", "." }
                local executables = {}
                for _, dir in ipairs(build_dirs) do
                    local files = vim.fn.glob(dir .. "*", false, true)
                    for _, file in ipairs(files) do
                        if vim.fn.executable(file) == 1 then
                            table.insert(executables, file)
                        end
                    end
                end

                if #executables > 0 then
                    return vim.fn.input('Path to executable: ', executables[1], 'file')
                else
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end
            end,
            cwd = '${workspaceFolder}',
            stopAtBeginningOfMainSubprogram = false,
        },
        {
            name = "Attach to Process (CodeLLDB)",
            type = "codelldb",
            request = "attach",
            pid = require('dap.utils').pick_process,
            args = {},
        },
        {
            name = "Attach to Process (GDB)",
            type = "gdb",
            request = "attach",
            pid = require('dap.utils').pick_process,
            args = {},
        }
    }

    -- Apply the same config for both C and C++
    dap.configurations.cpp = cpp_config
    dap.configurations.c = cpp_config

    -- Setup DAP UI if available
    pcall(function()
        require("dapui").setup()

        -- Auto-open DAP UI when debug session starts
        dap.listeners.after.event_initialized["dapui_config"] = function()
            require("dapui").open()
        end

        -- Auto-close DAP UI when debug session ends
        dap.listeners.before.event_terminated["dapui_config"] = function()
            require("dapui").close()
        end
        
        -- Close DAP UI on exit
        dap.listeners.before.event_exited["dapui_config"] = function()
            require("dapui").close()
        end
    end)
end

return M