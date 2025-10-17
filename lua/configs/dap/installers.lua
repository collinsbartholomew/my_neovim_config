-- Helpers to ensure DAP adapters are installed via Mason
local ok_registry, mason_registry = pcall(require, 'mason-registry')
if ok_registry then
	local adapters = {
		'js-debug-adapter',
		'codelldb',
		'cpptools',
		'debugpy',
		'bash-debug-adapter',
		'delve',
		'java-debug-adapter',
		'netcoredbg',
	}
	for _, adapter in ipairs(adapters) do
		if not mason_registry.is_installed(adapter) then
			vim.cmd('MasonInstall ' .. adapter)
		end
	end
else
	vim.notify('Mason registry not available for DAP adapter installation', vim.log.levels.WARN)
end

-- Ensure js-debug-adapter payload exists
local js_debug_path = vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js'
if vim.fn.filereadable(js_debug_path) ~= 1 then
	vim.notify('js-debug-adapter not found. Installing via Mason...', vim.log.levels.WARN)
	vim.cmd('MasonInstall js-debug-adapter')
end

return {}
