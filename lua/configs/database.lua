-- God-Level Database Tools Configuration
local M = {}

-- Database UI setup with enhanced features
function M.setup_dadbod_ui()
	vim.g.db_ui_use_nerd_fonts = 1
	vim.g.db_ui_show_database_icon = 1
	vim.g.db_ui_force_echo_messages = 1
	vim.g.db_ui_win_position = 'left'
	vim.g.db_ui_winwidth = 30
	
	-- Auto-execute queries
	vim.g.db_ui_auto_execute_table_helpers = 1
	
	-- Save location for queries
	vim.g.db_ui_save_location = vim.fn.stdpath('data') .. '/db_ui'
	
	-- Database keymaps are handled in plugins/init.lua
end

-- SQL LSP enhancements for database work
function M.setup_sql_lsp()
	-- Enhanced SQL completion and formatting
	vim.api.nvim_create_autocmd('FileType', {
		pattern = { 'sql', 'mysql', 'plsql', 'postgresql' },
		callback = function()
			-- SQL-specific keymaps
			vim.keymap.set('n', '<leader>se', '<cmd>SqlExecute<cr>', { desc = 'Execute SQL', buffer = true })
			vim.keymap.set('v', '<leader>se', ':SqlExecute<cr>', { desc = 'Execute SQL Selection', buffer = true })
			
			-- Enhanced SQL formatting
			vim.keymap.set('n', '<leader>sf', function()
				require('conform').format({ formatters = { 'sqlfluff' }, async = true })
			end, { desc = 'Format SQL', buffer = true })
			
			-- SQL-specific options
			vim.opt_local.commentstring = '-- %s'
			vim.opt_local.iskeyword:append('@-@')
		end,
	})
end

-- MongoDB support enhancements
function M.setup_mongodb()
	vim.api.nvim_create_autocmd('FileType', {
		pattern = { 'javascript', 'typescript' },
		callback = function()
			-- MongoDB query helpers
			if vim.fn.search('db\\.', 'nw') > 0 or vim.fn.search('collection\\.', 'nw') > 0 then
				vim.keymap.set('n', '<leader>me', function()
					-- Execute MongoDB query in current buffer
					local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
					local query = table.concat(lines, '\\n')
					vim.fn.system('mongosh --eval \"' .. query .. '\"')
				end, { desc = 'Execute MongoDB Query', buffer = true })
			end
		end,
	})
end

-- Prisma enhancements
function M.setup_prisma()
	vim.api.nvim_create_autocmd('FileType', {
		pattern = 'prisma',
		callback = function()
			-- Prisma-specific keymaps
			vim.keymap.set('n', '<leader>pg', '<cmd>!npx prisma generate<cr>', { desc = 'Prisma Generate', buffer = true })
			vim.keymap.set('n', '<leader>pm', '<cmd>!npx prisma migrate dev<cr>', { desc = 'Prisma Migrate', buffer = true })
			vim.keymap.set('n', '<leader>ps', '<cmd>!npx prisma studio<cr>', { desc = 'Prisma Studio', buffer = true })
			vim.keymap.set('n', '<leader>pf', '<cmd>!npx prisma format<cr>', { desc = 'Prisma Format', buffer = true })
		end,
	})
end

-- Initialize all database tools
function M.setup()
	M.setup_dadbod_ui()
	M.setup_sql_lsp()
	M.setup_mongodb()
	M.setup_prisma()
end

return M