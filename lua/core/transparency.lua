local M = {}

function M.setup()
    -- Global transparency setup
    vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
            -- Core UI elements with complete transparency
            local highlights = {
                -- Window elements
                { "Normal", { bg = "NONE", ctermbg = "NONE" } },
                { "NormalNC", { bg = "NONE", ctermbg = "NONE" } },
                { "NormalFloat", { bg = "NONE", ctermbg = "NONE" } },
                { "FloatBorder", { bg = "NONE", ctermbg = "NONE" } },
                { "WinSeparator", { bg = "NONE", ctermbg = "NONE" } },

                -- Neo-tree specific
                { "NeoTreeNormal", { bg = "NONE", ctermbg = "NONE" } },
                { "NeoTreeNormalNC", { bg = "NONE", ctermbg = "NONE" } },
                { "NeoTreeEndOfBuffer", { bg = "NONE", ctermbg = "NONE" } },
                { "NeoTreeIndentMarker", { fg = "#3b4261", bg = "NONE" } },

                -- Editor elements
                { "SignColumn", { bg = "NONE", ctermbg = "NONE" } },
                { "MsgArea", { bg = "NONE", ctermbg = "NONE" } },
                { "TelescopeNormal", { bg = "NONE", ctermbg = "NONE" } },
                { "TelescopeBorder", { bg = "NONE", ctermbg = "NONE" } },

                -- Completion and popups
                { "Pmenu", { bg = "NONE", ctermbg = "NONE" } },
                { "PmenuSel", { bg = "#2d3149" } },
                { "PmenuSbar", { bg = "NONE" } },
                { "PmenuThumb", { bg = "#3b4261" } },

                -- Line numbers and cursor
                { "LineNr", { bg = "NONE", fg = "#3b4261" } },
                { "CursorLineNr", { bg = "NONE", fg = "#737aa2" } },
                { "CursorLine", { bg = "#1f2335" } },

                -- LSP and diagnostics
                { "LspFloatWinNormal", { bg = "NONE" } },
                { "DiagnosticFloatingError", { bg = "NONE" } },
                { "DiagnosticFloatingWarn", { bg = "NONE" } },
                { "DiagnosticFloatingInfo", { bg = "NONE" } },
                { "DiagnosticFloatingHint", { bg = "NONE" } },
            }

            -- Apply highlights in batch for better performance
            for _, hl in ipairs(highlights) do
                vim.api.nvim_set_hl(0, hl[1], hl[2])
            end
        end,
    })
end

return M
