-- added-by-agent: zig-setup 20251020
local M = {}

function M.setup()
    -- Check for DAP availability
    local has_dap, dap = pcall(require, "dap")
    if not has_dap then
        vim.notify("DAP is not available", vim.log.levels.WARN)
        return
    end

    -- Try to find codelldb through different methods
    local codelldb_path
    local extension_path

    -- First try Mason
    local mason_registry = require("mason-registry")
    if mason_registry.is_installed("codelldb") then
        local package = mason_registry.get_package("codelldb")
        local install_path = package:get_install_path()
        
        -- Platform specific paths
        if vim.fn.has("mac") == 1 then
            codelldb_path = install_path .. "/extension/adapter/codelldb"
            extension_path = install_path .. "/extension/lldb/lib/liblldb.dylib"
        elseif vim.fn.has("unix") == 1 then
            codelldb_path = install_path .. "/extension/adapter/codelldb"
            extension_path = install_path .. "/extension/lldb/lib/liblldb.so"
        elseif vim.fn.has("win32") == 1 then
            codelldb_path = install_path .. "/extension/adapter/codelldb.exe"
            extension_path = install_path .. "/extension/lldb/bin/liblldb.dll"
        end
    else
        -- Try system paths
        local possible_paths = {
            vim.fn.exepath("codelldb"),
            "/usr/lib/codelldb/adapter/codelldb",
            "/usr/local/lib/codelldb/adapter/codelldb",
        }

        for _, path in ipairs(possible_paths) do
            if vim.fn.filereadable(path) == 1 then
                codelldb_path = path
                extension_path = vim.fn.fnamemodify(path, ":h:h")
                break
            end
        end
    end

    if not codelldb_path then
        vim.notify([[
      codelldb not found. Please either:
      1. Install via Mason: :MasonInstall codelldb
      2. Install via system package manager:
         sudo pacman -S codelldb
      3. Install manually from https://github.com/vadimcn/vscode-lldb/releases
    ]], vim.log.levels.WARN)
        return
    end

    -- Configure codelldb adapter
    dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
            command = codelldb_path,
            args = { "--port", "${port}" },
        },
    }

    -- Configure Zig debugging with enhanced configurations
    dap.configurations.zig = {
        {
            name = "Launch Zig Program",
            type = "codelldb",
            request = "launch",
            program = function()
                local build_zig = vim.fn.findfile('build.zig', '.;')
                if build_zig ~= '' then
                    -- If build.zig exists, use zig build
                    local target = vim.fn.input('Build target (or empty for default): ', '')
                    if target ~= '' then
                        return vim.fn.input('Path to executable: ', './zig-out/bin/' .. target, 'file')
                    else
                        -- Try to find default executable
                        local files = vim.fn.glob('./zig-out/bin/*', false, true)
                        if #files > 0 then
                            return vim.fn.input('Path to executable: ', files[1], 'file')
                        else
                            return vim.fn.input('Path to executable: ', './zig-out/bin/', 'file')
                        end
                    end
                else
                    -- No build.zig, compile current file
                    local file = vim.fn.expand('%:p')
                    if vim.fn.filereadable(file) == 1 and vim.bo.filetype == 'zig' then
                        local output = vim.fn.fnamemodify(file, ':r')
                        vim.fn.system({'zig', 'build-exe', file})
                        return output
                    else
                        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                    end
                end
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            runInTerminal = false,
            console = "internalConsole",
            args = function()
                return vim.split(vim.fn.input('Arguments: ', ""), " ")
            end,
        },
        {
            name = "Debug Zig Tests",
            type = "codelldb",
            request = "launch",
            program = function()
                -- Build tests
                vim.fn.system({'zig', 'build-exe', '--test', vim.fn.expand('%:p')})
                local test_file = vim.fn.fnamemodify(vim.fn.expand('%:p'), ':r') .. '.test'
                return test_file
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            runInTerminal = false,
            console = "internalConsole",
            args = { "--listen=-" },
        },
        {
            name = "Attach to Process",
            type = "codelldb",
            request = "attach",
            pid = require('dap.utils').pick_process,
            args = {},
        },
        {
            name = "Debug Current File",
            type = "codelldb",
            request = "launch",
            program = function()
                local file = vim.fn.expand('%:p:r')
                vim.fn.system('zig build-exe ' .. vim.fn.expand('%:p'))
                return file
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            runInTerminal = false,
        }
    }

    -- Load DAP UI if available
    local dapui_status_ok, dapui = pcall(require, "dapui")
    if dapui_status_ok then
        dapui.setup()
        
        -- Auto-open DAP UI when debug session starts
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end

        -- Auto-close DAP UI when debug session ends
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
        end
        
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
        end
    end

    -- Load virtual text if available
    local virt_text_status_ok, virt_text = pcall(require, "nvim-dap-virtual-text")
    if virt_text_status_ok then
        virt_text.setup()
    end
end

return M