--Profile startup time
local startup_time = vim.fn.reltime()

-- Essential options that must be set before plugins load
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_python3_provider = 0  -- Disable Python provider if not needed
vim.g.loaded_ruby_provider = 0     -- Disable Ruby provider if not needed
vim.g.loaded_node_provider = 0     -- Disable Node provider if not needed
vim.g.loaded_perl_provider = 0     -- Disable Perl provider if not needed

-- Ensure modules table exists early
_G.modules = {
    loaded = {},
    failed = {},
 startup_errors = {},
}

-- Create early utility functions
local function log_error(msg, level)
    level = level or vim.log.levels.ERROR
    table.insert(_G.modules.startup_errors, { msg = msg, level = level })
    vim.schedule(function()
        vim.notify(msg, level)
    end)
end

-- Early compatibility checks
local has_min_version = vim.fn.has("nvim-0.8.0") == 1

if not has_min_version then
    log_error("Neovim >= 0.8.0 is required")
    return
end

-- Set performance-related options early
vim.opt.shadafile = "NONE"            -- Disable shada file during startup
vim.opt.lazyredraw = true             -- Don't redraw screen during macros
vim.opt.ruler = false                 -- Disable ruler during startup
vim.opt.showcmd = false               -- Disable showcmd during startup

-- Bootstrap lazy.nvim witherrorhandling
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.notify("Installing lazy.nvim...", vim.log.levels.INFO)
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

-- Configure and load plugins
require("lazy").setup({
    spec= {
        { import = "plugins" },
    },
    defaults = {
        lazy = true,
        version = false,
    },
    install = {
        colorscheme = { "rose-pine" },
    },
    checker = {
        enabled = true,
        notify = false,
    },
    change_detection ={
        notify = false,
   },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
    ui = {
        border = "rounded",
    },
})

--Load core configuration
require("core").setup()

-- Load language configurations
require("langs").setup()

-- Restorestartup options
vim.opt.shadafile = ""            -- Restore shada file
vim.opt.lazyredraw = false        -- Restore normal redraw
vim.opt.ruler = true              -- Restore ruler
vim.opt.showcmd = true           -- Restore showcmd

-- Report startup time
vim.schedule(function()
    local elapsed= vim.fn.reltimefloat(vim.fn.reltime(startup_time))
    vim.notify(string.format("Startup completed in %.2f seconds", elapsed), vim.log.levels.INFO)
end)

-- Set colorscheme after everythingis loaded
vim.cmd.colorscheme("rose-pine")
