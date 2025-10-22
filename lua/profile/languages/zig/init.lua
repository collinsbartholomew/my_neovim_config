-- added-by-agent: zig-setup 20251020
-- mason: zls, codelldb
-- manual: build zls from source if using Zig nightly

local M = {}

function M.setup()
    -- Load sub-modules
    require('profile.languages.zig.lsp').setup()
    require('profile.languages.zig.debug').setup()
    require('profile.languages.zig.tools').setup()
    require('profile.languages.zig.mappings').setup()

    -- Ensure treesitter parser
    local ok, tsinstall = pcall(require, 'nvim-treesitter.install')
    if ok then
        tsinstall.ensure_installed({ 'zig' })
    end
end

return M