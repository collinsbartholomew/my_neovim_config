local M = {}

-- Load test adapters based on filetype
local adapters = {
    go = "neotest-go",
    python = "neotest-python",
    rust = "neotest-rust",
    lua = "neotest-vim-test",
    javascript = "neotest-jest",
    typescript = "neotest-jest",
}

function M.setup()
    -- Load test adapters
    local neotest_adapters = {}

    for ft, adapter in pairs(adapters) do
        local ok, loaded_adapter = pcall(require, adapter)
        if ok then
            table.insert(neotest_adapters, loaded_adapter)
        end
    end

    -- Configure neotest
    require("neotest").setup({
        -- Adapters configured based on what's available
        adapters = neotest_adapters,

        -- Status handling
        status = {
            enabled = true,
            signs = true,
            virtual_text = true,
        },

        -- Output handling
        output = {
            enabled = true,
            open_on_run = true,
        },

        -- Quick fix list integration
        quickfix = {
            enabled = true,
            open = false,
        },

        -- Test running configuration
        running = {
            concurrent = true,
        },

        -- Summary window configuration
        summary = {
            enabled = true,
            expand_errors = true,
            follow = true,
            mappings = {
                attach = "a",
                expand = { "<CR>", "<2-LeftMouse>" },
                expand_all = "e",
                jumpto = "i",
                output = "o",
                run = "r",
                short = "O",
                stop = "u",
            },
        },

        -- Icons for various test states
        icons = {
            child_indent = "│",
            child_prefix = "├",
            collapsed = "─",
            expanded = "╮",
            failed = "✖",
            final_child_indent = " ",
            final_child_prefix = "╰",
            non_collapsible = "─",
            passed = "✓",
            running = "⟳",
            running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
            skipped = "ﰸ",
            unknown = "?",
        },
    })

    -- Set up autocommands for test discovery
    vim.api.nvim_create_autocmd("FileType", {
        pattern = vim.tbl_keys(adapters),
        callback = function()
            -- Load keymaps for testing
            local opts = { buffer = true }
            vim.keymap.set("n", "<leader>tt", "<cmd>lua require('neotest').run.run()<cr>", opts)
            vim.keymap.set("n", "<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", opts)
            vim.keymap.set("n", "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<cr>", opts)
            vim.keymap.set("n", "<leader>to", "<cmd>lua require('neotest').output.open({ enter = true })<cr>", opts)
            vim.keymap.set("n", "<leader>tO", "<cmd>lua require('neotest').output_panel.toggle()<cr>", opts)
            vim.keymap.set("n", "<leader>tS", "<cmd>lua require('neotest').run.stop()<cr>", opts)
        end,
    })

    return true
end

return M
