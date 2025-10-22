---
-- Go keymaps and which-key registration
local M = {}
local wk_status_ok, wk = pcall(require, "which-key")
if not wk_status_ok then
    vim.notify("which-key not available", vim.log.levels.WARN)
    return
end

function M.setup()
    wk.register({
        g = {
            name = "Go",
            o = {
                name = "Go",
                b = { "<cmd>GoBuild<cr>", "Build Project" },
                r = { "<cmd>GoRun<cr>", "Run Project" },
                t = { "<cmd>GoTest<cr>", "Run Tests" },
                f = { "<cmd>lua require('conform').format()<CR>", "Format Buffer" },
                c = { "<cmd>GoCoverage<cr>", "Coverage Report" },
                v = { "<cmd>GoVet<cr>", "Run Go Vet" },
                m = { "<cmd>GoModTidy<cr>", "Run Go Mod Tidy" },
                g = { "<cmd>GoGenerate<cr>", "Run Go Generate" },
                l = { "<cmd>GoLint<cr>", "Run Go Lint" },
                d = { "<cmd>GoDoc<cr>", "Show Go Doc" },
                p = { "<cmd>GoPprof<cr>", "Run Go Pprof" },
                B = { "<cmd>GoBench<cr>", "Run Benchmarks" },
                s = { "<cmd>GoSec<cr>", "Security Scan" },
                R = { "<cmd>GoRace<cr>", "Race Detector" },
            },
        },
        r = {
            name = "Run/Test",
            t = { "<cmd>lua require('neotest').run.run(vim.fn.getcwd())<CR>", "Run package tests" },
            tf = { "<cmd>lua require('neotest').run.run()<CR>", "Run test under cursor" },
            rr = { "<cmd>lua require('dap').continue()<CR>", "DAP Continue/Run" },
            rd = { "<cmd>GoLint<CR>", "Run Go Lint" },
            rf = { "<cmd>lua require('conform').format()<CR>", "Format Go buffer" },
        },
        d = {
            name = "Debug",
            b = { "<cmd>lua require('dap').toggle_breakpoint()<CR>", "Toggle Breakpoint" },
            c = { "<cmd>lua require('dap').continue()<CR>", "Continue" },
            v = { "<cmd>lua require('dap').step_over()<CR>", "Step Over" },
            i = { "<cmd>lua require('dap').step_into()<CR>", "Step Into" },
            o = { "<cmd>lua require('dap').step_out()<CR>", "Step Out" },
            r = { "<cmd>lua require('dap').repl.open()<CR>", "Open REPL" },
            u = { "<cmd>lua require('dapui').toggle()<CR>", "Toggle DAP UI" },
            q = { "<cmd>lua require('dap').terminate()<CR>", "Stop Debugging" },
        },
        s = {
            name = "Software Eng.",
            e = {
                name = "Go",
                c = { "<cmd>GoCoverage<cr>", "Coverage" },
                r = { "<cmd>lua require('conform').format()<CR>", "Reformat" },
                t = { "<cmd>GoTest<cr>", "Test" },
                f = { "<cmd>GoModTidy<cr>", "Tidy" },
                l = { "<cmd>GoLint<cr>", "Lint" },
                s = { "<cmd>GoSec<cr>", "Security Scan" },
                R = { "<cmd>GoRace<cr>", "Race Detector" },
            },
        },
    }, { prefix = "<leader>" })
end

function M.lsp(bufnr)
    wk.register({
        ["<leader>lh"] = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Hover" },
        ["<leader>lr"] = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
        ["<leader>la"] = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action" },
        ["<leader>ld"] = { "<cmd>lua vim.diagnostic.open_float()<CR>", "Diagnostics" },
        ["<leader>lf"] = { "<cmd>lua require('conform').format()<CR>", "Format" },
        ["<leader>lg"] = { "<cmd>GoDoc<cr>", "Go Doc" },
        ["<leader>li"] = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Implementation" },
        ["<leader>ls"] = { "<cmd>lua vim.lsp.buf.document_symbol()<CR>", "Document Symbols" },
        ["<leader>lw"] = { "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", "Workspace Symbols" },
        ["<leader>lt"] = { "<cmd>lua vim.lsp.codelens.run()<CR>", "Run CodeLens" },
    }, { buffer = bufnr })
end

function M.dap()
    wk.register({
        ["<leader>db"] = { "<cmd>lua require('dap').toggle_breakpoint()<CR>", "Toggle Breakpoint" },
        ["<leader>dc"] = { "<cmd>lua require('dap').continue()<CR>", "Continue" },
        ["<leader>do"] = { "<cmd>lua require('dap').step_over()<CR>", "Step Over" },
        ["<leader>di"] = { "<cmd>lua require('dap').step_into()<CR>", "Step Into" },
        ["<leader>dO"] = { "<cmd>lua require('dap').step_out()<CR>", "Step Out" },
        ["<leader>dr"] = { "<cmd>lua require('dap').repl.open()<CR>", "Open REPL" },
        ["<leader>du"] = { "<cmd>lua require('dapui').toggle()<CR>", "Toggle DAP UI" },
        ["<leader>dq"] = { "<cmd>lua require('dap').terminate()<CR>", "Stop Debugging" },
        ["<leader>dt"] = { "<cmd>lua require('dap').terminate()<CR>", "Terminate Session" },
        ["<leader>dp"] = { "<cmd>lua require('dap').pause()<CR>", "Pause Execution" },
        ["<leader>dw"] = { "<cmd>lua require('dap.ui.widgets').hover()<CR>", "Widget Hover" },
    })
end

return M