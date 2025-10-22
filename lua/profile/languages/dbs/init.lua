---
-- Databases Language Module
-- Plugins: vim-dadbod, vim-dadbod-ui
-- Features: DB UI, SQL execution, Mongo shell
local M = {}
function M.setup()
    require('profile.languages.dbs.lsp').setup()
    require('profile.languages.dbs.tools').setup()
    require('profile.languages.dbs.mappings').setup()
    require('profile.ui.dbs-ui').setup()
end
return M