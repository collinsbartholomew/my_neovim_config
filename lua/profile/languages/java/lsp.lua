-- added-by-agent: java-setup 20251020-163000
-- mason: jdtls
-- manual: java-debug and vscode-java-test bundle build steps

local M = {}

function M.setup(config)
  config = config or {}
  
  -- Check if jdtls is available
  local jdtls_status, jdtls = pcall(require, "jdtls")
  if not jdtls_status then
    vim.notify("nvim-jdtls not found. Please install the plugin.", vim.log.levels.WARN)
    return
  end

  -- Find root directory
  local root_dir = jdtls.setup.find_root({'.git', 'pom.xml', 'build.gradle', 'settings.gradle', 'mvnw', 'gradlew'})
  if not root_dir then
    vim.notify("Unable to find Java project root directory.", vim.log.levels.WARN)
    return
  end

  -- Setup workspace directory
  local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
  local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspace/' .. project_name
  vim.fn.mkdir(workspace_dir, 'p')

  -- Find Java executable
  local java_exec = nil
  local jdtls_java_home = os.getenv("JDTLS_JAVA_HOME")
  if jdtls_java_home then
    java_exec = jdtls_java_home .. '/bin/java'
  else
    -- Try to find Java 21 or latest available
    local java_paths = {
      '/usr/lib/jvm/java-21-openjdk/bin/java',
      '/usr/lib/jvm/java-17-openjdk/bin/java',
      '/usr/lib/jvm/default/bin/java',
      'java'
    }
    
    for _, path in ipairs(java_paths) do
      if vim.fn.executable(path) == 1 then
        java_exec = path
        break
      end
    end
  end

  if not java_exec then
    vim.notify("Java executable not found. Please install JDK and set JDTLS_JAVA_HOME.", vim.log.levels.ERROR)
    return
  end

  -- Find JDTLS installation
  local jdtls_path = nil
  local mason_registry_status, mason_registry = pcall(require, "mason-registry")
  if mason_registry_status and mason_registry.is_installed("jdtls") then
    local jdtls_pkg = mason_registry.get_package("jdtls")
    jdtls_path = jdtls_pkg:get_install_path()
  else
    -- Try common installation paths
    local common_paths = {
      '/usr/share/java/jdtls',
      vim.fn.expand('~/.local/share/jdtls'),
    }
    
    for _, path in ipairs(common_paths) do
      if vim.fn.isdirectory(path) == 1 then
        jdtls_path = path
        break
      end
    end
  end

  if not jdtls_path then
    vim.notify("JDTLS not found. Please install via Mason or manually.", vim.log.levels.ERROR)
    return
  end

  -- Setup bundles from dap module
  local bundles = require('profile.languages.java.dap').get_bundles()

  -- Configure JDTLS
  local extendedClientCapabilities = jdtls.extendedClientCapabilities
  extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

  local config = {
    cmd = {
      java_exec,
      '-Declipse.application=org.eclipse.jdt.ls.core.id1',
      '-Dosgi.bundles.defaultStartLevel=4',
      '-noverify',
      '-Xmx1G',
      '--add-modules=ALL-SYSTEM',
      '--add-opens', 'java.base/java.util=ALL-UNNAMED',
      '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
      '-jar', jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar',
      '-configuration', jdtls_path .. '/config_linux',
      '-data', workspace_dir
    },
    root_dir = root_dir,
    settings = {
      java = {
        eclipse = {
          downloadSources = true
        },
        configuration = {
          updateBuildConfiguration = "interactive"
        },
        maven = {
          downloadSources = true
        },
        implementationsCodeLens = {
          enabled = true
        },
        referencesCodeLens = {
          enabled = true
        },
        references = {
          includeDecompiledSources = true
        },
        format = {
          enabled = true,
          settings = {
            url = vim.fn.stdpath("config") .. "/lua/profile/languages/java/formatter.xml",
            profile = "GoogleStyle"
          }
        }
      }
    },
    init_options = {
      bundles = bundles,
      extendedClientCapabilities = extendedClientCapabilities
    },
    on_attach = function(client, bufnr)
      -- Buffer local mappings
      local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
      local opts = { noremap=true, silent=true }
      
      buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
      buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
      buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
      buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
      buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
      
      -- JDTLS specific mappings
      buf_set_keymap('n', '<leader>jo', '<Cmd>lua require(\'jdtls\').organize_imports()<CR>', opts)
      buf_set_keymap('n', '<leader>jv', '<Cmd>lua require(\'jdtls\').extract_variable()<CR>', opts)
      buf_set_keymap('n', '<leader>jc', '<Cmd>lua require(\'jdtls\').extract_constant()<CR>', opts)
      buf_set_keymap('v', '<leader>jm', '<Esc><Cmd>lua require(\'jdtls\').extract_method(true)<CR>', opts)
      
      -- Enable inlay hints if available
      pcall(function() 
        if client.supports_method("textDocument/inlayHint") then
          vim.lsp.inlay_hint(bufnr, true)
        end
      end)
    end
  }

  -- Start JDTLS
  jdtls.start_or_attach(config)
  
  -- Create restart command
  vim.api.nvim_create_user_command('JavaRestartServer', function()
    vim.cmd('LspRestart jdtls')
  end, {})
end

return M