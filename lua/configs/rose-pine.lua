local ok, rose_pine = pcall(require, "rose-pine")
if not ok then
	return
end

rose_pine.setup({
	--- @usage 'auto'|'main'|'moon'|'dawn'
	variant = "auto",
	--- @usage 'main'|'moon'|'dawn'
	dark_variant = "main",
	bold_vert_split = false,
	dim_nc_background = false,
	disable_background = true,
	disable_float_background = true,
	disable_italics = true,
	--- @usage string hex value or named color from rosepinetheme.com/palette
	groups = {
		background = "base",
		panel = "surface",
		border = "highlight_med",
		comment = "muted",
		link = "iris",
		punctuation = "subtle",

		error = "love",
		hint = "iris",
		info = "foam",
		warn = "gold",

		headings = {
			h1 = "iris",
			h2 = "foam",
			h3 = "rose",
			h4 = "gold",
			h5 = "pine",
			h6 = "foam",
		},
		-- or set all headings at once
		-- headings = 'subtle'
	},

	-- Change specific vim highlight groups
	-- https://github.com/rose-pine/neovim/wiki/Recipes
	highlight_groups = {
		Comment = { fg = "muted" },
		["@string"] = { fg = "gold" },
		["@string.escape"] = { fg = "pine" },
		["@string.special"] = { fg = "foam" },
		["@punctuation.special"] = { fg = "iris" },
		["@function"] = { fg = "rose" },
		["@function.builtin"] = { fg = "rose" },
		["@function.call"] = { fg = "rose" },
	},
})

-- Apply the colorscheme explicitly
vim.cmd([[colorscheme rose-pine]])

-- Global theme state
_G.current_theme = "rose-pine"

