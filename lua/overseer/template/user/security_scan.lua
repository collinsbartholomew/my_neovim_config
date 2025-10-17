return {
	name = "security scan with trivy",
	builder = function()
		local file_dir = vim.fn.expand("%:p:h")
		return {
			cmd = { "trivy" },
			args = {
				"fs",
				"--security-checks",
				"vuln,config,secret",
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
			"c", "cpp", "rust",
			"go",
			"python",
			"javascript", "typescript",
			"java", "kotlin",
			"cs", "csharp",
			"elixir",
			"dockerfile", "yaml", "yml",
		},
	}
}
