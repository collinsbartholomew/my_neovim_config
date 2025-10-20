local M = {}

function M.setup()
  if _G.mern_setup_done then
    return
  end

  require("mern.lsp")
  require("mern.dap")
  require("mern.tools")
  require("mern.mappings")

  _G.mern_setup_done = true
end

return M