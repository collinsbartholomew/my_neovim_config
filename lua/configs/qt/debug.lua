local M = {}
local utils = require('configs.qt.utils')

function M.setup()
	local ok, dap = pcall(require, 'dap')
	if not ok then
		return
	end

	-- Ensure codelldb adapter is defined (only if not already configured by core dap)
	if not dap.adapters.codelldb then
		local codelldb = utils.find_codelldb()
		if codelldb then
			dap.adapters.codelldb = {
				type = 'server',
				port = '${port}',
				executable = {
					command = codelldb,
					args = { '--port', '${port}' },
				},
			}
		end
	end

	-- A helper to show actionable instructions for pretty-printers
	vim.api.nvim_create_user_command('QtDAPInstallPrinters', function()
		local msg = [[
Qt pretty-printers installation hints:
- For gdb: install libstdc++ pretty printers and add 'set auto-load safe-path /' to ~/.gdbinit
- For lldb/codelldb: ensure lldb Python support is available and consider adding Qt pretty-printers via scripts.
- You can also enable pretty-printers in DAP sessions by adding 'setupCommands' in dap.configurations (gdb) or using adapter-specific init.
See core configs/dap.lua for where adapters are configured.
]]
		vim.notify(msg, vim.log.levels.INFO)
	end, {})

	-- Android attach helper (non-destructive hint)
	vim.api.nvim_create_user_command('QtAndroidAttachHelp', function()
		local msg = [[
To attach to an Android process:
1) Build with NDK and gdbserver/lldb-server on device.
2) Push binary and start lldb-server on device: lldb-server platform --server
3) Forward port: adb forward tcp:12345 tcp:12345
4) Use DAP attach configuration (set port and host).
This command prints a skeletal recipe only; adapt to your project.
]]
		vim.notify(msg, vim.log.levels.INFO)
	end, {})

	-- Optionally, auto-add a small listener to prompt user to install printers when debug starts
	dap.listeners.after.event_initialized['qt_pretty_printer_hint'] = function()
		if vim.g.qt_dap_printers_hint_shown then
			return
		end
		vim.notify('Qt debug session started — run :QtDAPInstallPrinters for pretty-printer hints', vim.log.levels.INFO)
		vim.g.qt_dap_printers_hint_shown = true
	end
end

return M
