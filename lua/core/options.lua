local o = vim.opt

-- Performance optimizations
o.lazyredraw = false -- Don't redraw during macros
o.synmaxcol = 300 -- Limit syntax highlighting for long lines
o.updatetime = 50 -- Faster completion and diagnostics
o.timeoutlen = 300 -- Faster key sequence timeout
o.ttimeoutlen = 0 -- No delay for key codes
o.redrawtime = 1500 -- More time for syntax highlighting

-- UI settings
o.termguicolors = true
o.number = true
o.relativenumber = true
o.signcolumn = "yes:1"
o.cursorline = true
o.wrap = false
o.scrolloff = 8
o.sidescrolloff = 8
o.scrolljump = 1
o.cmdheight = 0 -- Set to 0 since we'll use noice for command line
o.laststatus = 3
o.showcmd = true
o.showmode = false
o.pumheight = 15 -- Limit popup menu height

-- Font settings
vim.o.guifont = "JetBrains Mono Nerd Font:h12"
vim.g.neovide_font_family = "JetBrains Mono Nerd Font"
vim.g.neovide_font_size = 12

-- Indentation (pure tabs with 4-space width)
o.tabstop = 4
o.shiftwidth = 4
o.expandtab = false
o.smartindent = true
o.breakindent = true
o.softtabstop = 0
o.listchars = "tab:│ ,trail:·,extends:>,precedes:<"
o.list = true

-- File handling
o.swapfile = false
o.backup = false
o.undofile = true
o.undodir = vim.fn.stdpath("state") .. "/undo"
o.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"

-- Search and completion
o.ignorecase = true
o.smartcase = true
o.incsearch = true
o.hlsearch = false
o.completeopt = "menu,menuone,noselect"

-- Clipboard
o.clipboard = "unnamedplus"

-- Cursor and visual
o.guicursor = "n-v-c-sm:block,i-ci-ve:block,r-cr-o:hor20"
o.mouse = "a"
o.splitright = true
o.splitbelow = true

-- Folding (updated syntax)
o.foldmethod = "expr"
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
o.foldenable = false
o.foldlevel = 99
o.foldlevelstart = 99

-- Wayland clipboard optimization
if vim.fn.executable("wl-copy") == 1 then
	vim.g.clipboard = {
		name = "wl-clipboard",
		copy = {
			["+"] = { "wl-copy", "--foreground", "--type", "text/plain" },
			["*"] = { "wl-copy", "--foreground", "--type", "text/plain" },
		},
		paste = {
			["+"] = { "wl-paste", "--no-newline" },
			["*"] = { "wl-paste", "--no-newline" },
		},
		cache_enabled = true,
	}
end