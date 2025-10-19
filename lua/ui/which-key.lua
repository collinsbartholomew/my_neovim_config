local M = {}

function M.setup()
    local wk = require("which-key")
    wk.setup({
        plugins = {
            marks = true,
            registers = true,
            presets = {
                operators = false,  -- Disable preset operators
                motions = false,   -- Disable preset motions
                text_objects = false, -- Disable preset text objects
                windows = false,   -- Disable preset windows
                nav = false,      -- Disable preset nav
                z = true,
                g = true,
            },
            spelling = {
                enabled = true,
                suggestions = 20,
            },
        },
        icons = {
            breadcrumb = "»",
            separator = "➜",
            group = "󰙅 ",
        },
        window = {
            border = "rounded",
            position = "bottom",
            margin = { 1, 0, 1, 0 },
            padding = { 1, 1, 1, 1 },
            winblend = 0,
        },
        layout = {
            align = "center",
        },
        ignore_missing = true,    -- Ignore missing mappings
        hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " },
        show_help = true,
        show_keys = true,
        triggers = "auto",
    })

    -- Register base groups first
    wk.register({
        ["g"] = { name = "+goto" },
        ["gz"] = { name = "+surround" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader>"] = {
            b = { name = "+buffer" },
            c = { name = "+code" },
            f = { name = "+file/find" },
            g = { name = "+git" },
            h = { name = "+help" },
            l = { name = "+lsp" },
            s = { name = "+search" },
            t = { name = "+test/task" },
            w = { name = "+window" },
            x = { name = "+diagnostics" },
        },
    })

    -- LSP mappings
    wk.register({
        ["<leader>l"] = {
            name = "+lsp",
            f = { function() vim.lsp.buf.format({ async = true }) end, "Format" },
            r = { function() vim.lsp.buf.rename() end, "Rename" },
            a = { function() vim.lsp.buf.code_action() end, "Code Action" },
            d = { function() vim.lsp.buf.definition() end, "Definition" },
            D = { function() vim.lsp.buf.declaration() end, "Declaration" },
            i = { function() vim.lsp.buf.implementation() end, "Implementation" },
            R = { function() vim.lsp.buf.references() end, "References" },
            h = { function() vim.lsp.buf.hover() end, "Hover Documentation" },
            H = { function() vim.lsp.buf.signature_help() end, "Signature Help" },
        },
    })

    -- Diagnostics mappings
    wk.register({
        ["<leader>x"] = {
            name = "+diagnostics",
            x = { "<cmd>TroubleToggle<cr>", "Toggle Trouble" },
            w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace Diagnostics" },
            d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document Diagnostics" },
            l = { "<cmd>TroubleToggle loclist<cr>", "Location List" },
            q = { "<cmd>TroubleToggle quickfix<cr>", "Quickfix List" },
            n = { function() vim.diagnostic.goto_next() end, "Next Diagnostic" },
            p = { function() vim.diagnostic.goto_prev() end, "Previous Diagnostic" },
        },
    })

    -- Buffer mappings
    wk.register({
        ["<leader>b"] = {
            name = "+buffer",
            b = { "<cmd>Telescope buffers<cr>", "Switch Buffer" },
            d = { "<cmd>bdelete<cr>", "Delete Buffer" },
            D = { "<cmd>bdelete!<cr>", "Delete Buffer (Force)" },
            n = { "<cmd>bnext<cr>", "Next Buffer" },
            p = { "<cmd>bprevious<cr>", "Previous Buffer" },
            f = { "<cmd>Telescope buffers<cr>", "Find Buffer" },
        },
    })
end

return M
