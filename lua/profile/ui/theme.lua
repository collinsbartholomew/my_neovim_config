-- Configuration for Rose Pine theme with 100% transparency

local M = {}

function M.setup()
  -- Set up rose-pine with full transparency
  require('rose-pine').setup({
    variant = 'moon',
    dark_variant = 'moon',
    bold_vert_split = false,
    dim_nc_background = false,
    disable_background = true,
    disable_float_background = true,
    disable_italics = false,
    groups = {
      background = 'NONE',
      panel = 'NONE',
      border = 'highlight_med',
      comment = 'muted',
      link = 'iris',
      punctuation = 'subtle',
      error = 'love',
      hint = 'iris',
      info = 'foam',
      warn = 'gold',
      git_add = 'foam',
      git_change = 'rose',
      git_delete = 'love',
      git_dirty = 'rose',
      git_ignore = 'muted',
      git_merge = 'iris',
      git_rename = 'pine',
      git_stage = 'iris',
      git_text = 'rose',
    },
  })

  -- Set colorscheme with full transparency
  vim.cmd('colorscheme rose-pine')

  -- Enable true color support
  vim.opt.termguicolors = true

  -- Set fully transparent background
  vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "FoldColumn", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "VertSplit", { bg = "NONE", ctermbg = "NONE" })
end

return M