-- Configuration for lualine with Rose Pine theme integration

local M = {}

function M.setup()
  -- Get navic status for winbar integration
  local function navic_location()
    if package.loaded['nvim-navic'] then
      return require('nvim-navic').get_location()
    end
    return ''
  end
  
  -- Check if navic is available
  local function navic_available()
    if package.loaded['nvim-navic'] then
      return require('nvim-navic').is_available()
    end
    return false
  end

  require('lualine').setup({
    options = {
      theme = 'tokyonight',
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
        { 
          'diff',
          symbols = {
            added = ' ',
            modified = ' ',
            removed = ' ',
          },
        },
      },
      lualine_c = {
        { 
          'diagnostics',
          sources = { 'nvim_diagnostic' },
          symbols = {
            error = ' ',
            warn = ' ',
            info = ' ',
            hint = ' ',
          },
        },
        { 'filename', path = 1 },
        {
          navic_location,
          cond = navic_available,
        },
      },
      lualine_x = {
        { 
          'encoding',
          fmt = string.upper,
        },
        { 
          'fileformat',
          icons_enabled = true,
        },
        { 
          'filetype', 
          icon_only = true,
          colored = true,
        },
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
    tabline = {
      lualine_a = {
        {
          'buffers',
          mode = 1,
          max_length = vim.o.columns * 0.7,
          filetype_names = {
            TelescopePrompt = 'Telescope',
            dashboard = 'Dashboard',
            packer = 'Packer',
            fzf = 'FZF',
            alpha = 'Dashboard',
          },
          buffers_color = {
            active = 'lualine_c_normal',
            inactive = 'lualine_b_normal',
          },
        },
      },
      lualine_z = {
        {
          'tabs',
          max_length = vim.o.columns * 0.3,
          tabs_color = {
            active = 'lualine_c_normal',
            inactive = 'lualine_b_normal',
          },
        }
      }
    },
    winbar = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        {
          navic_location,
          cond = navic_available,
        },
      },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {}
    },
    inactive_winbar = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 'filename' },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {}
    },
    extensions = {
      'neo-tree',
      'toggleterm',
      'quickfix',
      'symbols-outline',
      'fzf',
    },
  })
end

return M