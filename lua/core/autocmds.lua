--Highlight on yank
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
		--Batch highlight updates for performance
		local highlights = {
			{ "Normal", { bg = "NONE" } },
			{ "NormalFloat", { bg = "NONE" } },
			{ "FloatBorder", { bg = "NONE" } },
			{ "SignColumn", { bg ="NONE" } },
			{ "DiagnosticUnderlineError", { underline = true, sp = "#eb6f92" } },
			{ "DiagnosticUnderlineWarn", { underline = true, sp = "#f6c177" } },
			{ "DiagnosticUnderlineInfo",{ underline = true, sp = "#31748f" } },
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
		-- Avoid external system calls in autocmds; terminal buffers will keep their own settings
	end,
})

-- Force tabs after formatting
vim.api.nvim_create_autocmd("BufWritePost", {
	desc = "Convert spaces to tabs afterformatting",
	group = vim.api.nvim_create_augroup("force-tabs", { clear = true }),
	pattern = { "*.c", "*.cpp", "*.h", "*.hpp" },
	callback = function()
		-- Use a safe, in-editor substitution to convert groups of 4 spaces to tabs
		pcall(vim.cmd, [[silent! %s/^\(    \)\+/\=repeat('\t', len(submatch(0))/4)/g]])
	end,
})

-- Set terminal tab stops on startup (no external system calls)
vim.api.nvim_create_autocmd("VimEnter", {
	desc = "Set terminal tab stops to 4",
	group = vim.api.nvim_create_augroup("terminal-tabs", { clear = true }),
	callback = function()
		-- Intentionally left blank; avoid spawning external `tabs` command from config
	end,
})

-- Large file optimization
vim.api.nvim_create_autocmd("BufReadPre", {
	desc = "Optimize for large files",
	group = vim.api.nvim_create_augroup("large-file", { clear = true }),
	callback = function(args)
		local bufname = vim.api.nvim_buf_get_name(args.buf)
		local ok, stats = pcall(function() return vim.loop.fs_stat(bufname) end)
		if ok and stats and stats.size and stats.size > 1024 * 1024 then -- 1MB
			vim.opt_local.foldmethod = "manual"
			vim.opt_local.undolevels = -1
			vim.opt_local.swapfile = false
			-- Disable syntax highlighting for huge files safely
			pcall(vim.cmd, "syntax off")
		end
	end,
})

-- Auto-create directories
vim.api.nvim_create_autocmd("BufWritePre", {
	desc = "Auto-create parent directories",
	group = vim.api.nvim_create_augroup("auto-mkdir", { clear = true }),
	callback = function(args)
		-- skip over URIs like "file://..."
		if args.match:match("^%w+://") then
			return
		end
		-- Resolve to absolute path reliably using vim.fn
		local file = vim.fn.fnamemodify(args.match, ":p") or args.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

-- Auto-open neotree on startup
vim.api.nvim_create_autocmd("VimEnter", {
	desc = "Open neotree on startup",
	group = vim.api.nvim_create_augroup("neotree-startup", { clear = true }),
	callback = function()
		if vim.fn.argc() == 0 then
			pcall(function() vim.cmd("Neotree show") end)
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
	end,
})
