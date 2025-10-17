local M = {}

-- Helpers to find Qt tools (qmlls, qmlformat, qmlscene) and Mason-installed codelldb
local function env_candidates()
	local env = {}
	env.qt_root = vim.g.qt_root or os.getenv('QT_ROOT') or os.getenv('QT_PATH') or os.getenv('QT_DIR') or os.getenv('QT_HOME')
	env.home = os.getenv('HOME') or '~'
	return env
end

function M.find_executable(name)
	if vim.fn.executable(name) == 1 then
		return name
	end
	local e = env_candidates()
	if e.qt_root and e.qt_root ~= '' then
		local cand = e.qt_root .. '/bin/' .. name
		if vim.fn.filereadable(cand) == 1 or vim.fn.executable(cand) == 1 then
			return cand
		end
	end
	-- common locations
	local guesses = {
		e.home .. '/Qt/*/bin/' .. name,
		'/usr/lib/qt*/bin/' .. name,
		'/usr/bin/' .. name,
		'/usr/local/bin/' .. name,
	}
	for _, g in ipairs(guesses) do
		local globbed = vim.fn.glob(g)
		if globbed and globbed ~= '' then
			for p in string.gmatch(globbed, "[^\n]+") do
				if vim.fn.executable(p) == 1 or vim.fn.filereadable(p) == 1 then
					return p
				end
			end
		end
	end
	return nil
end

function M.find_qmlls()
	return M.find_executable('qmlls')
end

function M.find_qmlformat()
	return M.find_executable('qmlformat')
end

function M.find_qmlscene()
	return M.find_executable('qmlscene')
end

-- codelldb path (mason or PATH)
function M.find_codelldb()
	local mason_path = vim.fn.stdpath('data') .. '/mason/bin/codelldb'
	if vim.fn.executable(mason_path) == 1 then
		return mason_path
	end
	if vim.fn.executable('codelldb') == 1 then
		return 'codelldb'
	end
	-- mason newer layout: extension/adapter/codelldb
	local alt = vim.fn.stdpath('data') .. '/mason/packages/codelldb/extension/adapter/codelldb'
	if vim.fn.executable(alt) == 1 then
		return alt
	end
	return nil
end

return M

