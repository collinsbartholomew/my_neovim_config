--Winbar configuration with navic breadcrumbs
local M = {}

function M.setup()
  -- Disable winbar completely
  vim.opt.winbar = ""
  vim.opt.laststatus = 3 -- Use global statusline

  -- Setup autocommands for winbar updates
  vim.api.nvim_create_augroup("WinbarUpdate", { clear = true })
  vim.api.nvim_create_autocmd({"CursorMoved", "BufEnter"}, {
    group = "WinbarUpdate",
    callback = function()
      vim.cmd("redrawstatus")
    end,
  })
end

function M.eval()
  local navic = require("nvim-navic")
  if navic.is_available() then
    return navic.get_location()
  else
    return ""
  end
end

return M