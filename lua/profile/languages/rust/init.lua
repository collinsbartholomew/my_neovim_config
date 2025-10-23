-- Rust Language Module
-- LSP: rust-analyzer
-- Mason: rust-analyzer, codelldb
local M = {}

function M.setup()
    -- Setup LSP
    require('profile.languages.rust.lsp').setup()
    
    -- Setup debugging
    require('profile.languages.rust.debug').setup()
    
    -- Setup tools (formatting, linting, crates)
    require('profile.languages.rust.tools').setup()
    
    -- Setup keymaps
    require('profile.languages.rust.mappings').setup()
    
    -- Load UI enhancements
    local ui_status_ok, ui = pcall(require, "profile.ui.rust-ui")
    if ui_status_ok then
        ui.setup()
    end
end

return M