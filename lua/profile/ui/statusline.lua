-- Configuration for lualine - proper bottom statusline
local M = {}

function M.setup()
    -- Enable the statusline
    vim.opt.laststatus = 3  -- Global statusline
    
    -- Configure lualine
    local status_ok, lualine = pcall(require, "lualine")
    if not status_ok then
        return
    end
    
    local function trailing_whitespace()
        local space = vim.fn.search([[\s\+$]], 'nwc')
        return space ~= 0 and '󰧟' or ''
    end

    local function mixed_indent()
        local space_pat = [[\v^ +]]
        local tab_pat = [[\v^\t+]]
        local space_indent = vim.fn.search(space_pat, 'nwc')
        local tab_indent = vim.fn.search(tab_pat, 'nwc')
        local mixed = (space_indent > 0 and tab_indent > 0)
        local mixed_same_line = vim.fn.search([[\v^(\t+ | +\t)]], 'nwc')
        return mixed_same_line ~= 0 or mixed and '󰉞' or ''
    end

    -- Function to get navic breadcrumbs
    local function navic_location()
        local navic_ok, navic = pcall(require, "nvim-navic")
        if navic_ok and navic.is_available() then
            return navic.get_location()
        end
        return ""
    end

    lualine.setup({
        options = {
            icons_enabled = true,
            theme = 'auto',
            component_separators = { left = '', right = ''},
            section_separators = { left = '', right = ''},
            disabled_filetypes = {},
            always_divide_middle = true,
            globalstatus = true,
        },
        sections = {
            lualine_a = {'mode'},
            lualine_b = {'branch', 'diff', 'diagnostics'},
            lualine_c = {
                {
                    'filename',
                    file_status = true,
                    path = 1
                },
                {
                    navic_location,
                    cond = function()
                        local navic_ok, navic = pcall(require, "nvim-navic")
                        return navic_ok and navic.is_available()
                    end
                }
            },
            lualine_x = {
                {
                    'encoding',
                    fmt = string.upper
                },
                'fileformat',
                'filetype'
            },
            lualine_y = {'progress'},
            lualine_z = {
                'location',
                mixed_indent,
                trailing_whitespace
            }
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {'filename'},
            lualine_x = {'location'},
            lualine_y = {},
            lualine_z = {}
        },
        tabline = {},
        extensions = {}
    })
end

return M