-- Python LSP configuration
local M = {}

function M.setup()
  -- Ensure mason and mason-lspconfig are loaded
  local mason_ok, mason = pcall(require, "mason")
  local mason_lsp_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
  local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
  
  if not (mason_ok and mason_lsp_ok and lspconfig_ok) then
    return
  end

  -- Setup mason
  mason.setup()
  
  -- Ensure Python-related LSP servers are installed
  mason_lspconfig.setup({
    ensure_installed = { "pyright" }
  })

  -- Configure pyright
  mason_lspconfig.setup_handlers({
    function(server_name)
      if server_name == "pyright" then
        lspconfig.pyright.setup({
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true
              }
            }
          }
        })
      end
    end
  })
end

return M