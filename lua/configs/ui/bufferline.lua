-- Lightweight bufferline configuration (safe-guarded)
local ok, bufferline = pcall(require, 'bufferline')
if not ok then
	return
end

bufferline.setup({
	options = {
		numbers = "ordinal",
		indicator = { style = 'underline' },
		buffer_close_icon = '',
		modified_icon = '●',
		close_icon = '',
		left_trunc_marker = '',
		right_trunc_marker = '',
		max_name_length = 30,
		max_prefix_length = 15,
		tab_size = 20,
		enforce_regular_tabs = false,
		view = 'tabs',
		show_buffer_close_icons = true,
		show_close_icon = false,
		show_duplicate_prefix = false,
		persist_buffer_sort = true,
		separator_style = 'thin',
		diagnostics = 'nvim_lsp',
		offsets = { { filetype = 'neo-tree', text = 'File Explorer', text_align = 'center' } },
		sort_by = 'insert_after_current',
	},
})

