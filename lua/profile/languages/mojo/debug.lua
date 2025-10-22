---
-- Mojo DAP configuration
local M = {}

function M.setup()
    local dap_ok, dap = pcall(require, "dap")
    local dapui_ok, dapui = pcall(require, "dapui")

    if not (dap_ok and dapui_ok) then
        return
    end

    -- Setup dap-ui
    dapui.setup()

    -- Register dapui hooks
    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
    end

    -- LLDB adapter for Mojo debugging
    dap.adapters.lldb = {
        type = "executable",
        command = "lldb-vscode",
        name = "lldb"
    }

    -- Codelldb adapter as alternative
    dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
            command = "codelldb",
            args = {"--port", "${port}"},
        }
    }

    -- Mojo debug configurations
    dap.configurations.mojo = {
        {
            name = "Launch Mojo File",
            type = "lldb",
            request = "launch",
            program = function()
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            args = {},
        },
        {
            name = "Launch with args",
            type = "lldb",
            request = "launch",
            program = function()
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            args = function()
                local args_string = vim.fn.input("Arguments: ")
                return vim.split(args_string, " ", {trimempty = true})
            end,
        },
        {
            name = "Attach to process",
            type = "lldb",
            request = "attach",
            pid = function()
                return vim.fn.input("PID: ")
            end,
            cwd = "${workspaceFolder}",
        },
    }

    require('profile.languages.mojo.mappings').dap()
end

return M