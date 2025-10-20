return {
  -- UI & Theme
  { "folke/tokyonight.nvim" },
  { "nvim-tree/nvim-web-devicons" },
  { "nvim-lualine/lualine.nvim" },
  { "akinsho/bufferline.nvim" },

  -- Core
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "jay-babu/mason-nvim-dap.nvim" }, -- added-by-agent: mern-setup 20251020-170000
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },

  -- Debug & Test
  { "mfussenegger/nvim-dap" },
  { "rcarriga/nvim-dap-ui" },
  { "rcarriga/nvim-dap-ui" },
  { "theHamsta/nvim-dap-virtual-text" },
  { "nvim-neotest/neotest" },

  -- Treesitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- Navigation & Search
  { "nvim-telescope/telescope.nvim" },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

  -- Git
  { "lewis6991/gitsigns.nvim" },

  -- MERN Specific
  { "jose-elias-alvarez/null-ls.nvim" }, -- added-by-agent: mern-setup 20251020-170000
  { "windwp/nvim-ts-autotag" }, -- added-by-agent: mern-setup 20251020-170000
  { "mattn/emmet-vim" }, -- added-by-agent: mern-setup 20251020-170000
}