---
-- Go tools integration: formatting, linting, test runner
-- Formatters: gofumpt, goimports (Mason)
-- Linters: staticcheck, golangci-lint (Mason/manual)
-- Test runner: neotest-go
local M = {}
function M.setup()
  -- Conform.nvim for formatting
  require('conform').setup({
    formatters_by_ft = {
      go = { 'gofumpt', 'goimports' },
    },
  })
  -- Neotest-go for test running
  require('neotest').setup({
    adapters = {
      require('neotest-go')({
        dap = { justMyCode = false },
      }),
    },
  })
end
return M

