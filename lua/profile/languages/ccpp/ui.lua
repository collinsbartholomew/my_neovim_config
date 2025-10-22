-- added-by-agent: ccpp-setup 20251020
-- mason: none
-- manual: none

local M = {}

function M.setup()
    -- Configure diagnostic display for C/C++
    vim.diagnostic.config({
        virtual_text = {
            prefix = "●",
            spacing = 2,
            source = "if_many",
            severity = {
                min = vim.diagnostic.severity.HINT,
            },
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    })

    -- Show diagnostics in hover window
    vim.api.nvim_create_autocmd("CursorHold", {
        pattern = { "*.c", "*.cpp", "*.h", "*.hpp", "*.qml" },
        callback = function()
            vim.diagnostic.open_float({ scope = "cursor", focus = false })
        end,
    })

    -- Configure trouble.nvim if available
    pcall(function()
        require("trouble").setup({
            mode = "document_diagnostics",
            auto_preview = false,
            use_diagnostic_signs = true,
        })
    end)
end

return M
