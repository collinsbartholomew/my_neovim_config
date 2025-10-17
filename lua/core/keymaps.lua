--============================================================================
-- ULTIMATE KEYMAP CONFIGURATION
-- ============================================================================
-- Structure: <leader>(package_initial)(functionality_initial)
-- Per-filetype keymaps for language-specific functionality
-- Comprehensive coverage of all plugins, debuggers, linters, and LSPs
-- ============================================================================

local keymap = vim.keymap.set

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================================================
-- CORE NEOVIM KEYMAPS
-- ============================================================================

-- Basic Navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Buffer Management
keymap("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
keymap("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
keymap("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
keymap("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next buffer" })
keymap("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
keymap("n", "<leader>ba", "<cmd>%bd|e#<cr>", { desc = "Delete all buffers (except current)" })

-- Window Management
keymap("n", "<leader>wv", "<C-w>v", { desc = "Vertical split" })
keymap("n", "<leader>wh", "<C-w>s", { desc = "Horizontal split" })
keymap("n", "<leader>we", "<C-w>=", { desc = "Equalize window sizes" })
keymap("n", "<leader>wx", "<cmd>close<cr>", { desc = "Close window" })

-- Quick Actions
keymap("n", "<C-s>", "<cmd>w<cr>", { desc = "Save file" })
keymap("i", "<C-s>", "<Esc><cmd>w<cr>a", { desc = "Save file" })
keymap("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
keymap("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Better indenting
keymap("v", "<", "<gv", { desc = "Decrease indent" })
keymap("v", ">", ">gv", { desc = "Increase indent" })

-- Move lines
keymap("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
keymap("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
keymap("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
keymap("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- ============================================================================
-- TELESCOPE KEYMAPS (T prefix)
-- ============================================================================
-- Telescope keymaps are handled by plugin configuration in configs/telescope.lua

-- ============================================================================
-- NEO-TREE KEYMAPS (N prefix)
-- ============================================================================

-- Handled by plugin configuration

-- ============================================================================
-- LSP KEYMAPS (L prefix)
-- ============================================================================
-- LSP keymaps are now handled by plugin configuration in lsp-unified.lua

-- ============================================================================
-- DIAGNOSTIC KEYMAPS (D prefix)
-- ============================================================================
-- Diagnostic keymaps are now handled by plugin configuration

-- ============================================================================
-- FORMATTING KEYMAPS (F prefix)
-- ============================================================================

keymap({ "n", "v" }, "<leader>f", function()
	local ok, conform = pcall(require, "conform")
	if ok then
		conform.format({ async = true, lsp_fallback = true })
	else
		vim.lsp.buf.format({ async = true })
	end
end, { desc = "Format" })

keymap("n", "<leader>fi", function()
	local ok = pcall(vim.cmd, "ConformInfo")
	if not ok then
		vim.notify("Conform not available", vim.log.levels.WARN)
	end
end, { desc = "Format info" })

-- Language-specific formatters
keymap("n", "<leader>fb", function()
	local ok, conform = pcall(require, "conform")
	if ok then
		conform.format({ formatters = { "biome" }, async = true })
	else
		vim.notify("Conform not available", vim.log.levels.WARN)
	end
end, { desc = "Format with Biome" })

keymap("n", "<leader>fp", function()
	local ok, conform = pcall(require, "conform")
	if ok then
		conform.format({ formatters = { "prettier" }, async = true })
	else
		vim.notify("Conform not available", vim.log.levels.WARN)
	end
end, { desc = "Format with Prettier" })

keymap("n", "<leader>fs", function()
	local ok, conform = pcall(require, "conform")
	if ok then
		conform.format({ formatters = { "stylua" }, async = true })
	else
		vim.notify("Conform not available", vim.log.levels.WARN)
	end
end, { desc = "Format with Stylua" })

keymap("n", "<leader>fr", function()
	local ok, conform = pcall(require, "conform")
	if ok then
		conform.format({ formatters = { "rustfmt" }, async = true })
	else
		vim.notify("Conform not available", vim.log.levels.WARN)
	end
end, { desc = "Format with Rustfmt" })

keymap("n", "<leader>fg", function()
	local ok, conform = pcall(require, "conform")
	if ok then
		conform.format({ formatters = { "gofmt" }, async = true })
	else
		vim.notify("Conform not available", vim.log.levels.WARN)
	end
end, { desc = "Format with Gofmt" })

keymap("n", "<leader>fc", function()
	local ok, conform = pcall(require, "conform")
	if ok then
		conform.format({ formatters = { "clang_format" }, async = true })
	else
		vim.notify("Conform not available", vim.log.levels.WARN)
	end
end, { desc = "Format with Clang" })

keymap("n", "<leader>fq", function()
	local ok, conform = pcall(require, "conform")
	if ok then
		conform.format({ formatters = { "sqlfluff" }, async = true })
	else
		vim.notify("Conform not available", vim.log.levels.WARN)
	end
end, { desc = "Format with SQL" })

-- ============================================================================
-- LINTING KEYMAPS (L prefix + second letter)
-- ============================================================================

keymap("n", "<leader>ll", function()
	local ok, lint = pcall(require, "lint")
	if ok then
		lint.try_lint()
	else
		vim.notify("nvim-lint not available", vim.log.levels.WARN)
	end
end, { desc = "Lint" })

keymap("n", "<leader>li", function()
	local filetype = vim.bo.filetype
	local ok, lint = pcall(require, "lint")
	if not ok then
		vim.notify("nvim-lint not available", vim.log.levels.WARN)
		return
	end

	local linters = lint.linters_by_ft[filetype] or {}
	if #linters == 0 then
		vim.notify("No linters available for " .. filetype, vim.log.levels.INFO)
	else
		vim.notify("Linters for " .. filetype .. ": " .. table.concat(linters, ", "), vim.log.levels.INFO)
	end
end, { desc = "Lint info" })

keymap("n", "<leader>lI", "<cmd>Mason<cr>", { desc = "Lint install (Mason)" })

-- ============================================================================
-- DEBUG KEYMAPS (D prefix + second letter)
-- ============================================================================
-- DAP keymaps are now handled by plugin configurations in dap.lua

-- ============================================================================
-- GIT KEYMAPS (G prefix)
-- ============================================================================
-- Git keymaps are now handled by plugin configurations

-- ============================================================================
-- MASON KEYMAPS (M prefix)
-- ============================================================================
-- Mason keymaps are now handled by plugin configurations

-- ============================================================================
-- TROUBLE KEYMAPS (X prefix)
-- ============================================================================
-- Trouble keymaps are now handled by plugin configurations

-- ============================================================================
-- TERMINAL KEYMAPS (T prefix + second letter)
-- ============================================================================
-- Terminal keymaps are now handled by plugin configurations

-- ============================================================================
-- FLASH NAVIGATION KEYMAPS
-- ============================================================================
-- Flash keymaps are now handled by plugin configurations

-- ============================================================================
-- HARPOON KEYMAPS (H prefix)
-- ============================================================================
-- Harpoon keymaps are now handled by plugin configurations

-- ============================================================================
-- OVERSEER KEYMAPS (O prefix)
-- ============================================================================
-- Overseer keymaps are now handled by plugin configurations

-- ============================================================================
-- TESTING KEYMAPS (T prefix + second letter)
-- ============================================================================
-- Testing keymaps are now handled by plugin configurations

-- ============================================================================
-- REFACTORING KEYMAPS (R prefix)
-- ============================================================================
-- Refactoring keymaps are now handled by plugin configurations

-- ============================================================================
-- SESSION KEYMAPS (Q prefix)
-- ============================================================================
-- Session keymaps are now handled by plugin configurations

-- ============================================================================
-- DATABASE KEYMAPS (D prefix + uppercase)
-- ============================================================================
-- Database keymaps are now handled by plugin configurations in database.lua

-- ============================================================================
-- COLORIZER KEYMAPS (C prefix)
-- ============================================================================
-- Colorizer keymaps are now handled by plugin configurations in colorizer.lua

-- ============================================================================
-- UTILITY & SYSTEM KEYMAPS
-- ============================================================================

-- Theme switching (using different key to avoid conflict with Telescope help)
keymap("n", "<leader>tt", function()
	local ok, err
	if _G.current_theme == "rose-pine" then
		ok, err = pcall(vim.cmd, "colorscheme tokyonight")
		if ok then
			_G.current_theme = "tokyonight"
			vim.notify("Switched to Tokyo Night", vim.log.levels.INFO)
		else
			vim.notify("Failed to load Tokyo Night:" .. tostring(err), vim.log.levels.ERROR)
		end
	else
		ok, err = pcall(vim.cmd, "colorscheme rose-pine")
		if ok then
			_G.current_theme = "rose-pine"
			vim.notify("Switched to Rose Pine", vim.log.levels.INFO)
		else
			vim.notify("Failed to load Rose Pine: " .. tostring(err), vim.log.levels.ERROR)
		end
	end
end, { desc = "Theme toggle" })

-- Tab visualization
keymap("n", "<leader>tT", function()
	vim.opt.list = not vim.opt.list:get()
end, { desc = "Tab toggle" })

-- Plugin management
keymap("n", "<leader>ur", "<cmd>Lazy reload<cr>", { desc = "Utility reload" })
keymap("n", "<leader>uc", "<cmd>Lazy clean<cr>", { desc = "Utility clean" })
keymap("n", "<leader>us", "<cmd>Lazy sync<cr>", { desc = "Utility sync" })
keymap("n", "<leader>up", "<cmd>Lazy profile<cr>", { desc = "Utility profile" })

-- Quick actions
keymap("n", "<leader>q", "<cmd>qa<cr>", { desc = "Quit all" })

-- Toggle noice UI elements
keymap("n", "<leader>un", function()
	local ok, noice = pcall(require, "noice")
	if ok then
		noice.cmd("dismiss")
	else
		vim.notify("Noice not available", vim.log.levels.WARN)
	end
end, { desc = "Dismiss notifications" })

-- Toggle UI elements
keymap("n", "<leader>uC", function()
	local ok, colorizer = pcall(require, "colorizer")
	if ok then
		vim.cmd("ColorizerToggle")
	else
		vim.notify("Colorizer not available", vim.log.levels.WARN)
	end
end, { desc = "Toggle colorizer" })

keymap("n", "<leader>uf", function()
	local ok, flash = pcall(require, "flash")
	if ok then
		flash.toggle()
	else
		vim.notify("Flash not available", vim.log.levels.WARN)
	end
end, { desc = "Toggle flash" })

-- ============================================================================
-- LANGUAGE-SPECIFIC KEYMAPS (Per-filetype)
-- ============================================================================

-- Go-specific keymaps
vim.api.nvim_create_autocmd("FileType", {
	pattern = "go",
	callback = function()
		keymap("n", "<leader>gte", "<cmd>GoTestExplorer<cr>", { desc = "Go test explorer", buffer = true })
		keymap("n", "<leader>gtf", "<cmd>GoTestFunc<cr>", { desc = "Go test function", buffer = true })
		keymap("n", "<leader>gtp", "<cmd>GoTestPkg<cr>", { desc = "Go test package", buffer = true })
		keymap("n", "<leader>gta", "<cmd>GoTestAll<cr>", { desc = "Go test all", buffer = true })
		keymap("n", "<leader>gat", "<cmd>GoAddTag<cr>", { desc = "Go add tags", buffer = true })
		keymap("n", "<leader>grt", "<cmd>GoRmTag<cr>", { desc = "Go remove tags", buffer = true })
		keymap("n", "<leader>gif", "<cmd>GoIfErr<cr>", { desc = "Go if err", buffer = true })
		keymap("n", "<leader>gfs", "<cmd>GoFillStruct<cr>", { desc = "Go fill struct", buffer = true })
	end,
})

-- Rust-specific keymaps
vim.api.nvim_create_autocmd("FileType", {
	pattern = "rust",
	callback = function()
		keymap("n", "<leader>rr", "<cmd>RustRun<cr>", { desc = "Rust run", buffer = true })
		keymap("n", "<leader>rt", "<cmd>RustTest<cr>", { desc = "Rust test", buffer = true })
		keymap("n", "<leader>rb", "<cmd>RustBuild<cr>", { desc = "Rust build", buffer = true })
		keymap("n", "<leader>rc", "<cmd>RustCheck<cr>", { desc = "Rust check", buffer = true })
		keymap("n", "<leader>rd", "<cmd>RustDoc<cr>", { desc = "Rust doc", buffer = true })
	end,
})

-- Python-specific keymaps
vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		keymap("n", "<leader>pr", "<cmd>!python %<cr>", { desc = "Python run", buffer = true })
		keymap("n", "<leader>pt", "<cmd>!python -m pytest<cr>", { desc = "Python test", buffer = true })
		keymap("n", "<leader>pi", "<cmd>!python -m pip install -r requirements.txt<cr>", { desc = "Python install", buffer = true })
	end,
})

-- JavaScript/TypeScript-specific keymaps
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
	callback = function()
		keymap("n", "<leader>jr", "<cmd>!node %<cr>", { desc = "JS run", buffer = true })
		keymap("n", "<leader>jt", "<cmd>!npm test<cr>", { desc = "JS test", buffer = true })
		keymap("n", "<leader>ji", "<cmd>!npm install<cr>", { desc = "JS install", buffer = true })
		keymap("n", "<leader>jb", "<cmd>!npm run build<cr>", { desc = "JS build", buffer = true })
		keymap("n", "<leader>jd", "<cmd>!npm run dev<cr>", { desc = "JS dev", buffer = true })
	end,
})

-- C/C++-specific keymaps
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp", "h", "hpp" },
	callback = function()
		keymap("n", "<leader>cb", "<cmd>!make<cr>", { desc = "C build", buffer = true })
		keymap("n", "<leader>cr", "<cmd>!make run<cr>", { desc = "C run", buffer = true })
		keymap("n", "<leader>cc", "<cmd>!make clean<cr>", { desc = "C clean", buffer = true })
		keymap("n", "<leader>ct", "<cmd>!make test<cr>", { desc = "C test", buffer = true })
	end,
})

-- Java-specific keymaps
vim.api.nvim_create_autocmd("FileType", {
	pattern = "java",
	callback = function()
		keymap("n", "<leader>jc", "<cmd>!javac %<cr>", { desc = "Java compile", buffer = true })
		keymap("n", "<leader>jr", "<cmd>!java %:r<cr>", { desc = "Java run", buffer = true })
		keymap("n", "<leader>jt", "<cmd>!mvn test<cr>", { desc = "Java test", buffer = true })
		keymap("n", "<leader>jb", "<cmd>!mvn compile<cr>", { desc = "Java build", buffer = true })
	end,
})

-- Dart/Flutter-specific keymaps
vim.api.nvim_create_autocmd("FileType", {
	pattern = "dart",
	callback = function()
		keymap("n", "<leader>fr", "<cmd>FlutterRun<cr>", { desc = "Flutter run", buffer = true })
		keymap("n", "<leader>fh", "<cmd>FlutterHotReload<cr>", { desc = "Flutter hot reload", buffer = true })
		keymap("n", "<leader>fR", "<cmd>FlutterHotRestart<cr>", { desc = "Flutter restart", buffer = true })
		keymap("n", "<leader>fq", "<cmd>FlutterQuit<cr>", { desc = "Flutter quit", buffer = true })
		keymap("n", "<leader>fd", "<cmd>FlutterDevices<cr>", { desc = "Flutter devices", buffer = true })
	end,
})

-- Assembly-specific keymaps
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "asm", "nasm", "gas", "s", "S" },
	callback = function()
		keymap("n", "<leader>ab", "<cmd>!nasm -f elf64 % -o %:r.o && ld %:r.o -o %:r<cr>", { desc = "Assembly build", buffer = true })
		keymap("n", "<leader>ar", "<cmd>!./%:r<cr>", { desc = "Assembly run", buffer = true })
		keymap("n", "<leader>ad", "<cmd>!objdump -d %:r<cr>", { desc = "Assembly disassemble", buffer = true })
	end,
})

