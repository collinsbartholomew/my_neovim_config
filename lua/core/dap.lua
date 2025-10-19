local M = {}

function M.setup()
    -- Initialize DAP first
    local dap = require("dap")

    -- Configure dap-ui with error handling
    local status_ok, dapui = pcall(require, "dapui")
    if not status_ok then
        vim.notify("nvim-dap-ui not found. Please install it with your package manager.", vim.log.levels.WARN)
        return
    end

    -- Set up DAP event listeners
    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
    end

    -- Set up DAP UI
    dapui.setup({
        layouts = {
            {
                elements = {
                    { id = "scopes", size = 0.25 },
                    { id = "breakpoints", size = 0.25 },
                    { id = "stacks", size = 0.25 },
                    { id = "watches", size = 0.25 },
                },
                position = "left",
                size = 40
            },
            {
                elements = {
                    { id = "repl", size = 0.5 },
                    { id = "console", size = 0.5 }
                },
                position = "bottom",
                size = 10
            }
        },
        icons = {
            expanded = "▾",
            collapsed = "▸",
            current_frame = "▸"
        },
        controls = {
            icons = {
                pause = "⏸",
                play = "▶",
                step_into = "⏎",
                step_over = "⏭",
                step_out = "⏮",
                step_back = "b",
                run_last = "▶▶",
                terminate = "⏹",
            },
        },
    })

    -- Set up signs
    vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "DapBreakpoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "🟡", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
    vim.fn.sign_define("DapLogPoint", { text = "📝", texthl = "DapLogPoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "⭐", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })

    -- Set up DAP completion
    vim.fn.sign_define("DapStopped", { text = "→", texthl = "DiagnosticWarn" })

    -- Integrate DAP UI
    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
    end

    -- Set up debug keymaps
    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, opts)
    vim.keymap.set("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, opts)
    vim.keymap.set("n", "<leader>dl", function()
        dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
    end, opts)
    vim.keymap.set("n", "<leader>dc", dap.continue, opts)
    vim.keymap.set("n", "<leader>di", dap.step_into, opts)
    vim.keymap.set("n", "<leader>do", dap.step_over, opts)
    vim.keymap.set("n", "<leader>dO", dap.step_out, opts)
    vim.keymap.set("n", "<leader>dr", dap.repl.open, opts)
    vim.keymap.set("n", "<leader>dq", dap.terminate, opts)
    vim.keymap.set("n", "<leader>dh", dapui.eval, opts)
    vim.keymap.set("n", "<leader>du", dapui.toggle, opts)

    -- Common adapter setup (used by multiple language configs)
    dap.adapters.codelldb = {
        type = 'server',
        port = "${port}",
        executable = {
            command = vim.fn.exepath('codelldb'),
            args = { "--port", "${port}" },
        }
    }

    -- Basic configurations that might be extended by language-specific setups
    dap.configurations.cpp = {
        {
            name = "Launch file",
            type = "codelldb",
            request = "launch",
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
        },
    }
    dap.configurations.c = dap.configurations.cpp
    dap.configurations.rust = dap.configurations.cpp
end

return M
