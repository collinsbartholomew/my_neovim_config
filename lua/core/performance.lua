local M = {}

function M.setup()
    -- Set performance-related options
    vim.opt.hidden = true                 -- Enable background buffers
    vim.opt.history = 100                 -- Reduce history size
    vim.opt.lazyredraw = true            -- Don't redraw while executing macros
    vim.opt.synmaxcol = 240              -- Max column for syntax highlight
    vim.opt.updatetime = 250             -- Faster completion
    vim.opt.timeoutlen = 400             -- Faster key sequence completion
    vim.opt.redrawtime = 1500            -- Allow more time for loading syntax
    vim.opt.ttimeoutlen = 10             -- Faster key code recognition
    vim.opt.wrapscan = false             -- Don't wrap searches around the end of file

    -- Disable some built-in plugins we don't need
    local disabled_built_ins = {
        "2html_plugin",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "matchit",
        "tar",
        "tarPlugin",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        "tutor",
        "rplugin",
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
    }

    for _, plugin in pairs(disabled_built_ins) do
        vim.g["loaded_" .. plugin] = 1
    end

    -- Disable providers we don't use
    vim.g.loaded_python3_provider = 0
    vim.g.loaded_ruby_provider = 0
    vim.g.loaded_node_provider = 0
    vim.g.loaded_perl_provider = 0

    -- Improve startup time
    vim.g.cursorhold_updatetime = 100    -- Reduce CursorHold update time
    vim.g.did_load_filetypes = 1         -- Don't load built-in ftdetect
    vim.g.do_filetype_lua = 1            -- Use Lua for filetype detection

    -- Set completion options for better performance
    vim.opt.pumheight = 10               -- Limit completion menu height
    vim.opt.shortmess:append("c")        -- Don't show completion messages
    vim.opt.completeopt = {
        "menuone",
        "noselect",
        "noinsert",
    }

    -- Disable unused features
    vim.opt.backup = false
    vim.opt.writebackup = false
    vim.opt.swapfile = false
    vim.opt.undofile = true              -- Keep undo history only

    return true
end

return M
