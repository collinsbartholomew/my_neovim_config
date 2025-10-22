-- Line number styling configuration
local M = {}

function M.setup()
    -- Function to set line number highlights
    local function set_line_number_colors()
        -- Line numbers for relative lines (darker/muted color)
        vim.api.nvim_set_hl(0, "LineNr", { 
            fg = "#7e8294", 
            bg = "NONE",
            ctermbg = "NONE"
        })
        
        -- Line number for current line (brighter and bold)
        vim.api.nvim_set_hl(0, "CursorLineNr", { 
            fg = "#a6adce", 
            bg = "NONE", 
            ctermbg = "NONE",
            bold = true 
        })
    end

    -- Apply line number styling immediately
    set_line_number_colors()

    -- Reapply whenever colorscheme changes
    vim.api.nvim_create_autocmd("ColorScheme", {
        callback = set_line_number_colors,
    })

    -- Also reapply when entering vim
    vim.api.nvim_create_autocmd("VimEnter", {
        callback = set_line_number_colors,
    })
end

return M