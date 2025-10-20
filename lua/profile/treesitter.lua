-- nvim-treesitter setup
require('nvim-treesitter.configs').setup({
  ensure_installed = { "lua", "python", "java", "javascript", "typescript", "c", "cpp", "go" },
  sync_install = false,
  highlight = { enable = true },
  indent = { enable = true },
  autotag = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = false,
      node_decremental = "<bs>",
    },
  },
})