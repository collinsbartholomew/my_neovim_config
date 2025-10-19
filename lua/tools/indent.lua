local M = {}

function M.setup()
    local highlight = {
        "IblIndent",
        "IblScope",
    }

    local hooks = require("ibl.hooks")
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "IblIndent", { fg = "#1a1a2a", nocombine = true })
        vim.api.nvim_set_hl(0, "IblScope", { fg = "#2a2a3c", nocombine = true })
    end)

    require("ibl").setup({
        indent = {
            char = "│", -- Using a very thin vertical bar
            tab_char = "│",
            highlight = highlight,
            smart_indent_cap = true,
            priority = 1,
        },
        whitespace = {
            highlight = highlight,
            remove_blankline_trail = true,
        },
        scope = {
            enabled = true,
            char = "│",
            show_start = false,
            show_end = false,
            highlight = "IblScope",
            priority = 2,
        },
        exclude = {
            filetypes = {
                "help",
                "dashboard",
                "neo-tree",
                "Trouble",
                "TelescopePrompt",
                "Float",
                "alpha",
            },
            buftypes = {
                "terminal",
                "nofile",
                "quickfix",
                "prompt",
            },
        },
    })
end

return M
