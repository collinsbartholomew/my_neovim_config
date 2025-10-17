-- Conform formatting configuration (moved to configs/tools/formatting.lua)
local ok, conform = pcall(require, "conform")
if not ok then
	return
end

conform.setup({
	formatters_by_ft = {
		javascript = { "prettierd", "prettier", "biome" },
		typescript = { "prettierd", "prettier", "biome" },
		javascriptreact = { "prettierd", "prettier", "biome" },
		typescriptreact = { "prettierd", "prettier", "biome" },
		json = { "biome" },
		jsonc = { "biome" },
		html = { "prettierd", "prettier" },
		htm = { "prettierd", "prettier" },
		htmldjango = { "prettierd", "prettier" },
		handlebars = { "prettierd", "prettier" },
		hbs = { "prettierd", "prettier" },
		mustache = { "prettierd", "prettier" },
		templ = { "prettierd", "prettier" },
		ejs = { "prettierd", "prettier" },
		vue = { "prettierd", "prettier" },
		svelte = { "prettierd", "prettier" },
		astro = { "prettierd", "prettier" },
		css = { "prettierd", "prettier" },
		scss = { "prettierd", "prettier" },
		less = { "prettierd", "prettier" },
		sass = { "prettierd", "prettier" },

		sql = { "sqlfluff" },
		postgresql = { "pg_format" },
		prisma = { "prisma-fmt" },

		lua = { "stylua" },
		python = { "ruff_format", "ruff_organize_imports" },
		rust = { "rustfmt" },
		go = { "goimports", "gofmt" },
		c = { "clang_format" },
		cpp = { "clang_format" },
		cs = { "csharpier" },
		hpp = { "clang_format" },
		h = { "clang_format" },
		objc = { "clang_format" },
		objcpp = { "clang_format" },
		cuda = { "clang_format" },
		proto = { "clang_format" },
		java = { "google-java-format" },
		kotlin = { "ktlint" },
		dart = { "dart_format" },
		zig = { "zigfmt" },
		php = { "php_cs_fixer" },
		r = { "styler" },
		rmd = { "styler" },

		qml = { "qmlformat" },
		qmljs = { "qmlformat" },
		cmake = { "cmake_format" },

		asm = { "asmfmt" },

		sh = { "shfmt" },
		bash = { "shfmt" },
		zsh = { "shfmt" },
		yaml = { "prettier" },
		toml = { "taplo" },
		markdown = { "prettier" },
		xml = { "xmlformat" },
		proto = { "buf" },
		hyprlang = { "prettier" },
	},

	formatters = {
		biome = { command = "biome", args = { "format", "--stdin-file-path", "$FILENAME" }, stdin = true, cwd = require("conform.util").root_file({ "biome.json" }) },
		sqlfluff = { args = { "format", "--dialect=postgres", "--stdin-filename", "$FILENAME", "-" } },
		pg_format = { args = { "--spaces", "4", "--no-rcfile" } },
		rustfmt = { args = { "--edition", "2021", "--emit", "stdout" } },
		goimports = { args = { "-local", "github.com/yourorg" } },
		ruff_format = { args = { "format", "--indent-width", "4", "--stdin-filename", "$FILENAME", "-" } },
		ruff_organize_imports = { command = "ruff", args = { "check", "--select", "I", "--fix", "--stdin-filename", "$FILENAME", "-" }, stdin = true },
		shfmt = { args = { "-i", "4", "-ci", "-sr", "-" } },
		["google-java-format"] = { args = { "--aosp", "-" } },
		ktlint = { args = { "--format", "--stdin" } },
		php_cs_fixer = { args = { "fix", "--rules=@PSR12", "$FILENAME" }, stdin = false },
		dart_format = { command = "dart", args = { "format", "--stdin-name", "$FILENAME" }, stdin = true },
		zigfmt = { command = "zig", args = { "fmt", "--stdin" }, stdin = true },
		clang_format = { args = { "--style={BasedOnStyle: Google, UseTab: Always, TabWidth: 4, IndentWidth: 4, ColumnLimit: 120}" }, filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto", "hpp", "h" } },
		asmfmt = { args = { "-w", "4" } },
		xmlformat = { command = "xmllint", args = { "--format", "-" }, stdin = true },
		qmlformat = { command = "qmlformat", args = { "-i", "$FILENAME" }, stdin = false },
		cmake_format = { command = "cmake-format", args = { "-" }, stdin = true },
		styler = { command = "Rscript", args = { "-e", "styler::style_text(readLines('stdin'), indent_by = 4)" }, stdin = true },
		prettier = { args = { "--stdin-filepath", "$FILENAME", "--tab-width", "4", "--use-tabs", "true", "--print-width", "120", "--html-whitespace-sensitivity", "css", "--bracket-same-line", "false", "--single-attribute-per-line", "false" }, filetypes = { "html", "htm", "css", "scss", "less", "sass", "yaml", "markdown", "json", "jsonc", "ejs", "vue", "svelte", "astro" } },
		prettierd = { command = "prettierd", stdin = true, env = { PRETTIER_TAILWIND_PLUGIN_SEARCH_DIR = vim.loop.cwd() } },
		buf = { args = { "format", "$FILENAME" }, stdin = false },
	},

	format_on_save = function(bufnr)
		if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) or vim.fn.mode() == 'c' then
			return nil
		end
		if vim.bo[bufnr].buftype ~= '' then
			return nil
		end
		local filetype = vim.bo[bufnr].filetype
		local skip_filetypes = { "oil", "neo-tree", "trouble", "qf", "help", "man", "lspinfo", "checkhealth", "gitcommit", "gitrebase", "fugitive", "" }
		if vim.tbl_contains(skip_filetypes, filetype) then
			return nil
		end
		local ok2, buf_size = pcall(vim.api.nvim_buf_get_offset, bufnr, vim.api.nvim_buf_line_count(bufnr))
		if not ok2 or buf_size > 1024 * 1024 then
			return nil
		end
		return { timeout_ms = 500, lsp_fallback = true, quiet = true }
	end,

	format_after_save = { lsp_fallback = true },
	notify_on_error = true,
})

vim.keymap.set({ "n", "v" }, "<leader>f", function()
	conform.format({ async = true, lsp_fallback = true })
end, { desc = "Format file or range" })
vim.keymap.set("n", "<leader>fb", function()
	conform.format({ formatters = { "biome" }, async = true })
end, { desc = "Format with Biome" })
vim.keymap.set("n", "<leader>fs", function()
	conform.format({ formatters = { "sqlfluff" }, async = true })
end, { desc = "Format SQL" })
vim.keymap.set("n", "<leader>fp", function()
	conform.format({ formatters = { "prettier" }, async = true })
end, { desc = "Format with Prettier" })
vim.keymap.set("n", "<leader>fr", function()
	conform.format({ formatters = { "ruff_format" }, async = true })
end, { desc = "Format Python with Ruff" })
vim.keymap.set("n", "<leader>fi", "<cmd>ConformInfo<cr>", { desc = "Conform Info" })
