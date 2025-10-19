-- Core autocommands for Neovim
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local M = {}

function M.setup()
    -- Highlight on yank with better performance
    local yank_group = augroup("highlight-yank", { clear = true })
    autocmd("TextYankPost", {
        group = yank_group,
        desc = "Highlight when yanking text",
        callback = function()
            vim.schedule(function()
                vim.highlight.on_yank({ timeout = 150, on_macro = false, on_visual = true })
            end)
        end,
    })

    -- UI enhancements with deferred loading
    local ui_group = augroup("ui-fixes", { clear = true })
    autocmd("ColorScheme", {
        group = ui_group,
        desc = "Set transparent background and enhance UI elements",
        callback = function()
            -- Batch highlight updates for performance
            local highlights = {
                { "Normal", { bg = "NONE", ctermbg = "NONE" } },
                { "NormalFloat", { bg = "NONE", ctermbg = "NONE" } },
                { "FloatBorder", { bg = "NONE", ctermbg = "NONE" } },
                { "SignColumn", { bg = "NONE", ctermbg = "NONE" } },
                { "NeoTreeNormal", { bg = "NONE", ctermbg = "NONE" } },
                { "NeoTreeNormalNC", { bg = "NONE", ctermbg = "NONE" } },
                -- Diagnostic styling
                { "DiagnosticUnderlineError", { underline = true, sp = "#eb6f92" } },
                { "DiagnosticUnderlineWarn", { underline = true, sp = "#f6c177" } },
                { "DiagnosticUnderlineInfo", { underline = true, sp = "#31748f" } },
                { "DiagnosticUnderlineHint", { underline = true, sp = "#9ccfd8" } },
            }

            vim.schedule(function()
                for _, hl in ipairs(highlights) do
                    vim.api.nvim_set_hl(0, hl[1], hl[2])
                end
            end)
        end,
    })

    -- File type specific settings
    local ft_group = augroup("filetype-settings", { clear = true })

    -- Terminal settings
    autocmd("TermOpen", {
        group = ft_group,
        desc = "Terminal-specific settings",
        callback = function()
            vim.opt_local.number = false
            vim.opt_local.relativenumber = false
            vim.cmd("startinsert")
        end,
    })

    -- Restore cursor position
    autocmd("BufReadPost", {
        group = ft_group,
        desc = "Restore cursor position",
        callback = function()
            local mark = vim.api.nvim_buf_get_mark(0, '"')
            local lcount = vim.api.nvim_buf_line_count(0)
            if mark[1] > 0 and mark[1] <= lcount then
                pcall(vim.api.nvim_win_set_cursor, 0, mark)
            end
        end,
    })

    -- Auto formatting
    autocmd("BufWritePre", {
        group = ft_group,
        desc = "Auto format on save",
        callback = function()
            vim.lsp.buf.format({ async = false })
        end,
    })

    return true
end

return M
