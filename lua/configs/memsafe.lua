local M = {}

function M.setup()
  local ok, merged = pcall(require, 'configs.merged')
  if ok and merged and merged.setup_memsafe then pcall(merged.setup_memsafe) end
end

return M
