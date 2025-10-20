-- added-by-agent: zig-setup 20251020
local M = {}

function M.setup()
  -- Check for DAP availability
  local has_dap, dap = pcall(require, "dap")
  if not has_dap then
    vim.notify("DAP is not available", vim.log.levels.WARN)
    return
  end

  -- Try to find codelldb through different methods
  local codelldb_path
  local extension_path

  -- First try Mason
  local mason_registry = require("mason-registry")
  if mason_registry.is_installed("codelldb") then
    local package = mason_registry.get_package("codelldb")
    local install_path = package:get_install_path()
    codelldb_path = install_path .. "/extension/adapter/codelldb"
    extension_path = install_path .. "/extension"
  else
    -- Try system paths
    local possible_paths = {
      vim.fn.exepath("codelldb"),
      "/usr/lib/codelldb/adapter/codelldb",
      "/usr/local/lib/codelldb/adapter/codelldb",
    }

    for _, path in ipairs(possible_paths) do
      if vim.fn.filereadable(path) == 1 then
        codelldb_path = path
        extension_path = vim.fn.fnamemodify(path, ":h:h")
        break
      end
    end
  end

  if not codelldb_path then
    vim.notify([[
      codelldb not found. Please either:
      1. Install via Mason: :MasonInstall codelldb
      2. Install via system package manager:
         sudo pacman -S codelldb
      3. Install manually from https://github.com/vadimcn/vscode-lldb/releases
    ]], vim.log.levels.WARN)
    return
  end

  -- Configure codelldb adapter
  dap.adapters.codelldb = {
    type = 'server',
    port = '${port}',
    executable = {
      command = codelldb_path,
      args = {"--port", "${port}"},
    },
    extensions_dir = extension_path,
  }

  -- Configure Zig debugging
  dap.configurations.zig = {
    {
      name = "Launch Zig Program",
      type = "codelldb",
      request = "launch",
      program = function()
        local default_path = vim.fn.getcwd() .. '/zig-out/bin/'
        -- Try to find the executable based on project structure
        local possible_exes = vim.fn.glob(default_path .. '*', false, true)
        if #possible_exes > 0 then
          return vim.fn.input('Path to executable: ', possible_exes[1], 'file')
        end
        return vim.fn.input('Path to executable: ', default_path, 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      runInTerminal = false,
      console = "internalConsole",
    },
    {
      name = "Attach to Process",
      type = "codelldb",
      request = "attach",
      pid = require('dap.utils').pick_process,
      args = {},
    },
    {
      name = "Debug Current File",
      type = "codelldb",
      request = "launch",
      program = function()
        local file = vim.fn.expand('%:p:r')
        vim.fn.system('zig build-exe ' .. vim.fn.expand('%:p'))
        return file
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      runInTerminal = false,
    }
  }

  -- Load DAP UI if available
  pcall(function()
    require("dapui").setup()
    require("nvim-dap-virtual-text").setup()
  end)
end

return M
