return {
	name = "secrets scan with trufflehog",
	builder = function()
		local file_dir = vim.fn.expand("%:p:h")
		return {
			cmd = { "trufflehog" },
			args = {
				"git",
				file_dir
			},
			cwd = file_dir,
			components = {
				{ "on_output_quickfix", set_diagnostics = true },
				"default"
			}
		}
	end,
	condition = {
		filetype = { "python", "javascript", "typescript", "java", "go" },
	}
}
