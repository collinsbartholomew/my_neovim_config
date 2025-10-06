-- Unified Formatting Configuration
require("conform").setup({
	formatters_by_ft = {
		-- Web Development Stack
		javascript = { "biome" },
		typescript = { "biome" },
		javascriptreact = { "biome" },
		typescriptreact = { "biome" },
		json = { "biome" },
		html = { "prettierd" },
		css = { "prettierd" },
		scss = { "prettierd" },

		-- Database Stack
		sql = { "sqlfmt" },
		prisma = { "prisma-fmt" },

		-- Multi-Language SE Stack
		lua = { "stylua" },
		python = { "ruff_format" },
		rust = { "rustfmt" },
		go = { "goimports", "gofmt" },
		c = { "clang-format" },
		cpp = { "clang-format" },
		java = { "google-java-format" },
		dart = { "dart_format" },
		zig = { "zigfmt" },

		-- Assembly
		asm = { "asmfmt" },

		-- Shell and Config
		sh = { "shfmt" },
		bash = { "shfmt" },
		yaml = { "yamlfmt" },
		toml = { "taplo" },
		markdown = { "prettierd" },
	},

	formatters = {
		-- Biome for fast JS/TS formatting
		biome = {
			command = "biome",
			args = { "format", "--stdin-file-path", "$FILENAME" },
			stdin = true,
			cwd = require("conform.util").root_file({ "biome.json" }),
		},

		-- SQL formatting with PostgreSQL dialect
		sqlfmt = {
			args = { "--dialect", "postgresql", "--tab-width", "2", "-" },
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

		-- Shell formatting with tabs
		shfmt = {
			args = { "-i", "0", "-ci", "-sr", "-" },
		},

		-- Java with Google style
		["google-java-format"] = {
			args = { "--aosp", "-" },
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

		-- C/C++ formatting with 4-character tab indenting
		["clang-format"] = {
			args = {
				"--style={IndentWidth: 4, UseTab: ForIndentation, TabWidth: 4, ColumnLimit: 100}",
			},
		},

		-- Assembly formatting
		asmfmt = {
			args = { "-w", "4" }, -- 4-space indentation
		},
	},

	-- Git-aware format on save with safety checks
	format_on_save = function(bufnr)
		-- Validate buffer
		if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
			return nil
		end

		-- Skip formatting for certain file types
		local filetype = vim.bo[bufnr].filetype
		local skip_filetypes = { "sql", "gitcommit", "gitrebase" } -- Skip problematic types

		if vim.tbl_contains(skip_filetypes, filetype) then
			return nil
		end

		-- Check if file is in Git and not ignored
		local file_path = vim.api.nvim_buf_get_name(bufnr)
		if file_path ~= "" and vim.fn.executable("git") == 1 then
			local ok, git_check = pcall(vim.fn.system, "git check-ignore " .. vim.fn.shellescape(file_path))
			if ok and vim.v.shell_error == 0 then
				-- File is git-ignored, skip formatting
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
			timeout_ms = 2000,
			lsp_fallback = true,
			quiet = true,
		}
	end,
})

-- Stack-specific format commands
vim.keymap.set("n", "<leader>fb", function()
	require("conform").format({
		formatters = { "biome" },
		timeout_ms = 2000,
	})
end, { desc = "Format with Biome" })

vim.keymap.set("n", "<leader>fs", function()
	require("conform").format({
		formatters = { "sqlfmt" },
		timeout_ms = 2000,
	})
end, { desc = "Format SQL" })

