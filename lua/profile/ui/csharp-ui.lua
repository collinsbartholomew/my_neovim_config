-- added-by-agent: csharp-setup 20251020-153000
-- mason: none
-- manual: none

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

  -- Show diagnostics on hover
  vim.api.nvim_create_autocmd("CursorHold", {
    pattern = "*.cs",
    callback = function()
      vim.diagnostic.open_float(nil, { focus = false })
    end,
  })

  -- Enable inlay hints for C# files when LSP attaches
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.name == "omnisharp" then
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

return M