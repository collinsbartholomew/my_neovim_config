---
-- Mojo UI enhancements
local M = {}

function M.setup()
    -- Mojo-specific UI settings
    -- Set up specific colorcolumn for Mojo files
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "mojo",
        callback = function()
            vim.api.nvim_buf_set_option(0, "colorcolumn", "100")
        end,
    })
    
    -- Configure better folding for Mojo files
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "mojo",
        callback = function()
            vim.api.nvim_buf_set_option(0, "foldmethod", "indent")
            vim.api.nvim_buf_set_option(0, "foldlevel", 99)
        end,
    })
end

return M