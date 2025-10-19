-- Statusline configuration using lualine
local M = {}
local _setup_done = false

-- Utility functions for statusline components
local function get_lsp_status()
    local clients = vim.lsp.get_clients()
    if #clients > 0 then
        local names = {}
        for _, client in ipairs(clients) do
            table.insert(names, client.name)
        end
        return " LSP:" .. table.concat(names, ",")
    end
    return ""
end

local function get_recording_status()
    local recording = vim.fn.reg_recording()
    if recording ~= "" then
        return "󰑋 @" .. recording
    end
    return ""
end

local function get_macro_status()
    local register = vim.fn.reg_recording()
    if register ~= "" then
        return "Recording @" .. register
    end
    local replay = vim.fn.reg_executing()
    if replay ~= "" then
        return "Executing @" .. replay
    end
    return ""
end

local function get_diagnostics_count()
    local counts = {
        error = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }),
        warn = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }),
        info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO }),
        hint = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT }),
    }

    local result = {}
    if counts.error > 0 then table.insert(result, "󰅚 " .. counts.error) end
    if counts.warn > 0 then table.insert(result, "󰀪 " .. counts.warn) end
    if counts.info > 0 then table.insert(result, " " .. counts.info) end
    if counts.hint > 0 then table.insert(result, "󰌶 " .. counts.hint) end

    return table.concat(result, " ")
end

function M.setup()
    if _setup_done then return end
    _setup_done = true

    local ok, lualine = pcall(require, "lualine")
    if not ok then
        vim.notify("lualine not available", vim.log.levels.WARN)
        return
    end

    -- Set up lualine with enhanced configuration
    lualine.setup({
        options = {
            theme = "auto",
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            globalstatus = true,
            disabled_filetypes = {
                statusline = { "dashboard", "alpha", "starter" },
                winbar = { "dashboard", "alpha", "starter" },
            },
            refresh = {
                statusline = 1000,
                tabline = 1000,
                winbar = 1000,
            },
        },
        sections = {
            lualine_a = {
                { "mode", separator = { left = "", right = "" }, padding = 2 },
            },
            lualine_b = {
                { "branch", icon = "" },
                {
                    "diff",
                    symbols = {
                        added = " ",
                        modified = "󰝤 ",
                        removed = " ",
                    },
                },
                {
                    get_diagnostics_count,
                    color = {
                        error = "#db4b4b",
                        warn = "#e0af68",
                        info = "#0db9d7",
                        hint = "#1abc9c",
                    },
                },
            },
            lualine_c = {
                {
                    "filename",
                    path = 1,
                    symbols = {
                        modified = "󰷈",
                        readonly = "",
                        unnamed = "[No Name]",
                        newfile = "[New]",
                    },
                },
                { get_lsp_status },
            },
            lualine_x = {
                { get_recording_status },
                { get_macro_status },
                {
                    require("lazy.status").updates,
                    cond = require("lazy.status").has_updates,
                    color = { fg = "#ff9e64" },
                },
                {
                    "filetype",
                    colored = true,
                    icon_only = false,
                },
            },
            lualine_y = {
                { "progress", separator = { left = "", right = "" }, padding = 1 },
            },
            lualine_z = {
                { "location", separator = { left = "", right = "" }, padding = 1 },
            },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = { "location" },
            lualine_y = {},
            lualine_z = {},
        },
        extensions = {
            "neo-tree",
            "lazy",
            "trouble",
            "quickfix",
            "toggleterm",
            "man",
        },
    })
end

return M
