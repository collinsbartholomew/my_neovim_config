--Core editor options
local opt = vim.opt
-- Basic editor options
opt.number = true -- Show line numbers
opt.relativenumber = true -- Show relative line numbers
opt.clipboard = "unnamedplus" -- Use system clipboard
opt.mouse = "a" -- Enable mouse support in all modes
-- Indentation settings
opt.tabstop = 4 -- Number of spaces that a tab character represents
opt.softtabstop = 4 -- Number of spaces inserted/deleted when using tab/shift+tab
opt.shiftwidth = 4 -- Number of spaces used for autoindent
opt.expandtab = false -- Use actual tabs, not spaces
opt.smartindent = true -- Enable smart autoindenting for new lines
-- Search settings
opt.hlsearch = false -- Don't highlight search results
opt.incsearch = true -- Show search matches as you type
-- Appearance settings
opt.termguicolors = true -- Enable 24-bit RGB color in the terminal
opt.signcolumn = "yes" -- Always show the sign column
opt.wrap = false -- Don't wrap lines
-- Folding settings
opt.foldlevel = 99 -- Open all folds by default
opt.foldlevelstart = 99 -- Start with all folds open
opt.foldenable = true -- Enable folding
-- Backspace behavior
opt.backspace = "indent,eol,start" -- Allow backspacing over indent, end of line, and start of insert
-- Window splitting behavior
opt.splitright = true -- Split windows to the right
opt.splitbelow = true -- Split windows below
-- File handling settings
opt.swapfile = false -- Don't create swap files
opt.backup = false -- Don't create backup files
opt.undodir = vim.fn.expand("~/.vim/undodir") -- Directory for undo files
opt.undofile = true -- Save undo history to a file
-- Assembly-specific options
-- Enable syntax highlighting for assembly files
vim.cmd([[autocmd BufNewFile,BufRead *.asm,*.s,*.S set filetype=asm]])
-- Better display for assembly files
-- Set specific indentation for assembly files
vim.cmd([[autocmd FileType asm setlocal tabstop=4 shiftwidth=4 noexpandtab]])
-- Additional search settings
opt.ignorecase = true -- Ignore case when searching
opt.smartcase = true -- Case-sensitive search if pattern contains uppercase
-- UI settings
opt.cmdheight = 1 -- Set command height to 1 to properly show messages
opt.updatetime = 300 -- Faster completion (4000ms default)
opt.timeoutlen = 300 -- Time to wait for mapped sequence to complete
opt.showtabline = 0 -- Disable tabline completely
opt.pumheight = 10 -- Maximum number of items to show in popup menu
opt.scrolloff = 8 -- Minimum number of lines to keep above and below cursor
opt.sidescrolloff = 8 -- Minimum number of columns to keep left and right of cursor
opt.shortmess:append("c") -- Don't show redundant messages
-- Mojo-specific options
-- Enable syntax highlighting for Mojo files
vim.cmd([[autocmd BufNewFile,BufRead *.mojo,*.🔥 set filetype=mojo]])
-- Better display for Mojo files
-- Set specific indentation for Mojo files
vim.cmd([[autocmd FileType mojo setlocal tabstop=4 shiftwidth=4 expandtab]])
-- Lua-specific options
-- Set specific indentation for Lua files
vim.cmd([[autocmd FileType lua setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab]])
-- XML-like languages (HTML, JSX, TSX, etc.) use 3-character tab indentation
-- Set specific indentation for XML-like languages
vim.cmd([[autocmd FileType html,jsx,tsx,xml,xhtml setlocal tabstop=3 softtabstop=3 shiftwidth=3 expandtab]])
-- PHP-specific options
-- Enable syntax highlighting for PHP files
vim.cmd([[autocmd BufNewFile,BufRead *.php set filetype=php]])
-- Enable syntax highlighting for Blade files
vim.cmd([[autocmd BufNewFile,BufRead *.blade.php set filetype=blade]])
-- Better display for PHP files
-- Set specific indentation for PHP files (PSR-12 compliant)
vim.cmd([[autocmd FileType php setlocal tabstop=4 shiftwidth=4 expandtab]])
-- Better display for Blade files
vim.cmd([[autocmd FileType blade setlocal tabstop=4 shiftwidth=4 expandtab]])
-- Ensure consistent indentation on startup
vim.cmd([[autocmd BufNewFile,BufRead * setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab]])
-- Return empty table to satisfy module requirements
return {}