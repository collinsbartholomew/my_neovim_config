--Autocommands
--This file defines automatic commands that trigger on specific events
local api = vim.api

-- Create autocommand group to organize our autocmds
-- The 'clear = true' option ensures the group is cleared when reloading config
local profile_augroup = api.nvim_create_augroup("ProfileAutocommands", { clear = true })

-- Auto resize windows when terminal is resized
-- This ensures windows maintain proper proportions when terminal size changes
api.nvim_create_autocmd({ "VimResized" }, {
	group = profile_augroup,
	pattern = "*",
	command = "wincmd =", -- Equalize window sizes
})

-- Highlight on yank
-- Temporarily highlight text that has been yanked (copied) for visual feedback
api.nvim_create_autocmd("TextYankPost", {
	group = profile_augroup,
	pattern = "*",
	callback = function()
		-- Highlight the yanked text for 200ms
		vim.hl.on_yank({ timeout = 200 })
	end,
})

-- Auto remove trailing whitespace
-- Automatically remove trailing whitespace before saving a file
api.nvim_create_autocmd("BufWritePre", {
	group = profile_augroup,
	pattern = "*",
	command = [[%s/\s\+$//e]], -- Remove trailing whitespace from all lines
})

-- Autocreate directory if it doesn't exist
-- Automatically create parent directories when saving a file to a new path
api.nvim_create_autocmd("BufWritePre", {
	group = profile_augroup,
	pattern = "*",
	callback = function(args)
		--Only create directory if not in a terminal buffer
		if not vim.fn.expand("%:p"):match("term://") then
			-- Create parent directories as needed
			vim.fn.mkdir(vim.fn.expand("%:p:h"), "p")
		end
	end,
})

-- Auto close certain filetypes with'q'
-- Make specific filetypes close with the 'q' key for convenience
api.nvim_create_autocmd("FileType", {
	group = profile_augroup,
	pattern = {
		"help", -- Help documents
		"startuptime", -- Startup time analysis
		"qf", -- Quickfix list
		"lspinfo", -- LSP information
		"man", -- Manual pages
		"spectre_panel", -- Spectre search panel
		"dbui", -- Database UI
		"neotest-summary", -- Neotest summary
		"neotest-output", -- Neotest output
		"neotest-output-panel", -- Neotest output panel
		"aerial-nav", -- Aerial navigation
		"PlenaryTestPopup", -- Plenary test popup
		"grug-far", -- Grugfind and replace
	},
	callback = function(event)
		-- Make these buffers not appear in the buffer list
		vim.bo[event.buf].buflisted = false
		-- Map 'q' toclose the buffer
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- Auto close dap floats
--Automatically close DAP floating windows with ESC key
api.nvim_create_autocmd("FileType", {
	group = profile_augroup,
	pattern = {
		"dap-float", -- DAP floating windows
	},
	callback = function(event)
		-- Map ESC to forcefully close the floating window
		vim.keymap.set("n", "<ESC>", "<cmd>close!<cr>", { buffer = event.buf, silent = true })
	end,
})

-- Auto open diagnostics
-- Automatically show diagnostic information when diagnostics change
-- Commented out to reduce intrusiveness
-- api.nvim_create_autocmd("DiagnosticChanged", {
--     group = profile_augroup,
--    pattern = "*",
--     callback = function()
--         --Getdiagnostics for current buffer
--         local diagnostics= vim.diagnostic.get(0)
--         -- If there are diagnostics, show them in a floating window
--         if #diagnostics > 0 then
--             vim.diagnostic.open_float()
--         end
--     end,
-- })

-- Auto format on save
-- Automatically format code whensaving files using conform.nvim
api.nvim_create_autocmd("BufWritePre", {
	group = profile_augroup,
	pattern = "*",
	callback = function()
		-- Try to load conform.nvim
		local conform_ok, conform = pcall(require, "conform")
		if conform_ok then
			--Format the currentbuffer with a 500ms timeout
			conform.format({
				bufnr = 0, -- Current buffer
				lsp_fallback = true, -- Use LSP formatter if no conform formatter isavailable
				timeout_ms = 500, -- Timeout after 500ms
			})
		end
	end,
})

-- Autotoggle relative numbers
-- Enable relative line numbers when entering buffer, gaining focus, or leaving insert mode
api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave" }, {
	group = profile_augroup,
	pattern = "*",
	callback = function()
		-- Only if line numbers are enabled
		if vim.api.nvim_get_option_value("number", {}) then
			-- Enable relative line numbers
			vim.api.nvim_set_option_value("relativenumber", true, {})
		end
	end,
})

-- Disable relative numbers when leaving buffer, losing focus, or entering insert mode
api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter" }, {
	group = profile_augroup,
	pattern = "*",
	callback = function()
		-- Only if line numbers are enabled
		if vim.api.nvim_get_option_value("number", {}) then
			-- Disable relative line numbers
			vim.api.nvim_set_option_value("relativenumber", false, {})
		end
	end,
})

