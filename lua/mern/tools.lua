local M = {}

function M.setup()
  -- NpmInstall command
  vim.api.nvim_create_user_command("NpmInstall", function()
    vim.cmd("terminal npm install")
  end, {})

  -- StartDev command
  vim.api.nvim_create_user_command("StartDev", function()
    vim.cmd("terminal npm run dev")
  end, {})

  -- Format command
  vim.api.nvim_create_user_command("Format", function()
    vim.lsp.buf.format()
  end, {})

  -- Null-ls setup for formatting and linting
  local null_ls = require("null-ls")
  null_ls.setup({
    sources = {
      null_ls.builtins.formatting.prettierd,
      null_ls.builtins.diagnostics.eslint_d,
    },
  })
end

return M