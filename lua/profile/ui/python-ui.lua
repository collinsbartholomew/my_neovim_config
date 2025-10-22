---
-- Python UI enhancements
local M = {}

function M.setup()
    -- Python-specific UI settings
    -- Set up specific colorcolumn for Python files (PEP 8 recommends 79 characters)
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function()
            vim.api.nvim_buf_set_option(0, "colorcolumn", "79")
        end,
    })
    
    -- Configure better folding for Python files
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function()
            vim.api.nvim_buf_set_option(0, "foldmethod", "indent")
            vim.api.nvim_buf_set_option(0, "foldlevel", 99)
        end,
    })
end

return M