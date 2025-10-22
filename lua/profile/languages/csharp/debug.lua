-- added-by-agent: csharp-setup 20251020-153000
-- mason: netcoredbg
-- manual: yay -S netcoredbg-bin

local M = {}

local function get_netcoredbg_path()
    -- Check NETCOREDBG_PATH environment variable first
    local netcoredbg_path = os.getenv("NETCOREDBG_PATH")
    if netcoredbg_path and vim.fn.executable(netcoredbg_path) == 1 then
        return netcoredbg_path
    end

    -- Check for Mason installed netcoredbg
    local mason_registry = package.loaded["mason-registry"]
    if mason_registry and mason_registry.is_installed("netcoredbg") then
        local netcoredbg_pkg = mason_registry.get_package("netcoredbg")
        local install_path = netcoredbg_pkg:get_install_path()

        local possible_paths = {
            install_path .. "/netcoredbg",
            install_path .. "/bin/netcoredbg",
            install_path .. "/netcoredbg/netcoredbg",
        }

        for _, path in ipairs(possible_paths) do
            if vim.fn.executable(path) == 1 then
                return path
            end
        end
    end

    -- Check system netcoredbg
    if vim.fn.executable("netcoredbg") == 1 then
        return "netcoredbg"
    end

    -- Fallback - notify user
    vim.notify(
            "netcoredbg not found. Please install via Mason or set NETCOREDBG_PATH.",
            vim.log.levels.WARN
    )

    return nil
end

function M.setup()
    local dap_ok, dap = pcall(require, "dap")
    if not dap_ok then
        vim.notify("nvim-dap not available for C# debug setup", vim.log.levels.ERROR)
        return
    end

    local netcoredbg_path = get_netcoredbg_path()
    if not netcoredbg_path then
        return
    end

    -- Setup coreclr adapter (primary .NET debugger)
    dap.adapters.coreclr = {
        type = "executable",
        command = netcoredbg_path,
        args = { "--interpreter=vscode" }
    }

    -- Setup netcoredbg adapter
    dap.adapters.netcoredbg = {
        type = "executable",
        command = netcoredbg_path,
        args = { "--interpreter=vscode" }
    }

    -- Setup DAP UI if available
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

    -- Setup virtual text if available
    local virt_text_status_ok, virt_text = pcall(require, "nvim-dap-virtual-text")
    if virt_text_status_ok then
        virt_text.setup({
            display_callback = function(variable)
                return string.format("%s = %s", variable.name, variable.value)
            end,
        })
    end

    -- C# specific debug configurations
    dap.configurations.cs = {
        {
            type = "coreclr",
            name = "Launch Project",
            request = "launch",
            program = function()
                -- Try to find the project DLL
                local project_dir = vim.fn.getcwd()
                local build_dir = project_dir .. "/bin/Debug"
                
                -- Try to find any DLL file in the build directory
                local handle = io.popen('find "' .. build_dir .. '" -name "*.dll" -type f | head -n 1')
                if handle then
                    local result = handle:read("*l")
                    handle:close()
                    
                    if result and result ~= "" then
                        return result
                    end
                end
                
                -- Fallback to manual input
                return vim.fn.input('Path to dll or executable: ', project_dir .. '/bin/Debug/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopAtEntry = false,
            args = {},
        },
        {
            type = "coreclr",
            name = "Launch Assembly",
            request = "launch",
            program = function()
                return vim.fn.input('Path to dll or executable: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopAtEntry = false,
            args = {},
        },
        {
            type = "coreclr",
            name = "Attach to Process",
            request = "attach",
            processId = require 'dap.utils'.pick_process,
        },
        {
            type = "coreclr",
            name = "Launch Web API",
            request = "launch",
            program = function()
                local project_dir = vim.fn.getcwd()
                local build_dir = project_dir .. "/bin/Debug"
                
                local handle = io.popen('find "' .. build_dir .. '" -name "*.dll" -type f | head -n 1')
                if handle then
                    local result = handle:read("*l")
                    handle:close()
                    return result or ""
                end
                return ""
            end,
            args = {},
            cwd = '${workspaceFolder}',
            stopAtEntry = false,
            serverReadyAction = {
                pattern = '\\bNow listening on:\\s+(https?://\\S+)',
                uriFormat = '%s',
                action = 'openExternally'
            },
            env = {
                ASPNETCORE_ENVIRONMENT = "Development"
            }
        },
        {
            type = "coreclr",
            name = "Launch Unit Tests",
            request = "launch",
            program = "dotnet",
            args = {"test"},
            cwd = '${workspaceFolder}',
            stopAtEntry = false,
        }
    }

    -- Register DAP keymaps
    require("profile.languages.csharp.mappings").dap()
end

return M