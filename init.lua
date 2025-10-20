-- Set leader key BEFORE loading any plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic options that should be set before plugins
vim.opt.termguicolors = true
vim.opt.background = "dark"

    { "--branch=stable" },
    lazypath
)
vim.opt.rtp:prepend(lazypath)

-- Load and initialize lazy
require("lazy").setup("profile.lazy.plugins", {
  install = {
    colorscheme = { "tokyonight" },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
  change_detection = {
    notify = false,
  },
      },
    },
  },
})

-- Set a default colorscheme that we know exists
vim.cmd([[colorscheme tokyonight]])

-- Neovim bootstrap: load modular profile config
pcall(require, 'profile')