-- Autoenable diagnostics for supported filetypes
-- Control whether diagnostics are enabled based on global setting
api.nvim_create_autocmd("FileType", {
	group = profile_augroup,
	pattern = "*",
	callback = function(args)
		-- Initialize diagnostics_enabled global variable if not set
		if vim.g.diagnostics_enabled == nil then
			vim.g.diagnostics_enabled = true
		end

		-- Enable or disable diagnostics based on global setting
		if vim.g.diagnostics_enabled then
			vim.diagnostic.enable(true, { bufnr = args.buf })
		else
			vim.diagnostic.enable(false, { bufnr = args.buf })
		end
	end,
})

-- Run linter on save for supported filetypes
-- Automatically lint code after saving files using nvim-lint
api.nvim_create_autocmd({ "BufWritePost" }, {
	group = profile_augroup,
	callback = function()
		-- Try to loadnvim-lint
		local lint_ok, lint = pcall(require, "lint")
		if lint_ok then
			-- Run the default linter for the currentfiletype
			lint.try_lint()

			-- Run specific linters for different filetypes
			local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
			if buf_ft == "c" or buf_ft == "cpp" then
				-- For C/C++ files, runclang-tidy and cppcheck
				lint.try_lint("clangtidy")
				lint.try_lint("cppcheck")
			elseif buf_ft == "qml" then
				-- For QML files, run qmllint
				lint.try_lint("qmllint")
			elseif buf_ft == "rust" then
				-- For Rust files, run clippy
				lint.try_lint("clippy")
			elseif buf_ft == "zig" then
				-- For Zig files, run zls
				lint.try_lint("zls")
			elseif buf_ft == "go" then
				-- ForGo files, run golangci-lint
				lint.try_lint("golangcilint")
			elseif buf_ft == "cs" then
				-- For C# files, we rely on OmniSharp for diagnostics
			elseif buf_ft == "java" then
				-- For Java files, run checkstyle
				lint.try_lint("checkstyle")
			elseif buf_ft == "python" then
				-- For Python files, run rufflint.try_lint("ruff")
			end
		end
	end,
})

-- Set specific options for Qt/QML files
-- Configure indentation and tab settingsfor QML files
api.nvim_create_autocmd("FileType", {
	group = profile_augroup,
	pattern = { "qml" },
	callback = function()
		-- Set 4-space indentation for QML files
		vim.api.nvim_buf_set_option(0, "tabstop", 4)
		vim.api.nvim_buf_set_option(0, "shiftwidth", 4)
		vim.api.nvim_buf_set_option(0, "expandtab", true)
	end,
})

-- Set specific options for C/C++ files
--Configure indentation and text width for C/C++ files
api.nvim_create_autocmd("FileType", {
	group = profile_augroup,
	pattern = { "c", "cpp" },
	callback = function()
		-- Set 4-space indentation for C/C++ files
		vim.api.nvim_buf_set_option(0, "tabstop", 4)
		vim.api.nvim_buf_set_option(0, "shiftwidth", 4)
		vim.api.nvim_buf_set_option(0, "expandtab", true)
		-- Set text width to 100 characters
		vim.api.nvim_buf_set_option(0, "textwidth", 100)
		-- Show color column at 100 characters
		vim.api.nvim_buf_set_option(0, "colorcolumn", "100")
	end,
})

