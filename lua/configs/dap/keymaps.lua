-- DAP keymaps
local ok, dap = pcall(require, 'dap')
if not ok then
	return {}
end

vim.keymap.set('n', '<leader>db', function()
	dap.toggle_breakpoint()
end, { desc = 'Toggle Breakpoint' })
vim.keymap.set('n', '<leader>dc', function()
	dap.continue()
end, { desc = 'Continue' })
vim.keymap.set('n', '<leader>di', function()
	dap.step_into()
end, { desc = 'Step Into' })
vim.keymap.set('n', '<leader>do', function()
	dap.step_over()
end, { desc = 'Step Over' })
vim.keymap.set('n', '<leader>dO', function()
	dap.step_out()
end, { desc = 'Step Out' })
vim.keymap.set('n', '<leader>dr', function()
	dap.repl.open()
end, { desc = 'Open REPL' })
vim.keymap.set('n', '<leader>dl', function()
	dap.run_last()
end, { desc = 'Run Last' })
vim.keymap.set('n', '<leader>dt', function()
	dap.terminate()
end, { desc = 'Terminate' })

-- Enhanced widgets
vim.keymap.set('n', '<leader>dsm', function()
	local widgets = require('dap.ui.widgets')
	widgets.centered_float(widgets.scopes)
end, { desc = 'DAP Memory/Scopes' })

vim.keymap.set('n', '<leader>dsh', function()
	local widgets = require('dap.ui.widgets')
	widgets.hover()
end, { desc = 'DAP Hover' })

vim.keymap.set('n', '<leader>dsp', function()
	local widgets = require('dap.ui.widgets')
	widgets.preview()
end, { desc = 'DAP Preview' })

-- Conditional and log points
vim.keymap.set('n', '<leader>dB', function()
	dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end, { desc = 'Conditional Breakpoint' })

vim.keymap.set('n', '<leader>dL', function()
	dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
end, { desc = 'Log Point' })

return {}
