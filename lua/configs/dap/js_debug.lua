-- Setup for js-debug via nvim-dap-vscode-js and Mason-installed js-debug-adapter
local ok, dap = pcall(require, 'dap')
if not ok then
  return
end

local ok2, dap_vscode_js = pcall(require, 'dap-vscode-js')
if not ok2 then
  -- plugin not installed; nothing to do
  return
end

-- Configure adapters provided by js-debug
dap_vscode_js.setup({
  adapters = { 'pwa-node', 'pwa-chrome' },
})

-- Ensure adapter entries exist (they should be provided by configs/dap/adapters)
-- Provide some sensible default configurations for Node and Chrome
dap.configurations.javascript = dap.configurations.javascript or {}
dap.configurations.javascript = vim.list_extend(dap.configurations.javascript, {
  {
    type = 'pwa-node', request = 'launch', name = 'Launch Node (file)', program = '${file}', cwd = '${workspaceFolder}', console = 'integratedTerminal', sourceMaps = true
  },
  {
    type = 'pwa-node', request = 'attach', name = 'Attach to Node', processId = require('dap.utils').pick_process, cwd = '${workspaceFolder}', sourceMaps = true
  },
  {
    type = 'pwa-chrome', request = 'attach', name = 'Attach to Chrome', port = 9222, webRoot = '${workspaceFolder}'
  },
})

dap.configurations.typescript = dap.configurations.typescript or dap.configurations.javascript

-- Auto-open dapui handled elsewhere; here just ensure adapter registration done
return {}

