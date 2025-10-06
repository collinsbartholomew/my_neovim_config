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

-- God-level LSP keybindings (safe with nil checks)
map("n", "<leader>lh", function()
	if vim.lsp.inlay_hint and vim.lsp.inlay_hint.enable then
		local bufnr = vim.api.nvim_get_current_buf()
		local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
		vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
		vim.notify("Inlay hints " .. (enabled and "disabled" or "enabled"), vim.log.levels.INFO)
	end
end, { desc = "Toggle inlay hints" })

map("n", "<leader>cl", function()
	if vim.lsp.codelens and vim.lsp.codelens.run then
		vim.lsp.codelens.run()
	end
end, { desc = "Run code lens" })

map("n", "<leader>cr", function()
	if vim.lsp.codelens and vim.lsp.codelens.refresh then
		vim.lsp.codelens.refresh()
	end
end, { desc = "Refresh code lens" })

map("n", "<leader>ci", function()
	if vim.lsp.buf.incoming_calls then
		vim.lsp.buf.incoming_calls()
	end
end, { desc = "Incoming calls" })

map("n", "<leader>co", function()
	if vim.lsp.buf.outgoing_calls then
		vim.lsp.buf.outgoing_calls()
	end
end, { desc = "Outgoing calls" })

map("n", "<leader>st", function()
	if vim.lsp.buf.supertypes then
		vim.lsp.buf.supertypes()
	end
end, { desc = "Supertypes" })

map("n", "<leader>it", function()
	if vim.lsp.buf.subtypes then
		vim.lsp.buf.subtypes()
	end
end, { desc = "Subtypes" })

map("n", "<leader>lr", function()
	if vim.lsp.buf.refresh then
		vim.lsp.buf.refresh()
	end
	if vim.lsp.codelens and vim.lsp.codelens.refresh then
		vim.lsp.codelens.refresh()
	end
	if vim.lsp.inlay_hint and vim.lsp.inlay_hint.enable then
		vim.lsp.inlay_hint.enable(true)
	end
end, { desc = "Refresh all LSP" })

