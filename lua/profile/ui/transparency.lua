-- Transparency configuration with 100% transparency
local M = {}

local function set_transparent()
  for _, group in ipairs({'Normal', 'SignColumn', 'MsgArea', 'NormalNC', 'TelescopeNormal', 'EndOfBuffer', 'FoldColumn', 'VertSplit'}) do
    vim.api.nvim_set_hl(0, group, { bg = 'NONE' })
  end
end

function M.setup()
  -- Apply transparency on startup
  set_transparent()
  
  -- Create toggle command
  vim.api.nvim_create_user_command('ToggleTransparency', set_transparent, {})
  
  -- Map <leader>tr to ToggleTransparency
  vim.keymap.set('n', '<leader>tr', '<cmd>ToggleTransparency<CR>', { desc = 'Toggle transparency' })
  
  -- Register with which-key
  require('which-key').register({
    t = {
      name = 'UI/Theme',
      r = 'Toggle transparency',
    },
  }, { prefix = '<leader>' })
end

return M