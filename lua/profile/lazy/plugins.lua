--lazy.nvim plugin specs
-- Bootstrap lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

return {
    { "folke/lazy.nvim", version = "*" },
    { "lewis6991/impatient.nvim" },

    checker = { enabled = true, notify = false },
    performance = {
        cache = {
            enabled = true,
        },
        reset_packpath = true,
        rtp = {
            reset = true,
            paths = {},
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },

    --Which-key
    { "folke/which-key.nvim", event = "VeryLazy" },

    -- Completion
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "saadparwaiz1/cmp_luasnip",
            "L3MON4D3/LuaSnip",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            localstatus_ok, module = pcall(require, "profile.completion.cmp")
            if status_ok then
                return module
            end
        end,
    },

    -- LSP
    { "williamboman/mason.nvim", cmd = "Mason", config = true },
    { "williamboman/mason-lspconfig.nvim" },
    { "WhoIsSethDaniel/mason-tool-installer.nvim" },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local status_ok, module = pcall(require, "profile.lsp.lspconfig")
           if status_ok then
                return module
            end
        end,
    },
    { "folke/neodev.nvim", ft = "lua" },
   -- { "tjdevries/scriptease.vim", ft= "lua" },  -- Commented out as repository not found

  --Debugging
    {
        "mfussenegger/nvim-dap",
        event = "VeryLazy",
        config = function()
            local status_ok, module = pcall(require, "profile.dap.init")
            if status_ok then
                return module
            end
        end,
    },
   { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
    { "jay-babu/mason-nvim-dap.nvim" },

    -- Git
 {"tpope/vim-fugitive", cmd = "Git" },
    {"kdheepak/lazygit.nvim", cmd = "LazyGit" },
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
        config = true,
    },
{
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("gitsigns").setup({
                signs={
                    add = { text = "▎" },
                    change = {text= "▎" },
                    delete = { text = "" },
                    topdelete = { text = "" },
                    changedelete = { text = "▎" },
                    untracked = { text="▎" },
                },
                signcolumn = true, --Toggle with`:Gitsigns toggle_signs`
                numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
                linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
                word_diff= false, -- Toggle with `:Gitsignstoggle_word_diff`
                watch_gitdir = {
                    interval = 1000,
                    follow_files = true,
                },
                attach_to_untracked = true,
                current_line_blame = false, -- Toggle with `:Gitsignstoggle_current_line_blame`
                current_line_blame_opts = {
                   virt_text = true,
                    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
                    delay = 1000,
                    ignore_whitespace = false,
                },
                current_line_blame_formatter= "<author>,<author_time:%Y-%m-%d>-<summary>",
                sign_priority = 6,
                update_debounce = 100,
                status_formatter = nil, -- Usedefault
                max_file_length = 40000,
                preview_config = {
                    --Optionspassed tonvim_open_winborder = "single",
                    style ="minimal",
                    relative = "cursor",
                    row = 0,
                    col = 1,
                },
            })
        end,
    },
    {
        "pwntester/octo.nvim",
        cmd = "Octo",
        dependencies ={"nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim", "nvim-tree/nvim-web-devicons" },
        config = true,
    },

    -- Navigation
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
dependencies={ "nvim-lua/plenary.nvim"},
        config = function()
            require("telescope").setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-h>"] = "which_key",
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
                    -- Add ifneeded
                },
            })

            require("telescope").load_extension("harpoon")
            require("telescope").load_extension("undo")
            require("telescope").load_extension("colorscheme")
        end,
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        cmd = { "Neotree", "NeoTreeFocus", "NeoTreeReveal" },
        dependencies = { "nvim-lua/plenary.nvim","nvim-tree/nvim-web-devicons","MunifTanjim/nui.nvim" },
        config = true,
    },
    { "ThePrimeagen/harpoon", event = "VeryLazy", dependencies = { "nvim-lua/plenary.nvim" },

    },

   -- CodeFolding
    {
        "kevinhwang91/nvim-ufo",
        event = "BufReadPost",
        dependencies = { "kevinhwang91/promise-async" },
        config = function()
            require("ufo").setup({
                provider_selector = function(bufnr,filetype,buftype)
                    return { "treesitter","indent" }
                end,
               fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
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
                            table.insert(newVirtText, {chunkText, hlGroup})
                            chunkWidth = vim.fn.strdisplaywidth(chunkText)
                            if curWidth+ chunkWidth < targetWidth then
                                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                            end
                            break
                        end
                        curWidth = curWidth + chunkWidth
                    end
                    table.insert(newVirtText, {suffix, 'MoreMsg'})
                    return newVirtText
                end,
                enable_get_fold_virt_text = true,
                close_fold_kinds = {"imports", "comment" }, -- Close only imports and comments by default
                preview = {
                    win_config = {
                        border = {'', '─', '', '', '', '─', '', ''},
                        winhighlight = 'Normal:Folded',
                        winblend =0
                    },
                    mappings = {
                       scrollU = '<C-u>',
                        scrollD = '<C-d>',
                        jumpTop = '[',
                        jumpBot = ']'
                    }
                },
open_fold_hl_timeout = 0, -- Disable fold highlight
            })
            
            -- Disable automatic folding by setting fold level to 99 (show all)
            vim.api.nvim_create_autocmd("BufEnter", {
                callback = function()
                    vim.opt.foldlevel = 99
               end,
            })
        end
    },

