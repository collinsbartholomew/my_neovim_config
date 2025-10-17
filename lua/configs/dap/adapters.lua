-- DAP adapters (debug servers/bridges)
local ok, dap = pcall(require, 'dap')
if not ok then
	return {}
end

-- C/C++ via cpptools (GDB)
dap.adapters.cppdbg = {
	id = 'cppdbg',
	type = 'executable',
	command = vim.fn.stdpath('data') .. '/mason/bin/OpenDebugAD7',
}

-- GDB DAP
dap.adapters.gdb = {
	type = 'executable',
	command = 'gdb',
	args = { '-i', 'dap' },
}

-- JavaScript/TypeScript (js-debug)
dap.adapters['pwa-node'] = {
	type = 'server',
	host = 'localhost',
	port = '${port}',
	executable = {
		command = 'node',
		args = { vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js', '${port}' },
	},
}

-- Browser (pwa-chrome) using same js-debug adapter
dap.adapters['pwa-chrome'] = {
	type = 'server',
	host = 'localhost',
	port = '${port}',
	executable = {
		command = 'node',
		args = { vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js', '${port}' },
	},
}

-- Go (delve)
dap.adapters.delve = {
	type = 'server',
	port = '${port}',
	executable = {
		command = 'dlv',
		args = { 'dap', '-l', '127.0.0.1:${port}' },
	},
}

-- codelldb for Rust/C/C++
dap.adapters.codelldb = {
	type = 'server',
	port = '${port}',
	executable = {
		command = vim.fn.stdpath('data') .. '/mason/bin/codelldb',
		args = { '--port', '${port}' },
	},
}

-- Python (debugpy)
dap.adapters.python = {
	type = 'executable',
	command = vim.fn.stdpath('data') .. '/mason/bin/debugpy-adapter',
}

-- Dart/Flutter
dap.adapters.dart = {
	type = 'executable',
	command = 'dart',
	args = { 'debug_adapter' },
}

-- Bash
dap.adapters.bashdb = {
	type = 'executable',
	command = vim.fn.stdpath('data') .. '/mason/packages/bash-debug-adapter/bash-debug-adapter',
	name = 'bashdb',
}

-- .NET
dap.adapters.coreclr = {
	type = 'executable',
	command = vim.fn.stdpath('data') .. '/mason/bin/netcoredbg',
	args = { '--interpreter=vscode' },
}

return {}
