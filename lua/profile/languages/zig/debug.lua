-- added-by-agent: zig-setup 20251020
-- mason: codelldb
-- manual: Install codelldb via package manager if Mason install fails

local M = {}

function M.setup()
  local ok_dap, dap = pcall(require, "dap")
  if not ok_dap then
    vim.notify("DAP not available", vim.log.levels.WARN)
    return
  end

  -- Try to get codelldb path from Mason first
  local codelldb_path
  local ok_mason, mason_registry = pcall(require, "mason-registry")
  if ok_mason then
    local codelldb_pkg = mason_registry.get_package("codelldb")
    if codelldb_pkg:is_installed() then
      codelldb_path = codelldb_pkg:get_install_path() .. "/extension/adapter/codelldb"
    end
  end

  -- Configure codelldb adapter
  dap.adapters.codelldb = {
    type = 'server',
    port = '${port}',
    executable = {
      command = codelldb_path or 'codelldb',
      args = {'--port', '${port}'},
    }
  }

  -- Configure Zig debugging
  dap.configurations.zig = {
    {
      name = "Launch Zig Program",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/zig-out/bin/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
    },
    {
      name = "Attach to process",
      type = "codelldb",
      request = "attach",
      pid = require('dap.utils').pick_process,
      args = {},
    },
  }
end

return M
