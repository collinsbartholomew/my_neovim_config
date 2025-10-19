local M = {}

function M.setup()
    -- Configure tokyonight theme
    require("tokyonight").setup({
        style = "night",
        transparent = false,
        terminal_colors = true,
        styles = {
            comments = { italic = true },
            keywords = { italic = true },
            functions = {},
            variables = {},
        },
        sidebars = { "qf", "help", "terminal", "packer" },
        day_brightness = 0.3,
        hide_inactive_statusline = false,
        dim_inactive = false,
        lualine_bold = false,
    })

    -- Configure rose-pine theme
    require("rose-pine").setup({
        variant = "main",
        dark_variant = "moon",
        dim_inactive_windows = false,
        extend_background_behind_borders = true,
    })

    -- Set initial theme
    vim.cmd.colorscheme("tokyonight-night")
end

return M
