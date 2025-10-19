local M = {}

function M.setup()
    require("lualine").setup({
        options = {
            theme = "auto",
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            globalstatus = true,
            disabled_filetypes = {
                statusline = { "neo-tree" },
                winbar = {},
            },
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = {
                "branch",
                {
                    "diff",
                    colored = true,
                    symbols = { added = " ", modified = " ", removed = " " },
                },
            },
            lualine_c = {
                {
                    "diagnostics",
                    sources = { "nvim_diagnostic" },
                    sections = { "error", "warn", "info", "hint" },
                    symbols = { error = " ", warn = " ", info = " ", hint = " " },
                    colored = true,
                    always_visible = false,
                },
                { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
                { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
            },
            lualine_x = {
                {
                    "encoding",
                    fmt = string.upper,
                },
                {
                    "fileformat",
                    icons_enabled = true,
                },
                {
                    require("lazy.status").updates,
                    cond = require("lazy.status").has_updates,
                },
            },
            lualine_y = {
                { "progress", separator = " ", padding = { left = 1, right = 0 } },
                { "location", padding = { left = 0, right = 1 } },
            },
            lualine_z = {
                function()
                    return " " .. os.date("%R")
                end,
            },
        },
        extensions = { "neo-tree", "lazy", "mason", "trouble" },
    })
end

return M
