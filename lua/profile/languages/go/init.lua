---
-- Go Language Integration
-- LSP: gopls (Mason)
-- DAP: delve (Mason)
-- Formatters: gofumpt, goimports (Mason)
-- Linters: staticcheck, golangci-lint (Mason/manual)
-- Test runner: neotest-go
-- Mason packages: gopls, delve, gofumpt, goimports, staticcheck
-- See README.md for manual install steps if needed
local M = {}

function M.setup()
    require("profile.languages.go.lsp").setup()
    require("profile.languages.go.debug").setup()
    require("profile.languages.go.tools").setup()
    require("profile.languages.go.mappings").setup()
    
    -- Ensure treesitter parsers
    local tsinstall_status_ok, tsinstall = pcall(require, "nvim-treesitter.install")
    if tsinstall_status_ok then
        tsinstall.ensure_installed({ "go", "gomod", "gosum", "gowork", "gotmpl" })
    end
end

return M