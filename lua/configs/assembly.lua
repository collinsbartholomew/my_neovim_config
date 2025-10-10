-- Assembly Language Support
-- Uses Overseer.nvim for build tasks and minimal config

-- Assembly file settings
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "asm", "nasm", "gas" },
	callback = function()
		vim.bo.commentstring = "; %s"
		vim.bo.tabstop = 4
		vim.bo.shiftwidth = 4
		vim.bo.expandtab = false

		-- Assembly keymaps (use Overseer for builds)
		local opts = { buffer = true, silent = true }
		vim.keymap.set("n", "<F5>", "<cmd>OverseerRun<cr>", opts)
		vim.keymap.set("n", "<F6>", "<cmd>!./%:r<cr>", opts)
		vim.keymap.set("n", "<F7>", function()
			local ok, dap = pcall(require, "dap")
			if ok then
				dap.continue()
			else
				vim.notify("DAP not available", vim.log.levels.WARN)
			end
		end, opts)
		vim.keymap.set("n", "<F8>", "<cmd>!objdump -d %:r<cr>", opts)
	end,
})