-- SQL-specific keymaps
vim.api.nvim_create_autocmd("FileType", {
	pattern = "sql",
	callback = function()
		keymap("n", "<leader>se", "<cmd>SqlsExecuteQuery<cr>", { desc = "SQL execute", buffer = true })
		keymap("n", "<leader>ss", "<cmd>SqlsShowSchemas<cr>", { desc = "SQL schemas", buffer = true })
		keymap("n", "<leader>st", "<cmd>SqlsShowTables<cr>", { desc = "SQL tables", buffer = true })
	end,
})

-- Hyprland-specific keymaps
vim.api.nvim_create_autocmd("FileType", {
	pattern = "hyprlang",
	callback = function()
		keymap("n", "<leader>hr", "<cmd>!hyprctl reload<cr>", { desc = "Hyprland reload", buffer = true })
		keymap("n", "<leader>hk", "<cmd>!hyprctl kill<cr>", { desc = "Hyprland kill", buffer = true })
		keymap("n", "<leader>hi", "<cmd>!hyprctl info<cr>", { desc = "Hyprland info", buffer = true })
	end,
})

-- Convenience: Organize imports (alias)
keymap("n", "<leader>co", function()
    pcall(function()
        vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
    end)
end, { desc = "Organize imports" })

-- Convenience: Debug Continue (alias to dap.continue)
keymap("n", "<leader>cd", function()
    local ok, dap = pcall(require, 'dap')
    if ok then
        pcall(dap.continue)
    else
        vim.notify('DAP not available', vim.log.levels.WARN)
    end
end, { desc = "Debug: Continue" })

