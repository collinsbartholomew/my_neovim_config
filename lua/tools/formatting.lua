local M = {}

function M.setup()
    local conform = require("conform")

    -- Set global editor options for tabs
    vim.opt.expandtab = false -- Use real tabs by default
    vim.opt.tabstop = 3
    vim.opt.shiftwidth = 3
    vim.opt.softtabstop = 3

    -- Configure formatters
    conform.setup({
        formatters_by_ft = {
            -- Web development
            javascript = { "prettier" },
            typescript = { "prettier" },
            javascriptreact = { "prettier" },
            typescriptreact = { "prettier" },
            css = { "prettier" },
            html = { "prettier" },
            json = { "prettier" },
            yaml = { "prettier" },
            markdown = { "prettier" },
            graphql = { "prettier" },
            -- Lua
            lua = { "stylua" },
            -- Python
            python = { "black" },
            -- Rust
            rust = { "rustfmt" },
            -- Go
            go = { "gofmt" },
        },

        format_on_save = {
            timeout_ms = 500,
            lsp_fallback = true,
            async = true,
        },

        formatters = {
            prettier = {
                prepend_args = function()
                    return {
                        "--use-tabs",
                        "--tab-width",
                        "3",
                        "--print-width",
                        "120",
                        "--html-whitespace-sensitivity",
                        "ignore",
                        "--single-quote",
                        "--trailing-comma",
                        "es5",
                    }
                end,
            },
            stylua = {
                prepend_args = function()
                    return {
                        "--indent-type",
                        "Tabs",
                        "--indent-width",
                        "3",
                        "--quote-style",
                        "AutoPreferSingle",
                        "--call-parentheses",
                        "None",
                    }
                end,
            },
            rustfmt = {
                prepend_args = function()
                    return {
                        "--config",
                        "tab_spaces=3",
                        "--config",
                        "use_tabs=true",
                    }
                end,
            },
        },
    })

    -- Set up format-on-save autocommands
    local format_group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        group = format_group,
        callback = function(args)
            -- Ensure indentation settings are correct before formatting
            local ft = vim.bo[args.buf].filetype
            if ft:match("javascript.*") or ft:match("typescript.*") or ft:match("html") or ft:match("css") or ft:match("jsx") or ft:match("tsx") or ft:match("xml") then
                vim.bo[args.buf].expandtab = false
                vim.bo[args.buf].tabstop = 3
                vim.bo[args.buf].shiftwidth = 3
                vim.bo[args.buf].softtabstop = 3
            end
            conform.format({ bufnr = args.buf, async = true, timeout_ms = 500 })
        end,
    })
end

return M
