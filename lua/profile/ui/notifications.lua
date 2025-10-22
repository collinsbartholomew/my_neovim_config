-- Configuration for notifications and UI feedback

local M = {}

function M.setup()
    -- Configure nvim-notify with transparency
    require("notify").setup({
        background_colour = "NONE", -- Fully transparent
        fps = 60,
        render = "minimal",
        stages = "fade_in_slide_out",
        timeout = 3000,
        transparency = 100, -- Fully transparent
        top_down = false,
        max_width = 80, -- Limit width
        max_height = 10, -- Limit height
    })

    -- Set as default notify handler
    vim.notify = require("notify")

    -- Configure fidget.nvim for LSP progress
    require("fidget").setup({
        text = {
            spinner = "dots",
        },
        window = {
            blend = 0, -- Fully transparent
            relative = "editor",
            maxWidth = 60, -- Limit width
            maxHeight = 5, -- Limit height
        },
        sources = {
            ["null-ls"] = { ignore = true },
        },
    })

    -- Set up dressing.nvim for better UI
    require("dressing").setup({
        input = {
            enabled = true,
            default_prompt = "➤ ",
            win_options = {
                winblend = 0, -- Fully transparent
            },
            -- Scale down by 40%
            relative = "cursor",
            prefer_width = 40,
            max_width = 60,
            min_width = 20,
        },
        select = {
            enabled = true,
            backend = { "telescope", "builtin" },
            telescope = {
                layout_config = {
                    width = 0.3, -- Reduced from 0.5 (40% smaller)
                    height = 0.4, -- Reduced from 0.6 (40% smaller)
                },
            },
        },
    })
end

return M