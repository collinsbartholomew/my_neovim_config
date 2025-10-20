-- lazy.nvim plugin specs
-- Bootstrap lazy.nvim if not installed
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath})
end
vim.opt.rtp:prepend(lazypath)

local lazy = require("lazy")

lazy.setup({
  checker = { enabled = true, notify = false },
  performance = {
    rtp = {
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
  spec = {
    -- Core
    { "folke/lazy.nvim" },

    -- Which-key
    { "folke/which-key.nvim", event = "VeryLazy" },

    -- Completion
    { "hrsh7th/nvim-cmp", event = "InsertEnter", dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    } },

    -- LSP
    { "williamboman/mason.nvim", cmd = "Mason", config = true },
    { "williamboman/mason-lspconfig.nvim" },
    { "neovim/nvim-lspconfig", event = { "BufReadPre", "BufNewFile" } },
    { "folke/neodev.nvim", ft = "lua" },

    -- Debugging
    { "mfussenegger/nvim-dap", event = "VeryLazy" },
    { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
    { "jay-babu/mason-nvim-dap.nvim" },

    -- Git
    { "tpope/vim-fugitive", cmd = "Git" },
    { "kdheepak/lazygit.nvim", cmd = "LazyGit" },
    { "lewis6991/gitsigns.nvim", event = "BufReadPre", config = true },
    { "pwntester/octo.nvim", cmd = "Octo", dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim", "nvim-tree/nvim-web-devicons" }, config = true },

    -- Navigation
    { "nvim-telescope/telescope.nvim", cmd = "Telescope", dependencies = { "nvim-lua/plenary.nvim" } },
    { "nvim-neo-tree/neo-tree.nvim", branch = "v3.x", cmd = "Neotree", dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" }, config = true },
    { "ThePrimeagen/harpoon", event = "VeryLazy", dependencies = { "nvim-lua/plenary.nvim" } },

    -- Code Folding
    { "kevinhwang91/nvim-ufo", event = "BufRead", dependencies = { "kevinhwang91/promise-async" } },

    -- Formatting/Linting
    { "stevearc/conform.nvim", event = "BufWritePre" },
    { "mfussenegger/nvim-lint", event = "BufReadPre" },

    -- Tasks
    { "stevearc/overseer.nvim", cmd = { "OverseerRun", "OverseerToggle" }, config = true },

    -- Terminal
    { "akinsho/toggleterm.nvim", cmd = "ToggleTerm", config = true },

    -- UI
    { "nvim-lualine/lualine.nvim", event = "VeryLazy", dependencies = { "nvim-tree/nvim-web-devicons" } },
    { "akinsho/bufferline.nvim", event = "VeryLazy", config = true },
    { "rcarriga/nvim-notify", event = "VeryLazy", config = function() vim.notify = require("notify") end },
    { "folke/tokyonight.nvim", lazy = false, priority = 1000, config = function() vim.cmd.colorscheme("tokyonight") end },
    { "nvim-tree/nvim-web-devicons", lazy = true },
    { "folke/noice.nvim", event = "VeryLazy", dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" } },
    { "stevearc/dressing.nvim", event = "VeryLazy", config = true },
    { "lukas-reineke/indent-blankline.nvim", event = "BufReadPre", main = "ibl", config = true },
    { "windwp/nvim-autopairs", event = "InsertEnter", config = true },
    { "windwp/nvim-ts-autotag", ft = { "html", "javascript", "typescript", "jsx", "tsx" } },
    { "SmiteshP/nvim-navic", event = "LspAttach" },
    { "SmiteshP/nvim-navbuddy", dependencies = { "MunifTanjim/nui.nvim", "SmiteshP/nvim-navic" }, event = "LspAttach", config = true },
    { "gorbit99/codewindow.nvim", event = "BufReadPre", config = true }, -- Minimap

    -- Treesitter
    { "nvim-treesitter/nvim-treesitter", event = "BufReadPre", build = ":TSUpdate" },

    -- Session
    { "folke/persistence.nvim", event = "BufReadPre", config = true },

    -- Search/Replace
    { "nvim-pack/nvim-spectre", cmd = "Spectre", dependencies = { "nvim-lua/plenary.nvim" } },

    -- Testing
    { "nvim-neotest/neotest", event = "VeryLazy", dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- Adapters: add as needed, e.g. neotest-python, neotest-jest, etc.
    } },

    -- Other
    { "numToStr/Comment.nvim", event = "BufReadPre", config = true },
    { "kylechui/nvim-surround", event = "VeryLazy", config = true },
    { "mbbill/undotree", cmd = "UndotreeToggle" },
    { "zbirenbaum/copilot.lua", event = "InsertEnter" },
    { "folke/trouble.nvim", cmd = "TroubleToggle", dependencies = { "nvim-tree/nvim-web-devicons" }, config = true },
    { "tiagovla/scope.nvim", event = "VeryLazy", config = true }, -- Tab scopes
    { "folke/todo-comments.nvim", event = "BufReadPre", dependencies = { "nvim-lua/plenary.nvim" }, config = true },
    
    -- Language specific plugins from previous setup
    { 'p00f/clangd_extensions.nvim' },
    { 'simrat39/rust-tools.nvim' },
    { 'rust-lang/rust.vim' },
    { 'ray-x/go.nvim' },
    { 'leoluz/nvim-dap-go' },
    { 'ziglang/zig.vim' },
    { 'Hoffs/omnisharp-extended-lsp.nvim' }, -- added-by-agent: csharp-setup
    { 'akinsho/flutter-tools.nvim', -- added-by-agent: flutter-setup
      dependencies = {
        'nvim-lua/plenary.nvim',
        'stevearc/conform.nvim',
      },
      config = true
    },
    { 'mfussenegger/nvim-jdtls' }, -- added-by-agent: java-setup
    
    -- database-related plugins (for lazy.nvim) -- added-by-agent: db-setup 20251020-151229
    { "kristijanhusak/vim-dadbod" },
    { "kristijanhusak/vim-dadbod-ui" },
  },
})