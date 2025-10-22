-- added-by-agent: ccpp-setup 20251020
-- mason: clangd, codelldb
-- manual: sudo pacman -S --needed base-devel cmake ninja git gcc clang llvm lld lldb gdb clang-tools-extra qt6-base qt6-declarative

local M = {}

function M.setup()
    -- Load submodules
    require("profile.languages.ccpp.lsp").setup()
    require("profile.languages.ccpp.qmlls").setup()
    require("profile.languages.ccpp.debug").setup()
    require("profile.languages.ccpp.tools").setup()
    require("profile.languages.ccpp.qt").setup()
    require("profile.languages.ccpp.mappings").setup()
end

return M