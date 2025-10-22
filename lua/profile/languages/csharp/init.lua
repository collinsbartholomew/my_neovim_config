-- added-by-agent: csharp-setup 20251020-153000
-- mason: omnisharp
-- manual: dotnet-sdk installation required

local M = {}

function M.setup(config)
    -- Idempotency check
    if _G.csharp_setup_done then
        return
    end

    -- Load all C# modules
    require('profile.languages.csharp.lsp').setup(config)
    require('profile.languages.csharp.debug').setup()
    require('profile.languages.csharp.tools').setup()
    require('profile.languages.csharp.mappings').setup()
    
    -- Ensure treesitter parsers
    local tsinstall_status_ok, tsinstall = pcall(require, "nvim-treesitter.install")
    if tsinstall_status_ok then
        tsinstall.ensure_installed({ "csharp", "csproj" })
    end

    -- Mark setup as done
    _G.csharp_setup_done = true
end

return M