# Go Integration for Neovim

This module provides full Go development support: LSP (gopls), DAP (delve), formatting (gofumpt, goimports), linting (staticcheck, golangci-lint), and test running (neotest-go).

## Mason Packages
- gopls
- delve
- gofumpt
- goimports
- staticcheck

## Manual Installs (if not in Mason)
- golangci-lint: `sudo pacman -S golangci-lint` or `go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest`
- goimports-reviser: `go install github.com/incu6us/goimports-reviser/v2@latest`

## Common Commands
- Format: `<leader>gf` or `<leader>rf`
- Lint: `<leader>rd` (runs GoLint)
- Test: `<leader>rt` (package), `<leader>rtf` (single)
- Debug: `<leader>rr` (run/continue), `<leader>d*` (DAP controls)

## Troubleshooting
- If gopls or delve are missing, run `:Mason` and install them.
- If formatting fails, ensure gofumpt/goimports are installed and on PATH.
- For DAP, ensure delve is installed and up-to-date.
- For linting, ensure golangci-lint is installed and on PATH.

## Settings
- See lsp.lua for gopls tuning (staticcheck, gofumpt, analyses, hints).
- See tools.lua for formatter and test runner setup.

## Manual Steps
- Install missing tools via Mason, pacman, or go install as listed above.
- Ensure $GOBIN is on your PATH for Go tools.
---
-- Go LSP configuration (gopls)
-- Mason package: gopls
local M = {}
function M.setup()
  local lsp_zero = require('lsp-zero')
  lsp_zero.configure('gopls', {
    settings = {
      gopls = {
        gofumpt = true,
        staticcheck = true,
        analyses = {
          shadow = true,
          nilness = true,
          unusedparams = true,
          unusedwrite = true,
          unusedvariable = true,
        },
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
      },
    },
    on_attach = function(client, bufnr)
      require('profile.languages.go.mappings').lsp(bufnr)
      if client.supports_method('textDocument/inlayHint') then
        vim.lsp.inlay_hint(bufnr, true)
      end
    end,
  })
end
return M

