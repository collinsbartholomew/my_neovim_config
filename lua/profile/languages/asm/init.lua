---
-- Assembly Language Module
-- LSP: asm-lsp
-- Mason: asm-lsp
local M = {}

function M.setup()
    -- Setup LSP
    require('profile.languages.asm.lsp').setup()
    
    -- Setup debugging
    require('profile.languages.asm.debug').setup()
    
    -- Setup tools (formatting, linting)
    require('profile.languages.asm.tools').setup()
    
    -- Setup templates
    require('profile.languages.asm.templates')
    
    -- Setup keymaps
    require('profile.languages.asm.mappings').setup()
end

return M