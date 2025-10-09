return {
	name = "rust_build",
	builder = function()
		return {
			cmd = { "cargo" },
			args = { "build" },
			components = { "default" },
		}
	end,
	condition = {
		filetype = { "rust" },
	},
}