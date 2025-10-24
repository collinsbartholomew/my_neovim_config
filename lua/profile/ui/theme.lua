--Configuration for themes with 100% transparency

local M = {}

function M.setup()
    -- Set up rose-pine with full transparency
    require('rose-pine').setup({
        variant = 'main',
        dark_variant = 'main',
        bold_vert_split = false,
        dim_nc_background = false,
        disable_background = true,
        disable_float_background = true,
        disable_italics = false,
        groups = {
            background = 'NONE',
            panel = 'NONE',
            border = 'highlight_med',
            comment = 'muted',
            link = 'iris',
            punctuation = 'subtle',
            error = 'love',
            hint = 'iris',
            info = 'foam',
            warn = 'gold',
            git_add = 'foam',
            git_change = 'rose',
            git_delete = 'love',
            git_dirty = 'rose',
            git_ignore = 'muted',
            git_merge = 'iris',
            git_rename = 'pine',
            git_stage = 'iris',
            git_text = 'rose',
        },
    })

    -- Set up tokyonight with full transparency
    require('tokyonight').setup({
        style = "moon",
        transparent = true,
        terminal_colors = true,
        styles = {
            comments = { italic = true },
            keywords = { italic = true },
            functions = {},
            variables = {},
            sidebars = "transparent",
            floats = "transparent",
        },
        sidebars = { "qf", "help" },
        hide_inactive_statusline = false,
        dim_inactive = false,
        lualine_bold = false,
        on_highlights = function(hl, c)
            local transparent = { bg = "NONE", ctermbg = "NONE" }
            hl.Normal = transparent
            hl.NormalNC = transparent
            hl.NormalFloat = transparent
            hl.FloatBorder = transparent
            hl.SignColumn = transparent
            hl.LineNr = transparent
            hl.FoldColumn = transparent
            hl.EndOfBuffer = transparent
            hl.VertSplit = transparent
        end
    })

    -- Set up nightfox with full transparency
    require('nightfox').setup({
        options = {
            transparent = true,
            terminal_colors = true,
            dim_inactive = false,
            styles = {
                comments = "italic",
                keywords = "bold",
                types = "italic,bold",
            },
            inverse = {
                match_paren = false,
            },
        },
        groups = {
            all = {
                Normal = { bg = "NONE" },
                NormalNC = { bg = "NONE" },
                NormalFloat = { bg = "NONE" },
                FloatBorder = { bg = "NONE" },
                SignColumn = { bg = "NONE" },
                LineNr = { bg = "NONE" },
                FoldColumn = { bg = "NONE" },
                EndOfBuffer = { bg = "NONE" },
                VertSplit = { bg = "NONE", fg = "NONE" }, -- Make vertical splits invisible
                StatusLine = { bg = "NONE" },
                StatusLineNC = { bg = "NONE" },
                Pmenu = { bg = "NONE" },
                PmenuSel = { bg = "NONE" },
                PmenuSbar = { bg = "NONE" },
                PmenuThumb = { bg = "NONE" },
                TelescopeNormal = { bg = "NONE" },
                TelescopeBorder = { bg = "NONE" },
                TelescopePromptNormal = { bg = "NONE" },
                TelescopePromptBorder = { bg = "NONE" },
                TelescopeResultsNormal = { bg = "NONE" },
                TelescopeResultsBorder = { bg = "NONE" },
                TelescopePreviewNormal = { bg = "NONE" },
                TelescopePreviewBorder = { bg = "NONE" },
            }
        }
    })

    -- Set colorscheme with full transparency
    vim.cmd('colorscheme rose-pine')

    -- Enable true color support
    vim.opt.termguicolors = true

    -- Set fully transparent background for all UI elements
    local function set_transparent_background()
        vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE", ctermbg = "NONE" })
        vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE", ctermbg = "NONE" })
        vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE", ctermbg = "NONE" })
        vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE", ctermbg = "NONE" })
        vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE", ctermbg = "NONE" })
        vim.api.nvim_set_hl(0, "FoldColumn", { bg = "NONE", ctermbg = "NONE" })
        vim.api.nvim_set_hl(0, "VertSplit", { bg = "NONE", ctermbg = "NONE" })
        vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE", ctermbg = "NONE" })
        vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE", ctermbg = "NONE" })
        vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE", ctermbg = "NONE" })
        vim.api.nvim_set_hl(0, "PmenuSel", { bg = "NONE", ctermbg = "NONE" })
        vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "NONE", ctermbg = "NONE" })
        vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "NONE", ctermbg = "NONE" })
        vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "NONE", ctermbg = "NONE" })
        vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "NONE", ctermbg = "NONE" })
        vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "NONE", ctermbg = "NONE" })
        vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "NONE", ctermbg = "NONE" })
        vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "NONE", ctermbg = "NONE" })
        vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { bg = "NONE", ctermbg = "NONE" })
        vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "NONE", ctermbg = "NONE" })
        vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { bg = "NONE", ctermbg = "NONE" })

        -- Additional UI elements that might need transparency
        vim.api.nvim_set_hl(0, "WinSeparator", { bg = "NONE", fg = "NONE" })  -- Make window separators invisible
        vim.api.nvim_set_hl(0, "TabLine", { bg = "NONE", ctermbg = "NONE" })
        vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE", ctermbg = "NONE" })
        vim.api.nvim_set_hl(0, "TabLineSel", { bg = "NONE", ctermbg = "NONE" })

        -- Noice command line highlights
        vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { bg = "NONE", fg = "NONE" })
        vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { bg = "NONE", fg = "#808080" })
        vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", { bg = "NONE", fg = "#7aa2f7" })
        vim.api.nvim_set_hl(0, "NoiceCmdline", { bg = "NONE", fg = "#a9b1d6" })

        -- Customize line number colors to distinguish current line
        -- Line numbers for relative lines
        vim.api.nvim_set_hl(0, "LineNr", { fg = "#7e8294", bg = "NONE" })
        -- Line number for current line
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#a6adce", bg = "NONE", bold = true })
    end

    -- Apply transparent background immediately andon ColorScheme changes
    set_transparent_background()
    vim.api.nvim_create_autocmd("ColorScheme", {
        callback = set_transparent_background,
    })
end

-- Function to toggle between themes
function M.toggle()
    local current_scheme = vim.g.colors_name
    if current_scheme == "rose-pine" then
        vim.cmd('colorscheme nightfox')
    elseif current_scheme == "nightfox" then
        vim.cmd('colorscheme rose-pine')
    else
        vim.cmd('colorscheme rose-pine')
    end
end

return M