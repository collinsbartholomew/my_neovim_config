-- Winbar configuration with navic breadcrumbs
local M = {}

function M.setup()
  -- Enable winbar
  vim.opt.winbar = "%{%v:lua.require('profile.ui.winbar').eval()%}"

  -- Set up autocommands for winbar updates
  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "BufWinEnter", "BufFilePost" }, {
    callback = function()
      vim.cmd("redrawstatus")
    end,
  })
end

function M.eval()
  local navic_ok, navic = pcall(require, "nvim-navic")
  if navic_ok and navic.is_available() then
    local location = navic.get_location()
    if location and location ~= "" then
      return "%#WinBar#" .. location
    end
  end
  
  -- Fallback to filename if no navic info
  local filename = vim.fn.expand("%:t")
  if filename == "" then
    filename = "[No Name]"
  end
  return "%#WinBar#" .. filename
end

return M