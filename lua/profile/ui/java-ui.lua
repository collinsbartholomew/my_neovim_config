-- added-by-agent: java-setup 20251020-163000
-- mason: jdtls
-- manual: java-debug and vscode-java-test bundle build steps

local M = {}

function M.setup()
  -- Configure diagnostics
  vim.diagnostic.config({
    virtual_text = { prefix = "●", spacing = 2 },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
  })

  -- Set update time for CursorHold events
  vim.o.updatetime = 250

  -- Show diagnostics on hover
  vim.api.nvim_create_autocmd("CursorHold", {
    pattern = "*.java",
    callback = function()
      vim.diagnostic.open_float(nil, { focus = false })
    end,
  })

  -- Enable inlay hints for Java files when LSP attaches
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.name == "jdtls" then
        local bufnr = args.buf
        pcall(function()
          if client.supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint(bufnr, true)
          end
        end)
      end
    end,
  })
end

-- Function to get Java server status (non-blocking)
function M.get_server_status()
  local clients = vim.lsp.get_active_clients()
  for _, client in ipairs(clients) do
    if client.name == "jdtls" then
      return "Running"
    end
  end
  return "Not running"
end

return M