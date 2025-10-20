--Set leader key BEFORE loading any plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic options that should be set before plugins
vim.opt.termguicolors = true
vim.opt.background = "dark"

-- Bootstrap lazy.nvim
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

-- Load and initialize lazy withthe new configuration
require("profile.lazy.plugins")

-- Neovim bootstrap: load modular profile config
require('profile')