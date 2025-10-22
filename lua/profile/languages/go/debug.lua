---
-- Go DAP configuration (delve)
-- Mason package: delve
local M = {}

function M.setup()
    local dap_status_ok, dap = pcall(require, "dap")
    if not dap_status_ok then
        vim.notify("nvim-dap not available", vim.log.levels.WARN)
        return
    end

    -- Setup delve adapter
    dap.adapters.dlv = {
        type = "executable",
        command = "dlv",
        args = {"dap", "-l", "127.0.0.1:38697"},
    }

    -- Debug configurations
    dap.configurations.go = {
        {
            type = "dlv",
            name = "Debug",
            request = "launch",
            program = ".",
        },
        {
            type = "dlv",
            name = "Debug test",
            request = "launch",
            mode = "test",
            program = ".",
        },
        {
            type = "dlv",
            name = "Debug test (go.mod)",
            request = "launch",
            mode = "test",
            program = "./${relativeFileDirname}",
        },
        {
            type = "dlv",
            name = "Debug executable",
            request = "launch",
            mode = "exec",
            program = function()
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
        },
        {
            type = "dlv",
            name = "Attach",
            request = "attach",
            processId = require("dap.utils").pick_process,
        },
        {
            type = "dlv",
            name = "Debug benchmark",
            request = "launch",
            mode = "test",
            program = ".",
            args = {"-test.bench=."},
        },
    }

    -- Setup dap-go
    local dapgo_status_ok, dapgo = pcall(require, "dap-go")
    if dapgo_status_ok then
        dapgo.setup({
            dap_configurations = {
                {
                    type = "go",
                    name = "Attach remote",
                    mode = "remote",
                    request = "attach",
                },
            },
            delve = {
                path = "dlv",
                initialize_timeout_sec = 20,
                port = "${port}",
                args = {},
                build_flags = "",
            },
        })
    end

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

    require("profile.languages.go.mappings").dap()
end

return M