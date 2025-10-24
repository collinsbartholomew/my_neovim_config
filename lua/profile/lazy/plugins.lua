--lazy.nvim plugin specs
-- This file defines all the plugins used in the Neovim configuration
-- Bootstrap lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    --Iflazy.nvim is not installed, clone it from GitHub
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
--Addlazy.nvim to the runtime path
vim.opt.rtp:prepend(lazypath)

return {
    -- Lazy.nvim plugin manager
    { "folke/lazy.nvim", version = "*" },
    -- Improve Neovim startup time
    { "lewis6991/impatient.nvim" },

    -- Plugin checker and performance settings
    checker = {
        enabled = true, -- Enable plugin update checking
        notify = false    -- Don't notify about updates
    },
    performance = {
        cache = {
            enabled = true, -- Enable plugin caching
        },
        reset_packpath = true,
        rtp = {
            reset = true,
            paths = {},
            disabled_plugins = {
                "gzip", -- Disable gzip plugin
                "matchit", -- Disable matchit plugin
                "matchparen", -- Disable matchparen plugin
                "netrwPlugin", --Disablenetrw plugin(using neo-tree instead)
                "tarPlugin", -- Disable tar plugin
                "tohtml", -- Disable tohtml plugin
                "tutor", -- Disable tutor plugin
                "zipPlugin", -- Disable zip plugin
            },
        },
    },

    --Which-key plugin- shows keybindings in a popup
    { "folke/which-key.nvim", event = "VeryLazy" },

    -- Completion engine
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" }, -- Loadoninsert or commandentry
        dependencies = {
            "hrsh7th/cmp-nvim-lsp", -- LSP completion source
            "hrsh7th/cmp-buffer", -- Buffer completion source
            "hrsh7th/cmp-path", -- Path completion source
            "hrsh7th/cmp-cmdline", -- Command line completion source
            "saadparwaiz1/cmp_luasnip", -- Luasnip completion source
            "L3MON4D3/LuaSnip", -- Snippet engine
            "rafamadriz/friendly-snippets", -- Collection of snippets
        },
        config = function()
            --Load custom cmp configuration
            local status_ok, module = pcall(require, "profile.completion.cmp")
            if status_ok then
                return module
            end
        end,
    },

    -- LSP Zero- LSP configuration helper
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        dependencies = {
            -- LSP Support
            { "neovim/nvim-lspconfig" },
            -- Autocompletion
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "L3MON4D3/LuaSnip" },
        }
    },

    -- LSP (LanguageServerProtocol) relatedplugins
    { "williamboman/mason.nvim", cmd = "Mason", config = true }, -- Package manager for LSP servers
    { "williamboman/mason-lspconfig.nvim" }, -- Bridge between Mason and lspconfig
    { "WhoIsSethDaniel/mason-tool-installer.nvim" }, -- Tool installer for Mason
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" }, -- Load when opening or creating files
        config = function()
            --Loadcustom LSPconfiguration
            local status_ok, module = pcall(require, "profile.lsp.lspconfig")
            if status_ok then
                return module
            end
        end,
    },
    { "folke/neodev.nvim", ft = "lua" }, -- Lua development support-- {"tjdevries/scriptease.vim", ft= "lua" },  -- Commented out as repositorynot found

    -- Debugging plugins
    {
        "mfussenegger/nvim-dap",
        event = "VeryLazy", -- Load when idle
        config = function()
            --Load custom DAP configuration
            local status_ok, module = pcall(require, "profile.dap.init")
            if status_ok then
                return module
            end
        end,
    },
    { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } }, -- DAP UI
    { "jay-babu/mason-nvim-dap.nvim" }, -- Bridge between Mason and DAP

    -- Git plugins
    { "tpope/vim-fugitive", cmd = "Git" }, -- Git wrapper
    { "kdheepak/lazygit.nvim", cmd = "LazyGit" }, -- LazyGit integration
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" }, --Loadon diff commands
        config = true, -- Use default configuration
    },
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" }, -- Load when opening or creating files
        config = function()
            --ConfigureGit signs (show changes in gutter)
            require("gitsigns").setup({
                signs = {
                    add = { text = "▎" }, -- Sign for added lines
                    change = { text = "▎" }, -- Sign for changed lines
                    delete = { text = "" }, -- Sign for deleted lines
                    topdelete = { text = "" }, -- Sign for top deleted lines
                    changedelete = { text = "▎" }, -- Sign for changed and deleted lines
                    untracked = { text = "▎" }, -- Signfor untracked lines
                },
                signcolumn = true, -- Show signs in sign column
                numhl = false, -- Don't highlight line numbers
                linehl = false, -- Don't highlight lines
                word_diff = false, -- Don't show word diff
                watch_gitdir = {
                    interval = 1000, -- Watch interval in ms
                    follow_files = true, -- Follow file movements
                },
                attach_to_untracked = true,
                current_line_blame = false, -- Don't show blame for current line
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = "eol", -- Show blame at end of line
                    delay = 1000, -- Delay before showing blame
                    ignore_whitespace = false,
                },
                current_line_blame_formatter = "<author>,<author_time:%Y-%m-%d>-<summary>",
                sign_priority = 6,
                update_debounce = 100,
                status_formatter = nil, -- Use default formatter
                max_file_length = 40000,
                preview_config = {
                    border = "single", -- Border style
                    style = "minimal", -- Minimal style
                    relative = "cursor", -- Relative to cursor
                    row = 0,
                    col = 1,
                },
            })
        end,
    },
    {
        "pwntester/octo.nvim",
        cmd = "Octo", -- Load on Octocommand
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "nvim-tree/nvim-web-devicons"
        },
        config = true, -- Use default configuration
    },

    -- Navigation plugins
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope", -- Load on Telescope command
        dependencies = { "nvim-lua/plenary.nvim" }, -- Required dependency
        config = function()
            -- Configure Telescope fuzzy finder
            require("telescope").setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-h>"] = "which_key", -- Show which-key in insert mode
                        },
                    },
                    file_ignore_patterns = {
                        "node_modules/",
                        ".git/",
                        "target/",
                        "build/",
                        "%.class"
                    }
                },
                extensions = {
                    -- Add extensions if needed
                },
            })

            -- Load Telescope extensions
            require("telescope").load_extension("harpoon")
            require("telescope").load_extension("undo")
            require("telescope").load_extension("colorscheme")
        end,
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x", -- Use v3.x branch
        cmd = { "Neotree", "NeoTreeFocus", "NeoTreeReveal" }, -- Load on tree commands
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim"
        },
        config = true, -- Use default configuration
    },
    {
        "ThePrimeagen/harpoon",
        event = "VeryLazy", -- Load when idle
        dependencies = { "nvim-lua/plenary.nvim" },
    },

    -- Emmet support for HTML/CSS
    { "mattn/emmet-vim", event = "BufReadPre" },

    --Code folding plugin
    {
        "kevinhwang91/nvim-ufo",
        event = "BufReadPost", -- Load after reading a file
        dependencies = { "kevinhwang91/promise-async" },
        config = function()
            -- Configure code folding with UFO (UnifiedFold)
            require("ufo").setup({
                provider_selector = function(bufnr, filetype, buftype)
                    return { "treesitter", "indent" }  -- Usetreesitter then indent for folding
                end,
                fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
                    -- Handle virtual text for folded regions
                    local newVirtText = {}
                    local suffix = (' 󰁂 %d '):format(endLnum - lnum)
                    local sufWidth = vim.fn.strdisplaywidth(suffix)
                    local targetWidth = width - sufWidth
                    local curWidth = 0
                    for _, chunk in ipairs(virtText) do
                        local chunkText = chunk[1]
                        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        if targetWidth > curWidth + chunkWidth then
                            table.insert(newVirtText, chunk)
                        else
                            chunkText = truncate(chunkText, targetWidth - curWidth)
                            local hlGroup = chunk[2]
                            table.insert(newVirtText, { chunkText, hlGroup })
                            chunkWidth = vim.fn.strdisplaywidth(chunkText)
                            if curWidth + chunkWidth < targetWidth
                            then
                                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                            end
                            break
                        end
                        curWidth = curWidth + chunkWidth
                    end
                    table.insert(newVirtText, { suffix, 'MoreMsg' })
                    return newVirtText
                end,
                enable_get_fold_virt_text = true,
                close_fold_kinds_for_ft = {
                    default = { "imports", "comment" },
                },
                preview = {
                    win_config = {
                        border = { '', '─', '', '', '', '─', '', '' },
                        winhighlight = 'Normal:Folded',
                        winblend = 0
                    },
                    mappings = {
                        scrollU = '<C-u>', -- Scroll up in preview
                        scrollD = '<C-d>', -- Scroll down in preview
                        jumpTop = '[', -- Jump to top in preview
                        jumpBot = ']'-- Jump to bottom in preview
                    }
                },
                open_fold_hl_timeout = 0, -- Disable fold highlight
            })

            -- Disable automatic folding bysetting foldlevel to 99 (show all)
            vim.api.nvim_create_autocmd("BufEnter", {
                callback = function()
                    vim.opt.foldlevel = 99
                end,
            })
        end
    },

    -- Formatting andlinting plugins
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre", "BufNewFile" }, -- Load when writing or creating files
        config = function()
            -- Load custom conform configuration
            local status_ok, module = pcall(require, "profile.tools.conform")
            if status_ok then
                return module
            end
        end,
    },

    -- Aerial - code structure overview (symbols outline)
    { "stevearc/aerial.nvim", event = "BufReadPost", config = true },

    -- Multi-cursor support
    { "mg979/vim-visual-multi", event = "BufReadPost" },

    -- Refactoring support
    {
        "ThePrimeagen/refactoring.nvim",
        event = "BufReadPost", -- Load after reading a file
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter"
        },
        config = true, -- Use default configuration
    },

    -- Flash - enhanced search navigation
    { "folke/flash.nvim", event = "VeryLazy", config = true },
    -- Linting plugin
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" }, -- Load when reading or creating files
        config = function()
            require("lint").linters_by_ft = {
                python = { "flake8" }, -- Python files use flake8
                java = { "checkstyle" }, -- Java files use checkstyle
                javascript = { "eslint_d" }, -- JavaScript files use eslint_d
                typescript = { "eslint_d" }, -- TypeScript files use eslint_d
                php = { "phpstan" }, -- PHP files use phpstan
                -- Add more filetypes and linters as needed
            }
        end,
    },

    -- Tasks plugin
    { "stevearc/overseer.nvim", cmd = { "OverseerRun", "OverseerToggle" }, config = true },

    -- Terminalplugin
    { "akinsho/toggleterm.nvim", cmd = { "ToggleTerm", "TermExec" }, config = true },

    -- UI plugins
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy", -- Load when idle
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            -- Load custom status line configuration
            require("profile.ui.statusline").setup()
        end,
    },

    -- Notification plugin
    {
        "rcarriga/nvim-notify",
        event = "VeryLazy", -- Load when idle
        config = function()
            -- Replace default vim.notify with nvim-notify
            vim.notify = require("notify")
        end,
    },

    -- Color themes
    {
        "folke/tokyonight.nvim",
        lazy = false, -- Load immediately
        priority = 1000, -- High priority
        config = function()
            -- Configure TokyoNight theme
            require("tokyonight").setup({
                style = "moon", -- Moon style
                transparent = true, -- Enable transparency
                terminal_colors = true, -- Enableterminal colors
            })
            -- Don't set colorscheme here since we'rehandling it in our theme module
        end,
    },
    { "rose-pine/neovim", name = "rose-pine", lazy = false, priority = 1000 },
    { "EdenEast/nightfox.nvim", lazy = false, priority = 1000 },
    { "nvim-tree/nvim-web-devicons", lazy = true }, -- Load on demand

    {
        "echasnovski/mini.icons",
        version = false,
        config = function()
            -- Configure mini.icons
            require("mini.icons").setup()
        end,
    },

     --Bufferline plugin (DISABLED)
     --{
     --    "akinsho/bufferline.nvim",
     --    event = "VeryLazy",
     --    dependencies ={ "nvim-tree/nvim-web-devicons" },
     --    config = function()
     --        require("bufferline").setup({
     --            options = {
     --                mode = "buffers",
     --                separator_style = "thin",
     --                always_show_bufferline = true,
     --               show_buffer_close_icons = true,
     --                show_close_icon = true,
     --            }
     --        })
     --    end
     --},

    -- Noice - enhance UI notifications and command line
    {
        "folke/noice.nvim",
        event = "VeryLazy", -- Load whenidle
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify"
        },
        config = function()
            -- Load custom noice configuration
            local status_ok, noice = pcall(require, "profile.ui.noice")
            if not status_ok then
                return
            end
            noice.setup()
        end,
    },

    -- Dressing - improve default UI elements
    { "stevearc/dressing.nvim", event = "VeryLazy", config = true },

    -- Indentation guides
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPost", "BufNewFile" }, -- Load when reading or creating files
        main = "ibl",
        config = true
    },

    -- Auto tag closing for HTML/JSX/XML
    { "windwp/nvim-ts-autotag", ft = { "html", "javascript", "typescript", "jsx", "tsx" } },

    -- Auto pairs for brackets, quotes, etc.
    { "windwp/nvim-autopairs", event = "InsertEnter", config = true },

    -- Context information in winbar
    { "SmiteshP/nvim-navic", event = "LspAttach" },

    -- Enhanced navigation UI
    {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "SmiteshP/nvim-navic"
        },
        event = "LspAttach", -- Load whenLSP attaches
        config = true,
    },

    -- Minimap
    { "gorbit99/codewindow.nvim", event = "BufReadPre", config = true },

    -- Treesitter - enhancedsyntax highlighting and code analysis
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPost", "BufNewFile" }, -- Load when reading or creating files
        build = ":TSUpdate", -- Run TSUpdate after installing
        config = function()
            --Load custom treesitter configuration
            local status_ok, module = pcall(require, "profile.treesitter")
            if status_ok then
                return module
            end
        end,
    },

    -- Session management
    { "folke/persistence.nvim", event = "BufReadPre", config = true },

    -- Dashboard/start screen
    {
        "goolord/alpha-nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = true,
        event = "VimEnter", -- Load when entering Vim
    },

    -- Search and replace
    { "nvim-pack/nvim-spectre", cmd = "Spectre", dependencies = { "nvim-lua/plenary.nvim" } },

    -- Testing framework
    {
        "nvim-neotest/neotest",
        event = "VeryLazy", -- Load when idle
        dependencies = {
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            -- Adapters: add as needed, e.g. neotest-python, neotest-jest, etc.
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    -- require("neotest-python"),
                    -- require("neotest-jest"),
                    -- Add adapters as needed
                },
            })
        end,
    },

    -- Languagespecific pluginsfrom previoussetup
    { 'p00f/clangd_extensions.nvim' },
    { "simrat39/rust-tools.nvim", event = "BufReadPre" },
    { "rust-lang/rust.vim" },
    { "ray-x/go.nvim", event = "BufReadPre", config = function()
        _GO_NVIM_CFG = {
            lsp_cfg = true,
        }
        require("go").setup()
    end },
    { "leoluz/nvim-dap-go" }, -- Go debugging support

    -- Zig language plugin
    { "ziglang/zig.vim" }, -- Zig syntax support

    -- C# languageplugins
    { "Hoffs/omnisharp-extended-lsp.nvim", event = "BufReadPre" }, -- Extended C# LSP support

    -- Flutter/Dart plugin
    {
        "akinsho/flutter-tools.nvim", -- Flutter development tools
        dependencies = {
            "nvim-lua/plenary.nvim",
            "stevearc/conform.nvim",
        },
        event = "BufReadPre", -- Load when reading files
        config = true,
    },

    -- Java language plugins
    { "mfussenegger/nvim-jdtls", event = "BufReadPre" }, -- Java LSP support
    { "rcasia/neotest-java", event = "BufReadPre" }, -- Java testing support

    -- C# testing plugin
    { "Issafalcon/neotest-dotnet", event = "BufReadPre" }, -- .NET testing support

    -- Web development plugins
    { "windwp/nvim-ts-autotag", ft = { "html", "javascript", "typescript", "jsx", "tsx", "vue", "svelte", "astro" } }, -- Auto close tags
    { "norcalli/nvim-colorizer.lua", ft = { "css", "scss", "sass", "less", "javascript", "typescript" } }, -- Color visualization

    -- Mojo language plugin
    { "czheo/mojo.vim", event = "BufReadPre" }, -- Syntax highlighting for Mojo

    -- Database plugins
    {
        "kristijanhusak/vim-dadbod", --Database interface
        cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" }
    },
    { "kristijanhusak/vim-dadbod-ui", cmd = { "DBUI", "DBUIToggle" } }, -- Database UI

    -- PHP language support plugins
    { "phpactor/phpactor", build = "composer install --ignore-platform-req=ext-iconv", ft = "php" }, -- PHP language server and refactoring tool
    { "ray-x/guihua.lua", ft = "php" }, -- Required for phpactor.nvim

    -- Laravel support
    { "adalessa/laravel.nvim", ft = { "php", "blade" }, dependencies = {
        "nvim-lua/plenary.nvim",
        "mfussenegger/nvim-dap",
        "rcarriga/nvim-notify",
    }, config = true },

    -- Blade template support
    { "jwalton512/vim-blade", ft = "blade" }, -- Blade syntax highlighting
}