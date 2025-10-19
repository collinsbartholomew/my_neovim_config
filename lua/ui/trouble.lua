local M = {}

function M.setup()
    require("trouble").setup({
        position = "bottom",
        height = 10,
        width = 50,
        icons = true,
        mode = "workspace_diagnostics",
        fold_open = "",
        fold_closed = "",
        group = true,
        padding = true,
        action_keys = {
            close = "q",
            cancel = "<esc>",
            refresh = "r",
            jump = "<cr>",
            open_split = { "<c-x>" },
            open_vsplit = { "<c-v>" },
            open_tab = { "<c-t>" },
            jump_close = {"o"},
            toggle_mode = "m",
            toggle_preview = "P",
            hover = "K",
            preview = "p",
            close_folds = {"zM", "zm"},
            open_folds = {"zR", "zr"},
            toggle_fold = {"zA", "za"},
            previous = "k",
            next = "j"
        },
        signs = {
            error = "",
            warning = "",
            hint = "",
            information = "",
            other = "﫠"
        },
        use_diagnostic_signs = true,
        auto_preview = false,
        auto_fold = false,
        auto_jump = {},
    })

    -- Keymaps
    vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end)
    vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
    vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
    vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
    vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
    vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)
end

return M
