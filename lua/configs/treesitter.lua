-- shim: forward to consolidated configs.merged

local M = {}
function M.setup()
  local ok, merged = pcall(require, 'configs.merged')
  if ok and merged and merged.setup_treesitter then pcall(merged.setup_treesitter) end
end
return M
