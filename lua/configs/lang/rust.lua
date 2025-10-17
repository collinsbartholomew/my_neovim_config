local M = {}

function M.setup()
	local ok, rust_tools = pcall(require, 'rust-tools')
	if not ok then
		vim.notify('rust-tools.nvim not available', vim.log.levels.WARN)
		return
	end

	local function find_codelldb()
		local mason_path = vim.fn.stdpath('data') .. '/mason/bin/codelldb'
		if vim.fn.executable(mason_path) == 1 then
			return mason_path
		end
		if vim.fn.executable('codelldb') == 1 then
			return 'codelldb'
		end
		local alt = vim.fn.stdpath('data') .. '/mason/packages/codelldb/extension/adapter/codelldb'
		if vim.fn.executable(alt) == 1 then
			return alt
		end
		return nil
	end

	rust_tools.setup({
		server = {
			on_attach = function(_, _)
				-- Intentionally empty: lsp-unified handles common on_attach keymaps.
			end,
			settings = {
				['rust-analyzer'] = {
					cargo = { allFeatures = true },
					checkOnSave = { command = 'clippy' },
					procMacro = { enable = true },
					diagnostics = { enable = true },
				},
			},
		},
		dap = {
			adapter = (function()
				local codelldb = find_codelldb()
				if codelldb then
					return {
						type = 'server',
						host = '127.0.0.1',
						port = '${port}',
						executable = { command = codelldb, args = { '--port', '${port}' } },
					}
				end
				return nil
			end)(),
		},
		tools = {
			autoSetHints = true,
			inlay_hints = { auto = true, show_parameter_hints = true },
			runnables = { use_telescope = true },
			hover_actions = { auto_focus = true },
		},
	})
end

return M

