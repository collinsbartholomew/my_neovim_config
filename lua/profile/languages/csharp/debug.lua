-- added-by-agent: csharp-setup 20251020-153000
-- mason: netcoredbg
-- manual: yay -S netcoredbg-bin

local M = {}

local function get_netcoredbg_path()
  -- Check NETCOREDBG_PATH environment variable first
  local netcoredbg_path = os.getenv("NETCOREDBG_PATH")
  if netcoredbg_path and vim.fn.executable(netcoredbg_path) == 1 then
    return netcoredbg_path
  end

  -- Check for Mason installed netcoredbg
  local mason_registry = package.loaded["mason-registry"]
  if mason_registry and mason_registry.is_installed("netcoredbg") then
    local netcoredbg_pkg = mason_registry.get_package("netcoredbg")
    local install_path = netcoredbg_pkg:get_install_path()
    
    local possible_paths = {
      install_path .. "/netcoredbg",
      install_path .. "/bin/netcoredbg",
      install_path .. "/netcoredbg/netcoredbg",
    }
    
    for _, path in ipairs(possible_paths) do
      if vim.fn.executable(path) == 1 then
        return path
      end
    end
  end

  -- Check system netcoredbg
  if vim.fn.executable("netcoredbg") == 1 then
    return "netcoredbg"
  end

  -- Fallback - notify user
  vim.notify(
    "netcoredbg not found. Please install via Mason or set NETCOREDBG_PATH.",
    vim.log.levels.WARN
  )
  
  return nil
end

function M.setup()
  local dap_ok, dap = pcall(require, "dap")
  if not dap_ok then
    vim.notify("nvim-dap not available for C# debug setup", vim.log.levels.ERROR)
    return
  end

  local netcoredbg_path = get_netcoredbg_path()
  if not netcoredbg_path then
    return
  end

  dap.adapters.coreclr = {
    type = "executable",
    command = netcoredbg_path,
    args = { "--interpreter=vscode" }
  }

  dap.adapters.netcoredbg = {
    type = "executable",
    command = netcoredbg_path,
    args = { "--interpreter=vscode" }
  }

  dap.configurations.cs = {
    {
      type = "coreclr",
      name = "launch - netcoredbg",
      request = "launch",
      program = function()
        return vim.fn.input('Path to dll or executable: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
      end,
    },
    {
      type = "coreclr",
      name = "attach - netcoredbg",
      request = "attach",
      processId = require'dap.utils'.pick_process,
    }
  }
end

return M