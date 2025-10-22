-- added-by-agent: ui-enhancement 20251020
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
        },
        select = {
            enabled = true,
            backend = { "telescope", "builtin" },
            telescope = {
                layout_config = {
                    width = 0.5,
                    height = 0.6,
                },
            },
        },
    })

    -- Setup trouble.nvim for diagnostics
    local trouble_ok, trouble = pcall(require, "trouble")
    if trouble_ok then
        trouble.setup({
            auto_open = false,
            auto_close = true,
            use_diagnostic_signs = true,
        })
    end
end

return M