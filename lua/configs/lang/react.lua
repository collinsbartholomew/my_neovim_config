-- React/Next.js Development Configuration
local M = {}

function M.setup()
	-- Disable ESLint LSP for React projects (use Biome instead)
	vim.api.nvim_create_autocmd('FileType', {
		pattern = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
		callback = function()
			-- Check if this is a React/Next.js project
			local package_json = vim.fn.findfile('package.json', '.;')
			if package_json ~= '' then
				local content = vim.fn.readfile(package_json)
				local package_str = table.concat(content, '\n')

				-- If it's a React/Next.js project, prefer Biome
				if package_str:match('"react"') or package_str:match('"next"') then
					-- Disable ESLint diagnostics
					vim.diagnostic.config({
						virtual_text = false,
						signs = false,
						underline = false,
						update_in_insert = false,
					}, vim.api.nvim_get_current_buf())

					-- Stop eslint_d if running
					pcall(vim.fn.system, {"eslint_d", "stop"})

					-- Set up Biome-specific keymaps
					vim.keymap.set('n', '<leader>rf', function()
						require('conform').format({ formatters = { 'biome' }, async = true })
					end, { desc = 'Format with Biome', buffer = true })

					vim.keymap.set('n', '<leader>rl', function()
						vim.cmd('!npx biome lint --apply .')
					end, { desc = 'Lint with Biome', buffer = true })
				end
			end
		end,
	})

	-- Ensure eslint_d doesn't start for JS/TS files (always use Biome)
	vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
		pattern = {'*.js', '*.jsx', '*.ts', '*.tsx'},
		callback = function()
			-- Set buffer-local variable to disable eslint_d
			vim.b.disable_eslint = true
		end
	})

	-- Enhanced React snippets and helpers
	vim.api.nvim_create_autocmd('FileType', {
		pattern = { 'javascriptreact', 'typescriptreact' },
		callback = function()
			-- React-specific settings
			vim.opt_local.iskeyword:append('-')

			-- Quick component creation
			vim.keymap.set('n', '<leader>rc', function()
				local component_name = vim.fn.input('Component name: ')
				if component_name ~= '' then
					local lines = {
						'import React from "react";',
						'',
						'interface ' .. component_name .. 'Props {',
						'  // Add props here',
						'}',
						'',
						'const ' .. component_name .. ': React.FC<' .. component_name .. 'Props> = () => {',
						'  return (',
						'    <div>',
						'      <h1>' .. component_name .. '</h1>',
						'    </div>',
						'  );',
						'};',
						'',
						'export default ' .. component_name .. ';',
					}
					vim.api.nvim_put(lines, 'l', true, true)
				end
			end, { desc = 'Create React component', buffer = true })
		end,
	})
end

return M

