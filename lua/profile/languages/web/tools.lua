-- added-by-agent: web-setup 20251020-173000
-- mason: prettier, eslint
-- manual: node.js, pnpm installation required

local M = {}

function M.setup()
  -- NpmInstall command
  vim.api.nvim_create_user_command("NpmInstall", function()
    vim.cmd("belowright new | terminal npm install")
  end, {})

  -- PnpmInstall command
  vim.api.nvim_create_user_command("PnpmInstall", function()
    vim.cmd("belowright new | terminal pnpm install")
  end, {})

  -- StartDev command
  vim.api.nvim_create_user_command("StartDev", function()
    vim.cmd("belowright new | terminal npm run dev")
  end, {})

  -- StartDevPnpm command
  vim.api.nvim_create_user_command("StartDevPnpm", function()
    vim.cmd("belowright new | terminal pnpm run dev")
  end, {})

  -- Format command
  vim.api.nvim_create_user_command("WebFormat", function()
    vim.lsp.buf.format()
  end, {})

  -- Null-ls setup for formatting and linting
  local null_ls_status, null_ls = pcall(require, "null-ls")
  if null_ls_status then
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.diagnostics.eslint_d,
        null_ls.builtins.code_actions.eslint_d,
      },
    })
  end

  -- Emmet setup
  vim.g.user_emmet_mode = 'n'
  vim.g.user_emmet_install_global = 0
  vim.cmd([[autocmd FileType html,css,scss,javascript,typescript,jsx,tsx EmmetInstall]])
end

return M