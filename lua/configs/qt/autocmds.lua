local M = {}

function M.setup()
	-- QML filetype detection (redundant but explicit)
	vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
		pattern = '*.qml',
		callback = function()
			vim.bo.filetype = 'qml'
		end,
	})

	-- qrc as XML with conceal
	vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
		pattern = '*.qrc',
		callback = function()
			vim.bo.filetype = 'xml'
			vim.bo.conceallevel = 2
		end,
	})

	-- Auto-detect compile_commands.json and set a buffer var
	vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
		pattern = { '*.c', '*.cpp', '*.h', '*.hpp', '*.qml' },
		callback = function()
			local cwd = vim.fn.getcwd()
			-- findfile searches upward when using ** patterns; use findfile in path list
			local compile_db = vim.fn.findfile('compile_commands.json', cwd .. ';')
			if compile_db and compile_db ~= '' then
				vim.b.compile_commands = compile_db
			end
		end,
	})

	-- Platform-specific hints and env flags
	if os.getenv('ANDROID_NDK_HOME') or os.getenv('ANDROID_NDK_ROOT') then
		vim.g.qt_has_android_ndk = true
	else
		vim.g.qt_has_android_ndk = false
	end

	-- Expose quick command to set QT root
	vim.api.nvim_create_user_command('QtSetRoot', function(opts)
		if opts.args and opts.args ~= '' then
			vim.g.qt_root = opts.args
			vim.notify('QT_ROOT set to ' .. opts.args, vim.log.levels.INFO)
		else
			vim.notify('Usage: :QtSetRoot /path/to/Qt', vim.log.levels.WARN)
		end
	end, { nargs = '?' })

	-- Optional: command to show current Qt info
	vim.api.nvim_create_user_command('QtInfo', function()
		local qt_root = vim.g.qt_root or os.getenv('QT_ROOT') or 'not set'
		local ndk = os.getenv('ANDROID_NDK_HOME') or os.getenv('ANDROID_NDK_ROOT') or 'not set'
		vim.print({ QT_ROOT = qt_root, ANDROID_NDK = ndk, platform = vim.loop.os_uname().sysname })
	end, {})
end

return M

