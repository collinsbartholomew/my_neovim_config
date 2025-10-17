local M = {}
local initialized = false

local function safe_require(name)
	local ok, mod = pcall(require, name)
	return ok and mod or nil
end

function M.setup()
	if initialized then
		return
	end
	initialized = true

	local cmp = safe_require('cmp')
	local luasnip = safe_require('luasnip')
	local lspkind = safe_require('lspkind')
	if not (cmp and luasnip and lspkind) then
		vim.notify('Completion dependencies not available', vim.log.levels.WARN)
		return
	end

	local filters = require('configs.completion.filters')

	-- Load snippets lazily
	pcall(function()
		require('luasnip.loaders.from_vscode').lazy_load()
	end)
	pcall(function()
		require('luasnip.loaders.from_vscode').lazy_load({ paths = { vim.fn.stdpath('config') .. '/snippets' } })
	end)

	cmp.setup({
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},

		mapping = cmp.mapping and cmp.mapping.preset and cmp.mapping.preset.insert({
			['<C-b>'] = cmp.mapping.scroll_docs(-4),
			['<C-f>'] = cmp.mapping.scroll_docs(4),
			['<C-Space>'] = cmp.mapping.complete(),
			['<C-e>'] = cmp.mapping.abort(),
			['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
			['<Tab>'] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				else
					fallback()
				end
			end, { 'i', 's' }),
			['<S-Tab>'] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, { 'i', 's' }),
		}) or {},

		-- Source priorities: prefer local buffer first, then LSP (imports), snippets, then path
		sources = cmp.config.sources({
			{ name = 'buffer', priority = 1200, max_item_count = 8, group_index = 1, option = { get_bufnrs = function()
				local bufs = {}
				local current_ft = vim.bo.filetype
				local current_buf = vim.api.nvim_get_current_buf()
				table.insert(bufs, current_buf)
				local count = 1
				for _, buf in ipairs(vim.api.nvim_list_bufs()) do
					if count >= 3 then
						break
					end
					if buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == current_ft then
						table.insert(bufs, buf)
						count = count + 1
					end
				end
				return bufs
			end } },
			{ name = 'nvim_lsp', priority = 1000, max_item_count = 15, entry_filter = filters.stack_filter, group_index = 1, duplicate = 0 },
			{ name = 'luasnip', priority = 750, max_item_count = 6, group_index = 2 },
			{ name = 'path', priority = 250, max_item_count = 5, group_index = 4 },
		}),

		formatting = {
			format = lspkind.cmp_format({ mode = 'symbol_text', maxwidth = 50, ellipsis_char = '...', before = function(entry, vim_item)
				local source_labels = { nvim_lsp = '[LSP]', luasnip = '[Snip]', buffer = '[Buf]', path = '[Path]' }
				vim_item.menu = source_labels[entry.source.name] or '[?]'
				local filetype = vim.bo.filetype
				if filetype:match('react') and entry.source.name == 'nvim_lsp' then
					if vim_item.kind == 'Function' and vim_item.word:match('^use') then
						vim_item.menu = vim_item.menu .. ' Hook'
					elseif vim_item.kind == 'Class' and vim_item.word:match('^[A-Z]') then
						vim_item.menu = vim_item.menu .. ' Component'
					end
				end
				return vim_item
			end })
		},

		window = {
			completion = cmp.config.window and cmp.config.window.bordered and cmp.config.window.bordered({ border = 'rounded', winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,Search:None' }) or nil,
			documentation = cmp.config.window and cmp.config.window.bordered and cmp.config.window.bordered({ border = 'rounded' }) or nil,
		},

		experimental = { ghost_text = { hl_group = 'CmpGhostText' } },

		sorting = {
			priority_weight = 2,
			comparators = {
				-- prefer local buffer matches first
				cmp.config.compare.locality,
				cmp.config.compare.recently_used,
				cmp.config.compare.offset,
				cmp.config.compare.exact,
				cmp.config.compare.score,
				function(entry1, entry2)
					local filetype = vim.bo.filetype
					local src1 = entry1.source and entry1.source.name or ''
					local src2 = entry2.source and entry2.source.name or ''
					-- prefer lsp imports after local buffer
					if src1 == 'nvim_lsp' and src2 == 'buffer' then
						return false
					end
					if src2 == 'nvim_lsp' and src1 == 'buffer' then
						return true
					end
					-- prefer snippets for JSX contexts
					if (filetype == 'typescriptreact' or filetype == 'javascriptreact') and filters.is_jsx_attribute_context() then
						if src1 == 'luasnip' and src2 ~= 'luasnip' then
							return true
						end
						if src2 == 'luasnip' and src1 ~= 'luasnip' then
							return false
						end
					end
					return nil
				end,
				cmp.config.compare.kind,
				cmp.config.compare.sort_text,
				cmp.config.compare.length,
				cmp.config.compare.order,
			}
		},
	})

	-- Filetype-specific configurations
	pcall(function()
		cmp.setup.filetype('gitcommit', { sources = cmp.config.sources({ { name = 'buffer' } }) })
		cmp.setup.filetype('sql', { sources = cmp.config.sources({ { name = 'nvim_lsp', priority = 1000 }, { name = 'buffer', priority = 500 } }) })
		cmp.setup.filetype('prisma', { sources = cmp.config.sources({ { name = 'nvim_lsp', priority = 1000 }, { name = 'buffer', priority = 500 } }) })
	end)
end

-- Auto-run setup on require to preserve previous behavior
M.setup()

return M

