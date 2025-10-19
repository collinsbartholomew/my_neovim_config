local M = {}

function M.setup()
    local lint = require("lint")

    -- Configure linters by filetype
    lint.linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        python = { "pylint", "ruff" },
        lua = { "selene", "luacheck" },
        sh = { "shellcheck" },
        dockerfile = { "hadolint" },
        yaml = { "yamllint" },
        markdown = { "markdownlint" },
        rust = { "cargo" },
        cpp = { "cpplint" },
        c = { "cpplint" },
    }

    -- Create an autocmd to trigger linting
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
            -- Don't lint if the file is too large
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(0))
            if ok and stats and stats.size > max_filesize then
                return
            end

            -- Don't lint if we're in a diff view
            if vim.wo.diff then
                return
            end

            -- Try to lint
            require("lint").try_lint()
        end,
    })

    -- Set up keymaps for linting
    vim.keymap.set("n", "<leader>ll", function()
        require("lint").try_lint()
    end, { desc = "Trigger linting for current file" })

    return true
end

return M
