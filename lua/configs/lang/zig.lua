local M = {}

function M.setup()
	-- Minimal Zig language support setup.
	-- LSP server configuration is handled by `configs.lsp-unified` using the `servers` table
	-- (we added `zls` there). This module adds helpful keymaps and checks for tools.

	-- Keymaps for common Zig operations if `zig` is installed
	if vim.fn.executable('zig') == 1 then
		-- Build (works in projects that use `zig build`)
		vim.keymap.set('n', '<leader>zb', function()
			vim.cmd('silent! write')
			vim.cmd('split | terminal zig build')
		end, { desc = 'Zig: build' })

		-- Run (zig run <file> for small scripts)
		vim.keymap.set('n', '<leader>zr', function()
			local fname = vim.fn.expand('%:p')
			if fname == '' then
				vim.notify('No file to run', vim.log.levels.WARN)
				return
			end
			vim.cmd('silent! write')
			vim.cmd('split | terminal zig run ' .. vim.fn.shellescape(fname))
		end, { desc = 'Zig: run current file' })

		-- Format with zig fmt via Conform (if conform available) or fallback to external command
		local ok_conform, conform = pcall(require, 'conform')
		if ok_conform then
			vim.keymap.set('n', '<leader>zf', function()
				conform.format({ formatters = { 'zigfmt' }, async = true })
			end, { desc = 'Zig: format with zig fmt' })
		else
			vim.keymap.set('n', '<leader>zf', function()
				vim.cmd('silent! write')
				vim.cmd('!zig fmt %')
			end, { desc = 'Zig: format with zig fmt (fallback)' })
		end
	else
		vim.notify('Zig toolchain not found (zig). Install to enable build/format keymaps.', vim.log.levels.INFO)
	end

	-- Optional: ensure Treesitter parser for zig will be installed by treesitter config
	-- LSP attachment and advanced config is handled by `configs.lsp-unified` using servers.lua
end

return M

