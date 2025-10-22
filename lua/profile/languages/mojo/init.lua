---
-- Mojo Language Integration
-- LSP: mojo-lsp (from Modular)
-- DAP: lldb/codelldb
-- Formatters: mojo format
-- Linters: mojo check
-- Test runner: neotest-mojo (custom)
-- Mason packages: lldb, valgrind
-- See README.md for manual install steps if needed
local M = {}

function M.setup()
    require('profile.languages.mojo.lsp').setup()
    require('profile.languages.mojo.debug').setup()
    require('profile.languages.mojo.tools').setup()
    require('profile.languages.mojo.mappings').setup()
    
    -- Ensure treesitter parsers
    local tsinstall_status_ok, tsinstall = pcall(require, "nvim-treesitter.install")
    if tsinstall_status_ok then
        -- Note: Mojo parser may not be available yet in treesitter
        -- tsinstall.ensure_installed({ "mojo" })
    end
    
    require('profile.ui.mojo-ui').setup()
end

return M