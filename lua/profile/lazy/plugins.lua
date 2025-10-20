-- lazy.nvim plugin specs
-- TODO: Bootstrap lazy.nvim if not installed
return {
  { 'folke/lazy.nvim', version = 'stable' },
  { 'neovim/nvim-lspconfig' },
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'L3MON4D3/LuaSnip' },
  { 'nvim-treesitter/nvim-treesitter' },
  { 'nvim-telescope/telescope.nvim' },
  { 'nvim-telescope/telescope-fzf-native.nvim' },
  { 'folke/which-key.nvim' },
  { 'nvim-lualine/lualine.nvim' },
  { 'akinsho/bufferline.nvim' },
  { 'nvim-neo-tree/neo-tree.nvim' },
  { 'lewis6991/gitsigns.nvim' },
  { 'jose-elias-alvarez/null-ls.nvim' },
  { 'mfussenegger/nvim-dap' },
  { 'mfussenegger/nvim-dap-ui' },
  { 'rose-pine/neovim' },
  { 'folke/tokyonight.nvim' },
  { 'iamcco/markdown-preview.nvim' },
  { 'nvim-treesitter/playground' },
  { 'telescope-live-grep-args' },
  -- Language-specific plugins
  { 'simrat39/rust-tools.nvim', ft = { 'rust' } },
  { 'saecki/crates.nvim', ft = { 'rust' } },
  { 'mfussenegger/nvim-dap-python', ft = { 'python' } },
  { 'akinsho/flutter-tools.nvim', ft = { 'dart', 'flutter' } },
  { 'm4xshen/smartcolumn.nvim' },
}
-- Neovim IDE bootstrap
-- Requires main profile config
pcall(require, 'profile')

