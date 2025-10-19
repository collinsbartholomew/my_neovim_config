local M = {}

function M.setup()
    -- Lazy load neotest to improve startup time
    vim.defer_fn(function()
        -- Load neotest with error handling
        local ok, neotest = pcall(require, "neotest")
        if not ok then
            vim.notify("neotest is not installed", vim.log.levels.WARN)
            return false
        end

        -- Load available adapters
        local adapters = {}
        local available = {
            go = "neotest-go",
            python = "neotest-python",
            rust = "neotest-rust",
            javascript = "neotest-jest",
            typescript = "neotest-jest",
            ["javascript.jsx"] = "neotest-jest",
            ["typescript.tsx"] = "neotest-jest",
        }

        -- Try to load each adapter silently
        for ft, adapter in pairs(available) do
            local ok, loaded_adapter = pcall(require, adapter)
            if ok then
                adapters[#adapters + 1] = loaded_adapter
            end
        end

        -- Only setup if we have at least one adapter
        if #adapters > 0 then
            -- Configure neotest
            neotest.setup({
                -- Add loaded adapters
                adapters = adapters,

                -- Status configuration
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

                -- Icons
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
                    skipped = "ﰸ",
                    unknown = "?",
                },
            })

            -- Set up keymaps
            vim.keymap.set("n", "<leader>tt", function() neotest.run.run() end, { desc = "Run nearest test" })
            vim.keymap.set("n", "<leader>tf", function() neotest.run.run(vim.fn.expand("%")) end, { desc = "Run file tests" })
            vim.keymap.set("n", "<leader>ts", function() neotest.summary.toggle() end, { desc = "Toggle test summary" })
            vim.keymap.set("n", "<leader>to", function() neotest.output.open({ enter = true }) end, { desc = "Show test output" })
            vim.keymap.set("n", "<leader>tp", function() neotest.output_panel.toggle() end, { desc = "Toggle test panel" })
            vim.keymap.set("n", "<leader>tS", function() neotest.run.stop() end, { desc = "Stop test run" })
        end
    end, 100)  -- Delay loading by 100ms to improve startup time

    return true
end

return M
