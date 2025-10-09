local map = vim.keymap.set

-- Telescope mappings for file and text searching
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })

-- Neo-tree file explorer toggle
map("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle file explorer" })

-- Quick quit
map("n", "<leader>q", "<cmd>qa<cr>", { desc = "Quit all" })

-- Buffer management
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Clear search highlighting
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Terminal
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Quick save
map("n", "<C-s>", "<cmd>w<cr>", { desc = "Save file" })
map("i", "<C-s>", "<Esc><cmd>w<cr>a", { desc = "Save file" })

-- Better indenting
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Move lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Toggle tab visualization
map("n", "<leader>tt", function()
	vim.opt.list = not vim.opt.list:get()
end, { desc = "Toggle tab visualization" })

-- Theme switching with error handling
map("n", "<leader>th", function()
	local ok, err
	if _G.current_theme == "rose-pine" then
		ok, err = pcall(vim.cmd, "colorscheme tokyonight")
		if ok then
			_G.current_theme = "tokyonight"
			vim.notify("Switched to Tokyo Night", vim.log.levels.INFO)
		else
			vim.notify("Failed to load Tokyo Night: " .. tostring(err), vim.log.levels.ERROR)
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
end, { desc = "Toggle theme (Rose Pine ⇄ Tokyo Night)" })

-- God-level productivity keymaps
map("n", "<leader>ur", "<cmd>Lazy reload<cr>", { desc = "Reload plugins" })
map("n", "<leader>uc", "<cmd>Lazy clean<cr>", { desc = "Clean plugins" })
map("n", "<leader>us", "<cmd>Lazy sync<cr>", { desc = "Sync plugins" })
map("n", "<leader>up", "<cmd>Lazy profile<cr>", { desc = "Profile plugins" })

-- Enhanced LSP keymaps (global)
map("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "LSP Info" })
map("n", "<leader>lI", "<cmd>LspInstall<cr>", { desc = "LSP Install" })
map("n", "<leader>ls", "<cmd>LspStart<cr>", { desc = "LSP Start" })
map("n", "<leader>lS", "<cmd>LspStop<cr>", { desc = "LSP Stop" })
map("n", "<leader>lr", "<cmd>LspRestart<cr>", { desc = "LSP Restart" })

-- Mason management
map("n", "<leader>m", "<cmd>Mason<cr>", { desc = "Mason" })
map("n", "<leader>mi", "<cmd>MasonInstall<cr>", { desc = "Mason Install" })
map("n", "<leader>mu", "<cmd>MasonUpdate<cr>", { desc = "Mason Update" })
map("n", "<leader>ml", "<cmd>MasonLog<cr>", { desc = "Mason Log" })

-- Structural search with Telescope + Treesitter
map("n", "<leader>ft", "<cmd>Telescope treesitter<cr>", { desc = "Find Treesitter symbols" })
map("n", "<leader>fc", "<cmd>Telescope commands<cr>", { desc = "Find commands" })
map("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Find keymaps" })
map("n", "<leader>fo", "<cmd>Telescope vim_options<cr>", { desc = "Find options" })

-- Enhanced navigation
map("n", "<leader>ju", "<cmd>Telescope jumplist<cr>", { desc = "Jump list" })
map("n", "<leader>jm", "<cmd>Telescope marks<cr>", { desc = "Marks" })
map("n", "<leader>jr", "<cmd>Telescope registers<cr>", { desc = "Registers" })

-- Code actions and refactoring shortcuts
map("n", "<leader>cA", function()
	vim.lsp.buf.code_action({ context = { only = { "source" } } })
end, { desc = "Source actions" })

map("n", "<leader>cR", function()
	vim.lsp.buf.code_action({ context = { only = { "refactor" } } })
end, { desc = "Refactor actions" })

-- Quick fix and location list
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Open quickfix" })
map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Open location list" })
map("n", "[q", "<cmd>cprev<cr>", { desc = "Previous quickfix" })
map("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix" })
map("n", "[l", "<cmd>lprev<cr>", { desc = "Previous location" })
map("n", "]l", "<cmd>lnext<cr>", { desc = "Next location" })

-- React/Next.js development shortcuts
map("n", "<leader>rd", "<cmd>!npm run dev<cr>", { desc = "Start dev server" })
map("n", "<leader>rb", "<cmd>!npm run build<cr>", { desc = "Build project" })
map("n", "<leader>rt", "<cmd>!npm test<cr>", { desc = "Run tests" })



