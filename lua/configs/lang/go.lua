local M = {}

function M.setup()
	local ok, go = pcall(require, 'go')
	if not ok then
		vim.notify('go.nvim not available', vim.log.levels.WARN)
		return
	end

	go.setup({
		goimport = 'gopls', -- use gopls for imports
		fillstruct = 'gopls',
		test_runner = 'richgo',
		lsp_cfg = true, -- will call lspconfig to setup gopls
		dap_debug = true, -- integrate with delve adapter
		dap_debug_keymap = false, -- we use core dap keymaps
		luasnip = true,
	})

	-- Keymaps
	vim.keymap.set('n', '<leader>gb', function()
		go.build()
	end, { desc = 'Go: build' })
	vim.keymap.set('n', '<leader>gt', function()
		go.test()
	end, { desc = 'Go: test' })
	vim.keymap.set('n', '<leader>gr', function()
		go.run()
	end, { desc = 'Go: run' })
	vim.keymap.set('n', '<leader>gi', function()
		go.add('imports')
	end, { desc = 'Go: organize imports' })

	-- Ensure gopls has recommended settings via lsp-unified (it uses servers.gopls entry)
end

return M

