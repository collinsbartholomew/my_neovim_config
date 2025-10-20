-- Linting configuration
local lint = require("lint")

lint.linters_by_ft = {
  python = { "flake8" },
  java = { "checkstyle" },
  javascript = { "eslint_d" },
  typescript = { "eslint_d" },
  -- Add more
}

return {}