-- Formatting/Linting
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre", "BufNewFile" },
        config = function()
           local status_ok, module = pcall(require, "profile.tools.conform")
            if status_ok then
                return module
end
        end,
    },
    -- Aerial - code structure overview
    { "stevearc/aerial.nvim", event = "BufReadPost", config = true },
-- Multi-cursor support
    { "mg979/vim-visual-multi", event = "BufReadPost"},
    -- Refactoring support
    {
        "ThePrimeagen/refactoring.nvim",
        event = "BufReadPost",
        dependencies = { "nvim-lua/plenary.nvim","nvim-treesitter/nvim-treesitter" },
        config = true,
    },
    -- Flash -enhanced search navigation
    { "folke/flash.nvim", event = "VeryLazy", config = true },
    {
        "mfussenegger/nvim-lint",
event = {"BufReadPre", "BufNewFile" },
        config = function()
            require("lint").linters_by_ft={
                python = { "flake8" },
                java = { "checkstyle" },
                javascript = { "eslint_d" },
                typescript = { "eslint_d" },
               -- Add more
            }
        end,
},

    -- Tasks
    { "stevearc/overseer.nvim", cmd = { "OverseerRun", "OverseerToggle" }, config = true },

    --Terminal
    { "akinsho/toggleterm.nvim", cmd ={ "ToggleTerm", "TermExec"}, config = true },

    --UI
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("profile.ui.statusline").setup()
        end,
},
-- { "akinsho/bufferline.nvim", event= "VeryLazy",config= true },
    {
        "rcarriga/nvim-notify",
        event = "VeryLazy",
        config = function()
            vim.notify = require("notify")
        end,
},
    {
       "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("tokyonight").setup({
                style = "moon",
                transparent = true,
                terminal_colors = true,
           })
            -- Don't set colorschemehere sincewe'rehandling it in our thememodule
        end,
    },
    { "rose-pine/neovim", name = "rose-pine", lazy = false, priority = 1000 },
    { "EdenEast/nightfox.nvim", lazy =false, priority = 1000 },
    { "nvim-tree/nvim-web-devicons", lazy = true },
   {
"echasnovski/mini.icons",
        version = false,
        config = function()
            require("mini.icons").setup()
        end,
    },
{
        "folke/noice.nvim",
event = "VeryLazy",
        dependencies = { "MunifTanjim/nui.nvim","rcarriga/nvim-notify" },
        config = function()
            local status_ok, noice = pcall(require, "profile.ui.noice")
            if not status_ok then
return
end
            noice.setup()
        end,
    },
    { "stevearc/dressing.nvim",event = "VeryLazy", config = true },
    { "lukas-reineke/indent-blankline.nvim", event = { "BufReadPost", "BufNewFile" },main = "ibl", config = true },
    { "windwp/nvim-ts-autotag", ft={ "html", "javascript", "typescript", "jsx", "tsx" }},
    { "windwp/nvim-autopairs", event = "InsertEnter", config = true},
   { "SmiteshP/nvim-navic", event = "LspAttach" },
    {
        "SmiteshP/nvim-navbuddy",
        dependencies = { "MunifTanjim/nui.nvim", "SmiteshP/nvim-navic" },
        event ="LspAttach",
config= true,
    },
    { "gorbit99/codewindow.nvim", event = "BufReadPre", config = true }, -- Minimap

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        event = {"BufReadPost", "BufNewFile" },
        build = ":TSUpdate",
        config = function()
            local status_ok, module =pcall(require, "profile.treesitter")
            if status_ok then
                return module
            end
        end,
    },

    -- Session
    { "folke/persistence.nvim", event= "BufReadPre", config = true },
    -- Dashboard
    {
        "goolord/alpha-nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = true,
        event = "VimEnter",
    },

   --Search/Replace
   { "nvim-pack/nvim-spectre", cmd = "Spectre", dependencies = { "nvim-lua/plenary.nvim" } },

    -- Testing
    {
        "nvim-neotest/neotest",
        event = "VeryLazy",
        dependencies= {
           "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            --Adapters:addas needed, e.g. neotest-python, neotest-jest, etc.
       },
        config= function()
require("neotest").setup({
                adapters = {
                    -- require("neotest-python"),
                    --require("neotest-jest"),
                    --Add adaptersas needed
                },
            })
        end,
    },

    -- Other{ "numToStr/Comment.nvim",event = "BufReadPre",config= true },
    { "kylechui/nvim-surround", event = "VeryLazy", config=true },
    { "mbbill/undotree", cmd = "UndotreeToggle" },
    {
        "zbirenbaum/copilot.lua",
       event = "InsertEnter",
config = function()
            require("copilot").setup({
                suggestion = { enabled = true, auto_trigger = true },
panel= { enabled = true },
            })
        end,
    },
    { "folke/trouble.nvim", cmd = "TroubleToggle", dependencies= { "nvim-tree/nvim-web-devicons" }, config = true },
    { "tiagovla/scope.nvim", event = "VeryLazy", config = true }, -- Tab scopes
    { "folke/todo-comments.nvim", event = { "BufReadPost", "BufNewFile" }, dependencies = {"nvim-lua/plenary.nvim" }, config = true },

    -- Language specific pluginsfrom previoussetup{ 'p00f/clangd_extensions.nvim' },
    { "simrat39/rust-tools.nvim", event = "BufReadPre" },
    {"rust-lang/rust.vim" },
    {"ray-x/go.nvim", event = "BufReadPre" },
    { "leoluz/nvim-dap-go" },
    { "ziglang/zig.vim" },
    { "Hoffs/omnisharp-extended-lsp.nvim", event = "BufReadPre" }, --added-by-agent: csharp-setup
    {
        "akinsho/flutter-tools.nvim", -- added-by-agent:flutter-setup
dependencies = {
            "nvim-lua/plenary.nvim",
            "stevearc/conform.nvim",
        },
       event = "BufReadPre",
        config = true,
    },
    { "mfussenegger/nvim-jdtls", event = "BufReadPre"}, --added-by-agent: java-setup
    { "Issafalcon/neotest-dotnet", event = "BufReadPre" }, --added-by-agent: csharp-setup
   {"rcasia/neotest-java", event = "BufReadPre" }, --added-by-agent: java-setup

    --Web development plugins
{ "windwp/nvim-ts-autotag", ft = { "html", "javascript", "typescript", "jsx", "tsx", "vue", "svelte", "astro" } },
    { "norcalli/nvim-colorizer.lua", ft = { "css", "scss", "sass", "less", "javascript", "typescript" } },
    
    -- Mojo
    { "czheo/mojo.vim", event = "BufReadPre" }, -- Syntax highlighting for Mojo

   -- database-relatedplugins (for lazy.nvim)--added-by-agent: db-setup 20251020-151229i
    {
        "kristijanhusak/vim-dadbod",
        cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer"}
    },
    { "kristijanhusak/vim-dadbod-ui", cmd = { "DBUI", "DBUIToggle" } }
}