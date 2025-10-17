-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ timeout = 150 })
	end,
})

-- Transparent background and disable italics
vim.api.nvim_create_autocmd("ColorScheme", {
	desc = "Set transparent background and disable italics",
	group = vim.api.nvim_create_augroup("ui-fixes", { clear = true }),
	callback = function()
		-- Batch highlight updates for performance
		local highlights = {
			{ "Normal", { bg = "NONE" } },
			{ "NormalFloat", { bg = "NONE" } },
			{ "FloatBorder", { bg = "NONE" } },
			{ "SignColumn", { bg = "NONE" } },
			{ "DiagnosticUnderlineError", { underline = true, sp = "#eb6f92" } },
			{ "DiagnosticUnderlineWarn", { underline = true, sp = "#f6c177" } },
			{ "DiagnosticUnderlineInfo", { underline = true, sp = "#31748f" } },
			{ "DiagnosticUnderlineHint", { underline = true, sp = "#9ccfd8" } },
		}
		for _, hl in ipairs(highlights) do
			vim.api.nvim_set_hl(0, hl[1], hl[2])
		end
	end,
})

-- Pure tabs for all file types with 4-space width
vim.api.nvim_create_autocmd("FileType", {
	desc = "Set pure tab indentation with 4-space width",
	group = vim.api.nvim_create_augroup("pure-tabs", { clear = true }),
	pattern = { "*" },
	callback = function()
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.expandtab = false
		vim.opt_local.softtabstop = 0
		-- Ensure terminal displays tabs as 4 spaces
		if vim.bo.buftype == "terminal" then
			vim.fn.system("tabs -4")
		end
	end,
})

-- Force tabs after formatting
vim.api.nvim_create_autocmd("BufWritePost", {
	desc = "Convert spaces to tabs after formatting",
	group = vim.api.nvim_create_augroup("force-tabs", { clear = true }),
	pattern = { "*.c", "*.cpp", "*.h", "*.hpp" },
	callback = function()
		vim.cmd([[silent! %s/^\(    \)\+/\=repeat('\t', len(submatch(0))/4)/g]])
	end,
})

-- Set terminal tab stops on startup
vim.api.nvim_create_autocmd("VimEnter", {
	desc = "Set terminal tab stops to 4",
	group = vim.api.nvim_create_augroup("terminal-tabs", { clear = true }),
	callback = function()
		vim.fn.system("tabs -4")
	end,
})

-- Large file optimization
vim.api.nvim_create_autocmd("BufReadPre", {
	desc = "Optimize for large files",
	group = vim.api.nvim_create_augroup("large-file", { clear = true }),
	callback = function(args)
		local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
		if ok and stats and stats.size > 1024 * 1024 then -- 1MB
			vim.opt_local.foldmethod = "manual"
			vim.opt_local.undolevels = -1
			vim.opt_local.swapfile = false
			vim.opt_local.syntax = ""
		end
	end,
})

-- Auto-create directories
vim.api.nvim_create_autocmd("BufWritePre", {
	desc = "Auto-create parent directories",
	group = vim.api.nvim_create_augroup("auto-mkdir", { clear = true }),
	callback = function(args)
		if args.match:match("^%w%w+:[\\/][\\/]") then
			return
		end
		local file = vim.uv.fs_realpath(args.match) or args.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

-- Auto-open neotree on startup
vim.api.nvim_create_autocmd("VimEnter", {
	desc = "Open neotree on startup",
	group = vim.api.nvim_create_augroup("neotree-startup", { clear = true }),
	callback = function()
		if vim.fn.argc() == 0 then
			vim.cmd("Neotree show")
		end
	end,
})

-- Organize imports and add missing imports on save for JS/TS
vim.api.nvim_create_autocmd("BufWritePre", {
	desc = "Auto organize and add missing imports",
	group = vim.api.nvim_create_augroup("ts-js-auto-imports", { clear = true }),
	pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
	callback = function()
		if vim.g.disable_auto_imports then return end
		local params = {
			context = { only = { "source.addMissingImports.ts", "source.organizeImports" } },
		}
		vim.lsp.buf.code_action(params)
		-- Some servers apply automatically; if not, we apply first available edit
		-- Note: vtsls supports apply=true via code_action, but Neovim API does not expose it directly
	end,
})
