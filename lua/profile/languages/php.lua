-- PHP language support loader
local M = {}

function M.setup()
    -- Load all PHP modules
    local status_ok, php_init = pcall(require, "profile.languages.php.init")
    if status_ok then
        php_init.setup()
    end
    
    -- We'll skip loading lsp.lua as it's handled by mason-lspconfig
    
    local debug_ok, php_debug = pcall(require, "profile.languages.php.debug")
    if debug_ok then
        php_debug.setup()
    end
    
    local tools_ok, php_tools = pcall(require, "profile.languages.php.tools")
    if tools_ok then
        php_tools.setup()
    end
    
    local mappings_ok, php_mappings = pcall(require, "profile.languages.php.mappings")
    if mappings_ok then
        php_mappings.setup()
    end
end

return M