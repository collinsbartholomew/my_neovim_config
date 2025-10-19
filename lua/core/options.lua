local M = {}

function M.setup()
	-- Get vim options reference
	local opt = vim.opt
	local g = vim.g

	-- Editor UI basics
	opt.termguicolors = true
	opt.showmode = false
	opt.number = true
	opt.relativenumber = true
	opt.signcolumn = "yes:1"
	opt.cursorline = true
	opt.cmdheight = 1
	opt.pumheight = 10
	opt.laststatus = 3
	opt.showtabline = 0 -- Hide the tab line completely
	opt.title = true
	opt.titlestring = "%<%F%=%l/%L - nvim"

	-- Window and UI transparency settings
	opt.winblend = 0
	opt.pumblend = 0
	opt.conceallevel = 2
	opt.list = true
	opt.listchars:append({
		tab = "→ ",
		trail = "·",
		extends = "⟩",
		precedes = "⟨",
		nbsp = "␣",
	})

	-- Fix fillchars with proper string lengths
	opt.fillchars:append({
		eob = " ",
		fold = " ",
		foldopen = "󰅀",
		foldclose = "󰅂",
		foldsep = "│",
		diff = "╱",
		msgsep = "‾",
		horiz = "━",
		horizup = "┻",
		horizdown = "┳",
		vert = "┃",
		vertleft = "┫",
		vertright = "┣",
		verthoriz = "╋",
	})

	-- Behavior
	opt.hidden = true
	opt.splitbelow = true
	opt.splitright = true
	opt.wrap = false
	opt.scrolloff = 8
	opt.sidescrolloff = 8
	opt.mouse = "a"
	opt.mousemoveevent = true
	opt.clipboard = "unnamedplus"
	opt.virtualedit = "block"
	opt.formatoptions = "jcroqlnt"

	-- Indentation
	opt.expandtab = false -- Use tabs instead of spaces
	opt.shiftwidth = 4 -- Number of spaces for autoindent
	opt.tabstop = 4 -- Width of tab character
	opt.softtabstop = 4 -- Number of spaces for a tab in insert mode
	opt.smartindent = true
	opt.autoindent = true
	opt.breakindent = true
	opt.showbreak = "↳ "

	-- Enhanced filetype detection
	vim.filetype.add({
		extension = {
			jsx = "javascriptreact",
			tsx = "typescriptreact",
			ejs = "html",
		},
	})

	-- Set up filetype-specific indentation
	vim.api.nvim_create_autocmd("FileType", {
		pattern = {
			"javascript", "typescript",
			"javascriptreact", "typescriptreact",
			"jsx", "tsx", "ejs",
			"html", "xhtml", "xml", "svg",
			"css", "scss", "sass", "less",
			"vue", "svelte",
		},
		callback = function()
			local bo = vim.bo
			bo.expandtab = false -- Use tabs
			bo.shiftwidth = 4 -- Indent width
			bo.tabstop = 4 -- Tab width
			bo.softtabstop = 4 -- Soft tab width
			bo.autoindent = true
			bo.smartindent = true

			-- Ensure proper indentation for JSX/TSX
			if bo.filetype:match("jsx$") or bo.filetype:match("tsx$") then
				vim.cmd[[setlocal indentkeys+=0]]
			end
		end,
	})

	-- Set up format-on-save for these filetypes
	vim.api.nvim_create_autocmd("BufWritePre", {
		pattern = {
			"*.js", "*.jsx", "*.ts", "*.tsx",
			"*.html", "*.xml", "*.css", "*.scss",
			"*.vue", "*.svelte",
		},
		callback = function()
			vim.lsp.buf.format({ async = false })
		end,
	})

	-- Search
	opt.ignorecase = true
	opt.smartcase = true
	opt.incsearch = true
	opt.hlsearch = true

	-- Better completion experience
	opt.completeopt = { "menuone", "noselect", "noinsert" }
	opt.shortmess:append({
		W = true,
		I = true,
		c = true,
		C = true,
	})

	-- Performance
	opt.redrawtime = 1500
	opt.timeoutlen = 250
	opt.updatetime = 250
	opt.backup = false
	opt.writebackup = false
	opt.undofile = true
	opt.swapfile = false
	opt.history = 100

	-- Better buffer splitting
	opt.splitkeep = "screen"

	-- Folding
	opt.foldlevel = 99
	opt.foldlevelstart = 99
	opt.foldenable = true
	opt.foldcolumn = "1"
	opt.foldmethod = "expr"
	opt.foldexpr = "nvim_treesitter#foldexpr()"

	-- File encoding
	opt.fileencoding = "utf-8"
	opt.fileformats = "unix,dos,mac"

	-- Wild menu and completion
	opt.wildmode = "longest:full,full"
	opt.wildoptions = "pum"
	opt.wildignore:append({
		"*.pyc",
		"*.o",
		"*.obj",
		"*.svn",
		"*.swp",
		"*.class",
		"*.hg",
		"*.DS_Store",
		"*.min.*",
		"node_modules",
		".git",
	})

	-- Diagnostics signs
	local signs = {
		Error = " ",
		Warn = " ",
		Hint = " ",
		Info = " ",
	}
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
	end

	-- Global variables
	g.loaded_perl_provider = 0
	g.loaded_ruby_provider = 0
	g.loaded_node_provider = 0
	g.loaded_python_provider = 0
	g.loaded_python3_provider = 0

	-- Disable builtin plugins
	local disabled_built_ins = {
		"netrw",
		"netrwPlugin",
		"netrwSettings",
		"netrwFileHandlers",
		"gzip",
		"zip",
		"zipPlugin",
		"tar",
		"tarPlugin",
		"getscript",
		"getscriptPlugin",
		"vimball",
		"vimballPlugin",
		"2html_plugin",
		"logipat",
		"rrhelper",
		"spellfile_plugin",
	}

	for _, plugin in pairs(disabled_built_ins) do
		g["loaded_" .. plugin] = 1
	end

	-- Return success
	return true
end

return M
