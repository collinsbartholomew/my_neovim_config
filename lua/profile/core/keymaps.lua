-- Keymaps and which-key setup
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
  { "<leader>f", group = "Find" },
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
})

-- Buffer
wk.add({
  { "<leader>bb", "<cmd>BufferLinePick<cr>", desc = "Pick buffer" },
  { "<leader>bc", "<cmd>BufferLinePickClose<cr>", desc = "Pick close buffer" },
  { "<leader>bd", "<cmd>bdelete<cr>", desc = "Delete buffer" },
  { "<leader>bn", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
  { "<leader>bp", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
})

-- Debug
wk.add({
  { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
  { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
  { "<leader>di", function() require("dap").step_into() end, desc = "Step into" },
  { "<leader>do", function() require("dap").step_over() end, desc = "Step over" },
  { "<leader>dO", function() require("dap").step_out() end, desc = "Step out" },
  { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
  { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
})

-- Find (Telescope)
wk.add({
  { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
  { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
  { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
  { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
  { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
  { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
  { "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Old files" },
  { "<leader>fr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
  { "<leader>fs", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Symbols" },
})

-- Git
wk.add({
  { "<leader>gb", "<cmd>Gitsigns blame_line<cr>", desc = "Blame line" },
  { "<leader>gc", "<cmd>Git commit<cr>", desc = "Commit" },
  { "<leader>gd", "<cmd>Gitsigns diffthis<cr>", desc = "Diff this" },
  { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
  { "<leader>gl", "<cmd>Git log<cr>", desc = "Log" },
  { "<leader>go", "<cmd>Octo<cr>", desc = "Octo (GH)" },
  { "<leader>gp", "<cmd>Git pull<cr>", desc = "Pull" },
  { "<leader>gP", "<cmd>Git push<cr>", desc = "Push" },
  { "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage hunk" },
})

-- LSP
wk.add({
  { "<leader>la", vim.lsp.buf.code_action, desc = "Code action" },
  { "<leader>ld", vim.lsp.buf.definition, desc = "Definition" },
  { "<leader>lD", vim.lsp.buf.declaration, desc = "Declaration" },
  { "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, desc = "Format" },
  { "<leader>lh", vim.lsp.buf.hover, desc = "Hover" },
  { "<leader>li", vim.lsp.buf.implementation, desc = "Implementation" },
  { "<leader>ll", "<cmd>LspInfo<cr>", desc = "LSP Info" },
  { "<leader>lr", vim.lsp.buf.references, desc = "References" },
  { "<leader>lR", vim.lsp.buf.rename, desc = "Rename" },
  { "<leader>ls", vim.lsp.buf.signature_help, desc = "Signature help" },
  { "<leader>lt", vim.lsp.buf.type_definition, desc = "Type definition" },
  { "<leader>lw", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace symbols" },
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
  { "<leader>pl", function() require("persistence").load() end, desc = "Load session" },
  { "<leader>ps", function() require("persistence").select() end, desc = "Select session" },
  { "<leader>pt", "<cmd>TodoTelescope<cr>", desc = "Todo" },
})

-- Quickfix
wk.add({
  { "<leader>qn", "<cmd>cnext<cr>", desc = "Next" },
  { "<leader>qp", "<cmd>cprev<cr>", desc = "Prev" },
  { "<leader>qo", "<cmd>copen<cr>", desc = "Open" },
  { "<leader>qc", "<cmd>cclose<cr>", desc = "Close" },
})

-- Refactor
wk.add({
  { "<leader>re", "<cmd>lua require('refactoring').refactor('Extract Function')<cr>", desc = "Extract function", mode = "v" },
  { "<leader>rv", "<cmd>lua require('refactoring').refactor('Extract Variable')<cr>", desc = "Extract variable", mode = "v" },
})

-- Search/Replace
wk.add({
  { "<leader>sp", "<cmd>Spectre<cr>", desc = "Project replace" },
  { "<leader>sw", require("spectre").open_visual, desc = "Replace word", mode = "v" },
})

-- Test/Terminal/Toggle
wk.add({
  { "<leader>tf", "<cmd>Neotest summary<cr>", desc = "Test summary" },
  { "<leader>tn", "<cmd>Neotest run<cr>", desc = "Run nearest test" },
  { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
  { "<leader>tu", "<cmd>lua require('nvim-tree.api').tree.toggle()<cr>", desc = "Toggle file tree" },
  { "<leader>tf", "<cmd>lua require('ufo').peekFoldedLinesUnderCursor()<cr>", desc = "Peek fold" },
})

-- UI/Undo
wk.add({
  { "<leader>ut", "<cmd>UndotreeToggle<cr>", desc = "Undo tree" },
  { "<leader>un", "<cmd>Noice<cr>", desc = "Noice history" },
})

-- Trouble/Diagnostics
wk.add({
  { "<leader>xx", "<cmd>TroubleToggle<cr>", desc = "Toggle Trouble" },
  { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace diagnostics" },
  { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document diagnostics" },
  { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix" },
  { "<leader>xl", "<cmd>TroubleToggle loclist<cr>", desc = "Loclist" },
})

-- Other general keymaps
wk.add({
  { "gd", vim.lsp.buf.definition, desc = "Goto Definition" },
  { "gr", vim.lsp.buf.references, desc = "Goto References" },
  { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
  { "K", vim.lsp.buf.hover, desc = "Hover" },
  { "<C-h>", "<cmd>lua require('nvim-navbuddy').open()<cr>", desc = "Navbuddy" },
  { "<leader>/", "<cmd>Comment toggle<cr>", desc = "Comment toggle", mode = { "n", "v" } },
  { "<leader>h", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = "Harpoon menu" },
  { "<leader>a", "<cmd>lua require('harpoon.mark').add_file()<cr>", desc = "Harpoon add" },
})