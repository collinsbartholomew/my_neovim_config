-- nvim-dap setup
local dap = require('dap')
-- TODO: Configure codelldb, delve, java-debug, netcoredbg, python adapters
-- Example: Rust/C++
dap.adapters.codelldb = {
  type = 'server',
  port = '${port}',
  executable = {
    command = 'codelldb',
    args = {'--port', '${port}'},
  },
}
-- Example: Go
dap.adapters.go = {
  type = 'server',
  port = '${port}',
  executable = {
    command = 'dlv',
    args = {'dap', '-l', '127.0.0.1:${port}'},
  },
}
