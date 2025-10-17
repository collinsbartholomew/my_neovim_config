return {
	name = "address sanitizer check",
	builder = function()
		local file = vim.fn.expand("%:p")
		local file_dir = vim.fn.expand("%:p:h")
		return {
			cmd = { "env" },
			args = {
				"ASAN_OPTIONS=detect_leaks=1",
				file
			},
			cwd = file_dir,
			components = {
				{ "on_output_quickfix", set_diagnostics = true },
				"default"
			}
		}
	end,
	condition = {
		filetype = { "c", "cpp" },
	}
}
