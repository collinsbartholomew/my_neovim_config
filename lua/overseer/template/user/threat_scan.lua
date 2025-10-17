return {
	name = "threat scan with semgrep",
	builder = function()
		local file_dir = vim.fn.expand("%:p:h")
		return {
			cmd = { "semgrep" },
			args = {
				"--config=auto",
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
		filetype = {
			"python",
			"javascript", "typescript",
			"go",
			"java", "kotlin",
			"cs", "csharp",
			"elixir",
			"c", "cpp", "rust",
			"dockerfile", "yaml", "yml",
		},
	}
}
