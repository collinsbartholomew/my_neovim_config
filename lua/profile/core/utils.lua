-- Utility functions
local M = {}
function M.is_file_exists(path)
  local f = io.open(path, 'r')
  if f then f:close(); return true end
  return false
end
return M