-- Set specific options for Rust files
api.nvim_create_autocmd("FileType", {
	group = profile_augroup,
	pattern = { "rust" },
	callback = function()
		vim.api.nvim_buf_set_option(0, "tabstop", 4)
		vim.api.nvim_buf_set_option(0, "shiftwidth", 4)
		vim.api.nvim_buf_set_option(0, "expandtab", true)
		vim.api.nvim_buf_set_option(0, "textwidth", 100)
		vim.api.nvim_buf_set_option(0, "colorcolumn", "100")
	end,
})

-- Set specific options for Zig files
api.nvim_create_autocmd("FileType", {
	group = profile_augroup,
	pattern = { "zig" },
	callback = function()
		vim.api.nvim_buf_set_option(0, "tabstop", 4)
		vim.api.nvim_buf_set_option(0, "shiftwidth", 4)
		vim.api.nvim_buf_set_option(0, "expandtab", true)
		vim.api.nvim_buf_set_option(0, "textwidth", 100)
		vim.api.nvim_buf_set_option(0, "colorcolumn", "100")
	end,
})

-- Set specific options for Go files
api.nvim_create_autocmd("FileType", {
	group = profile_augroup,
	pattern = { "go" },
	callback = function()
		vim.api.nvim_buf_set_option(0, "tabstop", 4)
		vim.api.nvim_buf_set_option(0, "shiftwidth", 4)
		vim.api.nvim_buf_set_option(0, "expandtab", false)
		vim.api.nvim_buf_set_option(0, "textwidth", 120)
		vim.api.nvim_buf_set_option(0, "colorcolumn", "120")
	end,
})

-- Set specific options for C# files
api.nvim_create_autocmd("FileType", {
	group = profile_augroup,
	pattern = { "cs" },
	callback = function()
		vim.api.nvim_buf_set_option(0, "tabstop", 4)
		vim.api.nvim_buf_set_option(0, "shiftwidth", 4)
		vim.api.nvim_buf_set_option(0, "expandtab", false)
		vim.api.nvim_buf_set_option(0, "textwidth", 120)
		vim.api.nvim_buf_set_option(0, "colorcolumn", "120")
	end,
})

-- Set specific options for Java files
api.nvim_create_autocmd("FileType", {
	group = profile_augroup,
	pattern = { "java" },
	callback = function()
		vim.api.nvim_buf_set_option(0, "tabstop", 4)
		vim.api.nvim_buf_set_option(0, "shiftwidth", 4)
		vim.api.nvim_buf_set_option(0, "expandtab", false)
		vim.api.nvim_buf_set_option(0, "textwidth", 100)
		vim.api.nvim_buf_set_option(0, "colorcolumn", "100")
	end,
})

-- Set specific options for Python files
api.nvim_create_autocmd("FileType", {
	group = profile_augroup,
	pattern = { "python" },
	callback = function()
		vim.api.nvim_buf_set_option(0, "tabstop", 4)
		vim.api.nvim_buf_set_option(0, "shiftwidth", 4)
		vim.api.nvim_buf_set_option(0, "expandtab", false)
		vim.api.nvim_buf_set_option(0, "textwidth", 88)
		vim.api.nvim_buf_set_option(0, "colorcolumn", "88")
	end,
})

--Set specific options for Mojo files
api.nvim_create_autocmd("FileType", {
	group = profile_augroup,
	pattern = { "mojo" },
	callback = function()
		vim.api.nvim_buf_set_option(0, "tabstop", 4)
		vim.api.nvim_buf_set_option(0, "shiftwidth", 4)
		vim.api.nvim_buf_set_option(0, "expandtab", false)
		vim.api.nvim_buf_set_option(0, "textwidth", 100)
		vim.api.nvim_buf_set_option(0, "colorcolumn", "100")
	end,
})

