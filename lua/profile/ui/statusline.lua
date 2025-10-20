-- added-by-agent: ui-enhancement 20251020
-- Configuration for lualine with Rose Pine theme integration

local M = {}

function M.setup()
  require('lualine').setup({
    options = {
      theme = 'rose-pine',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      globalstatus = true,
      refresh = {
        statusline = 100,
        tabline = 100,
        winbar = 100,
      },
    },
    sections = {
      lualine_a = {
        { 'mode', separator = { left = '' }, right_padding = 2 },
      },
      lualine_b = {
        { 'branch', separator = { left = '' } },
        { 'diff',
          symbols = {
            added = ' ',
            modified = ' ',
            removed = ' ',
          },
        },
      },
      lualine_c = {
        { 'diagnostics',
          sources = { 'nvim_diagnostic' },
          symbols = {
            error = ' ',
            warn = ' ',
            info = ' ',
            hint = ' ',
          },
        },
        { 'filename', path = 1 },
      },
      lualine_x = {
        { 'encoding' },
        { 'fileformat' },
        { 'filetype', icon_only = true },
      },
      lualine_y = {
        { 'progress', separator = { right = '' }, left_padding = 2 },
      },
      lualine_z = {
        { 'location', separator = { right = '' }, left_padding = 2 },
      },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 'filename' },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {},
    },
    extensions = {
      'neo-tree',
      'toggleterm',
      'quickfix',
      'symbols-outline',
    },
  })
end

return M
