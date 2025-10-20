-- Transparency toggle
local function set_transparent()
  for _, group in ipairs({'Normal', 'SignColumn', 'MsgArea', 'NormalNC', 'TelescopeNormal'}) do
    vim.api.nvim_set_hl(0, group, { bg = 'NONE' })
  end
end
vim.api.nvim_create_user_command('ToggleTransparency', set_transparent, {})
-- TODO: Map <leader>tr to ToggleTransparency

