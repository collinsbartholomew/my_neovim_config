---
-- Go DAP configuration (delve)
-- Mason package: delve
local M = {}
function M.setup()
  local dap = require('dap')
  local dapgo = require('dap-go')
  dapgo.setup()
  require('profile.languages.go.mappings').dap()
end
return M

