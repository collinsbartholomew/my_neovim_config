--Keymaps and which-key setup
local wk = require("which-key")

wk.setup({
	preset = "modern",
	win = {
		border = "single",
	},
})

wk.add({
	{ "<leader>b", group = "Buffer" },
	{ "<leader>d", group = "Debug" },
	{"<leader>f", group = "Find" },
	{ "<leader>g", group = "Git" },
	{ "<leader>l", group = "LSP" },
	{ "<leader>o", group = "Overseer/Task" },
	{ "<leader>p", group = "Project/Session" },
	{ "<leader>q", group = "Quickfix" },
	{ "<leader>r", group = "Refactor" },
	{ "<leader>s", group = "Search/Replace" },
	{ "<leader>t", group = "Test/Terminal/Toggle" },
	{ "<leader>u", group = "UI/Undo" },
	{ "<leader>x", group = "Trouble/Diagnostics" },
	{ "<leader>y", group = "UI/Theme" },
})

-- Buffer
wk.add({
	{ "<leader>bb", "<cmd>BufferLinePick<cr>", desc ="Pick buffer" },
	{ "<leader>bc", "<cmd>BufferLinePickClose<cr>", desc = "Pick close buffer" },
	{ "<leader>bd", "<cmd>bdelete<cr>", desc = "Delete buffer" },
	{ "<leader>bn", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
	{ "<leader>bp", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
})

-- Debug
wk.add({
	{
		"<leader>db",
		function()
			require("dap").toggle_breakpoint()
		end,
desc= "Toggle breakpoint",
	},
	{
		"<leader>dc",
		function()
			require("dap").continue()
		end,
		desc = "Continue",
	},
	{
		"<leader>di",
		function()
			require("dap").step_into()
		end,
		desc ="Step into",
	},
	{
		"<leader>do",
		function()
			require("dap").step_over()
		end,
		desc = "Step over",
	},
	{
		"<leader>dO",
		function()
			require("dap").step_out()
		end,
		desc = "Stepout",
},
	{
		"<leader>dr",
		function()
			require("dap").repl.toggle()
		end,
		desc = "Toggle REPL",
	},
	{
		"<leader>du",
		function()
			require("dapui").toggle()
		end,
		desc = "ToggleDAPUI",
	},
})

-- Find (Telescope)
wk.add({
	{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
	{ "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
	{ "<leader>ff","<cmd>Telescope find_files<cr>", desc = "Find files" },
	{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
	{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags"},
	{ "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
	{ "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Old files" },
	{ "<leader>fr", "<cmd>Telescope lsp_references<cr>", desc= "References" },
	{ "<leader>fs", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Symbols" },
})

-- Git
wk.add({
	{ "<leader>gb", "<cmd>Gitsignsblame_line<cr>", desc = "Blame line"},
	{"<leader>gc", "<cmd>Git commit<cr>", desc = "Commit" },
	{ "<leader>gd", "<cmd>Gitsigns diffthis<cr>", desc = "Diff this" },
	{ "<leader>gg", "<cmd>LazyGit<cr>",desc = "LazyGit"},
{ "<leader>gl", "<cmd>Git log<cr>", desc = "Log" },
	{ "<leader>go", "<cmd>Octo<cr>", desc = "Octo (GH)" },
	{ "<leader>gp", "<cmd>Git pull<cr>", desc= "Pull"},
	{ "<leader>gP", "<cmd>Git push<cr>", desc = "Push" },
	{ "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage hunk" },
	{ "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "Open DiffView" },
	{ "<leader>gV", "<cmd>DiffviewClose<cr>", desc = "Close DiffView" },
})

--LSP
wk.add({
	{ "<leader>la", vim.lsp.buf.code_action, desc ="Code action"},
	{ "<leader>ld", vim.lsp.buf.definition, desc = "Definition" },
	{ "<leader>lD", vim.lsp.buf.declaration, desc = "Declaration" },
	{
		"<leader>lf",
		function()
			vim.lsp.buf.format({async = true })
end,
		desc="Format",
	},
	{ "<leader>lh", vim.lsp.buf.hover, desc = "Hover" },
	{ "<leader>li", vim.lsp.buf.implementation, desc = "Implementation" },
	{ "<leader>ll", "<cmd>LspInfo<cr>",desc = "LSPInfo" },
	{ "<leader>lr", vim.lsp.buf.references, desc = "References" },
	{ "<leader>lR", vim.lsp.buf.rename, desc = "Rename" },
	{ "<leader>ls", vim.lsp.buf.signature_help,desc = "Signaturehelp" },
	{"<leader>lt", vim.lsp.buf.type_definition, desc = "Typedefinition" },
	{ "<leader>lw", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace symbols" },
	{ "<leader>lc", vim.lsp.codelens.run,desc = "Run codelens" },
})

-- Overseer/Task
wk.add({
	{ "<leader>ob", "<cmd>OverseerBuild<cr>", desc = "Build" },
	{ "<leader>oi", "<cmd>OverseerInfo<cr>", desc = "Info" },
	{ "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run" },
	{ "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Toggle" },
})

-- Project/Session
wk.add({
	{
		"<leader>pl",
		function()
			local status_ok, persistence = pcall(require, "persistence")
			if status_ok and persistence then
				persistence.load()
			else
				vim.notify("Persistencemodule not available", vim.log.levels.WARN)
			end
		end,
		desc = "Loadsession",
	},
{
		"<leader>ps",
		function()
			local status_ok, persistence = pcall(require, "persistence")
			if status_ok and persistence then
				persistence.select()
				elsevim.notify("Persistence module not available", vim.log.levels.WARN)
			end
		end,
		desc ="Selectsession",
	},
	{ "<leader>pt", "<cmd>TodoTelescope<cr>", desc = "Todo" },
})

-- Quickfix
wk.add({
	{ "<leader>qn", "<cmd>cnext<cr>", desc = "Next" },
	{ "<leader>qp", "<cmd>cprev<cr>", desc ="Prev" },
	{ "<leader>qo", "<cmd>copen<cr>", desc = "Open" },
	{ "<leader>qc", "<cmd>cclose<cr>", desc = "Close" },
})

-- Refactor
wk.add({
{
		"<leader>re",
		"<cmd>lua require('refactoring').refactor('Extract Function')<cr>",
		desc = "Extract function",
		mode = "v",
	},
	{
		"<leader>rf",
		"<cmd>lua require('refactoring').refactor('Extract Function To File')<cr>",
		desc="Extract function to file",
		mode = "v",
	},
	{
		"<leader>rv",
		"<cmd>luarequire('refactoring').refactor('Extract Variable')<cr>",
		desc = "Extract variable",
	mode = "v",
	},
	{
		"<leader>ri",
		"<cmd>lua require('refactoring').refactor('Inline Variable')<cr>",
		desc = "Inline variable",
		mode = "v",
	},
	{
		"<leader>rb",
		"<cmd>lua require('refactoring').refactor('Extract Block')<cr>",
		desc = "Extract block",
		mode = "v",
	},
	{
		"<leader>rp",
		"<cmd>lua require('refactoring').debug.printf({below = false})<cr>",
		desc = "Debugprint",
	},
	{
		"<leader>rc",
"<cmd>lua require('refactoring').debug.cleanup({})<cr>",
		desc = "Debug cleanup",
	},
})

-- Search/Replace
wk.add({
	{ "<leader>sp", "<cmd>Spectre<cr>", desc= "Project replace" },
	{"<leader>sw",require("spectre").open_visual, desc = "Replace word", mode = "v" },
})

-- Structure/Outline
wk.add({
	{ "<leader>s", group = "Structure/Outline" },
	{ "<leader>st", "<cmd>AerialToggle<cr>", desc ="Toggle outline" },
	{ "<leader>sf", "<cmd>AerialNavToggle<cr>", desc = "Navigate symbols" },
})

-- Test/Terminal/Toggle
wk.add({
	{ "<leader>tf", "<cmd>Neotest summary<cr>",desc = "Test summary" },
	{ "<leader>tn","<cmd>Neotest run<cr>", desc = "Run nearest test" },
	{ "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
	{ "<leader>tb", "<cmd>luarequire('profile.ui.toggleterm')._build_toggle()<cr>",desc = "Toggle build terminal" },
	{ "<leader>tr", "<cmd>lua require('profile.ui.toggleterm')._repl_toggle()<cr>", desc = "Toggle REPL terminal" },
	{ "<leader>tu", "<cmd>luarequire('nvim-tree.api').tree.toggle()<cr>",desc = "Toggle file tree" },
	{ "<leader>tp", "<cmd>lua require('ufo').peekFoldedLinesUnderCursor()<cr>", desc = "Peek fold" },
})

-- UI/Undo
wk.add({
	{ "<leader>ut", "<cmd>UndotreeToggle<cr>", desc= "Undotree" },
	{ "<leader>un", "<cmd>Noice<cr>", desc = "Noice history" },
	{ "<leader>uh", "<cmd>Telescope undo<cr>", desc = "Undo history" },
})

-- UI/Theme
wk.add({
	{ "<leader>yt", "<cmd>lua require('profile.ui.theme').toggle()<cr>", desc = "Toggle theme" },
	{ "<leader>yr", "<cmd>lua require('profile.ui.transparency').toggle()<cr>", desc = "Toggletransparency" },
})

--Trouble/Diagnostics
wk.add({
	{ "<leader>xx", "<cmd>TroubleToggle<cr>", desc = "ToggleTrouble" },
	{ "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace diagnostics" },
	{"<leader>xd","<cmd>TroubleToggledocument_diagnostics<cr>", desc = "Document diagnostics" },
	{ "<leader>xq", "<cmd>TroubleTogglequickfix<cr>", desc = "Quickfix" },
	{ "<leader>xl", "<cmd>TroubleToggle loclist<cr>", desc = "Loclist" },
})

--Othergeneralkeymaps
wk.add({
	{ "gd", vim.lsp.buf.definition, desc = "GotoDefinition" },
	{ "gr", vim.lsp.buf.references, desc = "Goto References" },
	{ "gI", vim.lsp.buf.implementation,desc = "Goto Implementation" },
{ "K", vim.lsp.buf.hover, desc = "Hover" },
	{ "<C-h>", "<cmd>lua require('nvim-navbuddy').open()<cr>", desc = "Navbuddy" },
	{
		"<leader>/",
		"<cmd>Comment toggle<cr>",
desc = "Commenttoggle",
		mode = { "n", "v" },
	},
	{ "<leader>h", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = "Harpoon menu" },
	{ "<leader>a","<cmd>lua require('harpoon.mark').add_file()<cr>", desc = "Harpoon add" },
	{ "<leader>S", "<cmd>lua require('flash').jump()<cr>", desc = "Flash jump" },
	{ "<leader>s", "<cmd>lua require('flash').treesitter()<cr>", desc = "Flashtreesitter" },
})

--AddAI group
wk.add({
	{ "<leader>ai", group = "AI" },
	{ "<leader>ait", "<cmd>Copilot toggle<cr>", desc = "Toggle Copilot" },
})

-- Lua development group
wk.add({
	{ "<leader>lu", group = "Lua Development" },
	{ "<leader>lur", desc = "Run Lua file" },
	{ "<leader>lud", desc = "Debug Lua file" },
	{ "<leader>lub", desc = "Reload Lua module" },
	{ "<leader>luc", desc= "Check Lua file" },
})

-- Foldinggroup
wk.add({
	{ "<leader>uf", group = "Folding" },
	{ "<leader>ufo", desc = "Open all folds" },
	{ "<leader>ufc", desc = "Close all folds" },
	{ "<leader>uft", desc = "Enable fold at cursor" },
	{ "<leader>ufn", desc = "Next closed fold" },
	{ "<leader>ufp", desc = "Previous closed fold" },
})

--Addmulti-cursor keymaps
wk.add({
	{ "<C-d>", "<cmd>VM_Find_Under<cr>", desc = "Multi-cursor find under", mode = { "n", "v" } },
	{ "<M-Up>", "<cmd>VM_Add_Cursor_Up<cr>", desc = "Addcursor above", mode ="n" },
	{ "<M-Down>", "<cmd>VM_Add_Cursor_Down<cr>", desc = "Add cursor below", mode = "n" },
})

--Keymaps
local map = vim.keymap.set
localopts = { noremap = true, silent=true }

-- Setleader keyvim.g.mapleader = " "
vim.g.maplocalleader = ""

-- Better window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j",opts)
map("n", "<C-k>","<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
map("n", "<A-Up>", ":resize -2<CR>", opts)
map("n", "<A-Down>",":resize +2<CR>", opts)
map("n", "<A-Left>", ":vertical resize -2<CR>", opts)
map("n", "<A-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
map("n", "<S-l>", ":bnext<CR>",opts)
map("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text up and down
map("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
map("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- Clear search highlights
map("n","<leader>h", ":nohlsearch<CR>", opts)

-- Toggle diagnostics
map("n", "<leader>d", ":lua require('profile.core.functions').toggle_diagnostics()<CR>", opts)

-- Check assembly tools
map("n", "<leader>atc", ":lua require('profile.core.functions').check_asm_tools()<CR>", opts)

-- Quick run for assemblyfiles
map("n", "<leader>arr", ":lua require('profile.core.functions').asm_run()<CR>", opts)

-- Check C++ tools
map("n", "<leader>ctc", ":lua require('profile.core.functions').check_cpp_tools()<CR>", opts)

-- Create C++ class
map("n", "<leader>ccc", ":lua require('profile.core.functions').create_cpp_class()<CR>", opts)

-- Check Rusttools
map("n", "<leader>rtc", ":lua require('profile.core.functions').check_rust_tools()<CR>", opts)

-- Create Rust module
map("n", "<leader>crm", ":lua require('profile.core.functions').create_rust_module()<CR>", opts)

-- Check Zig tools
map("n", "<leader>ztc", ":lua require('profile.core.functions').check_zig_tools()<CR>", opts)

--Create Zig module
map("n", "<leader>czm", ":lua require('profile.core.functions').create_zig_module()<CR>", opts)

-- Luadevelopment
map("n", "<leader>lu", "<cmd>echo 'Lua tools'<CR>", opts)
map("n", "<leader>lur", ":luafile %<CR>", opts) -- Run Lua file
map("n", "<leader>lud", ":lua require('dap').continue()<CR>", opts) -- Debug Lua file
map("n", "<leader>lub", ":lua require('profile.core.functions').reload_lua_module()<CR>", opts) -- Reload Lua module
map("n", "<leader>luc", ":lua require('os').execute('luacheck ' .. vim.fn.expand('%'))<CR>", opts) -- Check Lua file

--Better indenting
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

--Move selected line / block oftext in visual mode
map("x", "J", ":move '>+1<CR>gv-gv", opts)
map("x", "K", ":move '<-2<CR>gv-gv", opts)
map("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
map("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

--Folding keymaps
map("n", "<leader>ufo", ":lua require('ufo').openAllFolds()<CR>", { desc = "Open all folds" })
map("n", "<leader>ufc", ":lua require('ufo').closeAllFolds()<CR>", { desc = "Close all folds" })
map("n", "<leader>uft", ":lua require('ufo').enableFold()<CR>", { desc = "Toggle fold" })
map("n", "<leader>ufn", ":lua require('ufo').goNextClosedFold()<CR>", { desc = "Go to nextclosed fold" })
map("n", "<leader>ufp", ":lua require('ufo').goPreviousClosedFold()<CR>", { desc = "Go to previous closed fold" })
map("n", "zR", ":lua require('ufo').openAllFolds()<CR>", { desc = "Open all folds" })
map("n", "zM", ":lua require('ufo').closeAllFolds()<CR>", { desc = "Close all folds" })
map("n", "zr", ":lua require('ufo').openFoldsExceptKinds()<CR>", { desc = "Open folds except kinds" })
map("n", "zm", ":lua require('ufo').closeFoldsWith()<CR>", { desc = "Close folds with" })
map("n", "zp", ":lua require('ufo').peekFoldedLinesUnderCursor()<CR>", { desc = "Peek folded lines" })

return {}
