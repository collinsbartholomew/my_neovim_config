-- added-by-agent: csharp-setup 20251020-153000
-- mason: none
-- manual: dotnet-sdk installation required

local M = {}

function M.setup()
  -- Setup user commands
  vim.api.nvim_create_user_command('DotnetBuild', function()
    vim.cmd('belowright new | terminal dotnet build')
  end, {})

  vim.api.nvim_create_user_command('DotnetTest', function()
    vim.cmd('belowright new | terminal dotnet test')
  end, {})

  vim.api.nvim_create_user_command('DotnetRun', function()
    vim.cmd('belowright new | terminal dotnet run')
  end, {})

  vim.api.nvim_create_user_command('DotnetFormat', function()
    vim.cmd('belowright new | terminal dotnet format')
  end, {})

  vim.api.nvim_create_user_command('OmniReload', function()
    vim.cmd('LspRestart omnisharp')
  end, {})

  -- Setup conform.nvim integration if available
  local conform_ok, conform = pcall(require, "conform")
  if conform_ok then
    -- We don't add to formatters_by_ft here because we want to keep it optional
    -- User can add this to their conform setup:
    -- formatters_by_ft = {
    --   cs = { "dotnet_format" },
    -- }
  end
end

return M