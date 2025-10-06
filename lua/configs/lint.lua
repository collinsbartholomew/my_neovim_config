-- Modern linting configuration (matches main config)
local ok, lint = pcall(require, "lint")
if not ok then
	vim.notify("nvim-lint not available", vim.log.levels.WARN)
	return
end

-- Use same configuration as main plugin setup
lint.linters_by_ft = {
	-- Python: Use Ruff (faster than flake8)
	python = { "ruff" },
	-- Shell: Keep shellcheck (best for shell)
	sh = { "shellcheck" },
	bash = { "shellcheck" },
	-- JS/TS: Removed (Biome handles this better)
}

-- Autocmd with error handling
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		pcall(lint.try_lint)
	end,
})

