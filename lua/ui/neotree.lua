local M = {}

function M.setup()
    require("neo-tree").setup({
        close_if_last_window = true,
        enable_git_status = true,
        enable_diagnostics = true,
        default_component_configs = {
            container = {
                enable_character_fade = true,
            },
            indent = {
                indent_size = 2,
                padding = 1,
                with_markers = true,
                indent_marker = "│",
                last_indent_marker = "└",
                highlight = "NeoTreeIndentMarker",
                with_expanders = true,
                expander_collapsed = "",
                expander_expanded = "",
                expander_highlight = "NeoTreeExpander",
            },
            icon = {
                folder_closed = "󰉋",
                folder_open = "󰝰",
                folder_empty = "󰜌",
                default = "",
                highlight = "NeoTreeFileIcon",
            },
            modified = {
                symbol = "●",
                highlight = "NeoTreeModified",
            },
            name = {
                trailing_slash = true,
                use_git_status_colors = true,
                highlight = "NeoTreeFileName",
            },
            git_status = {
                symbols = {
                    added = "✚",
                    modified = "",
                    deleted = "✖",
                    renamed = "󰁕",
                    untracked = "",
                    ignored = "",
                    unstaged = "",
                    staged = "",
                    conflict = "",
                },
            },
            file_size = {
                enabled = true,
                required_width = 64,
            },
            type = {
                enabled = true,
                required_width = 122,
            },
            last_modified = {
                enabled = true,
                required_width = 88,
            },
            created = {
                enabled = true,
                required_width = 110,
            },
        },
        window = {
            position = "left",
            width = 35,
            mapping_options = {
                noremap = true,
                nowait = true,
            },
            mappings = {
                ["<space>"] = "none",
            },
        },
        filesystem = {
            filtered_items = {
                visible = true,
                show_hidden_count = true,
                hide_dotfiles = false,
                hide_gitignored = false,
                hide_by_name = {
                    ".git",
                    "node_modules",
                    ".cache",
                },
                never_show = {
                    ".DS_Store",
                    "thumbs.db",
                },
            },
            follow_current_file = {
                enabled = true,
                leave_dirs_open = true,
            },
            group_empty_dirs = true,
            hijack_netrw_behavior = "open_default",
            use_libuv_file_watcher = true,
        },
        event_handlers = {
            {
                event = "file_opened",
                handler = function()
                    -- Auto close neo-tree after opening a file
                    require("neo-tree.command").execute({ action = "close" })
                end,
            },
        },
    })
end

return M
