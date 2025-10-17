-- Helpers for pretty printers (GDB/LLDB) and notifications
local ok, dap = pcall(require, 'dap')
if not ok then
	return {}
end

local function find_gdb_printer()
	local candidates = {
		'/usr/share/gdb/auto-load/usr/lib/*/libstdc++-v6.py',
		'/usr/share/gdb/auto-load/*/libstdc++-v6.py',
		'/usr/share/gdb/auto-load/*/libstdc++.py',
		'/usr/lib/python*/site-packages/libstdcxx/v6/printers.py',
		vim.fn.stdpath('data') .. '/mason/packages/codelldb/extension/lldb/python/libstdcxx-v6.py',
	}
	for _, pat in ipairs(candidates) do
		local glob = vim.fn.glob(pat)
		if glob and glob ~= '' then
			for path in string.gmatch(glob, "[^\n]+") do
				if vim.fn.filereadable(path) == 1 then
					return path
				end
			end
		end
	end
	return nil
end

-- Inject pretty-printer loader into GDB configuration if available
local gdb_printer = find_gdb_printer()
if gdb_printer then
	for _, cfg in ipairs(dap.configurations.c or {}) do
		if cfg.name and cfg.name:match('Launch with GDB') then
			cfg.setupCommands = cfg.setupCommands or {}
			table.insert(cfg.setupCommands, 1, {
				description = 'Auto-load libstdc++ pretty-printers',
				text = "python\ntry:\n    exec(open('" .. gdb_printer .. "').read())\nexcept Exception as e:\n    print('Failed to load libstdc++ pretty-printers:', e)\nend\n",
				ignoreFailures = true,
			})
		end
	end
else
	-- If not found, provide a user command to instruct installation
	vim.api.nvim_create_user_command('InstallLibstdcxxPrinters', function()
		vim.notify('Libstdc++ pretty-printers not found. On Debian/Ubuntu you can install package `libstdc++6-<version>-dbg` or set up GDB pretty-printers from your distro. See https://gcc.gnu.org/onlinedocs/libstdc++/manual/debugging.html', vim.log.levels.INFO)
	end, {})
end

local function find_lldb_printer()
	local candidates = {
		vim.fn.stdpath('data') .. '/mason/packages/codelldb/extension/lldb/scripts/pretty-printers.py',
		vim.fn.stdpath('data') .. '/mason/packages/codelldb/extension/lldb/python/libstdcxx-v6.py',
		'/usr/share/lldb/pretty-printers/libstdcxx.py',
		'/usr/lib/lldb/pretty-printers/libstdcxx.py',
	}
	for _, p in ipairs(candidates) do
		if vim.fn.filereadable(p) == 1 then
			return p
		end
	end
	return nil
end

local lldb_printer = find_lldb_printer()
if lldb_printer then
	-- Notify user once that LLDB pretty-printers are available and how to enable them for codelldb
	vim.api.nvim_create_user_command('QtInstallLLDBPrinters', function()
		vim.notify('LLDB pretty-printers found at: ' .. lldb_printer .. '\nFor codelldb, ensure the adapter loads the printers or add the path to your lldb init. Example (lldbinit):\n  command script import "' .. lldb_printer .. '"', vim.log.levels.INFO)
	end, {})
else
	vim.api.nvim_create_user_command('QtInstallLLDBPrinters', function()
		vim.notify('LLDB pretty-printers not found. If using codelldb, ensure LLDB Python support and look for libstdc++ printers in your distro or in Mason codelldb package.', vim.log.levels.INFO)
	end, {})
end

-- When a debug session starts, remind user how to enable printers (non-intrusive)
if dap and lldb_printer then
	dap.listeners.after.event_initialized['qt_lldb_printer_hint'] = function()
		vim.notify('LLDB pretty-printers detected. Run :QtInstallLLDBPrinters for enable instructions.', vim.log.levels.DEBUG)
	end
end

return {}
