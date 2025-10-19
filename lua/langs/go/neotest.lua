local M = {}

function M.setup()
    -- Load go test adapter
    local ok, neotest = pcall(require, "neotest")
    if not ok then
        vim.notify("neotest is not installed", vim.log.levels.ERROR)
        return false
    end

    -- Load go test adapter
    local ok_go, neotest_go = pcall(require, "neotest-go")
    if not ok_go then
        vim.notify("neotest-go is not installed", vim.log.levels.ERROR)
        return false
    end

    -- Configure neotest with Go adapter
    neotest.setup({
        adapters = {
            neotest_go({
                experimental = {
                    test_table = true,
                },
                args = { "-count=1", "-timeout=60s" }
            })
        },
        status = {
            enabled = true,
            signs = true,
            virtual_text = true,
        },
        output = {
            enabled = true,
            open_on_run = true,
        },
        summary = {
            enabled = true,
            follow = true,
            expand_errors = true,
        },
        icons = {
            running = "⟳",
            passed = "✓",
            failed = "✖",
            skipped = "ﰸ",
        },
        floating = {
            border = "rounded",
            max_height = 0.6,
            max_width = 0.6,
            options = {}
        },
    })

    -- Set up keymaps for Go testing
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "go",
        callback = function()
            local opts = { buffer = true }
            vim.keymap.set("n", "<leader>tr", function() neotest.run.run() end, opts)
            vim.keymap.set("n", "<leader>tf", function() neotest.run.run(vim.fn.expand("%")) end, opts)
            vim.keymap.set("n", "<leader>ts", function() neotest.summary.toggle() end, opts)
            vim.keymap.set("n", "<leader>to", function() neotest.output.open({ enter = true }) end, opts)
            vim.keymap.set("n", "<leader>tO", function() neotest.output_panel.toggle() end, opts)
            vim.keymap.set("n", "<leader>tS", function() neotest.run.stop() end, opts)
        end
    })

    return true
end

return M
