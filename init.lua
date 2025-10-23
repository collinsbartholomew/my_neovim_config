-- Set leader key BEFORE loading any plugins
-- This ensures that all plugins use the same leader key
vim.g.mapleader = " "        -- Space as leader key
vim.g.maplocalleader = " "   -- Space as local leader key

-- Add LuaRocks paths
-- This allows Neovim to find Lua libraries installed via LuaRocks
local luarocks_paths = {
  package.path .. ';/home/collins/.luarocks/share/lua/*/?.lua;/home/collins/.luarocks/share/lua/5.4/?/init.lua',
  package.cpath .. ';/home/collins/.luarocks/lib/lua/*/?.so'
}

package.path = luarocks_paths[1]   -- Add LuaRocks to Lua path
package.cpath = luarocks_paths[2]  -- Add LuaRocks to C path

-- Basic options that should be set before plugins
vim.opt.termguicolors = true   -- Enable true color support
vim.opt.background = "dark"    -- Set background to dark mode

-- Bootstrap lazy.nvim
-- This section installs lazy.nvim plugin manager if it's not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- If lazy.nvim doesn't exist, clone it from GitHub
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",  -- Use the stable branch
    lazypath,
  })
end
-- Add lazy.nvim to the runtime path
vim.opt.rtp:prepend(lazypath)

-- Load and initialize lazy with the profile plugins
-- This loads all plugins defined in the profile.lazy.plugins module
require("lazy").setup("profile.lazy.plugins", {
  install = {
    colorscheme = { "rose-pine" },  -- Install rose-pine colorscheme by default
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",         -- Disable gzip plugin
        "matchit",      -- Disable matchit plugin
        "matchparen",   -- Disable matchparen plugin
        "netrwPlugin",  -- Disable netrw plugin (using neo-tree instead)
        "tarPlugin",    -- Disable tar plugin
        change_detection = {
          notify = false,  -- Disable change detection notifications
        },
      },
    },
  },
})

-- Neovim bootstrap: load modular profile config
-- This loads the main profile configuration module
require('profile')