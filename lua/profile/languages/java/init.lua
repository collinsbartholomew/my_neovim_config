-- added-by-agent: java-setup 20251020-163000
-- mason: jdtls
-- manual: java-debug and vscode-java-test bundle build steps

local M = {}

function M.setup(config)
    -- Idempotency check
    if _G.java_setup_done then
        return true
    end

    -- Load all Java modules
    require('profile.languages.java.lsp').setup(config)
    require('profile.languages.java.dap').setup(config)
    require('profile.languages.java.tools').setup(config)
    require('profile.languages.java.mappings').setup()
    
    -- Ensure treesitter parsers
    local tsinstall_status_ok, tsinstall = pcall(require, "nvim-treesitter.install")
    if tsinstall_status_ok then
        tsinstall.ensure_installed({ "java", "javaproperties" })
    end

    -- Mark setup as done
    _G.java_setup_done = true
    return true
end

return M