local M = {}

function M.setup()
    require("overseer").setup({
        -- Template configuration
        template_dir = vim.fn.stdpath("config") .. "/lua/tools/templates",
        templates = {
            "builtin",
            "cpp_build",
            "go_build",
            "rust_build",
            "safe_build",
            "asan_check",
            "valgrind_check",
            "secrets_scan",
            "security_scan",
            "threat_scan",
        },

        -- Task list appearance
        task_list = {
            direction = "right",
            width = 60,
            min_width = 10,
            max_width = 80,
            default_detail = 1,
            initial_detail = 1,
        },

        -- Component configuration
        component_aliases = {
            -- Default task components
            default = {
                "on_output_quickfix",
                "on_exit_set_status",
                "on_complete_notify",
                "on_complete_dispose",
            },
            -- Task components for builds
            build = {
                "on_output_quickfix",
                "on_exit_set_status",
                "on_complete_notify",
            },
            -- Task components for tests
            test = {
                "on_output_quickfix",
                "on_exit_set_status",
                "on_complete_notify",
            },
        },

        -- Configure actions
        actions = {
            ["watch"] = {
                desc = "watch task output",
                component = "default",
                condition = function(task)
                    return task:is_running()
                end,
                run = function(task)
                    task:add_component("on_output_watch")
                end,
            },
        },

        -- Status formatting
        status_win = {
            border = "rounded",
            winblend = 0, -- Keep transparent background
        },
    })

    -- Set up keymaps
    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "<leader>oo", "<cmd>OverseerToggle<cr>", opts)
    vim.keymap.set("n", "<leader>or", "<cmd>OverseerRun<cr>", opts)
    vim.keymap.set("n", "<leader>ot", "<cmd>OverseerTaskAction<cr>", opts)
    vim.keymap.set("n", "<leader>ob", "<cmd>OverseerBuild<cr>", opts)
    vim.keymap.set("n", "<leader>oc", "<cmd>OverseerRunCmd<cr>", opts)
end

return M
