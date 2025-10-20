-- nvim-treesitter setup
require('nvim-treesitter.configs').setup {
  ensure_installed = {
    'c', 'cpp', 'rust', 'go', 'javascript', 'typescript', 'tsx', 'html', 'css', 'dart', 'java', 'c_sharp', 'zig', 'lua', 'asm'
  },
  highlight = { enable = true },
  incremental_selection = { enable = true },
  textobjects = { enable = true },
  playground = { enable = true },
}

