local M = {}

local function setup_ui_components()
    -- Load UI components in order of dependency
    local components = {
        { name = "ui.notify", order = 1 },      -- Load notifications first
        { name = "ui.noice", order = 2 },       -- Then load noice which depends on notify
        { name = "ui.rose_pine", order = 3 },   -- Load theme
        { name = "ui.lualine", order = 4 },     -- Status line
        { name = "ui.bufferline", order = 5 },  -- Buffer line
        { name = "ui.gitsigns", order = 6 },    -- Git decorations
        { name = "ui.neotree", order = 7 },     -- File explorer
        { name = "ui.trouble", order = 8 },     -- Diagnostics
        { name = "ui.telescope", order = 9 },   -- Fuzzy finder
        { name = "ui.which-key", order = 10 },  -- Keybinding helper (module file: which-key.lua)
        { name = "ui.statusline", order = 11 }, -- Overall statusline setup (module file: statusline.lua)
    }

    -- Sort by order to ensure proper initialization sequence
    table.sort(components, function(a, b) return a.order < b.order end)

    for _, component in ipairs(components) do
        local ok, mod = pcall(require, component.name)
        if not ok then
            vim.notify(string.format("Failed to require %s: %s", component.name, mod), vim.log.levels.WARN)
        else
            -- Support modules that export either a table with setup() or a function directly
            local setup_fn = nil
            if type(mod) == "table" and type(mod.setup) == "function" then
                setup_fn = mod.setup
            elseif type(mod) == "function" then
                setup_fn = mod
            end

            if setup_fn then
                local success, err = pcall(setup_fn)
                if not success then
                    vim.notify(string.format("Failed to setup %s: %s", component.name, err), vim.log.levels.WARN)
                end
            end
        end
    end
end

function M.setup()
    -- First try to load and apply the colorscheme
    local theme_ok = pcall(function()
        vim.cmd.colorscheme("rose-pine")
    end)
    if not theme_ok then
        vim.notify("Failed to load colorscheme", vim.log.levels.WARN)
    end

    -- Then set up all UI components
    setup_ui_components()
end

return M
