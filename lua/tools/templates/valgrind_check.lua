return {
	name = "valgrind memory check",
	builder = function()
		return {
			cmd = { "valgrind" },
			args = {
				"--tool=memcheck",
				"--leak-check=full",
				"--show-leak-kinds=all",
				"--track-origins=yes",
				"--verbose",
				vim.fn.expand("%:p")
			},
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
