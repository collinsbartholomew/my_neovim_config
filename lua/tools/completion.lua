local M = {}

function M.setup()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local context = require("cmp.context")

    -- Use modern string indexing
    context.get_context = function(self, ...)
        local ctx = self:_get_context(...)
        if not ctx.cursor then return ctx end

        if vim.str then
            ctx.cursor.col = vim.str.utf_end(ctx.cursor_line, ctx.cursor.col)
        else
            -- Fallback for older Neovim versions
            ctx.cursor.col = vim.str_byteindex(ctx.cursor_line, ctx.cursor.col - 1) + 1
        end

        return ctx
    end

    -- Try to load lspkind with fallback
    local has_lspkind, lspkind = pcall(require, "lspkind")
    local formatting = {
        format = function(entry, vim_item)
            if has_lspkind then
                return lspkind.cmp_format({
                    mode = "symbol_text",
                    maxwidth = 50,
                    ellipsis_char = "...",
                    before = function(b_entry, b_vim_item)
                        -- Get the full snippet (and only keep first line)
                        local word = b_entry:get_insert_text()
                        if b_entry.completion_item.insertTextFormat == 2 then
                            word = vim.lsp.util.parse_snippet(word)
                        end
                        word = string.gsub(word, "\n.*", "")
                        b_vim_item.abbr = word
                        return b_vim_item
                    end
                })(entry, vim_item)
            end
            return vim_item
        end
    }

    -- Load friendly-snippets
    require("luasnip.loaders.from_vscode").lazy_load()

    -- Safe setup with error handling
    local setup_ok, err = pcall(function()
        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-p>"] = cmp.mapping.select_prev_item(),
                ["<C-n>"] = cmp.mapping.select_next_item(),
                ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.close(),
                ["<CR>"] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
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
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "buffer", max_item_count = 5 },
                { name = "path" },
            }),
            formatting = formatting,
            experimental = {
                ghost_text = true,
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            performance = {
                max_view_entries = 100,
                throttle = 50,
                debounce = 150,
            },
        })

        -- Set up cmdline completion with error handling
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = "path" },
                { name = "cmdline", max_item_count = 20 },
            }),
        })

        cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = "buffer", max_item_count = 10 },
            }),
        })
    end)

    if not setup_ok then
        vim.notify("Error setting up nvim-cmp: " .. tostring(err), vim.log.levels.ERROR)
        return
    end

    -- Set up buffer-local mappings
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local bufnr = args.buf
            local opts = { buffer = bufnr }
            vim.keymap.set("i", "<C-h>", function()
                local ok = pcall(vim.lsp.buf.signature_help)
                if not ok then
                    vim.notify("Signature help not available", vim.log.levels.INFO)
                end
            end, opts)
        end,
    })
end

return M
