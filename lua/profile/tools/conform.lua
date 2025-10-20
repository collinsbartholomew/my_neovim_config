-- Conform.nvim setup (formatters)
local conform_status, conform = pcall(require, "conform")
if not conform_status then
  vim.notify("Conform.nvim not available", vim.log.levels.WARN)
  return
end

conform.setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "black" },
    java = { "google-java-format" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    -- Add more
  },
  format_on_save = { timeout_ms = 500, lsp_fallback = true },
})

return {}