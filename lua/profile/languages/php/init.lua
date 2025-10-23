-- PHP language support
local M = {}

function M.setup()
    -- Setup autocommands for PHP files
    vim.api.nvim_create_augroup("PHP", { clear = true })
    
    -- Auto-format PHP files on save
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = "PHP",
        pattern = "*.php,*.blade.php",
        callback = function()
            vim.lsp.buf.format()
        end,
    })
    
    -- Set PHP-specific options
    vim.api.nvim_create_autocmd("FileType", {
        group = "PHP",
        pattern = "php,blade",
        callback = function()
            -- Set tabstop and shiftwidth to 4 for PHP (PSR-12)
            vim.opt_local.tabstop = 4
            vim.opt_local.shiftwidth = 4
            vim.opt_local.expandtab = false
            
            -- Enable matchparen for better parenthesis matching
            vim.opt_local.matchpairs:append("<:>")
        end,
    })
end

return M