---
-- Python keymaps and which-key registration
local M = {}
local wk = require("which-key")

function M.setup()
	wk.add({
		{ "<leader>p", group = "Python" },
		{ "<leader>py", group = "Python" },
		{ "<leader>pyb", "<cmd>PythonRun<cr>", desc = "Run file" },
		{ "<leader>pyt", "<cmd>PythonTest<cr>", desc = "Run tests" },
		{ "<leader>pyc", "<cmd>PythonCoverage<cr>", desc = "Coverage report" },
		{ "<leader>pyf", "<cmd>PythonFormat<cr>", desc = "Format code" },
		{ "<leader>pyl", "<cmd>PythonLint<cr>", desc = "Lint code" },
		{ "<leader>pys", "<cmd>PythonSecurity<cr>", desc = "Security scan" },
		{ "<leader>pym", "<cmd>PythonMemory<cr>", desc = "Memory profile" },
		{ "<leader>pyP", "<cmd>PythonProfile<cr>", desc = "CPU profile" },
		{ "<leader>pyv", "<cmd>PythonVenv<cr>", desc = "Create virtual env" },
		{ "<leader>pyr", "<cmd>PythonRequirements<cr>", desc = "Generate requirements" },
		{ "<leader>pyi", "<cmd>PythonInstall<cr>", desc = "Install requirements" },
		{ "<leader>pya", "<cmd>PythonAudit<cr>", desc = "Audit dependencies" },
		{ "<leader>pyd", "<cmd>PythonDeps<cr>", desc = "Show dependencies" },
	})

	wk.add({
		{ "<leader>t", group = "Test" },
		{ "<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", desc = "Run file tests" },
		{ "<leader>tt", "<cmd>lua require('neotest').run.run()<cr>", desc = "Run nearest test" },
		{ "<leader>to", "<cmd>lua require('neotest').output.open({ enter = true })<cr>", desc = "Show test output" },
		{ "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<cr>", desc = "Toggle test summary" },
		{ "<leader>tc", "<cmd>lua require('neotest').run.run({ strategy = 'dap' })<cr>", desc = "Debug nearest test" },
	})

	wk.add({
		{ "<leader>s", group = "Software Eng." },
		{ "<leader>se", group = "Python" },
		{ "<leader>sec", "<cmd>PythonCoverage<cr>", desc = "Coverage" },
		{ "<leader>ser", "<cmd>PythonFormat<cr>", desc = "Reformat" },
		{ "<leader>set", "<cmd>PythonTest<cr>", desc = "Test" },
		{ "<leader>sel", "<cmd>PythonLint<cr>", desc = "Lint" },
		{ "<leader>ses", "<cmd>PythonSecurity<cr>", desc = "Security scan" },
	})
end
function M.lsp(bufnr)
	wk.add({
		{ "<leader>lh", "<cmd>lua vim.lsp.buf.hover()<cr>", desc = "Hover", buffer = bufnr },
		{ "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename", buffer = bufnr },
		{ "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action", buffer = bufnr },
		{ "<leader>ld", "<cmd>lua vim.diagnostic.open_float()<cr>", desc = "Diagnostics", buffer = bufnr },
		{ "<leader>lf", "<cmd>lua vim.lsp.buf.format({ async = true })<cr>", desc = "Format", buffer = bufnr },
		{ "<leader>lg", "<cmd>lua vim.lsp.buf.definition()<cr>", desc = "Go to Definition", buffer = bufnr },
		{ "<leader>li", "<cmd>lua vim.lsp.buf.implementation()<cr>", desc = "Implementation", buffer = bufnr },
		{ "<leader>ls", "<cmd>lua vim.lsp.buf.document_symbol()<cr>", desc = "Document Symbols", buffer = bufnr },
		{ "<leader>lw", "<cmd>lua vim.lsp.buf.workspace_symbol()<cr>", desc = "Workspace Symbols", buffer = bufnr },
		{ "<leader>lt", "<cmd>lua vim.lsp.codelens.run()<cr>", desc = "Run CodeLens", buffer = bufnr },
	})
end

function M.dap()
	wk.add({
		{ "<leader>d", group = "Debug" },
		{ "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<cr>", desc = "Toggle Breakpoint" },
		{ "<leader>dc", "<cmd>lua require('dap').continue()<cr>", desc = "Continue" },
		{ "<leader>do", "<cmd>lua require('dap').step_over()<cr>", desc = "Step Over" },
		{ "<leader>di", "<cmd>lua require('dap').step_into()<cr>", desc = "Step Into" },
		{ "<leader>dO", "<cmd>lua require('dap').step_out()<cr>", desc = "Step Out" },
		{ "<leader>dr", "<cmd>lua require('dap').repl.open()<cr>", desc = "Open REPL" },
		{ "<leader>du", "<cmd>luarequire('dapui').toggle()<cr>", desc = "Toggle DAP UI" },
		{ "<leader>dq", "<cmd>lua require('dap').terminate()<cr>", desc = "Stop Debugging" },
		{ "<leader>dt", "<cmd>lua require('dap').terminate()<cr>", desc = "Terminate Session" },
		{ "<leader>dp", "<cmd>lua require('dap').pause()<cr>", desc = "Pause Execution" },
		{ "<leader>dw", "<cmd>lua require('dap.ui.widgets').hover()<cr>", desc = "Widget Hover" },
	})
end

return M

