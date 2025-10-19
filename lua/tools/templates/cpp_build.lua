return {
	name = "cpp_build",
	builder = function()
		local file = vim.fn.expand("%:p")
		local file_no_ext = vim.fn.expand("%:p:r")
		return {
			cmd = { "g++" },
			args = { "-std=c++17", "-Wall", "-Wextra", "-O2", file, "-o", file_no_ext },
			components = { "default" },
		}
	end,
	condition = {
		filetype = { "cpp", "c" },
	},
}