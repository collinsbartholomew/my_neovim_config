---
-- Python Language Integration
-- LSP: pyright (Mason)
-- DAP: debugpy (Mason)
-- Formatters: black, ruff, isort (Mason/pipx)
-- Linters: ruff (Mason/pipx)
-- Test runner: neotest-python
-- Mason packages: pyright, debugpy, black, ruff, isort
-- See README.md for manual install steps if needed
local M = {}

function M.setup()
    require('profile.languages.python.lsp').setup()
    require('profile.languages.python.debug').setup()
    require('profile.languages.python.tools').setup()
    require('profile.languages.python.mappings').setup()
    
    -- Ensure treesitter parsers
    local tsinstall_status_ok, tsinstall = pcall(require, "nvim-treesitter.install")
    if tsinstall_status_ok then
        tsinstall.ensure_installed({ "python", "requirements", "toml" })
    end
    
    require('profile.ui.python-ui').setup()
end

return M