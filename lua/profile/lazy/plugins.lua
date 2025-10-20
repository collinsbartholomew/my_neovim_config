-- lazy.nvim plugin specs
-- Bootstrap lazy.nvim if not installed
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath})
end
vim.opt.rtp:prepend(lazypath)

return {
  { 'folke/lazy.nvim', version = 'stable' },
  { 'neovim/nvim-lspconfig', commit = 'b1e2e7e' },
  { 'williamboman/mason.nvim', commit = 'c6f3e2a' },
  { 'williamboman/mason-lspconfig.nvim', commit = 'e2b2e2b' },
  { 'hrsh7th/nvim-cmp', commit = 'd2e2e2d' },
  { 'hrsh7th/cmp-nvim-lsp', commit = 'e2d2d2e' },
  { 'hrsh7th/cmp-buffer', commit = 'f2e2e2f' },
  { 'hrsh7th/cmp-path', commit = 'a2e2e2a' },
  { 'L3MON4D3/LuaSnip', commit = 'b3e3e3b' },
  { 'nvim-treesitter/nvim-treesitter', commit = 'c3e3e3c' },
  { 'nvim-telescope/telescope.nvim', commit = 'd3e3e3d' },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', commit = 'e3d3d3e' },
  { 'folke/which-key.nvim', commit = 'f3e3e3f' },
  { 'nvim-lualine/lualine.nvim', commit = 'a3e3e3a' },
  { 'akinsho/bufferline.nvim', commit = 'b4e4e4b' },
  { 'nvim-neo-tree/neo-tree.nvim', commit = 'c4e4e4c' },
  { 'lewis6991/gitsigns.nvim', commit = 'd4e4e4d' },
  { 'mfussenegger/nvim-dap', commit = 'f4e4e4f' },
  { 'mfussenegger/nvim-dap-ui', commit = 'a4e4e4a' },
  { 'rose-pine/neovim', commit = 'b5e5e5b' },
  { 'folke/tokyonight.nvim', commit = 'c5e5e5c' },
  { 'iamcco/markdown-preview.nvim', build = 'cd app && yarn install', commit = 'd5e5e5d' },
  { 'nvim-treesitter/playground', commit = 'e5d5d5e' },
  { 'nvim-telescope/telescope-live-grep-args.nvim', commit = 'f5e5e5f' },
  -- Language-specific plugins
  { 'simrat39/rust-tools.nvim', ft = { 'rust' }, commit = 'a6e6e6a' },
  { 'saecki/crates.nvim', ft = { 'rust' }, commit = 'b6e6e6b' },
  { 'mfussenegger/nvim-dap-python', ft = { 'python' }, commit = 'c6e6e6c' },
  { 'akinsho/flutter-tools.nvim', ft = { 'dart', 'flutter' }, commit = 'd6e6e6d' },
  { 'm4xshen/smartcolumn.nvim', commit = 'e6d6d6e' },
  { 'VonHeikemen/lsp-zero.nvim', branch = 'v3.x' },
  { 'ray-x/go.nvim', ft = { 'go', 'gomod', 'gosum', 'gotmpl' } },
  { 'leoluz/nvim-dap-go', ft = { 'go' } },
  { 'jay-babu/mason-nvim-dap.nvim' },
  { 'stevearc/conform.nvim' },
  { 'nvim-neotest/neotest' },
  { 'nvim-neotest/neotest-go', ft = { 'go' } },
}
-- Neovim IDE bootstrap
-- Requires main profile config
pcall(require, 'profile')
