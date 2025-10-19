local M = {}

-- Theme state management
local state_file = vim.fn.stdpath("data") .. "/theme_state.json"
local default_state = {
    theme = "rose-pine",
    variant = "moon",
    transparent = true,
}

-- Load theme state from file
local function load_state()
    local file = io.open(state_file, "r")
    if file then
        local content = file:read("*all")
        file:close()
        local ok, state = pcall(vim.json.decode, content)
        if ok then
            return state
        end
    end
    return default_state
end

-- Save theme state to file
local function save_state(state)
    local file = io.open(state_file, "w")
    if file then
        file:write(vim.json.encode(state))
        file:close()
    end
end

-- Theme management
local themes = {
    "rose-pine",
    "rose-pine-moon",
    "rose-pine-dawn",
}

function M.cycle_theme()
    local state = load_state()
    local current_index = 1
    for i, theme in ipairs(themes) do
        if theme == state.theme then
            current_index = i
            break
        end
    end

    -- Get next theme
    current_index = current_index % #themes + 1
    state.theme = themes[current_index]

    -- Apply and save
    vim.cmd.colorscheme(state.theme)
    save_state(state)
end

function M.toggle_transparency()
    local state = load_state()
    state.transparent = not state.transparent

    if state.transparent then
        vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
    else
        vim.api.nvim_set_hl(0, "Normal", { bg = "#191724" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#191724" })
    end

    save_state(state)
end

function M.setup()
    -- Load saved state
    local state = load_state()

    -- Configure theme
    require("rose-pine").setup({
        variant = state.variant,
        dark_variant = "moon",
        dim_inactive_windows = false,
        extend_background_behind_borders = true,

        styles = {
            bold = true,
            italic = true,
            transparency = true,
        },

        highlight_groups = {
            -- Ensure UI elements are properly styled
            Normal = { bg = state.transparent and "NONE" or "#191724" },
            NormalFloat = { bg = state.transparent and "NONE" or "#191724" },
            FloatBorder = { fg = "muted", bg = "NONE" },
            CursorLine = { bg = "#2a273f" },
            CursorLineNr = { fg = "rose", bold = true },
            LineNr = { fg = "muted" },

            -- Command line styling
            MsgArea = { bg = "NONE" },
            MsgSeparator = { bg = "NONE" },

            -- Ensure proper transparency
            SignColumn = { bg = "NONE" },
            StatusLine = { bg = "NONE" },
            NeoTreeNormal = { bg = "NONE" },
            TelescopeNormal = { bg = "NONE" },

            -- Better visual feedback
            Visual = { bg = "#2a273f" },
            Search = { fg = "base", bg = "rose" },
            IncSearch = { fg = "base", bg = "rose" },
        },
    })

    -- Apply the theme
    vim.cmd.colorscheme(state.theme)
end

return M
