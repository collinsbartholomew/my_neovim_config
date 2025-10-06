-- Modern color picker and preview integration
local ok, colorizer = pcall(require, "colorizer")
if not ok then
	vim.notify("nvim-colorizer not available", vim.log.levels.WARN)
	return
end

colorizer.setup({
	filetypes = {
		"css",
		"scss",
		"html",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"lua",
		"vim",
		"conf",
		"config",
	},
	user_default_options = {
		RGB = true,
		RRGGBB = true,
		names = true,
		RRGGBBAA = true,
		AARRGGBB = true,
		rgb_fn = true,
		hsl_fn = true,
		css = true,
		css_fn = true,
		mode = "background",
		tailwind = "both",
		sass = { enable = true, parsers = { "css" } },
		virtualtext = "■",
		always_update = false,
	},
	buftypes = {},
})
