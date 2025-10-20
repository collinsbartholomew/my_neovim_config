-- added-by-agent: flutter-setup 20251020-160000
-- mason: dart-debug-adapter
-- manual: flutter/dart/fvm install commands listed in README

local M = {}

local function get_flutter_cmd(config)
  config = config or {}
  if config.use_fvm and vim.fn.executable("fvm") == 1 then
    return "fvm flutter"
  else
    return "flutter"
  end
end

local function get_dart_cmd(config)
  config = config or {}
  if config.use_fvm and vim.fn.executable("fvm") == 1 then
    return "fvm dart"
  else
    return "dart"
  end
end

function M.setup(config)
  config = config or {}
  
  -- Check if flutter is available
  if vim.fn.executable("flutter") == 0 then
    vim.notify("Flutter not found in PATH. Some commands may not work.", vim.log.levels.WARN)
  end
  
  -- FvmUse command
  vim.api.nvim_create_user_command('FvmUse', function(opts)
    local fvm_cmd = string.format('%s use %s', get_flutter_cmd(config), opts.args)
    vim.cmd('belowright new | terminal ' .. fvm_cmd)
  end, { nargs = 1 })
  
  -- FlutterRun command
  vim.api.nvim_create_user_command('FlutterRun', function()
    vim.cmd('write')
    local flutter_cmd = string.format('%s run', get_flutter_cmd(config))
    vim.cmd('belowright new | terminal ' .. flutter_cmd)
  end, {})
  
  -- FlutterTest command
  vim.api.nvim_create_user_command('FlutterTest', function()
    local flutter_cmd = string.format('%s test', get_flutter_cmd(config))
    vim.cmd('belowright new | terminal ' .. flutter_cmd)
  end, {})
  
  -- FlutterReload command (alias to flutter-tools reload)
  vim.api.nvim_create_user_command('FlutterReload', function()
    local flutter_tools_status, flutter_tools = pcall(require, "flutter-tools")
    if flutter_tools_status then
      flutter_tools.reload()
    else
      vim.notify("Flutter tools not available for reload", vim.log.levels.WARN)
    end
  end, {})
  
  -- DartFormat command
  vim.api.nvim_create_user_command('DartFormat', function()
    local dart_cmd = string.format('%s format .', get_dart_cmd(config))
    vim.cmd('belowright new | terminal ' .. dart_cmd)
  end, {})
  
  -- DevTools command
  vim.api.nvim_create_user_command('DevTools', function()
    local dart_cmd = string.format('%s pub global run devtools', get_dart_cmd(config))
    vim.cmd('belowright new | terminal ' .. dart_cmd)
  end, {})
  
  -- FlutterDoctor command
  vim.api.nvim_create_user_command('FlutterDoctor', function()
    local flutter_cmd = string.format('%s doctor', get_flutter_cmd(config))
    vim.cmd('belowright new | terminal ' .. flutter_cmd)
  end, {})
  
  -- Integrate with conform.nvim for formatting
  local conform_status, conform = pcall(require, "conform")
  if conform_status then
    -- We don't add to formatters_by_ft here because we want to keep it optional
    -- User can add this to their conform setup:
    -- formatters_by_ft = {
    --   dart = { "dart_format" },
    -- }
  end
end

return M