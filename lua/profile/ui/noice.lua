--Noice configuration for command line display
local M = {}

function M.setup()
    local status_ok, noice = pcall(require, "noice")
    if not status_ok then
        return
    end

    noice.setup({
        lsp = {
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true,
            },
        },
        presets = {
            bottom_search = false, -- Use classic top search instead
            command_palette = true,
            long_message_to_split = true,
            inc_rename = false,
            lsp_doc_border = false,
        },
        views = {
            -- Centered search view
            mini = {
                win_options = {
                    winblend = 0,
                },
            },
            cmdline_popup = {
                position = {
                    row = "30%",
                    col = "50%",
                },
                size = {
                    width = 60,
                    height = 1,
                },
                border = {
                    style = "none",
                    padding = { 0, 1 },
                },
                win_options = {
                    winhighlight = {
                        Normal = "NoiceCmdlinePopup",
                        FloatBorder = "NoiceCmdlinePopupBorder",
                        CursorLine = "Visual"
                    },
                    winblend = 0,
                },
            },
            popupmenu = {
                relative = "editor",
                position = {
                    row = "32%",
                    col = "50%",
                },
                size = {
                    width = 60,
                    height = 10,
                },
                border = {
                    style = "none",
                    padding = { 0, 1 },
                },
                win_options = {
                    winhighlight = {
                        Normal = "Normal",
                        FloatBorder = "NoiceCmdlinePopupBorder",
                        CursorLine = "Visual"
                    },
                },
            },
            -- Notification view configuration (scaled down by 40%)
            notify = {
                merge = true,
                max_width = 60,
                max_height = 5,
                zindex = 100,
                timeout = 3000,
                render = "minimal",
                stages = "fade_in_slide_out",
                size = {
                    width = "auto",
                    height = "auto",
                },
            },
        },
        routes = {
            {
                filter = {
                    event = "msg_show",
                    kind = "",
                    find = "written",
                },
                view = "mini",
            },
            -- Redirect search to centered view
            {
                filter = {
                    event = "msg_showmode",
                },
                view = "mini",
            },
        },
        commands = {
            history = {
                view = "popup",
                opts = { enter = true, format = "details" },
                filter = {
                    any = {
                        { event = "notify" },
                        { error = true },
                        { warning = true },
                        { event = "msg_show", kind = { "" } },
                        { event = "lsp", kind = "message" },
                    },
                },
            },
        },
        messages = {
            enabled = true,
            view = "notify",
            view_error = "notify",
            view_warn = "notify",
            view_history = "messages",
            view_search = false,
        },
        cmdline = {
            enabled = true,
            view = "cmdline_popup",
            opts = {
                position = {
                    row = "30%", -- Center vertically
                    col = "50%",
                },
                size = {
                    width = 60,
                    height = 1,
                },
                border = {
                    style = "rounded",
                    padding = { 0, 1 },
                },
            },
            format = {
                cmdline = { pattern = "^:", icon = ">", icon_hl_group = "NoiceCmdlineIcon", lang = "vim", view = "cmdline_popup" },
                search_down = { kind = "search", pattern = "^/", icon = "/", icon_hl_group = "NoiceCmdlineIcon", lang = "regex", view = "cmdline_popup" },
                search_up = { kind = "search", pattern = "^%?", icon = "?", icon_hl_group = "NoiceCmdlineIcon", lang = "regex", view = "cmdline_popup" },
                filter = { pattern = "^:%s*!", icon = "$", icon_hl_group = "NoiceCmdlineIcon", lang = "bash", view = "cmdline_popup" },
                lua = {
                    pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" },
                    icon = "",
                    icon_hl_group = "NoiceCmdlineIcon",
                    lang = "lua",
                    view = "cmdline_popup",
                },
                help = { pattern = "^:%s*he?l?p?%s+", icon = "?", icon_hl_group = "NoiceCmdlineIcon", view = "cmdline_popup" },
                input = { view = "cmdline_popup" },
                recording = { icon = "●", icon_hl_group = "NoiceCmdlineIcon", lang = "vim", title = "Recording Macro", view = "cmdline_popup" },
            },
        },
    })
end

return M