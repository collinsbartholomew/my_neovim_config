-- added-by-agent: java-setup 20251020-163000
-- mason: jdtls
-- manual: java-debug and vscode-java-test bundle build steps

local M = {}

function M.get_bundles()
  local java_debug_root = vim.fn.stdpath('data') .. '/java_debug'
  local bundles = {}

  -- Check if java-debug bundle exists
  local java_debug_jar = java_debug_root .. '/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar'
  local java_test_jar = java_debug_root .. '/vscode-java-test/server/*.jar'

  -- Find actual jar files
  local java_debug_jars = vim.fn.glob(java_debug_jar, true, true)
  local java_test_jars = vim.fn.glob(java_test_jar, true, true)

  -- Add found jars to bundles
  for _, jar in ipairs(java_debug_jars) do
    if vim.fn.filereadable(jar) == 1 then
      table.insert(bundles, jar)
    end
  end

  for _, jar in ipairs(java_test_jars) do
    if vim.fn.filereadable(jar) == 1 then
      table.insert(bundles, jar)
    end
  end

  if #bundles == 0 then
    vim.notify("Java debug bundles not found. Debug functionality will be limited.", vim.log.levels.WARN)
  end

  return bundles
end

function M.setup(config)
  config = config or {}
  
  local dap_status, dap = pcall(require, "dap")
  if not dap_status then
    vim.notify("nvim-dap not available for Java debug setup", vim.log.levels.WARN)
    return
  end

  -- Get bundles
  local bundles = M.get_bundles()

  -- Setup dap.adapters.java
  dap.adapters.java = function(callback)
    callback({
      type = 'executable',
      command = 'java',
      args = {
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-noverify',
        '-Xmx1G',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        '-jar', vim.fn.stdpath('data') .. '/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar',
        '-configuration', vim.fn.stdpath('data') .. '/mason/packages/jdtls/config_linux',
        '-data', vim.fn.stdpath('data') .. '/jdtls-workspace'
      }
    })
  end

  -- Setup dap configurations
  dap.configurations.java = {
    {
      type = 'java',
      request = 'launch',
      name = 'Debug (Attach) - Remote',
      hostName = '127.0.0.1',
      port = 5005,
    },
    {
      type = 'java',
      request = 'launch',
      name = 'Debug Main Class',
      mainClass = function()
        return vim.fn.input('Main class: ', '', 'file')
      end,
      projectName = function()
        local root_dir = vim.fn.getcwd()
        return vim.fn.fnamemodify(root_dir, ':t')
      end,
    }
  }
end

return M