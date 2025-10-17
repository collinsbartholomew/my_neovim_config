local M = {}

function M.setup()
	local ok_parsers, parsers = pcall(require, 'nvim-treesitter.parsers')
	if not ok_parsers then
		return
	end

	-- Ensure qmljs parser is available (community parser name commonly 'qmljs' or 'qml')
	local parser_names = parsers.available_parsers() or {}
	local needs = {}
	if not vim.tbl_contains(parser_names, 'qmljs') and not vim.tbl_contains(parser_names, 'qml') then
		table.insert(needs, 'qmljs')
	end

	if #needs > 0 then
		local ok_inst, install = pcall(require, 'nvim-treesitter.install')
		if ok_inst and install and install.run then
			-- attempt to install missing parsers
			pcall(function()
				install.install(needs)
			end)
		end
	end

	-- Additional TS highlighting tweaks for QML can be added here
end

return M