-- Set foldlevel to show all folds by default (disable auto folding)
api.nvim_create_autocmd("BufReadPost", {
	group = profile_augroup,
	pattern = "*",
	callback = function()
		vim.api.nvim_buf_set_option(0, "foldlevel", 99)
	end,
})

--FormatLua files on save
api.nvim_create_autocmd("BufWritePre", {
	group = profile_augroup,
	pattern = { "*.lua" },
	callback = function()
		local conform_ok, conform = pcall(require, "conform")
		if conform_ok then
			conform.format({
				bufnr = 0,
				lsp_fallback = true,
				timeout_ms = 500,
			})
		end
	end,
})

-- Runlinter on save for Lua files
api.nvim_create_autocmd({ "BufWritePost" }, {
	group = profile_augroup,
	pattern = { "*.lua" },
	callback = function()
		local lint_ok, lint = pcall(require, "lint")
		if lint_ok then
			lint.try_lint("luacheck")
		end
	end,
})

--Format web files on save
api.nvim_create_autocmd("BufWritePre", {
	group = profile_augroup,
	pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.html", "*.css", "*.scss", "*.json" },
	callback = function()
		local conform_ok, conform = pcall(require, "conform")
		if conform_ok then
			conform.format({
				bufnr = 0,
				lsp_fallback = true,
				timeout_ms = 500,
			})
		end
	end,
})

-- Runlinter on save for webfiles
api.nvim_create_autocmd({ "BufWritePost" }, {
	group = profile_augroup,
	pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
	callback = function()
		local lint_ok, lint = pcall(require, "lint")
		if lint_ok then
			lint.try_lint("eslint_d")
		end
	end,
})

-- Format PHP files on save
api.nvim_create_autocmd("BufWritePre", {
	group = profile_augroup,
	pattern = { "*.php" },
	callback = function()
		local conform_ok, conform = pcall(require, "conform")
		if conform_ok then
			conform.format({
				bufnr = 0,
				lsp_fallback = true,
				timeout_ms = 500,
			})
		end
	end,
})

-- Run linter on save for PHP files
api.nvim_create_autocmd({ "BufWritePost" }, {
	group = profile_augroup,
	pattern = { "*.php" },
	callback = function()
		local lint_ok, lint = pcall(require, "lint")
		if lint_ok then
			lint.try_lint("phpstan")
		end
	end,
})

-- Set up custom diagnostic signs with icons
api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		-- Define diagnostic signs with icons
		vim.fn.sign_define("DiagnosticSignError", {
			text = "",
			texthl = "DiagnosticSignError",
			linehl = "",
			numhl = "",
		})

		vim.fn.sign_define("DiagnosticSignWarn", {
			text = "",
			texthl = "DiagnosticSignWarn",
			linehl = "",
			numhl = "",
		})
		vim.fn.sign_define("DiagnosticSignInfo", {
			text = "",
			texthl = "DiagnosticSignInfo",
			linehl = "",
			numhl = "",
		})

		vim.fn.sign_define("DiagnosticSignHint", {
			text = "󰌶",
			texthl = "DiagnosticSignHint",
			linehl = "",
			numhl = "",
		})
	end,
})

-- Set up diagnostic signs immediately
vim.fn.sign_define("DiagnosticSignError", {
	text = "",
	texthl = "DiagnosticSignError",
	linehl = "",
	numhl = "",
})

vim.fn.sign_define("DiagnosticSignWarn", {
	text = "",
	texthl = "DiagnosticSignWarn",
	linehl = "",
	numhl = "",
})

vim.fn.sign_define("DiagnosticSignInfo", {
	text = "",
	texthl = "DiagnosticSignInfo",
	linehl = "",
	numhl = "",
})

vim.fn.sign_define("DiagnosticSignHint", {
	text = "󰌶",
	texthl = "DiagnosticSignHint",
	linehl = "",
	numhl = "",
})

