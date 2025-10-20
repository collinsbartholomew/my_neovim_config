-- Python tools configuration
local M = {}

function M.setup()
  -- Setup conform.nvim for Python formatters
  local conform_ok, conform = pcall(require, "conform")
  if conform_ok then
    conform.setup({
      formatters_by_ft = {
        python = { "ruff", "black", "isort" }
      }
    })
  end

  -- Setup linting for Python
  local lint_ok, lint = pcall(require, "lint")
  if lint_ok then
    lint.linters_by_ft.python = { "ruff" }
  end
end

return M