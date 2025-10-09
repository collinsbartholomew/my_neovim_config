-- Unified Completion Configuration
local ok_cmp, cmp = pcall(require, "cmp")
local ok_luasnip, luasnip = pcall(require, "luasnip")
local ok_lspkind, lspkind = pcall(require, "lspkind")

if not ok_cmp or not ok_luasnip or not ok_lspkind then
	vim.notify("Completion dependencies not available", vim.log.levels.WARN)
	return
end

-- Context-aware filtering for different stacks
local function stack_filter(entry, ctx)
	local filetype = vim.bo.filetype
	local kind = entry.completion_item.kind
	local label = entry.completion_item.label or ""

	-- Web Development Filters
	if filetype == "typescriptreact" or filetype == "javascriptreact" then
		-- Filter out HTML tags in JSX unless in JSX context
		if kind == 10 and label:match("^<.*>$") then -- Snippet kind
			local line = vim.api.nvim_get_current_line()
			local col = vim.api.nvim_win_get_cursor(0)[2]
			local before_cursor = line:sub(1, col)
			-- Only allow HTML tags in JSX context (after < or return statement)
			return before_cursor:match("<$") or before_cursor:match("return%s*<$")
		end

		-- Prioritize React/component completions
		if entry.source.name == "nvim_lsp" and label:match("^[A-Z]") then
			entry.score = (entry.score or 0) + 100
		end
	end

	-- Database context (SQL/Prisma)
	if filetype == "sql" or filetype == "prisma" then
		-- Prioritize schema-related completions
		if entry.source.name == "nvim_lsp" and (label:match("Table") or label:match("Model")) then
			entry.score = (entry.score or 0) + 50
		end
	end

	-- Rust context - filter verbose inlay hints in completions
	if filetype == "rust" then
		if kind == 5 and label:match("&") then -- Field kind with references
			return false -- Hide verbose lifetime annotations
		end
	end

	return true
end

-- Load snippets
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").lazy_load({
	paths = { vim.fn.stdpath("config") .. "/snippets" },
})

-- Enhanced completion setup
cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},

	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),

	-- Stack-aware source prioritization with deduplication
	sources = cmp.config.sources({
		{
			name = "nvim_lsp",
			priority = 1000,
			max_item_count = 15,
			entry_filter = stack_filter,
			group_index = 1,
			duplicate = 0,
		},
		{
			name = "luasnip",
			priority = 750,
			max_item_count = 5,
			group_index = 2,
		},
		{
			name = "buffer",
			priority = 500,
			max_item_count = 3,
			group_index = 3,
			option = {
				get_bufnrs = function()
					local bufs = {}
					local current_ft = vim.bo.filetype
					local current_buf = vim.api.nvim_get_current_buf()

					-- Always include current buffer
					table.insert(bufs, current_buf)

					-- Add other buffers with same filetype (limit to 3 for performance)
					local count = 1
					for _, buf in ipairs(vim.api.nvim_list_bufs()) do
						if count >= 3 then
							break
						end
						if
							buf ~= current_buf
							and vim.api.nvim_buf_is_loaded(buf)
							and vim.bo[buf].filetype == current_ft
						then
							table.insert(bufs, buf)
							count = count + 1
						end
					end
					return bufs
				end,
			},
		},
		{
			name = "path",
			priority = 250,
			max_item_count = 3,
			group_index = 4,
		},
	}),

	formatting = {
		format = lspkind.cmp_format({
			mode = "symbol_text",
			maxwidth = 50,
			ellipsis_char = "...",
			before = function(entry, vim_item)
				-- Stack-specific icons and labels
				local source_labels = {
					nvim_lsp = "[LSP]",
					luasnip = "[Snip]",
					buffer = "[Buf]",
					path = "[Path]",
				}

				vim_item.menu = source_labels[entry.source.name] or "[?]"

				-- Add stack context to menu
				local filetype = vim.bo.filetype
				if filetype:match("react") and entry.source.name == "nvim_lsp" then
					if vim_item.kind == "Function" and vim_item.word:match("^use") then
						vim_item.menu = vim_item.menu .. " Hook"
					elseif vim_item.kind == "Class" and vim_item.word:match("^[A-Z]") then
						vim_item.menu = vim_item.menu .. " Component"
					end
				end

				return vim_item
			end,
		}),
	},

	window = {
		completion = cmp.config.window.bordered({
			border = "rounded",
			winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
		}),
		documentation = cmp.config.window.bordered({
			border = "rounded",
		}),
	},

	experimental = {
		ghost_text = {
			hl_group = "CmpGhostText",
		},
	},

	-- Enhanced sorting for stack-specific relevance
	sorting = {
		priority_weight = 2,
		comparators = {
			cmp.config.compare.offset,
			cmp.config.compare.exact,
			cmp.config.compare.score,
			-- Custom stack-aware comparator
			function(entry1, entry2)
				local filetype = vim.bo.filetype

				-- React/JSX: Prioritize components and hooks
				if filetype:match("react") then
					local label1 = entry1.completion_item.label or ""
					local label2 = entry2.completion_item.label or ""

					if label1:match("^use") and not label2:match("^use") then
						return true
					elseif label2:match("^use") and not label1:match("^use") then
						return false
					end

					if label1:match("^[A-Z]") and not label2:match("^[A-Z]") then
						return true
					elseif label2:match("^[A-Z]") and not label1:match("^[A-Z]") then
						return false
					end
				end

				return nil
			end,
			cmp.config.compare.recently_used,
			cmp.config.compare.locality,
			cmp.config.compare.kind,
			cmp.config.compare.sort_text,
			cmp.config.compare.length,
			cmp.config.compare.order,
		},
	},
})

-- Filetype-specific configurations
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "buffer" },
	}),
})

cmp.setup.filetype("sql", {
	sources = cmp.config.sources({
		{ name = "nvim_lsp", priority = 1000 },
		{ name = "buffer", priority = 500 },
	}),
})

cmp.setup.filetype("prisma", {
	sources = cmp.config.sources({
		{ name = "nvim_lsp", priority = 1000 },
		{ name = "buffer", priority = 500 },
	}),
})

-- Command line completion
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

