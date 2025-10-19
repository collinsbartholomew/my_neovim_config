local M = {}

function M.setup()
    require("todo-comments").setup({
        signs = true,
        sign_priority = 8,
        keywords = {
            FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
            TODO = { icon = " ", color = "info" },
            HACK = { icon = " ", color = "warning" },
            WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
            PERF = { icon = " ", color = "default", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
            NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
            TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
        },
        highlight = {
            before = "",
            keyword = "wide_bg",
            after = "fg",
            pattern = [[.*<(KEYWORDS)\s*:]],
            comments_only = true,
            max_line_len = 400,
            exclude = {},
        },
        search = {
            command = "rg",
            args = {
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
            },
            pattern = [[\b(KEYWORDS):]],
        },
    })

    -- Move TODO-related keymaps to notes/tasks prefix
    vim.keymap.set("n", "<leader>nt", "<cmd>TodoTelescope<cr>", { desc = "Search TODOs" })
    vim.keymap.set("n", "<leader>nq", "<cmd>TodoTrouble<cr>", { desc = "TODOs Trouble" })
    vim.keymap.set("n", "<leader>nl", "<cmd>TodoLocList<cr>", { desc = "TODOs Location List" })
end

return M
