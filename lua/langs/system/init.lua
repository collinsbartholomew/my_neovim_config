local M = {}

function M.setup()
    -- Load hyprland support
    require("langs.system.hyprland").setup()
end

return M