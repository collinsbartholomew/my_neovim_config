-- Node.js Enhanced Development Support
local M = {}

function M.setup()
	-- Node.js project detection and enhanced configuration
	vim.api.nvim_create_autocmd('BufRead', {
		pattern = { 'package.json', '*.js', '*.ts', '*.mjs', '*.cjs' },
		callback = function()
			local package_json = vim.fn.findfile('package.json', '.;')
			if package_json ~= '' then
				local content = vim.fn.readfile(package_json)
				local package_str = table.concat(content, '\n')

				-- Detect Node.js frameworks
				local frameworks = {
					express = package_str:match('"express"'),
					fastify = package_str:match('"fastify"'),
					nestjs = package_str:match('@nestjs/'),
					nextjs = package_str:match('"next"'),
					nuxt = package_str:match('"nuxt"'),
					electron = package_str:match('"electron"'),
				}

				-- Set Node.js specific settings
				vim.b.is_nodejs_project = true
				vim.opt_local.suffixesadd:append('.js,.ts,.json')

				-- Framework-specific configurations
				for framework, detected in pairs(frameworks) do
					if detected then
						vim.b.nodejs_framework = framework
						vim.notify('Node.js ' .. framework .. ' project detected', vim.log.levels.INFO)
						break
					end
				end
			end
		end,
	})

	-- Enhanced Node.js debugging configuration
	local dap_ok, dap = pcall(require, 'dap')
	if dap_ok then
		dap.configurations.javascript = vim.list_extend(dap.configurations.javascript or {}, {
			{
				type = 'pwa-node',
				request = 'launch',
				name = 'Launch Node.js Program',
				program = '${file}',
				cwd = '${workspaceFolder}',
				env = { NODE_ENV = 'development' },
				sourceMaps = true,
				protocol = 'inspector',
				console = 'integratedTerminal',
			},
			{
				type = 'pwa-node',
				request = 'launch',
				name = 'Launch Express Server',
				program = '${workspaceFolder}/server.js',
				cwd = '${workspaceFolder}',
				env = { NODE_ENV = 'development', PORT = '3000' },
				sourceMaps = true,
				restart = true,
			},
			{
				type = 'pwa-node',
				request = 'attach',
				name = 'Attach to Node.js Process',
				processId = require('dap.utils').pick_process,
				cwd = '${workspaceFolder}',
				sourceMaps = true,
			},
		})
	end

	-- Node.js specific keymaps
	vim.keymap.set('n', '<leader>nr', function()
		vim.cmd('terminal npm run dev')
	end, { desc = 'Node.js run dev' })

	vim.keymap.set('n', '<leader>nt', function()
		vim.cmd('terminal npm test')
	end, { desc = 'Node.js run tests' })

	vim.keymap.set('n', '<leader>ni', function()
		vim.cmd('terminal npm install')
	end, { desc = 'Node.js install dependencies' })
end

return M

