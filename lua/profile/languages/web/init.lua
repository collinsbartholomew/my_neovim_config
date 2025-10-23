-- added-by-agent: web-setup 20251020-173000
-- mason: ts_ls, tailwindcss-language-server, prettier, eslint, js-debug-adapter
-- manual: node.js, pnpm, and dev dependencies installation required

local M = {}

function M.setup()
    if _G.web_setup_done then
        return
    end

    require("profile.languages.web.lsp").setup()
    require("profile.languages.web.dap").setup()
    require("profile.languages.web.tools").setup()
    require("profile.languages.web.mappings").setup()

    -- Load UI enhancements
    local ui_status_ok, ui = pcall(require, "profile.ui.web-ui")
    if ui_status_ok then
        ui.setup()
    end

    _G.web_setup_done = true
end

return M