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
end

return M