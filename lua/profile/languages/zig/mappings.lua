-- added-by-agent: zig-setup 20251020
-- mason: none
-- dependencies: which-key.nvim

local M = {}

function M.setup()
    local ok_whichkey, whichkey = pcall(require, "which-key")
    if not ok_whichkey then
        vim.notify("which-key not available for Zig mappings", vim.log.levels.WARN)
        return
    end

    -- Register Zig-specific mappings
    whichkey.register({
        ["<leader>z"] = {
            name = "Zig",
            b = { "<cmd>ZigBuild<cr>", "Build Project" },
            r = { "<cmd>ZigRun<cr>", "Run Current File" },
            t = { "<cmd>ZigTest<cr>", "Run Tests" },
            f = { "<cmd>ZigFmt<cr>", "Format Buffer" },
            c = { "<cmd>ZigCheck<cr>", "Check Code" },
            d = { "<cmd>ZigDoc<cr>", "Generate Docs" },
            B = { "<cmd>ZigBench<cr>", "Run Benchmarks" },
            v = { "<cmd>ZigCoverage<cr>", "Coverage Report" },
            s = { "<cmd>ZigSanitize<cr>", "Sanitize Build" },
            d = {
                name = "Debug",
                b = { function()
                    require("dap").toggle_breakpoint()
                end, "Toggle Breakpoint" },
                c = { function()
                    require("dap").continue()
                end, "Continue" },
                s = { function()
                    require("dap").step_over()
                end, "Step Over" },
                i = { function()
                    require("dap").step_into()
                end, "Step Into" },
                o = { function()
                    require("dap").step_out()
                end, "Step Out" },
                r = { function()
                    require("dap").repl.open()
                end, "Open REPL" },
                u = { function()
                    require("dapui").toggle()
                end, "Toggle UI" },
                q = { function()
                    require("dap").terminate()
                end, "Stop Debugging" },
            },
        },
        ["<leader>s"] = {
            name = "Software Eng.",
            e = {
                name = "Zig",
                c = { "<cmd>ZigCoverage<cr>", "Coverage" },
                r = { "<cmd>ZigFmt<cr>", "Reformat" },
                t = { "<cmd>ZigTest<cr>", "Test" },
                d = { "<cmd>ZigDoc<cr>", "Documentation" },
            },
        },
    })
end

return M