-- added-by-agent: flutter-setup 20251020-160000
-- mason: dart-debug-adapter
-- manual: flutter/dart/fvm install commands listed in README

local M = {}

function M.setup()
    local whichkey_status, wk = pcall(require, "which-key")
    if not whichkey_status then
        vim.notify("which-key not available for Flutter mappings", vim.log.levels.WARN)
        return
    end

    wk.register({
        f = {
            name = "Flutter",
            r = {
                name = "Run",
                f = { "<cmd>FlutterRun<cr>", "Run Flutter App" },
                h = { "<cmd>FlutterReload<cr>", "Hot Reload" },
                R = { "<cmd>lua require('flutter-tools').restart()<cr>", "Full Restart" },
            },
            t = { "<cmd>FlutterTest<cr>", "Run Tests" },
            d = { "<cmd>FlutterDoctor<cr>", "Flutter Doctor" },
        },
        d = {
            name = "Debug",
            d = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
            b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
            r = { "<cmd>lua require'dap'.repl.open()<cr>", "Open REPL" },
            s = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
            i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
            o = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
            u = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle DAP UI" },
        },
        v = {
            name = "Devices/DevTools",
            d = {
                function()
                    local telescope_status, telescope = pcall(require, "telescope")
                    if telescope_status then
                        vim.cmd("FlutterDevices")
                    else
                        vim.cmd("FlutterDevices")
                    end
                end,
                "Select Device"
            },
            v = { "<cmd>DevTools<cr>", "Open DevTools" },
        },
    }, { prefix = "<leader>" })
end

return M