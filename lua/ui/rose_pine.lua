-- Rose Pine color scheme configuration (canonical UI module)
local M = {}
local _setup_done = false

local function set_transparency()
  pcall(vim.cmd, [[highlight Normal guibg=NONE ctermbg=NONE]])
  pcall(vim.cmd, [[highlight NormalFloat guibg=NONE ctermbg=NONE]])
  pcall(vim.cmd, [[highlight FloatBorder guibg=NONE ctermbg=NONE]])
  pcall(vim.cmd, [[highlight NonText guibg=NONE ctermbg=NONE]])
  pcall(vim.cmd, [[highlight NormalNC guibg=NONE ctermbg=NONE]])
end

function M.setup()
  if _setup_done then return end
  _setup_done = true

  local ok, rp = pcall(require, 'rose-pine')
  if ok and type(rp.setup) == 'function' then
    pcall(rp.setup, { disable_background = true })
  end

  local ok_cs, _ = pcall(vim.cmd, 'colorscheme rose-pine')
  if not ok_cs then
    -- colorscheme not available; do not error
    return
  end

  set_transparency()
  vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    callback = function() set_transparency() end,
  })
end

return M
