local M = {}

function M.setup()
	local ok, flutter_tools = pcall(require, "flutter-tools")
	if not ok then
		vim.notify("flutter-tools not available", vim.log.levels.WARN)
		return
	end

	flutter_tools.setup({
		ui = { border = "rounded" },
		decorations = { statusline = { app_version = false, device = true } },
		debugger = { enabled = false },
		flutter_path = nil,
		flutter_lookup_cmd = nil,
		fvm = false,
		widget_guides = { enabled = false },
		closing_tags = { highlight = "ErrorMsg", prefix = "//", enabled = true },
		dev_log = { enabled = true, open_cmd = "tabedit" },
		dev_tools = { autostart = false, auto_open_browser = false },
		outline = { open_cmd = "30vnew", auto_open = false },
		lsp = {
			color = { enabled = false, background = false, foreground = false, virtual_text = true, virtual_text_str = "■" },
			on_attach = nil,
			capabilities = nil,
			settings = {
				showTodos = true,
				completeFunctionCalls = true,
				analysisExcludedFolders = {
					vim.fn.expand("$HOME/AppData/Local/Pub/Cache"),
					vim.fn.expand("$HOME/.pub-cache"),
					vim.fn.expand("/opt/homebrew/"),
					vim.fn.expand("$HOME/tools/flutter/"),
				},
				renameFilesWithClasses = "prompt",
				enableSnippets = true,
			},
		},
	})
end

return M

