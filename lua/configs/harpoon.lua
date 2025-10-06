-- Modern Harpoon2 configuration
local ok, harpoon = pcall(require, "harpoon")
if not ok then
	vim.notify("harpoon not available", vim.log.levels.WARN)
	return
end

harpoon:setup({
	settings = {
		save_on_toggle = false,
		sync_on_ui_close = false,
		key = function()
			return vim.uv.cwd() or vim.loop.cwd()
		end,
	},
	default = {
		get_root_dir = function()
			return vim.uv.cwd() or vim.loop.cwd()
		end,
		select = function(list_item, list, options)
			options = options or {}
			if list_item == nil then
				return
			end
			if type(list_item) == "string" then
				vim.cmd("edit " .. vim.fn.fnameescape(list_item))
			else
				vim.cmd("edit " .. vim.fn.fnameescape(list_item.value))
			end
		end,
	},
})

-- Basic telescope configuration for harpoon
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
	local file_paths = {}
	for _, item in ipairs(harpoon_files.items) do
		table.insert(file_paths, item.value)
	end

	require("telescope.pickers")
		.new({}, {
			prompt_title = "Harpoon",
			finder = require("telescope.finders").new_table({
				results = file_paths,
			}),
			previewer = conf.file_previewer({}),
			sorter = conf.generic_sorter({}),
		})
		:find()
end

vim.keymap.set("n", "<C-e>", function()
	toggle_telescope(harpoon:list())
end, { desc = "Open harpoon window" })

