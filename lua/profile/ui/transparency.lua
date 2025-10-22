-- Transparency configuration with 100% transparency
local M = {}

local function set_transparent()
    -- Set all common UI elements to transparent
    local groups = {
        'Normal', 'NormalNC', 'NormalFloat', 'SignColumn', 'MsgArea',
        'EndOfBuffer', 'FoldColumn', 'VertSplit',
        'StatusLine', 'StatusLineNC', 'TabLine', 'TabLineFill', 'TabLineSel',
        'Pmenu', 'PmenuSel', 'PmenuSbar', 'PmenuThumb', 'WildMenu',
        'TelescopeNormal', 'TelescopeBorder', 'TelescopePromptNormal',
        'TelescopePromptBorder', 'TelescopeResultsNormal', 'TelescopeResultsBorder',
        'TelescopePreviewNormal', 'TelescopePreviewBorder', 'FloatBorder',
        'NvimTreeNormal', 'NvimTreeNormalNC', 'NvimTreeWinSeparator',
        'NeoTreeNormal', 'NeoTreeNormalNC', 'NeoTreeWinSeparator',
        'DashboardHeader', 'DashboardFooter', 'DashboardShortcut', 'DashboardCenter'
    }

    for _, group in ipairs(groups) do
        vim.api.nvim_set_hl(0, group, { bg = 'NONE', ctermbg = 'NONE' })
    end
    
    -- Set line number highlights but preserve foreground colors
    vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "NONE", ctermbg = "NONE" })
end

function M.setup()
    -- Apply transparency on startup
    set_transparent()

    -- Create toggle command
    vim.api.nvim_create_user_command('ToggleTransparency', set_transparent, {})

    -- Apply transparency whenever colorscheme changes
    vim.api.nvim_create_autocmd("ColorScheme", {
        callback = set_transparent,
    })
end

-- Function to toggle transparency
function M.toggle()
    set_transparent()
end

return M