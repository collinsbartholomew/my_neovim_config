return {
    {
        "mfussenegger/nvim-dap",
        event = "VeryLazy",
        dependencies = {
            {
                "rcarriga/nvim-dap-ui",
                dependencies = {
                    "nvim-neotest/nvim-nio",
                },
                config = function()
                    local dap, dapui = require("dap"), require("dapui")
                    dapui.setup({
                        controls = {
                            element = "repl",
                            enabled = true,
                        },
                        layouts = {
                            {
                                elements = {
                                    { id = "scopes", size = 0.25 },
                                    { id = "breakpoints", size = 0.25 },
                                    { id = "stacks", size = 0.25 },
                                    { id = "watches", size = 0.25 },
                                },
                                position = "left",
                                size = 40,
                            },
                            {
                                elements = {
                                    { id = "repl", size = 0.5 },
                                    { id = "console", size = 0.5 },
                                },
                                position = "bottom",
                                size = 10,
                            },
                        },
                    })
                    -- Auto open/close dapui
                    dap.listeners.after.event_initialized["dapui_config"] = function()
                        dapui.open()
                    end
                    dap.listeners.before.event_terminated["dapui_config"] = function()
                        dapui.close()
                    end
                    dap.listeners.before.event_exited["dapui_config"] = function()
                        dapui.close()
                    end
                end,
            },
            { "theHamsta/nvim-dap-virtual-text" },
            { "nvim-telescope/telescope-dap.nvim" },
        },
        config = function()
            require("core.dap").setup()
        end,
    },
}