-- Toggle format-on-save
keymap('n', '<leader>ft', function()
    _G.format_on_save = not (_G.format_on_save == true)
    vim.notify('Format on save ' .. ( _G.format_on_save and 'enabled' or 'disabled'))
end, { desc = 'Toggle format on save' })

-- ============================================================================
-- WHICH-KEY INTEGRATION
-- ============================================================================

-- Register which-key groups if available
local ok, which_key = pcall(require, "which-key")
if ok then
	which_key.register({
		["<leader>t"] = { name = "Telescope" },
		["<leader>tg"] = { name = "Git" },
		["<leader>T"] = { name = "Terminal" },
		["<leader>x"] = { name = "Trouble" },
		["<leader>n"] = { name = "Neo-tree" },
		["<leader>nl"] = { name = "nvim-lint" },
		["<leader>l"] = { name = "LSP" },
		["<leader>lw"] = { name = "Workspace" },
		["<leader>lc"] = { name = "Code Lens" },
		["<leader>d"] = { name = "Debug/Diagnostics" },
		["<leader>f"] = { name = "Format" },
		["<leader>g"] = { name = "Git" },
		["<leader>m"] = { name = "Mason" },
		["<leader>h"] = { name = "Harpoon" },
		["<leader>o"] = { name = "Overseer" },
		["<leader>r"] = { name = "Refactor" },
		["<leader>q"] = { name = "Session" },
		["<leader>D"] = { name = "Database" },
		["<leader>c"] = { name = "Colorizer" },
		["<leader>u"] = { name = "Utility" },
	})
end

-- ============================================================================
-- KEYMAP INFO COMMAND
-- ============================================================================

vim.api.nvim_create_user_command("KeymapInfo", function()
	print("=== Ultimate Keymap Configuration ===")
	print("Structure: <leader>(package_initial)(functionality_initial)")
	print("Leader key: <Space>")
	print("")
	print("Main prefixes:")
	print("  T - Telescope (fuzzy finding)")
	print("  N - Neo-tree (file explorer)")
	print("  L - LSP (language server)")
	print("  D - Debug/Diagnostics")
	print("  F - Formatting")
	print("  G - Git operations")
	print("  M - Mason (package manager)")
	print("  X - Trouble (diagnostics panel)")
	print("  H - Harpoon (quick files)")
	print("  O - Overseer (task runner)")
	print("  R - Refactoring")
	print("  Q - Session management")
	print("")
	print("Use :Telescope keymaps to search all keymaps")
end, {})

return {}