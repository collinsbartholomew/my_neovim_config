--Additional UI enhancements
local M = {}

function M.setup()
    -- Setup dropbar (breadcrumbs)
    pcall(function()
        require("dropbar").setup({
            icons = {
                enable = true,
            },
            bar = {
                enable = true,
                attach_events = {
                    "BufWinEnter",
                    "BufWritePost",
                    "BufModifiedSet",
                    "LspAttach",
                },
            },
        })
    end)

    -- Setup navic for winbar context
    pcall(function()
        require("nvim-navic").setup({
            highlight = true,
            separator = " > ",
            depth_limit = 0,
            depth_limit_indicator = "..",
        })
    end)

    -- Setup codewindow (minimap)
    pcall(function()
        require("codewindow").setup({
            auto_enable = true,
            width_multiplier = 12,
            height_multiplier = 12,
            show_cursor = true,
            auto_close = true,
            use_lsp = true,
            use_treesitter = true,
        })
        -- Add keymap for toggling minimap with which-key
        local wk_status_ok, wk = pcall(require, "which-key")
        if wk_status_ok then
            wk.register({
                ["<leader>u"] = {
                    name = "UI",
                    m = { require("codewindow").toggle_minimap, "Toggle minimap" },
                },
            }, { mode = "n" })
        else
            vim.keymap.set("n", "<leader>um", require("codewindow").toggle_minimap, { desc = "Toggle minimap" })
        end
    end)

    -- Setup indent-blankline
    pcall(function()
        local ibl = require("ibl")
        ibl.setup({
            indent = {
                char = "│",
                tab_char = "│",
            },
            scope = {
                enabled = true,
                show_start = true,
                show_end = true,
            },
            exclude = {
                filetypes = {
                    "help",
                    "alpha",
                    "dashboard",
                    "neo-tree",
                    "Trouble",
                    "trouble",
                    "lazy",
                    "mason",
                    "notify",
                    "toggleterm",
                    "lazyterm",
                },
            },
        })
    end)

    -- Setup alpha (startup screen)
    pcall(function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")
        if not dashboard then
            vim.notify("alpha.themes.dashboard not available", vim.log.levels.WARN)
            return
        end

        -- Customize header
        dashboard.section.header.val = {
            "                                                    ",
            "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
            "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
            "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
            "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
            "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
            "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝  ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
            "                                                     ",
        }

        -- Customize buttons
        dashboard.section.buttons.val = {
            dashboard.button("f", " Find file", ":Telescope find_files <CR>"),
            dashboard.button("e", " New file", ":ene <BAR> startinsert <CR>"),
            "",
            dashboard.button("p", " Find project", ":lua require('telescope').extensions.projects.projects()<CR>"),
            dashboard.button("r", " Recently used files", ":Telescope oldfiles <CR>"),
            dashboard.button("t", " Find text", ":Telescope live_grep <CR>"),
            "",
            dashboard.button("c", " Configuration", ":e ~/.config/nvim/init.lua <CR>"),
            dashboard.button("q", " Quit", ":qa<CR>"),
        }

        -- Customize footer
        dashboard.section.footer.val = {
            "Neovim Configuration",
        }

        -- Define layout explicitly
        local config = {
            layout = {
                { type = "padding", val = 2 },
                dashboard.section.header,
                { type = "padding", val = 2 },
                dashboard.section.buttons,
                { type = "padding", val = 2 },
                dashboard.section.footer,
            },
            opts = {
                margin = 5,
                noautocmd = false,
                setup = function()
                    vim.api.nvim_create_autocmd("User", {
                        pattern = "AlphaReady",
                        desc = "disable statusline and tabline for alpha",
                        callback = function()
                            vim.o.showtabline = 0
                            vim.o.laststatus = 0
                        end,
                    })
                    vim.api.nvim_create_autocmd("BufUnload", {
                        buffer = 0,
                        desc = "re-enable statusline and tabline after alpha",
                        callback = function()
                            vim.o.showtabline = 2
                            vim.o.laststatus = 2
                        end,
                    })
                end,
            },
        }

        -- Setup alpha with the config
        alpha.setup(config)
    end)
end

return M