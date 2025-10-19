local M = {}

function M.setup()
    local notify = require("notify")

    notify.setup({
        background_colour = "#000000",
        fps = 60,
        icons = {
            DEBUG = "",
            ERROR = "",
            INFO = "",
            TRACE = "✎",
            WARN = ""
        },
        level = 2,
        minimum_width = 50,
        render = "wrapped-compact",
        stages = "fade",
        timeout = 3000,
        top_down = true
    })

    -- Set as default notify handler
    vim.notify = notify

    -- Add transparency to notifications
    local notify_bg = "#000000"
    vim.api.nvim_set_hl(0, "NotifyERRORBorder", { fg = "#8A1F1F", bg = notify_bg })
    vim.api.nvim_set_hl(0, "NotifyWARNBorder", { fg = "#79491D", bg = notify_bg })
    vim.api.nvim_set_hl(0, "NotifyINFOBorder", { fg = "#4F6752", bg = notify_bg })
    vim.api.nvim_set_hl(0, "NotifyDEBUGBorder", { fg = "#8B8B8B", bg = notify_bg })
    vim.api.nvim_set_hl(0, "NotifyTRACEBorder", { fg = "#4F3552", bg = notify_bg })
    vim.api.nvim_set_hl(0, "NotifyERRORIcon", { fg = "#F70067", bg = notify_bg })
    vim.api.nvim_set_hl(0, "NotifyWARNIcon", { fg = "#F79000", bg = notify_bg })
    vim.api.nvim_set_hl(0, "NotifyINFOIcon", { fg = "#A9FF68", bg = notify_bg })
    vim.api.nvim_set_hl(0, "NotifyDEBUGIcon", { fg = "#8B8B8B", bg = notify_bg })
    vim.api.nvim_set_hl(0, "NotifyTRACEIcon", { fg = "#D484FF", bg = notify_bg })
    vim.api.nvim_set_hl(0, "NotifyERRORTitle", { fg = "#F70067", bg = notify_bg })
    vim.api.nvim_set_hl(0, "NotifyWARNTitle", { fg = "#F79000", bg = notify_bg })
    vim.api.nvim_set_hl(0, "NotifyINFOTitle", { fg = "#A9FF68", bg = notify_bg })
    vim.api.nvim_set_hl(0, "NotifyDEBUGTitle", { fg = "#8B8B8B", bg = notify_bg })
    vim.api.nvim_set_hl(0, "NotifyTRACETitle", { fg = "#D484FF", bg = notify_bg })
    vim.api.nvim_set_hl(0, "NotifyERRORBody", { bg = notify_bg })
    vim.api.nvim_set_hl(0, "NotifyWARNBody", { bg = notify_bg })
    vim.api.nvim_set_hl(0, "NotifyINFOBody", { bg = notify_bg })
    vim.api.nvim_set_hl(0, "NotifyDEBUGBody", { bg = notify_bg })
    vim.api.nvim_set_hl(0, "NotifyTRACEBody", { bg = notify_bg })
end

return M
