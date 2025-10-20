#!/bin/bash
# Setup Zig development environment

echo "Setting up Zig development environment..."

# Create a temporary init file that just installs packages
cat > /tmp/temp_init.lua << 'EOL'
vim.g.mapleader = " "
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "jay-babu/mason-nvim-dap.nvim",
})

vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  callback = function()
    require("mason").setup()
    local registry = require("mason-registry")
    registry.refresh()
    registry.install("zls")
    registry.install("codelldb")
    vim.cmd("sleep 10000m")
    vim.cmd("qa!")
  end,
})
EOL

# Run Neovim with the temporary init file
nvim --headless -u /tmp/temp_init.lua

echo "Installation complete. Please restart Neovim to use the Zig development environment."
