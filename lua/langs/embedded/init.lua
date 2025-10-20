local M = {}

function M.setup()
    -- Load assembly support
    require("langs.embedded.assembly")
    
    -- Load zig support
    require("langs.embedded.zig")
end

return M