-- added-by-agent: web-setup 20251020-173000
-- mason: none
-- manual: none

local M = {}

function M.setup()
    local which_key_status, which_key = pcall(require, "which-key")
    if not which_key_status then
        vim.notify("which-key not available for web mappings", vim.log.levels.WARN)
        return
    end

    which_key.register({
        j = {
            name = "JavaScript/TypeScript",
            a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
            d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Definition" },
            D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Declaration" },
            e = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to Definition" },
            f = { "<cmd>lua vim.lsp.buf.format({ async = true })<cr>", "Format" },
            h = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover" },
            i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Implementation" },
            l = { "<cmd>lua vim.diagnostic.open_float()<cr>", "Line Diagnostics" },
            n = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
            r = { "<cmd>lua require('profile.core.functions').run_npm_script()<cr>", "Run NPM Script" },
            R = { "<cmd>lua vim.lsp.buf.references()<cr>", "References" },
            s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
            t = { "<cmd>lua vim.lsp.buf.type_definition()<cr>", "Type Definition" },
        },
        m = {
            name = "MERN Stack",
            c = { "<cmd>lua _G.web_utils.create_express_route()<cr>", "Create Express Route" },
            d = { "<cmd>lua require('dap').continue()<cr>", "Debug Application" },
            i = { "<cmd>MongoConnect<cr>", "Connect to MongoDB" },
            r = { "<cmd>StartDev<cr>", "Run Dev Server" },
            s = { "<cmd>StartDev<cr>", "Start Server" },
            t = { "<cmd>WebTest<cr>", "Run Tests" },
        },
        w = {
            name = "Web",
            b = { "<cmd>lua _G.web_utils.create_react_component()<cr>", "Create React Component" },
            B = { "<cmd>WebBuild<cr>", "Build Project" },
            c = { "<cmd>lua require('profile.core.functions').run_npm_script()<cr>", "Run NPM Script" },
            C = { "<cmd>lua require('profile.core.functions').run_yarn_script()<cr>", "Run Yarn Script" },
            d = { "<cmd>lua require('dap').continue()<cr>", "Debug Application" },
            f = { "<cmd>WebFormat<cr>", "Format Code" },
            i = { "<cmd>PnpmInstall<cr>", "Install Dependencies (pnpm)" },
            I = { "<cmd>NpmInstall<cr>", "Install Dependencies (npm)" },
            j = { "<cmd>lua require('profile.core.functions').run_npm_script()<cr>", "Run NPM Script" },
            r = { "<cmd>StartDevPnpm<cr>", "Start Dev Server (pnpm)" },
            R = { "<cmd>StartDev<cr>", "Start Dev Server (npm)" },
            s = { "<cmd>lua require('profile.core.functions').run_pnpm_script()<cr>", "Run PNPM Script" },
            t = { "<cmd>lua require('telescope.builtin').find_files({ cwd = 'src' })<cr>", "Find Source Files" },
            T = { "<cmd>WebTest<cr>", "Run Tests" },
        },
        d = {
            name = "Debug",
            b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
            B = { "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", "Conditional Breakpoint" },
            c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
            C = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
            d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
            g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
            i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
            o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
            O = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
            p = { "<cmd>lua require'dap'.pause()<cr>", "Pause" },
            r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
            s = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
            q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
            u = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle UI" },
            U = { "<cmd>lua require'dap'.up()<cr>", "Up Stack" },
            D = { "<cmd>lua require'dap'.down()<cr>", "Down Stack" },
        },
        s = {
            name = "Software Engineering",
            e = { "<cmd>lua require('telescope.builtin').diagnostics()<cr>", "Show Diagnostics" },
            f = { "<cmd>lua vim.lsp.buf.format({ async = true })<cr>", "Format File" },
            r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename Symbol" },
            c = { "<cmd>lua require('telescope.builtin').git_status()<cr>", "Git Changes" },
        },
    }, { prefix = "<leader>" })
end

return M