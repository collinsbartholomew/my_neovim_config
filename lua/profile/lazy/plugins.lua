-- lazy.nvim plugin specs
-- Bootstrap lazy.nvim if not installed
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath})
end
vim.opt.rtp:prepend(lazypath)

return {
  { 'folke/lazy.nvim', version = '*' },

  -- UI
  { 'nvim-tree/nvim-web-devicons' },
  { 'MunifTanjim/nui.nvim' },  -- Required by neo-tree
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    }
  },
  { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },

  -- LSP & Completion
  { 'neovim/nvim-lspconfig' },
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/nvim-cmp',
      'L3MON4D3/LuaSnip',
    }
  },
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'L3MON4D3/LuaSnip' },
  { 'saadparwaiz1/cmp_luasnip' },

  -- Treesitter
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },

  -- Navigation & Search
  { 'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },

  -- Git
  { 'lewis6991/gitsigns.nvim' },

  -- Debug
  { 'mfussenegger/nvim-dap' },
  { 'rcarriga/nvim-dap-ui', dependencies = { 'mfussenegger/nvim-dap' } },

  -- Theme
  { 'rose-pine/neovim', name = 'rose-pine' },
  { 'folke/tokyonight.nvim' },

  -- UI Enhancements
  { 'nvim-focus/focus.nvim' },
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl' },
  { 'folke/zen-mode.nvim' },
  { 'folke/twilight.nvim' },
  { 'j-hui/fidget.nvim', tag = 'legacy' },
  { 'rcarriga/nvim-notify' },
  { 'stevearc/dressing.nvim' },
  
  -- Additional UI enhancements
  { 'mbbill/undotree' },  -- Visual undo tree
  { 'nvim-telescope/telescope-ui-select.nvim' },  -- Better UI for selections
  { 'SmiteshP/nvim-navic' },  -- Show code context in winbar
  { 'Bekaboo/dropbar.nvim' },  -- IDE-like breadcrumbs
  { 'utilyre/barbecue.nvim',  -- VS Code-like breadcrumbs
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {}
  },
  { 'akinsho/bufferline.nvim', -- Buffer tabs
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        mode = "tabs",
        separator_style = "slant",
      }
    }
  },
  { 'goolord/alpha-nvim', -- Startup screen
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
      require'alpha'.setup(require'alpha.themes.dashboard'.config)
    end
  },

  -- Language specific
  { 'p00f/clangd_extensions.nvim' },
  { 'simrat39/rust-tools.nvim' },
  { 'rust-lang/rust.vim' },
  { 'ray-x/go.nvim' },
  { 'leoluz/nvim-dap-go' },
  { 'ziglang/zig.vim' },
  { 'jay-babu/mason-nvim-dap.nvim' },
  { 'stevearc/conform.nvim' },
  { 'theHamsta/nvim-dap-virtual-text' },
  { 'folke/trouble.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },
  { 'akinsho/toggleterm.nvim', version = '*', config = true },

  -- Testing
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim"
    }
  },
  { 'rouge8/neotest-rust' },
  { 'nvim-neotest/neotest-go' },

  -- Other
  { 'folke/which-key.nvim' },
  { 'windwp/nvim-autopairs' },
  { 'numToStr/Comment.nvim' },
}