-- Copilot configuration
local M = {}

function M.setup()
    -- Check if copilot is available
    local status_ok, copilot = pcall(require, "copilot")
    if not status_ok then
        -- Try alternative module name
        status_ok, copilot = pcall(require, "copilot-lua")
        if not status_ok then
            vim.notify("Copilot not available", vim.log.levels.WARN)
            return
        end
    end

    copilot.setup({
        suggestion = {
            auto_trigger = true,
            keymap = {
                accept = "<C-l>",
                accept_word = false,
                accept_line = false,
                next = "<M-]>",
                prev = "<M-[>",
                dismiss = "<C-]>",
            },
        },
        panel = {
            enabled = true,
            auto_refresh = false,
            keymap = {
                jump_prev = "[[",
                jump_next = "]]",
                accept = "<CR>",
                refresh = "gr",
                open = "<M-CR>"
            },
            layout = {
                position = "bottom", -- | top
                ratio = 0.4
            },
        },
        filetypes = {
            yaml = false,
            markdown = false,
            help = false,
            gitcommit = false,
            gitrebase = false,
            hgcommit = false,
            svn = false,
            cvs = false,
            ["."] = false,
        },
    })
end

return M