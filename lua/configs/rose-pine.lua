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
		-- Examples
		-- Comment = { fg = "love" },
		-- VertSplit = { fg = "love", style = "italic" },
		-- Visual = { bg = "love", style = "italic" },
		--
		-- Italicize comments and keywords
		Comment = { fg = "muted", style = {} },
		["@comment"] = { fg = "muted", style = {} },
		["@keyword"] = { style = {} },
		["@keyword.function"] = { style = {} },
		["@keyword.operator"] = { style = {} },
		["@keyword.return"] = { style = {} },
		["@type"] = { style = {} },
		["@type.builtin"] = { style = {} },
		["@type.qualifier"] = { style = {} },
		["@constant"] = { style = {} },
		["@constant.builtin"] = { style = {} },
		["@constant.macro"] = { style = {} },
		["@structure"] = { style = {} },
		["@include"] = { style = {} },
		["@module"] = { style = {} },
		["@module.builtin"] = { style = {} },
		["@property"] = { style = {} },
		["@field"] = { style = {} },
		["@variable"] = { style = {} },
		["@variable.builtin"] = { style = {} },
		["@string"] = { fg = "gold" },
		["@string.escape"] = { fg = "pine" },
		["@string.special"] = { fg = "foam" },
		["@string.special.symbol"] = { fg = "foam" },
		["@string.regexp"] = { fg = "pine" },
		["@punctuation.special"] = { fg = "iris" },
		["@punctuation.delimiter"] = { fg = "subtle" },
		["@constructor"] = { fg = "foam" },
		["@operator"] = { fg = "subtle" },
		["@label"] = { fg = "iris" },
		["@tag"] = { fg = "foam" },
		["@tag.attribute"] = { fg = "iris" },
		["@tag.delimiter"] = { fg = "subtle" },
		["@function"] = { fg = "rose" },
		["@function.builtin"] = { fg = "rose" },
		["@function.call"] = { fg = "rose" },
		["@function.macro"] = { fg = "rose" },
		["@method"] = { fg = "rose" },
		["@method.call"] = { fg = "rose" },
	},
})

-- Apply the colorscheme explicitly
vim.cmd([[colorscheme rose-pine]])

