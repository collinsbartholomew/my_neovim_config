local M = {}

function M.setup()
    require("bufferline").setup({
        options = {
            mode = "buffers",
            separator_style = "slant",
            always_show_bufferline = false,
            show_buffer_close_icons = true,
            show_close_icon = false,
            color_icons = true,
            diagnostics = "nvim_lsp",
            highlights = {
                buffer_selected = {
                    gui = "bold",
                },
                diagnostic_selected = {
                    gui = "bold",
                },
                info_selected = {
                    gui = "bold",
                },
                info_diagnostic_selected = {
                    gui = "bold",
                },
            },
            offsets = {
                {
                    filetype = "neo-tree",
                    text = "File Explorer",
                    text_align = "center",
                    separator = true,
                },
            },
            hover = {
                enabled = true,
                delay = 0,
                reveal = {'close'},
            },
        },
    })
end

return M
