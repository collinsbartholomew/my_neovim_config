-- God-Level Unified Formatting Configuration
local ok, conform = pcall(require, "conform")
if not ok then
	return
end

conform.setup({
	formatters_by_ft = {
		-- Web Development Stack
		javascript = { "biome" },
		typescript = { "biome" },
		javascriptreact = { "biome" },
		typescriptreact = { "biome" },
		json = { "biome" },
		jsonc = { "biome" },
		html = { "prettier" },
		css = { "prettier" },
		scss = { "prettier" },
		less = { "prettier" },

		-- Database Stack
		sql = { "sqlfluff" },
		postgresql = { "pg_format" },
		prisma = { "prisma-fmt" },

		-- Multi-Language SE Stack
		lua = { "stylua" },
		python = { "ruff_format", "ruff_organize_imports" },
		rust = { "rustfmt" },
		go = { "goimports", "gofmt" },
		c = { "clang_format" },
		cpp = { "clang_format" },
		java = { "google-java-format" },
		kotlin = { "ktlint" },
		dart = { "dart_format" },
		zig = { "zigfmt" },
		php = { "php_cs_fixer" },

		-- Assembly
		asm = { "asmfmt" },

		-- Shell and Config
		sh = { "shfmt" },
		bash = { "shfmt" },
		zsh = { "shfmt" },
		yaml = { "prettier" },
		toml = { "taplo" },
		markdown = { "prettier" },
		xml = { "xmlformat" },
		proto = { "buf" },
	},

	-- Enhanced formatters configuration
	formatters = {
		-- Biome for fast JS/TS formatting
		biome = {
			command = "biome",
			args = { "format", "--stdin-file-path", "$FILENAME" },
			stdin = true,
			cwd = require("conform.util").root_file({ "biome.json" }),
		},

		-- SQL formatting with PostgreSQL dialect
		sqlfluff = {
			args = { "format", "--dialect=postgres", "--stdin-filename", "$FILENAME", "-" },
		},

		-- PostgreSQL specific
		pg_format = {
			args = { "--spaces", "2", "--no-rcfile" },
		},

		-- Rust formatting with edition
		rustfmt = {
			args = { "--edition", "2021", "--emit", "stdout" },
		},

		-- Go formatting with imports
		goimports = {
			args = { "-local", "github.com/yourorg" },
		},

		-- Python with Ruff (faster than Black)
		ruff_format = {
			args = { "format", "--stdin-filename", "$FILENAME", "-" },
		},

		ruff_organize_imports = {
			command = "ruff",
			args = { "check", "--select", "I", "--fix", "--stdin-filename", "$FILENAME", "-" },
			stdin = true,
		},

		-- Shell formatting with 2-space indentation
		shfmt = {
			args = { "-i", "2", "-ci", "-sr", "-" },
		},

		-- Java with Google style
		["google-java-format"] = {
			args = { "--aosp", "-" },
		},

		-- Kotlin formatting
		ktlint = {
			args = { "--format", "--stdin" },
		},

		-- PHP formatting
		php_cs_fixer = {
			args = { "fix", "--rules=@PSR12", "$FILENAME" },
			stdin = false,
		},

		-- Dart formatting
		dart_format = {
			command = "dart",
			args = { "format", "--stdin-name", "$FILENAME" },
			stdin = true,
		},

		-- Zig formatting
		zigfmt = {
			command = "zig",
			args = { "fmt", "--stdin" },
			stdin = true,
		},

		-- C/C++ formatting with Google style
		clang_format = {
			args = { "--style=Google" },
		},

		-- Assembly formatting
		asmfmt = {
			args = { "-w", "4" },
		},

		-- XML formatting
		xmlformat = {
			command = "xmllint",
			args = { "--format", "-" },
			stdin = true,
		},

		-- Protocol Buffers
		buf = {
			args = { "format", "$FILENAME" },
			stdin = false,
		},
	},

	-- Enhanced format on save with error prevention
	format_on_save = function(bufnr)
		-- Validate buffer
		if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
			return nil
		end

		-- Skip formatting for certain file types
		local filetype = vim.bo[bufnr].filetype
		local skip_filetypes = { 
			"oil", "neo-tree", "trouble", "qf", "help", "man", "lspinfo", 
			"checkhealth", "gitcommit", "gitrebase", "fugitive"
		}

		if vim.tbl_contains(skip_filetypes, filetype) then
			return nil
		end

		-- Check if file is in Git and not ignored
		local file_path = vim.api.nvim_buf_get_name(bufnr)
		if file_path ~= "" and vim.fn.executable("git") == 1 then
			local ok, git_check = pcall(vim.fn.system, "git check-ignore " .. vim.fn.shellescape(file_path))
			if ok and vim.v.shell_error == 0 then
				return nil
			end
		end

		-- Skip if buffer is too large (>1MB)
		local buf_size = vim.api.nvim_buf_get_offset(bufnr, vim.api.nvim_buf_line_count(bufnr))
		if buf_size > 1024 * 1024 then
			return nil
		end

		-- Format with timeout and LSP fallback
		return {
			timeout_ms = 1000,
			lsp_fallback = true,
			quiet = true,
		}
	end,

	format_after_save = {
		lsp_fallback = true,
	},

	notify_on_error = true,
})

-- Enhanced format commands with range support
vim.keymap.set({ "n", "v" }, "<leader>f", function()
	conform.format({ async = true, lsp_fallback = true })
end, { desc = "Format file or range" })

-- Language-specific format commands
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

-- Format info command
vim.keymap.set("n", "<leader>fi", "<cmd>ConformInfo<cr>", { desc = "Conform Info" })

