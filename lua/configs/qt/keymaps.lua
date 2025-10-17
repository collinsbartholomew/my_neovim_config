local M = {}
local utils = require('configs.qt.utils')

local function qml_preview()
	local qml = vim.api.nvim_buf_get_name(0)
	if qml == '' then
		vim.notify('No active QML file', vim.log.levels.WARN)
		return
	end
	local qmlscene = utils.find_qmlscene()
	if qmlscene then
		vim.cmd('silent !' .. vim.fn.shellescape(qmlscene) .. ' ' .. vim.fn.shellescape(qml) .. ' &')
		vim.notify('Launching QML preview: ' .. qml, vim.log.levels.INFO)
	else
		vim.notify('qmlscene not found in PATH. Set QT_ROOT or install Qt tools.', vim.log.levels.WARN)
	end
end

function M.setup()
	local keymap = vim.keymap.set

	-- QML-specific buffer-local keymaps
	vim.api.nvim_create_autocmd('FileType', {
		pattern = { 'qml', 'qmljs' },
		callback = function()
			local buf = vim.api.nvim_get_current_buf()
			keymap('n', '<leader>qv', qml_preview, { buffer = buf, desc = 'QML: Preview (qmlscene)' })
			keymap('n', '<leader>ql', function()
				vim.lsp.buf.code_action()
			end, { buffer = buf, desc = 'QML: Code actions (LSP)' })
			keymap('n', '<leader>qf', function()
				local ok, conform = pcall(require, 'conform')
				if ok then
					conform.format({ async = true })
				else
					vim.lsp.buf.format({ async = true })
				end
			end, { buffer = buf, desc = 'QML: Format file' })
			keymap('n', '<leader>qln', function()
				local ok, lint = pcall(require, 'lint')
				if ok then
					lint.try_lint()
				else
					vim.notify('nvim-lint not available', vim.log.levels.WARN)
				end
			end, { buffer = buf, desc = 'QML: Lint file' })

			-- QML navigation helpers
			keymap('n', '<leader>qg', function()
				vim.lsp.buf.definition()
			end, { buffer = buf, desc = 'QML: Go to definition' })
			keymap('n', '<leader>qr', function()
				vim.lsp.buf.references()
			end, { buffer = buf, desc = 'QML: References' })
		end,
	})

	-- C/C++ buffer-local keymaps
	vim.api.nvim_create_autocmd('FileType', {
		pattern = { 'c', 'cpp', 'h', 'hpp', 'objc', 'objcpp' },
		callback = function()
			local buf = vim.api.nvim_get_current_buf()
			keymap('n', '<leader>ci', function()
				vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports', 'source.fixAll' } }, apply = true })
			end, { buffer = buf, desc = 'C/C++: Organize includes / fix-its' })

			keymap('n', '<leader>cf', function()
				local ok, conform = pcall(require, 'conform')
				if ok then
					conform.format({ formatters = { 'clang_format' }, async = true })
				else
					vim.lsp.buf.format({ async = true })
				end
			end, { buffer = buf, desc = 'C/C++: Format (clang-format)' })

			keymap('n', '<leader>cb', '<cmd>!cmake --build build --config Debug<cr>', { buffer = buf, desc = 'C/C++: Build' })
			keymap('n', '<leader>cr', '<cmd>!cmake --build build --config Debug && ./build/<cr>', { buffer = buf, desc = 'C/C++: Run' })

			keymap('n', '<leader>ct', '<cmd>!ctest --output-on-failure -C Debug<cr>', { buffer = buf, desc = 'C/C++: Run tests' })

			keymap('n', '<leader>tf', function()
				local v = not vim.b.qt_format_on_save
				vim.b.qt_format_on_save = v
				vim.notify(('Format on save (buffer): %s'):format(tostring(v)), vim.log.levels.INFO)
			end, { buffer = buf, desc = 'Toggle format on save (buffer)' })

			-- DAP launch a debugging session for current target (delegates to core dap configs)
			keymap('n', '<leader>dd', function()
				local ok, dap = pcall(require, 'dap')
				if ok then
					dap.continue()
				else
					vim.notify('dap not available', vim.log.levels.WARN)
				end
			end, { buffer = buf, desc = 'DAP: Continue/Launch' })
		end,
	})
end

return M

