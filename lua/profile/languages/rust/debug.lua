-- added-by-agent: rust-setup 20251020
-- Mason: codelldb
local M = {}
local function get_codelldb_paths()
  local mason_registry = require('mason-registry')
  local ok, pkg = pcall(mason_registry.get_package, 'codelldb')
  if not ok then return nil end
  local install_path = pkg:get_install_path()
  local adapter = install_path .. '/extension/adapter/codelldb'
  local liblldb = install_path .. '/extension/lldb/lib/liblldb.so'
  return adapter, liblldb
end
function M.get_codelldb_adapter()
  local adapter, liblldb = get_codelldb_paths()
  if not adapter then return nil end
  return require('rust-tools.dap').get_codelldb_adapter(adapter, liblldb)
end
function M.setup()
  local dap = require('dap')
  local adapter, liblldb = get_codelldb_paths()
  if not adapter then return end
  dap.adapters.codelldb = {
    type = 'server',
    port = '${port}',
    executable = {
      command = adapter,
      args = { '--port', '${port}' },
      detached = true,
    },
  }
  dap.configurations.rust = {
    {
      name = 'Launch file',
      type = 'codelldb',
      request = 'launch',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
    },
    {
      name = 'Debug tests',
      type = 'codelldb',
      request = 'launch',
      program = function()
        return vim.fn.input('Path to test binary: ', vim.fn.getcwd() .. '/target/debug/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
    },
    {
      name = 'Attach to process',
      type = 'codelldb',
      request = 'attach',
      pid = require('dap.utils').pick_process,
      cwd = '${workspaceFolder}',
    },
  }
end
return M

