return {
	name = "safe build with sanitizers",
	builder = function()
		local file = vim.fn.expand("%:p")
		local file_dir = vim.fn.expand("%:p:h")
		local file_name = vim.fn.fnamemodify(file, ":t:r")
		return {
			cmd = { "gcc" },
			args = {
				"-fsanitize=address",
				"-fsanitize=undefined",
				"-g",
				"-O0",
				file,
				"-o",
				file_name .. "_safe"
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
