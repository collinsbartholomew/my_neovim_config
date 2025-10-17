-- Lightweight entry for unified LSP configuration
-- This file composes smaller modules for capabilities, on_attach, servers and diagnostics.
local M = {}

M.capabilities = require('configs.lsp.capabilities')
M.on_attach = require('configs.lsp.on_attach')
M.servers = require('configs.lsp.servers')
M.autostart = require('configs.lsp.autostart')
M.diagnostics = require('configs.lsp.diagnostics')

-- Setup function to initialize LSP system
function M.setup()
    -- Expose capabilities and on_attach for other configs
    -- autostart will create autocmds to start servers when buffers open
    if M.diagnostics and type(M.diagnostics.setup) == 'function' then
        M.diagnostics.setup()
    end
    if M.autostart and type(M.autostart.setup) == 'function' then
        M.autostart.setup(M.capabilities, M.on_attach, M.servers)
    end
end

return M

